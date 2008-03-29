Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1JfimP-0001UD-9a
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 22:40:04 +0100
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Sat, 29 Mar 2008 22:40:25 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Jdr7H52+t65760y"
Message-Id: <200803292240.25719.janne-dvb@grunau.be>
Subject: [linux-dvb] [PATCH] Add driver specific module option to choose dvb
	adapter numbers, second try
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_Jdr7H52+t65760y
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I resubmit this patch since I still think it is a good idea to the this 
driver option. There is still no udev recipe to guaranty stable dvb 
adapter numbers. I've tried to come up with some rules but it's tricky 
due to the multiple device nodes in a subdirectory. I won't claim that 
it is impossible to get udev to assign driver or hardware specific 
stable dvb adapter numbers but I think this patch is easier and more 
clean than a udev based solution.

I'll drop this patch if a simple udev solution is found in a reasonable 
amount of time. But if there is no I would like to see the attached 
patch merged.

Quoting myself for a short desciprtion for the patch:

> V4L drivers have the {radio|vbi|video}_nr module options to allocate
> static minor numbers per driver.
>
> Attached patch adds a similiar mechanism to the dvb subsystem. To
> avoid problems with device unplugging and repluging each driver holds
> a DVB_MAX_ADAPTER long array of the preffered order of adapter
> numbers.
>
> options dvb-usb-dib0700 adapter_nr=7,6,5,4,3,2,1,0 would result in a
> reversed allocation of adapter numbers.
>
> With adapter_nr=2,5 it tries first to get adapter number 2 and 5. If
> both are already in use it will allocate the lowest free adapter
> number.

Janne

--Boundary-00=_Jdr7H52+t65760y
Content-Type: text/x-diff;
  charset="utf-8";
  name="modoption_adapter_numbers2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="modoption_adapter_numbers2.diff"

