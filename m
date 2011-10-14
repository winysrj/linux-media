Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:34455 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab1JNRjx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 13:39:53 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: serial device name for smart card reader that is integrated to Anysee DVB USB device
Date: Fri, 14 Oct 2011 19:32:51 +0200
Cc: Greg KH <greg@kroah.com>, linux-serial@vger.kernel.org,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	=?iso-8859-1?q?Bj=F8rn_Mork?= <bjorn@mork.no>,
	"James Courtier-Dutton" <james.dutton@gmail.com>,
	HoP <jpetrous@gmail.com>,
	=?iso-8859-1?q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
References: <4E8B7901.2050700@iki.fi> <4E8BF6DE.1010105@iki.fi> <201110051016.06291.oneukum@suse.de>
In-Reply-To: <201110051016.06291.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141932.51378.oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, 5. Oktober 2011, 10:16:06 schrieb Oliver Neukum:
> Am Mittwoch, 5. Oktober 2011, 08:19:10 schrieb Antti Palosaari:
> > On 10/05/2011 09:15 AM, Oliver Neukum wrote:
> 
> > > But, Greg, Antti makes a very valid point here. The generic code assumes that
> > > it owns intfdata, that is you cannot use it as is for access to anything that lacks
> > > its own interface. But this is not a fatal flaw. We can alter the generic code to use
> > > an accessor function the driver can provide and make it default to get/set_intfdata
> > >
> > > What do you think?
> > 
> > Oliver, I looked your old thread reply but I didn't catch how you meant 
> > it to happen. Could you give some small example?

Hi,

here is the code I come up with at an early, extremely incomplete stage.
Just for your information because I'll stop working on this for a few days.

	Regards
		Oliver

diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index 2cbf19a..34c950a 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -31,6 +31,12 @@
  * is highly welcome!
  */
 
+#include <linux/kernel.h>
+#include <linux/tty_driver.h>
+#include <linux/tty.h>
+#include <linux/serial.h>
+#include <linux/usb.h>
+#include <linux/usb/serial.h>
 #include "anysee.h"
 #include "tda1002x.h"
 #include "mt352.h"
@@ -898,6 +904,8 @@ static int anysee_probe(struct usb_interface *intf,
 	if (ret)
 		return ret;
 
+	usb_serial_start(d->card_dev, intf);
+
 	return anysee_init(d);
 }
 
@@ -973,6 +981,10 @@ static int __init anysee_module_init(void)
 	if (ret)
 		err("%s: usb_register failed. Error number %d", __func__, ret);
 
+	ret = usb_serial_register(&anysee_card_driver);
+	if (ret)
+		usb_deregister(&anysee_driver);
+
 	return ret;
 }
 
diff --git a/drivers/media/dvb/dvb-usb/anysee.h b/drivers/media/dvb/dvb-usb/anysee.h
index ad6ccd1..f1ca088 100644
--- a/drivers/media/dvb/dvb-usb/anysee.h
+++ b/drivers/media/dvb/dvb-usb/anysee.h
@@ -61,6 +61,9 @@ struct anysee_state {
 	u8 seq;
 };
 
