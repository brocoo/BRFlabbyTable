BRFlabbyTable
=============

BRFlabbyTable is a set a classes that allow you to add a bouncy and distortion effect on a cell frame while the table is scrolling. The "flabbiness" of the cells is based on the speed of scrolling.

Upon pressing and dragging, the highlighted cell grows around the touch area.

![http://i.imgur.com/Fl90rLm.png](http://i.imgur.com/Fl90rLm.png)
![http://i.imgur.com/0KhUhMN.png](http://i.imgur.com/0KhUhMN.png)

Usage
-----

1.  Import the classes into your view controller:

  ```objective-c
    #import "BRFlabbyTableManager.h"
    #import "BRFlabbyTableViewCell.h"
  ```

2.  Initialize the `BRFlabbyTableManager` in the `viewDidLoad` method of your view controller or any `init` method

  ```objective-c
    self.flabbyTableManager = [[BRFlabbyTableManager alloc] initWithTableView:self.tableView];
    [self.flabbyTableManager setDelegate:self];
  ```

3.  Adopt the `BRFlabbyTableManagerDelegate` protocol and implement the following delegate method:

  ```objective-c
    - (UIColor *)flabbyTableManager:(BRFlabbyTableManager *)tableManager flabbyColorForIndexPath:(NSIndexPath *)indexPath{
            
        return [UIColor randomColor];
    }

  ```

4.  Register `BRFlabbyTableViewCell` subclasses for your UITableView and set their color and behavior in the `tableView:cellForRowAtIndexPath:` method :

  ```objective-c
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        BRFlabbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BRFlabbyTableViewCellIdentifier" forIndexPath:indexPath];
        [cell setFlabby:YES];
        [cell setLongPressAnimated:YES];
        [cell setFlabbyColor:[UIColor randomColor]];
        return cell;
    }
  ```

5.  Enjoy!


Notes
-----
`BRFlabbyTableViewCell` and its subclasses work with the Interface Builder and Autolayout.

Developed By
----

Julien Ducret - <brocoo@gmail.com>

Follow me on Twitter ([@jbrocoo](https://twitter.com/jbrocoo))

Check out my app, Spores! ([AppStore](https://itunes.apple.com/us/app/spores/id718495353?l=fr&ls=1&mt=8))


Licence
----

BRFlabbyTable is under Apache licence, see the LICENCE file for more info.
