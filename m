Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38802 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0FAIPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 04:15:37 -0400
Date: Tue, 1 Jun 2010 10:15:19 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] V4L/DVB: white space changes in dvb-usb-init.c
Message-ID: <20100601081519.GK5483@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I started fixing one or two lines, but after a while I got into a groove
and started changing everything.  I left the lines longer than 80
characters because that seemed to be the style in this file.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-init.c b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
index 5d91f70..2e3ea0f 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
@@ -15,7 +15,7 @@
 
 /* debug */
 int dvb_usb_debug;
-module_param_named(debug,dvb_usb_debug, int, 0644);
+module_param_named(debug, dvb_usb_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,pll=4,ts=8,err=16,rc=32,fw=64,mem=128,uxfer=256  (or-able))." DVB_USB_DEBUG_STATUS);
 
 int dvb_usb_disable_rc_polling;
@@ -29,7 +29,7 @@ MODULE_PARM_DESC(force_pid_filter_usage, "force all dvb-usb-devices to use a PID
 static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 {
 	struct dvb_usb_adapter *adap;
-	int ret,n;
+	int ret, n;
 
 	for (n = 0; n < d->props.num_adapters; n++) {
 		adap = &d->adapter[n];
@@ -38,7 +38,7 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 
 		memcpy(&adap->props, &d->props.adapter[n], sizeof(struct dvb_usb_adapter_properties));
 
-/* speed - when running at FULL speed we need a HW PID filter */
+		/* speed - when running at FULL speed we need a HW PID filter */
 		if (d->udev->speed == USB_SPEED_FULL && !(adap->props.caps & DVB_USB_ADAP_HAS_PID_FILTER)) {
 			err("This USB2.0 device cannot be run on a USB1.1 port. (it lacks a hardware PID filter)");
 			return -ENODEV;
@@ -46,7 +46,7 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 
 		if ((d->udev->speed == USB_SPEED_FULL && adap->props.caps & DVB_USB_ADAP_HAS_PID_FILTER) ||
 			(adap->props.caps & DVB_USB_ADAP_NEED_PID_FILTERING)) {
-			info("will use the device's hardware PID filter (table count: %d).",adap->props.pid_filter_count);
+			info("will use the device's hardware PID filter (table count: %d).", adap->props.pid_filter_count);
 			adap->pid_filtering  = 1;
 			adap->max_feed_count = adap->props.pid_filter_count;
 		} else {
@@ -64,9 +64,9 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 		}
 
 		if (adap->props.size_of_priv > 0) {
-			adap->priv = kzalloc(adap->props.size_of_priv,GFP_KERNEL);
+			adap->priv = kzalloc(adap->props.size_of_priv, GFP_KERNEL);
 			if (adap->priv == NULL) {
-				err("no memory for priv for adapter %d.",n);
+				err("no memory for priv for adapter %d.", n);
 				return -ENOMEM;
 			}
 		}
@@ -86,8 +86,8 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 	 * sometimes a timeout occures, this helps
 	 */
 	if (d->props.generic_bulk_ctrl_endpoint != 0) {
-		usb_clear_halt(d->udev,usb_sndbulkpipe(d->udev,d->props.generic_bulk_ctrl_endpoint));
-		usb_clear_halt(d->udev,usb_rcvbulkpipe(d->udev,d->props.generic_bulk_ctrl_endpoint));
+		usb_clear_halt(d->udev, usb_sndbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
+		usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
 	}
 
 	return 0;
@@ -96,6 +96,7 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 static int dvb_usb_adapter_exit(struct dvb_usb_device *d)
 {
 	int n;
+
 	for (n = 0; n < d->num_adapters_initialized; n++) {
 		dvb_usb_adapter_frontend_exit(&d->adapter[n]);
 		dvb_usb_adapter_dvb_exit(&d->adapter[n]);
@@ -111,11 +112,11 @@ static int dvb_usb_adapter_exit(struct dvb_usb_device *d)
 /* general initialization functions */
 static int dvb_usb_exit(struct dvb_usb_device *d)
 {
-	deb_info("state before exiting everything: %x\n",d->state);
+	deb_info("state before exiting everything: %x\n", d->state);
 	dvb_usb_remote_exit(d);
 	dvb_usb_adapter_exit(d);
 	dvb_usb_i2c_exit(d);
-	deb_info("state should be zero now: %x\n",d->state);
+	deb_info("state should be zero now: %x\n", d->state);
 	d->state = DVB_USB_STATE_INIT;
 	kfree(d->priv);
 	kfree(d);
@@ -132,14 +133,14 @@ static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums)
 	d->state = DVB_USB_STATE_INIT;
 
 	if (d->props.size_of_priv > 0) {
-		d->priv = kzalloc(d->props.size_of_priv,GFP_KERNEL);
+		d->priv = kzalloc(d->props.size_of_priv, GFP_KERNEL);
 		if (d->priv == NULL) {
 			err("no memory for priv in 'struct dvb_usb_device'");
 			return -ENOMEM;
 		}
 	}
 
-/* check the capabilities and set appropriate variables */
+	/* check the capabilities and set appropriate variables */
 	dvb_usb_device_power_ctrl(d, 1);
 
 	if ((ret = dvb_usb_i2c_init(d)) ||
@@ -157,16 +158,17 @@ static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums)
 }
 
 /* determine the name and the state of the just found USB device */
-static struct dvb_usb_device_description * dvb_usb_find_device(struct usb_device *udev,struct dvb_usb_device_properties *props, int *cold)
+static struct dvb_usb_device_description *dvb_usb_find_device(struct usb_device *udev, struct dvb_usb_device_properties *props, int *cold)
 {
-	int i,j;
+	int i, j;
 	struct dvb_usb_device_description *desc = NULL;
+
 	*cold = -1;
 
 	for (i = 0; i < props->num_device_descs; i++) {
 
 		for (j = 0; j < DVB_USB_ID_MAX_NUM && props->devices[i].cold_ids[j] != NULL; j++) {
-			deb_info("check for cold %x %x\n",props->devices[i].cold_ids[j]->idVendor, props->devices[i].cold_ids[j]->idProduct);
+			deb_info("check for cold %x %x\n", props->devices[i].cold_ids[j]->idVendor, props->devices[i].cold_ids[j]->idProduct);
 			if (props->devices[i].cold_ids[j]->idVendor  == le16_to_cpu(udev->descriptor.idVendor) &&
 				props->devices[i].cold_ids[j]->idProduct == le16_to_cpu(udev->descriptor.idProduct)) {
 				*cold = 1;
@@ -179,7 +181,7 @@ static struct dvb_usb_device_description * dvb_usb_find_device(struct usb_device
 			break;
 
 		for (j = 0; j < DVB_USB_ID_MAX_NUM && props->devices[i].warm_ids[j] != NULL; j++) {
-			deb_info("check for warm %x %x\n",props->devices[i].warm_ids[j]->idVendor, props->devices[i].warm_ids[j]->idProduct);
+			deb_info("check for warm %x %x\n", props->devices[i].warm_ids[j]->idVendor, props->devices[i].warm_ids[j]->idProduct);
 			if (props->devices[i].warm_ids[j]->idVendor == le16_to_cpu(udev->descriptor.idVendor) &&
 				props->devices[i].warm_ids[j]->idProduct == le16_to_cpu(udev->descriptor.idProduct)) {
 				*cold = 0;
@@ -190,7 +192,7 @@ static struct dvb_usb_device_description * dvb_usb_find_device(struct usb_device
 	}
 
 	if (desc != NULL && props->identify_state != NULL)
-		props->identify_state(udev,props,&desc,cold);
+		props->identify_state(udev, props, &desc, cold);
 
 	return desc;
 }
@@ -202,7 +204,7 @@ int dvb_usb_device_power_ctrl(struct dvb_usb_device *d, int onoff)
 	else
 		d->powered--;
 
-	if (d->powered == 0 || (onoff && d->powered == 1)) { // when switching from 1 to 0 or from 0 to 1
+	if (d->powered == 0 || (onoff && d->powered == 1)) { /* when switching from 1 to 0 or from 0 to 1 */
 		deb_info("power control: %d\n", onoff);
 		if (d->props.power_ctrl)
 			return d->props.power_ctrl(d, onoff);
@@ -222,32 +224,32 @@ int dvb_usb_device_init(struct usb_interface *intf,
 	struct dvb_usb_device *d = NULL;
 	struct dvb_usb_device_description *desc = NULL;
 
-	int ret = -ENOMEM,cold=0;
+	int ret = -ENOMEM, cold = 0;
 
 	if (du != NULL)
 		*du = NULL;
 
-	if ((desc = dvb_usb_find_device(udev,props,&cold)) == NULL) {
+	if ((desc = dvb_usb_find_device(udev, props, &cold)) == NULL) {
 		deb_err("something went very wrong, device was not found in current device list - let's see what comes next.\n");
 		return -ENODEV;
 	}
 
 	if (cold) {
-		info("found a '%s' in cold state, will try to load a firmware",desc->name);
-		ret = dvb_usb_download_firmware(udev,props);
+		info("found a '%s' in cold state, will try to load a firmware", desc->name);
+		ret = dvb_usb_download_firmware(udev, props);
 		if (!props->no_reconnect || ret != 0)
 			return ret;
 	}
 
-	info("found a '%s' in warm state.",desc->name);
-		d = kzalloc(sizeof(struct dvb_usb_device),GFP_KERNEL);
+	info("found a '%s' in warm state.", desc->name);
+	d = kzalloc(sizeof(struct dvb_usb_device), GFP_KERNEL);
 	if (d == NULL) {
 		err("no memory for 'struct dvb_usb_device'");
 		return -ENOMEM;
 	}
 
 	d->udev = udev;
-	memcpy(&d->props,props,sizeof(struct dvb_usb_device_properties));
+	memcpy(&d->props, props, sizeof(struct dvb_usb_device_properties));
 	d->desc = desc;
 	d->owner = owner;
 
@@ -259,9 +261,9 @@ int dvb_usb_device_init(struct usb_interface *intf,
 	ret = dvb_usb_init(d, adapter_nums);
 
 	if (ret == 0)
-		info("%s successfully initialized and connected.",desc->name);
+		info("%s successfully initialized and connected.", desc->name);
 	else
-		info("%s error while loading driver (%d)",desc->name,ret);
+		info("%s error while loading driver (%d)", desc->name, ret);
 	return ret;
 }
 EXPORT_SYMBOL(dvb_usb_device_init);
@@ -271,12 +273,12 @@ void dvb_usb_device_exit(struct usb_interface *intf)
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
 	const char *name = "generic DVB-USB module";
 
-	usb_set_intfdata(intf,NULL);
+	usb_set_intfdata(intf, NULL);
 	if (d != NULL && d->desc != NULL) {
 		name = d->desc->name;
 		dvb_usb_exit(d);
 	}
-	info("%s successfully deinitialized and disconnected.",name);
+	info("%s successfully deinitialized and disconnected.", name);
 
 }
 EXPORT_SYMBOL(dvb_usb_device_exit);