+static struct usb_serial_driver anysee_card_driver = {
+};
+
 #define ANYSEE_HW_507T    2 /* E30 */
 #define ANYSEE_HW_507CD   6 /* E30 Plus */
 #define ANYSEE_HW_507DC  10 /* E30 C Plus */
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 7d35d07..5333c4d 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -425,6 +425,7 @@ struct dvb_usb_device {
 	/* remote control */
 	struct rc_dev *rc_dev;
 	struct input_dev *input_dev;
+	struct usb_serial *card_dev;
 	char rc_phys[64];
 	struct delayed_work rc_query_work;
 	u32 last_event;
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index e4db5ad..4c387ab 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -175,6 +175,12 @@ int usb_serial_generic_prepare_write_buffer(struct usb_serial_port *port,
 	return kfifo_out_locked(&port->write_fifo, dest, size, &port->lock);
 }
 
+void usb_serial_generic_set_private_data(struct usb_interface *intf, struct usb_serial *serial)
+{
+	usb_set_intfdata(intf, serial);
+}
+EXPORT_SYMBOL_GPL(usb_serial_generic_set_private_data);
+
 /**
  * usb_serial_generic_write_start - kick off an URB write
  * @port:	Pointer to the &struct usb_serial_port data
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 1c03130..dd8cf75 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -707,19 +707,18 @@ static const struct tty_port_operations serial_port_ops = {
 	.shutdown = serial_down,
 };
 
-int usb_serial_probe(struct usb_interface *interface,
-			       const struct usb_device_id *id)
+int usb_serial_start(struct usb_serial *serial, struct usb_interface *interface)
 {
 	struct usb_device *dev = interface_to_usbdev(interface);
-	struct usb_serial *serial = NULL;
-	struct usb_serial_port *port;
+	struct usb_serial_driver *type = NULL;
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
 	struct usb_endpoint_descriptor *interrupt_in_endpoint[MAX_NUM_PORTS];
 	struct usb_endpoint_descriptor *interrupt_out_endpoint[MAX_NUM_PORTS];
 	struct usb_endpoint_descriptor *bulk_in_endpoint[MAX_NUM_PORTS];
 	struct usb_endpoint_descriptor *bulk_out_endpoint[MAX_NUM_PORTS];
-	struct usb_serial_driver *type = NULL;
+	struct usb_serial_port *port;
+
 	int retval;
 	unsigned int minor;
 	int buffer_size;
@@ -731,28 +730,6 @@ int usb_serial_probe(struct usb_interface *interface,
 	int num_ports = 0;
 	int max_endpoints;
 
-	mutex_lock(&table_lock);
-	type = search_serial_device(interface);
-	if (!type) {
-		mutex_unlock(&table_lock);
-		dbg("none matched");
-		return -ENODEV;
-	}
-
-	if (!try_module_get(type->driver.owner)) {
-		mutex_unlock(&table_lock);
-		dev_err(&interface->dev, "module get failed, exiting\n");
-		return -EIO;
-	}
-	mutex_unlock(&table_lock);
-
-	serial = create_serial(dev, interface, type);
-	if (!serial) {
-		module_put(type->driver.owner);
-		dev_err(&interface->dev, "%s - out of memory\n", __func__);
-		return -ENOMEM;
-	}
-
 	/* if this device type has a probe function, call it */
 	if (type->probe) {
 		const struct usb_device_id *id;
@@ -1087,7 +1064,8 @@ int usb_serial_probe(struct usb_interface *interface,
 
 exit:
 	/* success */
-	usb_set_intfdata(interface, serial);
+	serial->type->set_private_data(interface, serial);
+	//usb_set_intfdata(interface, serial);
 	module_put(type->driver.owner);
 	return 0;
 
@@ -1096,6 +1074,39 @@ probe_error:
 	module_put(type->driver.owner);
 	return -EIO;
 }
+EXPORT_SYMBOL_GPL(usb_serial_start);
+
+int usb_serial_probe(struct usb_interface *interface,
+			       const struct usb_device_id *id)
+{
+	struct usb_device *dev = interface_to_usbdev(interface);
+	struct usb_serial *serial = NULL;
+	struct usb_serial_driver *type = NULL;
+
+	mutex_lock(&table_lock);
+	type = search_serial_device(interface);
+	if (!type) {
+		mutex_unlock(&table_lock);
+		dbg("none matched");
+		return -ENODEV;
+	}
+
+	if (!try_module_get(type->driver.owner)) {
+		mutex_unlock(&table_lock);
+		dev_err(&interface->dev, "module get failed, exiting\n");
+		return -EIO;
+	}
+	mutex_unlock(&table_lock);
+
+	serial = create_serial(dev, interface, type);
+	if (!serial) {
+		module_put(type->driver.owner);
+		dev_err(&interface->dev, "%s - out of memory\n", __func__);
+		return -ENOMEM;
+	}
+
+	return usb_serial_start(serial, interface);
+}
 EXPORT_SYMBOL_GPL(usb_serial_probe);
 
 void usb_serial_disconnect(struct usb_interface *interface)
@@ -1109,7 +1120,8 @@ void usb_serial_disconnect(struct usb_interface *interface)
 	dbg("%s", __func__);
 
 	mutex_lock(&serial->disc_mutex);
-	usb_set_intfdata(interface, NULL);
+	serial->type->set_private_data(interface, NULL);
+
 	/* must set a flag, to signal subdrivers */
 	serial->disconnected = 1;
 	mutex_unlock(&serial->disc_mutex);
@@ -1148,11 +1160,11 @@ void usb_serial_disconnect(struct usb_interface *interface)
 	usb_serial_put(serial);
 	dev_info(dev, "device disconnected\n");
 }
+
 EXPORT_SYMBOL_GPL(usb_serial_disconnect);
 
-int usb_serial_suspend(struct usb_interface *intf, pm_message_t message)
+int usb_serial_do_suspend(struct usb_serial *serial, pm_message_t message)
 {
-	struct usb_serial *serial = usb_get_intfdata(intf);
 	struct usb_serial_port *port;
 	int i, r = 0;
 
@@ -1175,11 +1187,18 @@ int usb_serial_suspend(struct usb_interface *intf, pm_message_t message)
 err_out:
 	return r;
 }
-EXPORT_SYMBOL(usb_serial_suspend);
 
-int usb_serial_resume(struct usb_interface *intf)
+EXPORT_SYMBOL(usb_serial_do_suspend);
+
+int usb_serial_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usb_serial *serial = usb_get_intfdata(intf);
+	return usb_serial_do_suspend(serial, message);
+}
+EXPORT_SYMBOL(usb_serial_suspend);
+
+int usb_serial_do_resume(struct usb_serial *serial)
+{
 	int rv;
 
 	serial->suspending = 0;
@@ -1190,8 +1209,17 @@ int usb_serial_resume(struct usb_interface *intf)
 
 	return rv;
 }