diff -r 0776e4801991 linux/drivers/media/dvb/b2c2/flexcop.c
--- a/linux/drivers/media/dvb/b2c2/flexcop.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/b2c2/flexcop.c	Sat Mar 29 22:39:56 2008 +0100
@@ -49,6 +49,10 @@ MODULE_PARM_DESC(debug, "set debug level
 MODULE_PARM_DESC(debug, "set debug level (1=info,2=tuner,4=i2c,8=ts,16=sram,32=reg (|-able))." DEBSTATUS);
 #undef DEBSTATUS
 
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
+
 /* global zero for ibi values */
 flexcop_ibi_value ibi_zero;
 
@@ -67,7 +71,7 @@ static int flexcop_dvb_init(struct flexc
 static int flexcop_dvb_init(struct flexcop_device *fc)
 {
 	int ret;
-	if ((ret = dvb_register_adapter(&fc->dvb_adapter,"FlexCop Digital TV device",fc->owner,fc->dev)) < 0) {
+	if ((ret = dvb_register_adapter(&fc->dvb_adapter,"FlexCop Digital TV device",fc->owner,fc->dev,adapter_nr)) < 0) {
 		err("error registering DVB adapter");
 		return ret;
 	}
diff -r 0776e4801991 linux/drivers/media/dvb/bt8xx/dvb-bt8xx.c
--- a/linux/drivers/media/dvb/bt8xx/dvb-bt8xx.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/bt8xx/dvb-bt8xx.c	Sat Mar 29 22:39:56 2008 +0100
@@ -40,6 +40,11 @@ static int debug;
 
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 #define dprintk( args... ) \
 	do { \
@@ -718,7 +723,7 @@ static int __devinit dvb_bt8xx_load_card
 {
 	int result;
 
-	if ((result = dvb_register_adapter(&card->dvb_adapter, card->card_name, THIS_MODULE, &card->bt->dev->dev)) < 0) {
+	if ((result = dvb_register_adapter(&card->dvb_adapter, card->card_name, THIS_MODULE, &card->bt->dev->dev, adapter_nr)) < 0) {
 		printk("dvb_bt8xx: dvb_register_adapter failed (errno = %d)\n", result);
 		return result;
 	}
diff -r 0776e4801991 linux/drivers/media/dvb/cinergyT2/cinergyT2.c
--- a/linux/drivers/media/dvb/cinergyT2/cinergyT2.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/cinergyT2/cinergyT2.c	Sat Mar 29 22:39:56 2008 +0100
@@ -60,6 +60,10 @@ static int debug;
 static int debug;
 module_param_named(debug, debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,15)
 #define dprintk(level, args...)						\
@@ -1004,7 +1008,7 @@ static int cinergyt2_probe (struct usb_i
 		return -ENOMEM;
 	}
 
-	if ((err = dvb_register_adapter(&cinergyt2->adapter, DRIVER_NAME, THIS_MODULE, &cinergyt2->udev->dev)) < 0) {
+	if ((err = dvb_register_adapter(&cinergyt2->adapter, DRIVER_NAME, THIS_MODULE, &cinergyt2->udev->dev, adapter_nr)) < 0) {
 		kfree(cinergyt2);
 		return err;
 	}
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-core/dvbdev.c
--- a/linux/drivers/media/dvb/dvb-core/dvbdev.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.c	Sat Mar 29 22:39:56 2008 +0100
@@ -52,7 +52,6 @@ static const char * const dnames[] = {
 	"net", "osd"
 };
 
-#define DVB_MAX_ADAPTERS	8
 #define DVB_MAX_IDS		4
 #define nums2minor(num,type,id)	((num << 6) | (id << 4) | type)
 #define MAX_DVB_MINORS		(DVB_MAX_ADAPTERS*64)
@@ -277,18 +276,25 @@ void dvb_unregister_device(struct dvb_de
 }
 EXPORT_SYMBOL(dvb_unregister_device);
 
+static int dvbdev_check_free_adapter_num(int num)
+{
+        struct list_head *entry;
+        list_for_each (entry, &dvb_adapter_list) {
+                struct dvb_adapter *adap;
+                adap = list_entry(entry, struct dvb_adapter, list_head);
+                if (adap->num == num)
+                        return 0;
+        }
+        return 1;
+}
 
 static int dvbdev_get_free_adapter_num (void)
 {
 	int num = 0;
 
 	while (num < DVB_MAX_ADAPTERS) {
-		struct dvb_adapter *adap;
-		list_for_each_entry(adap, &dvb_adapter_list, list_head)
-			if (adap->num == num)
-				goto skip;
-		return num;
-skip:
+                if (dvbdev_check_free_adapter_num(num))
+                        return num;
 		num++;
 	}
 
@@ -296,13 +302,27 @@ skip:
 }
 
 
-int dvb_register_adapter(struct dvb_adapter *adap, const char *name, struct module *module, struct device *device)
+int dvb_register_adapter(struct dvb_adapter *adap, const char *name, struct module *module, struct device *device, int *adapter_nums)
 {
-	int num;
+	int i, num;
 
 	mutex_lock(&dvbdev_register_lock);
 
-	if ((num = dvbdev_get_free_adapter_num ()) < 0) {
+	for (i=0; i<DVB_MAX_ADAPTERS; ++i) {
+		num = adapter_nums[i];
+	        if (num >= 0  &&  num < DVB_MAX_ADAPTERS) {
+		/* use the one the driver asked for */
+			if (dvbdev_check_free_adapter_num(num))
+				break;
+		}
+		else {
+			num = dvbdev_get_free_adapter_num();
+		 	break;
+		}
+		num = -1;
+	}
+
+	if (num < 0) {
 		mutex_unlock(&dvbdev_register_lock);
 		return -ENFILE;
 	}
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-core/dvbdev.h
--- a/linux/drivers/media/dvb/dvb-core/dvbdev.h	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.h	Sat Mar 29 22:39:56 2008 +0100
@@ -31,6 +31,10 @@
 
 #define DVB_MAJOR 212
 
+#define DVB_MAX_ADAPTERS 8
+
+#define DVB_UNSET (-1)
+
 #define DVB_DEVICE_VIDEO      0
 #define DVB_DEVICE_AUDIO      1
 #define DVB_DEVICE_SEC        2
@@ -78,7 +82,9 @@ struct dvb_device {
 };
 
 
-extern int dvb_register_adapter (struct dvb_adapter *adap, const char *name, struct module *module, struct device *device);
+extern int dvb_register_adapter (struct dvb_adapter *adap, const char *name,
+				 struct module *module, struct device *device,
+				 int *adapter_nums);
 extern int dvb_unregister_adapter (struct dvb_adapter *adap);
 
 extern int dvb_register_device (struct dvb_adapter *adap,
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/a800.c
--- a/linux/drivers/media/dvb/dvb-usb/a800.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/a800.c	Sat Mar 29 22:39:56 2008 +0100
@@ -18,6 +18,9 @@ static int debug;
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (rc=1 (or-able))." DVB_USB_DEBUG_STATUS);
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 #define deb_rc(args...)   dprintk(debug,0x01,args)
 
 static int a800_power_ctrl(struct dvb_usb_device *d, int onoff)
@@ -94,7 +97,7 @@ static int a800_probe(struct usb_interfa
 static int a800_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&a800_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf,&a800_properties,THIS_MODULE,NULL,adapter_nr);
 }
 
 /* do not change the order of the ID table */
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/af9005.c
--- a/linux/drivers/media/dvb/dvb-usb/af9005.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/af9005.c	Sat Mar 29 22:39:56 2008 +0100
@@ -38,6 +38,10 @@ int dvb_usb_af9005_dump_eeprom = 0;
 int dvb_usb_af9005_dump_eeprom = 0;
 module_param_named(dump_eeprom, dvb_usb_af9005_dump_eeprom, int, 0);
 MODULE_PARM_DESC(dump_eeprom, "dump contents of the eeprom.");
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 /* remote control decoder */
 int (*rc_decode) (struct dvb_usb_device * d, u8 * data, int len, u32 * event,
@@ -1020,7 +1024,7 @@ static int af9005_usb_probe(struct usb_i
 static int af9005_usb_probe(struct usb_interface *intf,
 			    const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf, &af9005_properties, THIS_MODULE, NULL);
+	return dvb_usb_device_init(intf, &af9005_properties, THIS_MODULE, NULL, adapter_nr);
 }
 
 static struct usb_device_id af9005_usb_table[] = {
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/au6610.c
--- a/linux/drivers/media/dvb/dvb-usb/au6610.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/au6610.c	Sat Mar 29 22:39:56 2008 +0100
@@ -18,6 +18,10 @@ static int dvb_usb_au6610_debug;
 static int dvb_usb_au6610_debug;
 module_param_named(debug, dvb_usb_au6610_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 static int au6610_usb_msg(struct dvb_usb_device *d, u8 operation, u8 addr,
 			  u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
@@ -163,7 +167,7 @@ static int au6610_probe(struct usb_inter
 	if (intf->num_altsetting < AU6610_ALTSETTING_COUNT)
 		return -ENODEV;
 
-	if ((ret = dvb_usb_device_init(intf, &au6610_properties, THIS_MODULE, &d)) == 0) {
+	if ((ret = dvb_usb_device_init(intf, &au6610_properties, THIS_MODULE, &d, adapter_nr)) == 0) {
 		alt = usb_altnum_to_altsetting(intf, AU6610_ALTSETTING);
 
 		if (alt == NULL) {
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/cxusb.c
--- a/linux/drivers/media/dvb/dvb-usb/cxusb.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c	Sat Mar 29 22:39:56 2008 +0100
@@ -40,6 +40,11 @@ static int dvb_usb_cxusb_debug;
 static int dvb_usb_cxusb_debug;
 module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr, "DVB adapter numbers");
+
 #define deb_info(args...)   dprintk(dvb_usb_cxusb_debug,0x01,args)
 #define deb_i2c(args...)    if (d->udev->descriptor.idVendor == USB_VID_MEDION) \
 				dprintk(dvb_usb_cxusb_debug,0x01,args)
@@ -723,14 +728,14 @@ static int cxusb_probe(struct usb_interf
 static int cxusb_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
 {
-	if (dvb_usb_device_init(intf,&cxusb_medion_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&cxusb_bluebird_lgh064f_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&cxusb_bluebird_dee1601_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&cxusb_bluebird_lgz201_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&cxusb_bluebird_dtt7579_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&cxusb_bluebird_dualdig4_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&cxusb_bluebird_nano2_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&cxusb_bluebird_nano2_needsfirmware_properties,THIS_MODULE,NULL) == 0) {
+	if (dvb_usb_device_init(intf,&cxusb_medion_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&cxusb_bluebird_lgh064f_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&cxusb_bluebird_dee1601_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&cxusb_bluebird_lgz201_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&cxusb_bluebird_dtt7579_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&cxusb_bluebird_dualdig4_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&cxusb_bluebird_nano2_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&cxusb_bluebird_nano2_needsfirmware_properties,THIS_MODULE,NULL,adapter_nr) == 0) {
 		return 0;
 	}
 
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/dib0700_core.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Sat Mar 29 22:39:56 2008 +0100
@@ -16,6 +16,10 @@ static int dvb_usb_dib0700_ir_proto = 1;
 static int dvb_usb_dib0700_ir_proto = 1;
 module_param(dvb_usb_dib0700_ir_proto, int, 0644);
 MODULE_PARM_DESC(dvb_usb_dib0700_ir_proto, "set ir protocol (0=NEC, 1=RC5 (default), 2=RC6).");
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 /* expecting rx buffer: request data[0] data[1] ... data[2] */
 static int dib0700_ctrl_wr(struct dvb_usb_device *d, u8 *tx, u8 txlen)
@@ -289,7 +293,7 @@ static int dib0700_probe(struct usb_inte
 #endif
 
 	for (i = 0; i < dib0700_device_count; i++)
-		if (dvb_usb_device_init(intf, &dib0700_devices[i], THIS_MODULE, &dev) == 0)
+		if (dvb_usb_device_init(intf, &dib0700_devices[i], THIS_MODULE, &dev, adapter_nr) == 0)
 		{
 			dib0700_rc_setup(dev);
 			return 0;
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/dibusb-mb.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-mb.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-mb.c	Sat Mar 29 22:39:56 2008 +0100
@@ -13,6 +13,10 @@
  * see Documentation/dvb/README.dvb-usb for more information
  */
 #include "dibusb.h"
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 static int dib3000mb_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 {
@@ -107,10 +111,10 @@ static int dibusb_probe(struct usb_inter
 static int dibusb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	if (dvb_usb_device_init(intf,&dibusb1_1_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&dibusb1_1_an2235_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&dibusb2_0b_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&artec_t1_usb2_properties,THIS_MODULE,NULL) == 0)
+	if (dvb_usb_device_init(intf,&dibusb1_1_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&dibusb1_1_an2235_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&dibusb2_0b_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&artec_t1_usb2_properties,THIS_MODULE,NULL,adapter_nr) == 0)
 		return 0;
 
 	return -EINVAL;
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/dibusb-mc.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c	Sat Mar 29 22:39:56 2008 +0100
@@ -14,13 +14,17 @@
  */
 #include "dibusb.h"
 
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
+
 /* USB Driver stuff */
 static struct dvb_usb_device_properties dibusb_mc_properties;
 
 static int dibusb_mc_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&dibusb_mc_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf,&dibusb_mc_properties,THIS_MODULE,NULL,adapter_nr);
 }
 
 /* do not change the order of the ID table */
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/digitv.c
--- a/linux/drivers/media/dvb/dvb-usb/digitv.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/digitv.c	Sat Mar 29 22:39:56 2008 +0100
@@ -20,6 +20,11 @@ static int dvb_usb_digitv_debug;
 static int dvb_usb_digitv_debug;
 module_param_named(debug,dvb_usb_digitv_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr, "DVB adapter numbers");
+
 #define deb_rc(args...)   dprintk(dvb_usb_digitv_debug,0x01,args)
 
 static int digitv_ctrl_msg(struct dvb_usb_device *d,
@@ -257,7 +262,7 @@ static int digitv_probe(struct usb_inter
 {
 	struct dvb_usb_device *d;
 	int ret;
-	if ((ret = dvb_usb_device_init(intf,&digitv_properties,THIS_MODULE,&d)) == 0) {
+	if ((ret = dvb_usb_device_init(intf,&digitv_properties,THIS_MODULE,&d,adapter_nr)) == 0) {
 		u8 b[4] = { 0 };
 
 		if (d != NULL) { /* do that only when the firmware is loaded */
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/dtt200u.c
--- a/linux/drivers/media/dvb/dvb-usb/dtt200u.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dtt200u.c	Sat Mar 29 22:39:56 2008 +0100
@@ -17,6 +17,10 @@ int dvb_usb_dtt200u_debug;
 int dvb_usb_dtt200u_debug;
 module_param_named(debug,dvb_usb_dtt200u_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2 (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 static int dtt200u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
@@ -101,11 +105,11 @@ static int dtt200u_usb_probe(struct usb_
 static int dtt200u_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	if (dvb_usb_device_init(intf,&dtt200u_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&wt220u_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&wt220u_fc_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&wt220u_zl0353_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&wt220u_miglia_properties,THIS_MODULE,NULL) == 0)
+	if (dvb_usb_device_init(intf,&dtt200u_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&wt220u_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&wt220u_fc_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&wt220u_zl0353_properties,THIS_MODULE,NULL,adapter_nr) == 0 ||
+		dvb_usb_device_init(intf,&wt220u_miglia_properties,THIS_MODULE,NULL,adapter_nr) == 0)
 		return 0;
 
 	return -ENODEV;
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/dvb-usb-common.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-common.h	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-common.h	Sat Mar 29 22:39:56 2008 +0100
@@ -40,7 +40,7 @@ extern int dvb_usb_i2c_init(struct dvb_u
 extern int dvb_usb_i2c_init(struct dvb_usb_device *);
 extern int dvb_usb_i2c_exit(struct dvb_usb_device *);
 
-extern int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap);
+extern int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, int *adapter_nums);
 extern int dvb_usb_adapter_dvb_exit(struct dvb_usb_adapter *adap);
 extern int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap);
 extern int dvb_usb_adapter_frontend_exit(struct dvb_usb_adapter *adap);
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c	Sat Mar 29 22:39:56 2008 +0100
@@ -77,12 +77,12 @@ static int dvb_usb_stop_feed(struct dvb_
 	return dvb_usb_ctrl_feed(dvbdmxfeed,0);
 }
 
-int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap)
+int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, int *adapter_nums)
 {
 	int ret;
 
 	if ((ret = dvb_register_adapter(&adap->dvb_adap, adap->dev->desc->name,
-			adap->dev->owner, &adap->dev->udev->dev)) < 0) {
+			adap->dev->owner, &adap->dev->udev->dev, adapter_nums)) < 0) {
 		deb_info("dvb_register_adapter failed: error %d", ret);
 		goto err;
 	}
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/dvb-usb-init.c
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-init.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-init.c	Sat Mar 29 22:39:56 2008 +0100
@@ -26,7 +26,7 @@ module_param_named(force_pid_filter_usag
 module_param_named(force_pid_filter_usage, dvb_usb_force_pid_filter_usage, int, 0444);
 MODULE_PARM_DESC(force_pid_filter_usage, "force all dvb-usb-devices to use a PID filter, if any (default: 0).");
 
-static int dvb_usb_adapter_init(struct dvb_usb_device *d)
+static int dvb_usb_adapter_init(struct dvb_usb_device *d, int *adapter_nrs)
 {
 	struct dvb_usb_adapter *adap;
 	int ret,n;
@@ -72,7 +72,7 @@ static int dvb_usb_adapter_init(struct d
 		}
 
 		if ((ret = dvb_usb_adapter_stream_init(adap)) ||
-			(ret = dvb_usb_adapter_dvb_init(adap)) ||
+			(ret = dvb_usb_adapter_dvb_init(adap, adapter_nrs)) ||
 			(ret = dvb_usb_adapter_frontend_init(adap))) {
 			return ret;
 		}
@@ -122,7 +122,7 @@ static int dvb_usb_exit(struct dvb_usb_d
 	return 0;
 }
 
-static int dvb_usb_init(struct dvb_usb_device *d)
+static int dvb_usb_init(struct dvb_usb_device *d, int *adapter_nums)
 {
 	int ret = 0;
 
@@ -143,7 +143,7 @@ static int dvb_usb_init(struct dvb_usb_d
 	dvb_usb_device_power_ctrl(d, 1);
 
 	if ((ret = dvb_usb_i2c_init(d)) ||
-		(ret = dvb_usb_adapter_init(d))) {
+		(ret = dvb_usb_adapter_init(d, adapter_nums))) {
 		dvb_usb_exit(d);
 		return ret;
 	}
@@ -214,7 +214,7 @@ int dvb_usb_device_power_ctrl(struct dvb
  * USB
  */
 int dvb_usb_device_init(struct usb_interface *intf, struct dvb_usb_device_properties
-		*props, struct module *owner,struct dvb_usb_device **du)
+		*props, struct module *owner,struct dvb_usb_device **du, int *adapter_nums)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct dvb_usb_device *d = NULL;
@@ -254,7 +254,7 @@ int dvb_usb_device_init(struct usb_inter
 	if (du != NULL)
 		*du = d;
 
-	ret = dvb_usb_init(d);
+	ret = dvb_usb_init(d, adapter_nums);
 
 	if (ret == 0)
 		info("%s successfully initialized and connected.",desc->name);
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/dvb-usb.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb.h	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb.h	Sat Mar 29 22:39:56 2008 +0100
@@ -387,7 +387,7 @@ struct dvb_usb_device {
 	void *priv;
 };
 
-extern int dvb_usb_device_init(struct usb_interface *, struct dvb_usb_device_properties *, struct module *, struct dvb_usb_device **);
+extern int dvb_usb_device_init(struct usb_interface *, struct dvb_usb_device_properties *, struct module *, struct dvb_usb_device **, int *adapter_nums);
 extern void dvb_usb_device_exit(struct usb_interface *);
 
 /* the generic read/write method for device control */
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/gl861.c
--- a/linux/drivers/media/dvb/dvb-usb/gl861.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/gl861.c	Sat Mar 29 22:39:56 2008 +0100
@@ -15,6 +15,10 @@ static int dvb_usb_gl861_debug;
 static int dvb_usb_gl861_debug;
 module_param_named(debug,dvb_usb_gl861_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
 			 u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
@@ -140,7 +144,7 @@ static int gl861_probe(struct usb_interf
 	if (intf->num_altsetting < 2)
 		return -ENODEV;
 
-	if ((ret = dvb_usb_device_init(intf, &gl861_properties, THIS_MODULE, &d)) == 0) {
+	if ((ret = dvb_usb_device_init(intf, &gl861_properties, THIS_MODULE, &d, adapter_nr)) == 0) {
 		alt = usb_altnum_to_altsetting(intf, 0);
 
 		if (alt == NULL) {
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/gp8psk.c
--- a/linux/drivers/media/dvb/dvb-usb/gp8psk.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/gp8psk.c	Sat Mar 29 22:39:56 2008 +0100
@@ -21,6 +21,10 @@ int dvb_usb_gp8psk_debug;
 int dvb_usb_gp8psk_debug;
 module_param_named(debug,dvb_usb_gp8psk_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
 {
@@ -208,7 +212,7 @@ static int gp8psk_usb_probe(struct usb_i
 {
 	int ret;
 	struct usb_device *udev = interface_to_usbdev(intf);
-	ret =  dvb_usb_device_init(intf,&gp8psk_properties,THIS_MODULE,NULL);
+	ret = dvb_usb_device_init(intf,&gp8psk_properties,THIS_MODULE,NULL,adapter_nr);
 	if (ret == 0) {
 		info("found Genpix USB device pID = %x (hex)",
 			le16_to_cpu(udev->descriptor.idProduct));
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/m920x.c
--- a/linux/drivers/media/dvb/dvb-usb/m920x.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/m920x.c	Sat Mar 29 22:39:56 2008 +0100
@@ -21,6 +21,10 @@ static int dvb_usb_m920x_debug;
 static int dvb_usb_m920x_debug;
 module_param_named(debug,dvb_usb_m920x_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 static int m920x_set_filter(struct dvb_usb_device *d, int type, int idx, int pid);
 
@@ -619,26 +623,26 @@ static int m920x_probe(struct usb_interf
 		 */
 
 		if ((ret = dvb_usb_device_init(intf, &megasky_properties,
-					       THIS_MODULE, &d)) == 0) {
+					       THIS_MODULE, &d, adapter_nr)) == 0) {
 			rc_init_seq = megasky_rc_init;
 			goto found;
 		}
 
 		if ((ret = dvb_usb_device_init(intf, &digivox_mini_ii_properties,
-					       THIS_MODULE, &d)) == 0) {
+					       THIS_MODULE, &d, adapter_nr)) == 0) {
 			/* No remote control, so no rc_init_seq */
 			goto found;
 		}
 
 		/* This configures both tuners on the TV Walker Twin */
 		if ((ret = dvb_usb_device_init(intf, &tvwalkertwin_properties,
-					       THIS_MODULE, &d)) == 0) {
+					       THIS_MODULE, &d, adapter_nr)) == 0) {
 			rc_init_seq = tvwalkertwin_rc_init;
 			goto found;
 		}
 
 		if ((ret = dvb_usb_device_init(intf, &dposh_properties,
-					       THIS_MODULE, &d)) == 0) {
+					       THIS_MODULE, &d, adapter_nr)) == 0) {
 			/* Remote controller not supported yet. */
 			goto found;
 		}
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/nova-t-usb2.c
--- a/linux/drivers/media/dvb/dvb-usb/nova-t-usb2.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/nova-t-usb2.c	Sat Mar 29 22:39:56 2008 +0100
@@ -14,6 +14,10 @@ static int debug;
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc,2=eeprom (|-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 #define deb_rc(args...) dprintk(debug,0x01,args)
 #define deb_ee(args...) dprintk(debug,0x02,args)
@@ -142,7 +146,7 @@ static int nova_t_probe(struct usb_inter
 static int nova_t_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&nova_t_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf,&nova_t_properties,THIS_MODULE,NULL,adapter_nr);
 }
 
 /* do not change the order of the ID table */
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/opera1.c
--- a/linux/drivers/media/dvb/dvb-usb/opera1.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/opera1.c	Sat Mar 29 22:39:56 2008 +0100
@@ -45,6 +45,11 @@ MODULE_PARM_DESC(debug,
 MODULE_PARM_DESC(debug,
 		 "set debugging level (1=info,xfer=2,pll=4,ts=8,err=16,rc=32,fw=64 (or-able))."
 		 DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
+
 #if 0
 struct mutex mymutex;
 #endif
@@ -559,7 +564,7 @@ static int opera1_probe(struct usb_inter
 		return -EINVAL;
 	}
 
-	if (dvb_usb_device_init(intf, &opera1_properties, THIS_MODULE, NULL) != 0)
+	if (dvb_usb_device_init(intf, &opera1_properties, THIS_MODULE, NULL, adapter_nr) != 0)
 		return -EINVAL;
 	return 0;
 }
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/ttusb2.c
--- a/linux/drivers/media/dvb/dvb-usb/ttusb2.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/ttusb2.c	Sat Mar 29 22:39:56 2008 +0100
@@ -36,6 +36,10 @@ static int dvb_usb_ttusb2_debug;
 #define deb_info(args...)   dprintk(dvb_usb_ttusb2_debug,0x01,args)
 module_param_named(debug,dvb_usb_ttusb2_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 struct ttusb2_state {
 	u8 id;
@@ -186,7 +190,7 @@ static int ttusb2_probe(struct usb_inter
 static int ttusb2_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&ttusb2_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf,&ttusb2_properties,THIS_MODULE,NULL,adapter_nr);
 }
 
 static struct usb_device_id ttusb2_table [] = {
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/umt-010.c
--- a/linux/drivers/media/dvb/dvb-usb/umt-010.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/umt-010.c	Sat Mar 29 22:39:56 2008 +0100
@@ -12,6 +12,10 @@
 #include "dibusb.h"
 
 #include "mt352.h"
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 static int umt_mt352_demod_init(struct dvb_frontend *fe)
 {
@@ -75,7 +79,7 @@ static int umt_probe(struct usb_interfac
 static int umt_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	if (dvb_usb_device_init(intf,&umt_properties,THIS_MODULE,NULL) == 0)
+	if (dvb_usb_device_init(intf,&umt_properties,THIS_MODULE,NULL,adapter_nr) == 0)
 		return 0;
 	return -EINVAL;
 }
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/vp702x.c
--- a/linux/drivers/media/dvb/dvb-usb/vp702x.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/vp702x.c	Sat Mar 29 22:39:56 2008 +0100
@@ -20,6 +20,10 @@ int dvb_usb_vp702x_debug;
 int dvb_usb_vp702x_debug;
 module_param_named(debug,dvb_usb_vp702x_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 struct vp702x_state {
 	int pid_filter_count;
@@ -285,7 +289,7 @@ static int vp702x_usb_probe(struct usb_i
 static int vp702x_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&vp702x_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf,&vp702x_properties,THIS_MODULE,NULL,adapter_nr);
 }
 
 static struct usb_device_id vp702x_usb_table [] = {
diff -r 0776e4801991 linux/drivers/media/dvb/dvb-usb/vp7045.c
--- a/linux/drivers/media/dvb/dvb-usb/vp7045.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/vp7045.c	Sat Mar 29 22:39:56 2008 +0100
@@ -18,6 +18,11 @@ static int dvb_usb_vp7045_debug;
 static int dvb_usb_vp7045_debug;
 module_param_named(debug,dvb_usb_vp7045_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr, "DVB adapter numbers");
+
 #define deb_info(args...) dprintk(dvb_usb_vp7045_debug,0x01,args)
 #define deb_xfer(args...) dprintk(dvb_usb_vp7045_debug,0x02,args)
 #define deb_rc(args...)   dprintk(dvb_usb_vp7045_debug,0x04,args)
@@ -227,7 +232,7 @@ static int vp7045_usb_probe(struct usb_i
 static int vp7045_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&vp7045_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf,&vp7045_properties,THIS_MODULE,NULL,adapter_nr);
 }
 
 static struct usb_device_id vp7045_usb_table [] = {
diff -r 0776e4801991 linux/drivers/media/dvb/pluto2/pluto2.c
--- a/linux/drivers/media/dvb/pluto2/pluto2.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/pluto2/pluto2.c	Sat Mar 29 22:39:56 2008 +0100
@@ -90,6 +90,10 @@
 #define I2C_ADDR_TDA10046	0x10
 #define I2C_ADDR_TUA6034	0xc2
 #define NHWFILTERS		8
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 struct pluto {
 	/* pci */
@@ -666,7 +670,7 @@ static int __devinit pluto2_probe(struct
 		goto err_pluto_hw_exit;
 
 	/* dvb */
-	ret = dvb_register_adapter(&pluto->dvb_adapter, DRIVER_NAME, THIS_MODULE, &pdev->dev);
+	ret = dvb_register_adapter(&pluto->dvb_adapter, DRIVER_NAME, THIS_MODULE, &pdev->dev, adapter_nr);
 	if (ret < 0)
 		goto err_i2c_del_adapter;
 
diff -r 0776e4801991 linux/drivers/media/dvb/ttpci/av7110.c
--- a/linux/drivers/media/dvb/ttpci/av7110.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/av7110.c	Sat Mar 29 22:39:56 2008 +0100
@@ -87,6 +87,7 @@ static int wss_cfg_4_3 = 0x4008;
 static int wss_cfg_4_3 = 0x4008;
 static int wss_cfg_16_9 = 0x0007;
 static int tv_standard;
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
 
 module_param_named(debug, av7110_debug, int, 0644);
 MODULE_PARM_DESC(debug, "debug level (bitmask, default 0)");
@@ -111,6 +112,8 @@ MODULE_PARM_DESC(wss_cfg_16_9, "WSS 16:9
 MODULE_PARM_DESC(wss_cfg_16_9, "WSS 16:9 - default 0x0007 - bit 15: disable, 14: burst mode, 13..0: wss data");
 module_param(tv_standard, int, 0444);
 MODULE_PARM_DESC(tv_standard, "TV standard: 0 PAL (default), 1 NTSC");
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 static void restart_feeds(struct av7110 *av7110);
 
@@ -2461,7 +2464,7 @@ static int __devinit av7110_attach(struc
 		goto err_kfree_0;
 
 	ret = dvb_register_adapter(&av7110->dvb_adapter, av7110->card_name,
-				   THIS_MODULE, &dev->pci->dev);
+				   THIS_MODULE, &dev->pci->dev, adapter_nr);
 	if (ret < 0)
 		goto err_put_firmware_1;
 
diff -r 0776e4801991 linux/drivers/media/dvb/ttpci/budget-core.c
--- a/linux/drivers/media/dvb/ttpci/budget-core.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget-core.c	Sat Mar 29 22:39:56 2008 +0100
@@ -56,6 +56,10 @@ module_param_named(bufsize, dma_buffer_s
 module_param_named(bufsize, dma_buffer_size, int, 0444);
 MODULE_PARM_DESC(debug, "Turn on/off budget debugging (default:off).");
 MODULE_PARM_DESC(bufsize, "DMA buffer size in KB, default: 188, min: 188, max: 1410 (Activy: 564)");
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 /****************************************************************************
  * TT budget / WinTV Nova
@@ -471,7 +475,7 @@ int ttpci_budget_init(struct budget *bud
 		budget->buffer_width, budget->buffer_height);
 	printk("%s: dma buffer size %u\n", budget->dev->name, budget->buffer_size);
 
-	if ((ret = dvb_register_adapter(&budget->dvb_adapter, budget->card->name, owner, &budget->dev->pci->dev)) < 0) {
+	if ((ret = dvb_register_adapter(&budget->dvb_adapter, budget->card->name, owner, &budget->dev->pci->dev, adapter_nr)) < 0) {
 		return ret;
 	}
 
diff -r 0776e4801991 linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
--- a/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c	Sat Mar 29 22:39:56 2008 +0100
@@ -59,9 +59,12 @@
 */
 
 static int debug;
-
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 #define dprintk(x...) do { if (debug) printk(KERN_DEBUG x); } while (0)
 
@@ -1681,7 +1684,7 @@ static int ttusb_probe(struct usb_interf
 
 	mutex_unlock(&ttusb->semi2c);
 
-	if ((result = dvb_register_adapter(&ttusb->adapter, "Technotrend/Hauppauge Nova-USB", THIS_MODULE, &udev->dev)) < 0) {
+	if ((result = dvb_register_adapter(&ttusb->adapter, "Technotrend/Hauppauge Nova-USB", THIS_MODULE, &udev->dev, adapter_nr)) < 0) {
 		ttusb_free_iso_urbs(ttusb);
 		kfree(ttusb);
 		return result;
diff -r 0776e4801991 linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c
--- a/linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c	Sat Mar 29 22:39:56 2008 +0100
@@ -47,6 +47,7 @@ static int debug;
 static int debug;
 static int output_pva;
 static int enable_rc;
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
 
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
@@ -54,6 +55,8 @@ MODULE_PARM_DESC(output_pva, "Output PVA
 MODULE_PARM_DESC(output_pva, "Output PVA from dvr device (default:off)");
 module_param(enable_rc, int, 0644);
 MODULE_PARM_DESC(enable_rc, "Turn on/off IR remote control(default: off)");
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 #define dprintk	if (debug) printk
 
@@ -1456,7 +1459,7 @@ static int ttusb_dec_init_dvb(struct ttu
 	dprintk("%s\n", __FUNCTION__);
 
 	if ((result = dvb_register_adapter(&dec->adapter,
-					   dec->model_name, THIS_MODULE, &dec->udev->dev)) < 0) {
+					   dec->model_name, THIS_MODULE, &dec->udev->dev, adapter_nr)) < 0) {
 		printk("%s: dvb_register_adapter failed: error %d\n",
 		       __FUNCTION__, result);
 
diff -r 0776e4801991 linux/drivers/media/video/videobuf-dvb.c
--- a/linux/drivers/media/video/videobuf-dvb.c	Fri Mar 28 14:52:44 2008 -0300
+++ b/linux/drivers/media/video/videobuf-dvb.c	Sat Mar 29 22:39:56 2008 +0100
@@ -39,6 +39,10 @@ static unsigned int debug;
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug,"enable debug messages");
+
+static int adapter_nr[] = {[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET };
+module_param_array(adapter_nr, int, NULL, 0444);
+MODULE_PARM_DESC(adapter_nr,"DVB adapter numbers");
 
 #define dprintk(fmt, arg...)	if (debug)			\
 	printk(KERN_DEBUG "%s/dvb: " fmt, dvb->name , ## arg)
@@ -151,7 +155,7 @@ int videobuf_dvb_register(struct videobu
 	mutex_init(&dvb->lock);
 
 	/* register adapter */
-	result = dvb_register_adapter(&dvb->adapter, dvb->name, module, device);
+	result = dvb_register_adapter(&dvb->adapter, dvb->name, module, device, adapter_nr);
 	if (result < 0) {
 		printk(KERN_WARNING "%s: dvb_register_adapter failed (errno = %d)\n",
 		       dvb->name, result);

--Boundary-00=_Jdr7H52+t65760y
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_Jdr7H52+t65760y--