+EXPORT_SYMBOL(usb_serial_do_resume);
+
+int usb_serial_resume(struct usb_interface *intf)
+{
+	struct usb_serial *serial = usb_get_intfdata(intf);
+	return usb_serial_do_resume(serial);
+}
+
 EXPORT_SYMBOL(usb_serial_resume);
 
+
 static const struct tty_operations serial_ops = {
 	.open =			serial_open,
 	.close =		serial_close,
@@ -1332,6 +1360,7 @@ static void fixup_generic(struct usb_serial_driver *device)
 	set_to_generic_if_null(device, release);
 	set_to_generic_if_null(device, process_read_urb);
 	set_to_generic_if_null(device, prepare_write_buffer);
+	set_to_generic_if_null(device, set_private_data);
 }
 
 int usb_serial_register(struct usb_serial_driver *driver)
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index b29f70b..396de61 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -243,6 +243,7 @@ struct usb_serial_driver {
 	int (*probe)(struct usb_serial *serial, const struct usb_device_id *id);
 	int (*attach)(struct usb_serial *serial);
 	int (*calc_num_ports) (struct usb_serial *serial);
+	void (*set_private_data) (struct usb_interface *intf, struct usb_serial *serial);
 
 	void (*disconnect)(struct usb_serial *serial);
 	void (*release)(struct usb_serial *serial);
@@ -301,10 +302,13 @@ extern void usb_serial_port_softint(struct usb_serial_port *port);
 
 extern int usb_serial_probe(struct usb_interface *iface,
 			    const struct usb_device_id *id);
+extern int usb_serial_start(struct usb_serial *serial, struct usb_interface *iface);
 extern void usb_serial_disconnect(struct usb_interface *iface);
 
 extern int usb_serial_suspend(struct usb_interface *intf, pm_message_t message);
+extern int usb_serial_do_suspend(struct usb_serial *serial, pm_message_t message); 
 extern int usb_serial_resume(struct usb_interface *intf);
+extern int usb_serial_do_resume(struct usb_serial *serial);
 
 extern int ezusb_writememory(struct usb_serial *serial, int address,
 			     unsigned char *data, int length, __u8 bRequest);
@@ -329,6 +333,7 @@ extern int usb_serial_generic_open(struct tty_struct *tty,
 extern int usb_serial_generic_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count);
 extern void usb_serial_generic_close(struct usb_serial_port *port);
+extern void usb_serial_generic_set_private_data(struct usb_interface *intf, struct usb_serial *serial);
 extern int usb_serial_generic_resume(struct usb_serial *serial);
 extern int usb_serial_generic_write_room(struct tty_struct *tty);
 extern int usb_serial_generic_chars_in_buffer(struct tty_struct *tty);
