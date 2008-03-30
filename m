Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1Jg25v-0007eV-Uh
	for linux-dvb@linuxtv.org; Sun, 30 Mar 2008 20:17:31 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Sun, 30 Mar 2008 20:17:49 +0200
References: <200803292240.25719.janne-dvb@grunau.be>
	<37219a840803292302m191ea890nfefc51135706b017@mail.gmail.com>
	<200803301353.33801.janne-dvb@grunau.be>
In-Reply-To: <200803301353.33801.janne-dvb@grunau.be>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Nl97HlESVqpWnKP"
Message-Id: <200803302017.49799.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second try
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

--Boundary-00=_Nl97HlESVqpWnKP
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 30 March 2008 13:53:33 Janne Grunau wrote:
>
> I agree. Fixed, updated patch attached.

Next try:

replaced module option definition in each driver by a macro,
fixed all checkpatch.pl error and warning
added Signed-off-by line and patch description

Janne



--Boundary-00=_Nl97HlESVqpWnKP
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="modoption_adapter_numbers4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="modoption_adapter_numbers4.diff"

Adds selectable adapter numbers as per module option

From: Janne Grunau <janne-dvb@grunau.be>

The adapter_nr module options can be used to allocate static adapter numbers
on a driver level. It avoid problems with changing DVB apdapter numbers after
warm/cold boot or device unplugging and repluging.

Each driver holds DVB_MAX_ADAPTER long array of the preffered order of adapter
numbers.

options dvb-usb-dib0700 adapter_nr=7,6,5,4,3,2,1,0 would result in a
reversed allocation of adapter numbers.

With adapter_nr=2,5 it tries first to get adapter number 2 and 5. If
both are already in use it will allocate the lowest free adapter
number.

Signed-off-by: Janne Grunau <janne-dvb@grunau.be>

diff --git a/linux/drivers/media/dvb/b2c2/flexcop.c b/linux/drivers/media/dvb/b2c2/flexcop.c
--- a/linux/drivers/media/dvb/b2c2/flexcop.c
+++ b/linux/drivers/media/dvb/b2c2/flexcop.c
@@ -49,6 +49,8 @@ MODULE_PARM_DESC(debug, "set debug level
 MODULE_PARM_DESC(debug, "set debug level (1=info,2=tuner,4=i2c,8=ts,16=sram,32=reg (|-able))." DEBSTATUS);
 #undef DEBSTATUS
 
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
 /* global zero for ibi values */
 flexcop_ibi_value ibi_zero;
 
@@ -66,8 +68,10 @@ static int flexcop_dvb_stop_feed(struct 
 
 static int flexcop_dvb_init(struct flexcop_device *fc)
 {
-	int ret;
-	if ((ret = dvb_register_adapter(&fc->dvb_adapter,"FlexCop Digital TV device",fc->owner,fc->dev)) < 0) {
+	int ret = dvb_register_adapter(&fc->dvb_adapter,
+				       "FlexCop Digital TV device", fc->owner,
+				       fc->dev, adapter_nr);
+	if (ret < 0) {
 		err("error registering DVB adapter");
 		return ret;
 	}
diff --git a/linux/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/linux/drivers/media/dvb/bt8xx/dvb-bt8xx.c
--- a/linux/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/linux/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -40,6 +40,8 @@ static int debug;
 
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define dprintk( args... ) \
 	do { \
@@ -718,7 +720,10 @@ static int __devinit dvb_bt8xx_load_card
 {
 	int result;
 
-	if ((result = dvb_register_adapter(&card->dvb_adapter, card->card_name, THIS_MODULE, &card->bt->dev->dev)) < 0) {
+	result = dvb_register_adapter(&card->dvb_adapter, card->card_name,
+				      THIS_MODULE, &card->bt->dev->dev,
+				      adapter_nr);
+	if (result < 0) {
 		printk("dvb_bt8xx: dvb_register_adapter failed (errno = %d)\n", result);
 		return result;
 	}
diff --git a/linux/drivers/media/dvb/cinergyT2/cinergyT2.c b/linux/drivers/media/dvb/cinergyT2/cinergyT2.c
--- a/linux/drivers/media/dvb/cinergyT2/cinergyT2.c
+++ b/linux/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -60,6 +60,8 @@ static int debug;
 static int debug;
 module_param_named(debug, debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,15)
 #define dprintk(level, args...)						\
@@ -1004,7 +1006,10 @@ static int cinergyt2_probe (struct usb_i
 		return -ENOMEM;
 	}
 
-	if ((err = dvb_register_adapter(&cinergyt2->adapter, DRIVER_NAME, THIS_MODULE, &cinergyt2->udev->dev)) < 0) {
+	err = dvb_register_adapter(&cinergyt2->adapter, DRIVER_NAME,
+				   THIS_MODULE, &cinergyt2->udev->dev,
+				   adapter_nr);
+	if (err < 0) {
 		kfree(cinergyt2);
 		return err;
 	}
diff --git a/linux/drivers/media/dvb/dvb-core/dvbdev.c b/linux/drivers/media/dvb/dvb-core/dvbdev.c
--- a/linux/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.c
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
+	struct list_head *entry;
+	list_for_each(entry, &dvb_adapter_list) {
+		struct dvb_adapter *adap;
+		adap = list_entry(entry, struct dvb_adapter, list_head);
+		if (adap->num == num)
+			return 0;
+	}
+	return 1;
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
+		if (dvbdev_check_free_adapter_num(num))
+			return num;
 		num++;
 	}
 
@@ -296,13 +302,28 @@ skip:
 }
 
 
-int dvb_register_adapter(struct dvb_adapter *adap, const char *name, struct module *module, struct device *device)
+int dvb_register_adapter(struct dvb_adapter *adap, const char *name,
+			 struct module *module, struct device *device,
+			 int *adapter_nums)
 {
-	int num;
+	int i, num;
 
 	mutex_lock(&dvbdev_register_lock);
 
-	if ((num = dvbdev_get_free_adapter_num ()) < 0) {
+	for (i = 0; i < DVB_MAX_ADAPTERS; ++i) {
+		num = adapter_nums[i];
+		if (num >= 0  &&  num < DVB_MAX_ADAPTERS) {
+		/* use the one the driver asked for */
+			if (dvbdev_check_free_adapter_num(num))
+				break;
+		} else {
+			num = dvbdev_get_free_adapter_num();
+			break;
+		}
+		num = -1;
+	}
+
+	if (num < 0) {
 		mutex_unlock(&dvbdev_register_lock);
 		return -ENFILE;
 	}
diff --git a/linux/drivers/media/dvb/dvb-core/dvbdev.h b/linux/drivers/media/dvb/dvb-core/dvbdev.h
--- a/linux/drivers/media/dvb/dvb-core/dvbdev.h
+++ b/linux/drivers/media/dvb/dvb-core/dvbdev.h
@@ -31,6 +31,10 @@
 
 #define DVB_MAJOR 212
 
+#define DVB_MAX_ADAPTERS 8
+
+#define DVB_UNSET (-1)
+
 #define DVB_DEVICE_VIDEO      0
 #define DVB_DEVICE_AUDIO      1
 #define DVB_DEVICE_SEC        2
@@ -41,6 +45,11 @@
 #define DVB_DEVICE_NET        7
 #define DVB_DEVICE_OSD        8
 
+#define DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr) \
+	static int adapter_nr[] = \
+		{[0 ... (DVB_MAX_ADAPTERS - 1)] = DVB_UNSET }; \
+	module_param_array(adapter_nr, int, NULL, 0444); \
+	MODULE_PARM_DESC(adapter_nr, "DVB adapter numbers")
 
 struct dvb_adapter {
 	int num;
@@ -78,7 +87,9 @@ struct dvb_device {
 };
 
 
-extern int dvb_register_adapter (struct dvb_adapter *adap, const char *name, struct module *module, struct device *device);
+extern int dvb_register_adapter(struct dvb_adapter *adap, const char *name,
+				struct module *module, struct device *device,
+				int *adapter_nums);
 extern int dvb_unregister_adapter (struct dvb_adapter *adap);
 
 extern int dvb_register_device (struct dvb_adapter *adap,
diff --git a/linux/drivers/media/dvb/dvb-usb/a800.c b/linux/drivers/media/dvb/dvb-usb/a800.c
--- a/linux/drivers/media/dvb/dvb-usb/a800.c
+++ b/linux/drivers/media/dvb/dvb-usb/a800.c
@@ -18,6 +18,9 @@ static int debug;
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (rc=1 (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
 #define deb_rc(args...)   dprintk(debug,0x01,args)
 
 static int a800_power_ctrl(struct dvb_usb_device *d, int onoff)
@@ -94,7 +97,8 @@ static int a800_probe(struct usb_interfa
 static int a800_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&a800_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf, &a800_properties, THIS_MODULE, NULL,
+				   adapter_nr);
 }
 
 /* do not change the order of the ID table */
diff --git a/linux/drivers/media/dvb/dvb-usb/af9005.c b/linux/drivers/media/dvb/dvb-usb/af9005.c
--- a/linux/drivers/media/dvb/dvb-usb/af9005.c
+++ b/linux/drivers/media/dvb/dvb-usb/af9005.c
@@ -38,6 +38,8 @@ int dvb_usb_af9005_dump_eeprom = 0;
 int dvb_usb_af9005_dump_eeprom = 0;
 module_param_named(dump_eeprom, dvb_usb_af9005_dump_eeprom, int, 0);
 MODULE_PARM_DESC(dump_eeprom, "dump contents of the eeprom.");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* remote control decoder */
 int (*rc_decode) (struct dvb_usb_device * d, u8 * data, int len, u32 * event,
@@ -1020,7 +1022,8 @@ static int af9005_usb_probe(struct usb_i
 static int af9005_usb_probe(struct usb_interface *intf,
 			    const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf, &af9005_properties, THIS_MODULE, NULL);
+	return dvb_usb_device_init(intf, &af9005_properties, THIS_MODULE, NULL,
+				   adapter_nr);
 }
 
 static struct usb_device_id af9005_usb_table[] = {
diff --git a/linux/drivers/media/dvb/dvb-usb/au6610.c b/linux/drivers/media/dvb/dvb-usb/au6610.c
--- a/linux/drivers/media/dvb/dvb-usb/au6610.c
+++ b/linux/drivers/media/dvb/dvb-usb/au6610.c
@@ -18,6 +18,8 @@ static int dvb_usb_au6610_debug;
 static int dvb_usb_au6610_debug;
 module_param_named(debug, dvb_usb_au6610_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int au6610_usb_msg(struct dvb_usb_device *d, u8 operation, u8 addr,
 			  u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
@@ -163,7 +165,9 @@ static int au6610_probe(struct usb_inter
 	if (intf->num_altsetting < AU6610_ALTSETTING_COUNT)
 		return -ENODEV;
 
-	if ((ret = dvb_usb_device_init(intf, &au6610_properties, THIS_MODULE, &d)) == 0) {
+	ret = dvb_usb_device_init(intf, &au6610_properties, THIS_MODULE, &d,
+				  adapter_nr);
+	if (ret == 0) {
 		alt = usb_altnum_to_altsetting(intf, AU6610_ALTSETTING);
 
 		if (alt == NULL) {
diff --git a/linux/drivers/media/dvb/dvb-usb/cxusb.c b/linux/drivers/media/dvb/dvb-usb/cxusb.c
--- a/linux/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c
@@ -40,6 +40,9 @@ static int dvb_usb_cxusb_debug;
 static int dvb_usb_cxusb_debug;
 module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
 #define deb_info(args...)   dprintk(dvb_usb_cxusb_debug,0x01,args)
 #define deb_i2c(args...)    if (d->udev->descriptor.idVendor == USB_VID_MEDION) \
 				dprintk(dvb_usb_cxusb_debug,0x01,args)
@@ -723,16 +726,24 @@ static int cxusb_probe(struct usb_interf
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
+	if (0 == dvb_usb_device_init(intf, &cxusb_medion_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_lgh064f_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_dee1601_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_lgz201_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_dtt7579_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_dualdig4_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_nano2_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf,
+				&cxusb_bluebird_nano2_needsfirmware_properties,
+				     THIS_MODULE, NULL, adapter_nr))
 		return 0;
-	}
 
 	return -EINVAL;
 }
diff --git a/linux/drivers/media/dvb/dvb-usb/dib0700_core.c b/linux/drivers/media/dvb/dvb-usb/dib0700_core.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -16,6 +16,8 @@ static int dvb_usb_dib0700_ir_proto = 1;
 static int dvb_usb_dib0700_ir_proto = 1;
 module_param(dvb_usb_dib0700_ir_proto, int, 0644);
 MODULE_PARM_DESC(dvb_usb_dib0700_ir_proto, "set ir protocol (0=NEC, 1=RC5 (default), 2=RC6).");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* expecting rx buffer: request data[0] data[1] ... data[2] */
 static int dib0700_ctrl_wr(struct dvb_usb_device *d, u8 *tx, u8 txlen)
@@ -289,7 +291,8 @@ static int dib0700_probe(struct usb_inte
 #endif
 
 	for (i = 0; i < dib0700_device_count; i++)
-		if (dvb_usb_device_init(intf, &dib0700_devices[i], THIS_MODULE, &dev) == 0)
+		if (dvb_usb_device_init(intf, &dib0700_devices[i], THIS_MODULE,
+					&dev, adapter_nr) == 0)
 		{
 			dib0700_rc_setup(dev);
 			return 0;
diff --git a/linux/drivers/media/dvb/dvb-usb/dibusb-mb.c b/linux/drivers/media/dvb/dvb-usb/dibusb-mb.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -13,6 +13,8 @@
  * see Documentation/dvb/README.dvb-usb for more information
  */
 #include "dibusb.h"
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int dib3000mb_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 {
@@ -107,10 +109,14 @@ static int dibusb_probe(struct usb_inter
 static int dibusb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	if (dvb_usb_device_init(intf,&dibusb1_1_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&dibusb1_1_an2235_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&dibusb2_0b_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&artec_t1_usb2_properties,THIS_MODULE,NULL) == 0)
+	if (0 == dvb_usb_device_init(intf, &dibusb1_1_properties, THIS_MODULE,
+				     NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &dibusb1_1_an2235_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &dibusb2_0b_properties, THIS_MODULE,
+				     NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &artec_t1_usb2_properties,
+				     THIS_MODULE, NULL, adapter_nr))
 		return 0;
 
 	return -EINVAL;
diff --git a/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c b/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c
@@ -14,13 +14,16 @@
  */
 #include "dibusb.h"
 
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
 /* USB Driver stuff */
 static struct dvb_usb_device_properties dibusb_mc_properties;
 
 static int dibusb_mc_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&dibusb_mc_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf, &dibusb_mc_properties, THIS_MODULE,
+				   NULL, adapter_nr);
 }
 
 /* do not change the order of the ID table */
diff --git a/linux/drivers/media/dvb/dvb-usb/digitv.c b/linux/drivers/media/dvb/dvb-usb/digitv.c
--- a/linux/drivers/media/dvb/dvb-usb/digitv.c
+++ b/linux/drivers/media/dvb/dvb-usb/digitv.c
@@ -20,6 +20,9 @@ static int dvb_usb_digitv_debug;
 static int dvb_usb_digitv_debug;
 module_param_named(debug,dvb_usb_digitv_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
 #define deb_rc(args...)   dprintk(dvb_usb_digitv_debug,0x01,args)
 
 static int digitv_ctrl_msg(struct dvb_usb_device *d,
@@ -256,8 +259,9 @@ static int digitv_probe(struct usb_inter
 		const struct usb_device_id *id)
 {
 	struct dvb_usb_device *d;
-	int ret;
-	if ((ret = dvb_usb_device_init(intf,&digitv_properties,THIS_MODULE,&d)) == 0) {
+	int ret = dvb_usb_device_init(intf, &digitv_properties, THIS_MODULE, &d,
+				      adapter_nr);
+	if (ret == 0) {
 		u8 b[4] = { 0 };
 
 		if (d != NULL) { /* do that only when the firmware is loaded */
diff --git a/linux/drivers/media/dvb/dvb-usb/dtt200u.c b/linux/drivers/media/dvb/dvb-usb/dtt200u.c
--- a/linux/drivers/media/dvb/dvb-usb/dtt200u.c
+++ b/linux/drivers/media/dvb/dvb-usb/dtt200u.c
@@ -17,6 +17,8 @@ int dvb_usb_dtt200u_debug;
 int dvb_usb_dtt200u_debug;
 module_param_named(debug,dvb_usb_dtt200u_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2 (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int dtt200u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
@@ -101,11 +103,16 @@ static int dtt200u_usb_probe(struct usb_
 static int dtt200u_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	if (dvb_usb_device_init(intf,&dtt200u_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&wt220u_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&wt220u_fc_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&wt220u_zl0353_properties,THIS_MODULE,NULL) == 0 ||
-		dvb_usb_device_init(intf,&wt220u_miglia_properties,THIS_MODULE,NULL) == 0)
+	if (0 == dvb_usb_device_init(intf, &dtt200u_properties, THIS_MODULE,
+				     NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &wt220u_properties, THIS_MODULE,
+				     NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &wt220u_fc_properties, THIS_MODULE,
+				     NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &wt220u_zl0353_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &wt220u_miglia_properties,
+				     THIS_MODULE, NULL, adapter_nr))
 		return 0;
 
 	return -ENODEV;
diff --git a/linux/drivers/media/dvb/dvb-usb/dvb-usb-common.h b/linux/drivers/media/dvb/dvb-usb/dvb-usb-common.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-common.h
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-common.h
@@ -40,7 +40,8 @@ extern int dvb_usb_i2c_init(struct dvb_u
 extern int dvb_usb_i2c_init(struct dvb_usb_device *);
 extern int dvb_usb_i2c_exit(struct dvb_usb_device *);
 
-extern int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap);
+extern int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap,
+				    int *adapter_nums);
 extern int dvb_usb_adapter_dvb_exit(struct dvb_usb_adapter *adap);
 extern int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap);
 extern int dvb_usb_adapter_frontend_exit(struct dvb_usb_adapter *adap);
diff --git a/linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
@@ -77,12 +77,13 @@ static int dvb_usb_stop_feed(struct dvb_
 	return dvb_usb_ctrl_feed(dvbdmxfeed,0);
 }
 
-int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap)
+int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, int *adapter_nums)
 {
-	int ret;
+	int ret = dvb_register_adapter(&adap->dvb_adap, adap->dev->desc->name,
+				       adap->dev->owner, &adap->dev->udev->dev,
+				       adapter_nums);
 
-	if ((ret = dvb_register_adapter(&adap->dvb_adap, adap->dev->desc->name,
-			adap->dev->owner, &adap->dev->udev->dev)) < 0) {
+	if (ret < 0) {
 		deb_info("dvb_register_adapter failed: error %d", ret);
 		goto err;
 	}
diff --git a/linux/drivers/media/dvb/dvb-usb/dvb-usb-init.c b/linux/drivers/media/dvb/dvb-usb/dvb-usb-init.c
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-init.c
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-init.c
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
@@ -213,8 +213,10 @@ int dvb_usb_device_power_ctrl(struct dvb
 /*
  * USB
  */
-int dvb_usb_device_init(struct usb_interface *intf, struct dvb_usb_device_properties
-		*props, struct module *owner,struct dvb_usb_device **du)
+int dvb_usb_device_init(struct usb_interface *intf,
+			struct dvb_usb_device_properties *props,
+			struct module *owner, struct dvb_usb_device **du,
+			int *adapter_nums)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct dvb_usb_device *d = NULL;
@@ -254,7 +256,7 @@ int dvb_usb_device_init(struct usb_inter
 	if (du != NULL)
 		*du = d;
 
-	ret = dvb_usb_init(d);
+	ret = dvb_usb_init(d, adapter_nums);
 
 	if (ret == 0)
 		info("%s successfully initialized and connected.",desc->name);
diff --git a/linux/drivers/media/dvb/dvb-usb/dvb-usb.h b/linux/drivers/media/dvb/dvb-usb/dvb-usb.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -387,7 +387,10 @@ struct dvb_usb_device {
 	void *priv;
 };
 
-extern int dvb_usb_device_init(struct usb_interface *, struct dvb_usb_device_properties *, struct module *, struct dvb_usb_device **);
+extern int dvb_usb_device_init(struct usb_interface *,
+			       struct dvb_usb_device_properties *,
+			       struct module *, struct dvb_usb_device **,
+			       int *adapter_nums);
 extern void dvb_usb_device_exit(struct usb_interface *);
 
 /* the generic read/write method for device control */
diff --git a/linux/drivers/media/dvb/dvb-usb/gl861.c b/linux/drivers/media/dvb/dvb-usb/gl861.c
--- a/linux/drivers/media/dvb/dvb-usb/gl861.c
+++ b/linux/drivers/media/dvb/dvb-usb/gl861.c
@@ -15,6 +15,8 @@ static int dvb_usb_gl861_debug;
 static int dvb_usb_gl861_debug;
 module_param_named(debug,dvb_usb_gl861_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
 			 u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
@@ -140,7 +142,9 @@ static int gl861_probe(struct usb_interf
 	if (intf->num_altsetting < 2)
 		return -ENODEV;
 
-	if ((ret = dvb_usb_device_init(intf, &gl861_properties, THIS_MODULE, &d)) == 0) {
+	ret = dvb_usb_device_init(intf, &gl861_properties, THIS_MODULE, &d,
+				  adapter_nr);
+	if (ret == 0) {
 		alt = usb_altnum_to_altsetting(intf, 0);
 
 		if (alt == NULL) {
diff --git a/linux/drivers/media/dvb/dvb-usb/gp8psk.c b/linux/drivers/media/dvb/dvb-usb/gp8psk.c
--- a/linux/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/linux/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -21,6 +21,8 @@ int dvb_usb_gp8psk_debug;
 int dvb_usb_gp8psk_debug;
 module_param_named(debug,dvb_usb_gp8psk_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
 {
@@ -208,7 +210,8 @@ static int gp8psk_usb_probe(struct usb_i
 {
 	int ret;
 	struct usb_device *udev = interface_to_usbdev(intf);
-	ret =  dvb_usb_device_init(intf,&gp8psk_properties,THIS_MODULE,NULL);
+	ret = dvb_usb_device_init(intf, &gp8psk_properties, THIS_MODULE, NULL,
+				  adapter_nr);
 	if (ret == 0) {
 		info("found Genpix USB device pID = %x (hex)",
 			le16_to_cpu(udev->descriptor.idProduct));
diff --git a/linux/drivers/media/dvb/dvb-usb/m920x.c b/linux/drivers/media/dvb/dvb-usb/m920x.c
--- a/linux/drivers/media/dvb/dvb-usb/m920x.c
+++ b/linux/drivers/media/dvb/dvb-usb/m920x.c
@@ -21,6 +21,8 @@ static int dvb_usb_m920x_debug;
 static int dvb_usb_m920x_debug;
 module_param_named(debug,dvb_usb_m920x_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int m920x_set_filter(struct dvb_usb_device *d, int type, int idx, int pid);
 
@@ -618,27 +620,31 @@ static int m920x_probe(struct usb_interf
 		 * multi-tuner device
 		 */
 
-		if ((ret = dvb_usb_device_init(intf, &megasky_properties,
-					       THIS_MODULE, &d)) == 0) {
+		ret = dvb_usb_device_init(intf, &megasky_properties,
+					  THIS_MODULE, &d, adapter_nr);
+		if (ret == 0) {
 			rc_init_seq = megasky_rc_init;
 			goto found;
 		}
 
-		if ((ret = dvb_usb_device_init(intf, &digivox_mini_ii_properties,
-					       THIS_MODULE, &d)) == 0) {
+		ret = dvb_usb_device_init(intf, &digivox_mini_ii_properties,
+					  THIS_MODULE, &d, adapter_nr);
+		if (ret == 0) {
 			/* No remote control, so no rc_init_seq */
 			goto found;
 		}
 
 		/* This configures both tuners on the TV Walker Twin */
-		if ((ret = dvb_usb_device_init(intf, &tvwalkertwin_properties,
-					       THIS_MODULE, &d)) == 0) {
+		ret = dvb_usb_device_init(intf, &tvwalkertwin_properties,
+					  THIS_MODULE, &d, adapter_nr);
+		if (ret == 0) {
 			rc_init_seq = tvwalkertwin_rc_init;
 			goto found;
 		}
 
-		if ((ret = dvb_usb_device_init(intf, &dposh_properties,
-					       THIS_MODULE, &d)) == 0) {
+		ret = dvb_usb_device_init(intf, &dposh_properties,
+					  THIS_MODULE, &d, adapter_nr);
+		if (ret == 0) {
 			/* Remote controller not supported yet. */
 			goto found;
 		}
diff --git a/linux/drivers/media/dvb/dvb-usb/nova-t-usb2.c b/linux/drivers/media/dvb/dvb-usb/nova-t-usb2.c
--- a/linux/drivers/media/dvb/dvb-usb/nova-t-usb2.c
+++ b/linux/drivers/media/dvb/dvb-usb/nova-t-usb2.c
@@ -14,6 +14,8 @@ static int debug;
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=rc,2=eeprom (|-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define deb_rc(args...) dprintk(debug,0x01,args)
 #define deb_ee(args...) dprintk(debug,0x02,args)
@@ -142,7 +144,8 @@ static int nova_t_probe(struct usb_inter
 static int nova_t_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&nova_t_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf, &nova_t_properties, THIS_MODULE, NULL,
+				   adapter_nr);
 }
 
 /* do not change the order of the ID table */
diff --git a/linux/drivers/media/dvb/dvb-usb/opera1.c b/linux/drivers/media/dvb/dvb-usb/opera1.c
--- a/linux/drivers/media/dvb/dvb-usb/opera1.c
+++ b/linux/drivers/media/dvb/dvb-usb/opera1.c
@@ -45,6 +45,9 @@ MODULE_PARM_DESC(debug,
 MODULE_PARM_DESC(debug,
 		 "set debugging level (1=info,xfer=2,pll=4,ts=8,err=16,rc=32,fw=64 (or-able))."
 		 DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
 #if 0
 struct mutex mymutex;
 #endif
@@ -559,7 +562,8 @@ static int opera1_probe(struct usb_inter
 		return -EINVAL;
 	}
 
-	if (dvb_usb_device_init(intf, &opera1_properties, THIS_MODULE, NULL) != 0)
+	if (0 != dvb_usb_device_init(intf, &opera1_properties, THIS_MODULE,
+				     NULL, adapter_nr))
 		return -EINVAL;
 	return 0;
 }
diff --git a/linux/drivers/media/dvb/dvb-usb/ttusb2.c b/linux/drivers/media/dvb/dvb-usb/ttusb2.c
--- a/linux/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/linux/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -36,6 +36,8 @@ static int dvb_usb_ttusb2_debug;
 #define deb_info(args...)   dprintk(dvb_usb_ttusb2_debug,0x01,args)
 module_param_named(debug,dvb_usb_ttusb2_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct ttusb2_state {
 	u8 id;
@@ -186,7 +188,8 @@ static int ttusb2_probe(struct usb_inter
 static int ttusb2_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&ttusb2_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf, &ttusb2_properties, THIS_MODULE, NULL,
+				   adapter_nr);
 }
 
 static struct usb_device_id ttusb2_table [] = {
diff --git a/linux/drivers/media/dvb/dvb-usb/umt-010.c b/linux/drivers/media/dvb/dvb-usb/umt-010.c
--- a/linux/drivers/media/dvb/dvb-usb/umt-010.c
+++ b/linux/drivers/media/dvb/dvb-usb/umt-010.c
@@ -12,6 +12,8 @@
 #include "dibusb.h"
 
 #include "mt352.h"
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static int umt_mt352_demod_init(struct dvb_frontend *fe)
 {
@@ -75,7 +77,8 @@ static int umt_probe(struct usb_interfac
 static int umt_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	if (dvb_usb_device_init(intf,&umt_properties,THIS_MODULE,NULL) == 0)
+	if (0 == dvb_usb_device_init(intf, &umt_properties, THIS_MODULE, NULL,
+				     adapter_nr))
 		return 0;
 	return -EINVAL;
 }
diff --git a/linux/drivers/media/dvb/dvb-usb/vp702x.c b/linux/drivers/media/dvb/dvb-usb/vp702x.c
--- a/linux/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/linux/drivers/media/dvb/dvb-usb/vp702x.c
@@ -20,6 +20,8 @@ int dvb_usb_vp702x_debug;
 int dvb_usb_vp702x_debug;
 module_param_named(debug,dvb_usb_vp702x_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct vp702x_state {
 	int pid_filter_count;
@@ -285,7 +287,8 @@ static int vp702x_usb_probe(struct usb_i
 static int vp702x_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&vp702x_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf, &vp702x_properties, THIS_MODULE, NULL,
+				   adapter_nr);
 }
 
 static struct usb_device_id vp702x_usb_table [] = {
diff --git a/linux/drivers/media/dvb/dvb-usb/vp7045.c b/linux/drivers/media/dvb/dvb-usb/vp7045.c
--- a/linux/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/linux/drivers/media/dvb/dvb-usb/vp7045.c
@@ -18,6 +18,9 @@ static int dvb_usb_vp7045_debug;
 static int dvb_usb_vp7045_debug;
 module_param_named(debug,dvb_usb_vp7045_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
 #define deb_info(args...) dprintk(dvb_usb_vp7045_debug,0x01,args)
 #define deb_xfer(args...) dprintk(dvb_usb_vp7045_debug,0x02,args)
 #define deb_rc(args...)   dprintk(dvb_usb_vp7045_debug,0x04,args)
@@ -227,7 +230,8 @@ static int vp7045_usb_probe(struct usb_i
 static int vp7045_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&vp7045_properties,THIS_MODULE,NULL);
+	return dvb_usb_device_init(intf, &vp7045_properties, THIS_MODULE, NULL,
+				   adapter_nr);
 }
 
 static struct usb_device_id vp7045_usb_table [] = {
diff --git a/linux/drivers/media/dvb/pluto2/pluto2.c b/linux/drivers/media/dvb/pluto2/pluto2.c
--- a/linux/drivers/media/dvb/pluto2/pluto2.c
+++ b/linux/drivers/media/dvb/pluto2/pluto2.c
@@ -38,6 +38,8 @@
 #include "dvb_net.h"
 #include "dvbdev.h"
 #include "tda1004x.h"
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define DRIVER_NAME		"pluto2"
 
@@ -666,7 +668,8 @@ static int __devinit pluto2_probe(struct
 		goto err_pluto_hw_exit;
 
 	/* dvb */
-	ret = dvb_register_adapter(&pluto->dvb_adapter, DRIVER_NAME, THIS_MODULE, &pdev->dev);
+	ret = dvb_register_adapter(&pluto->dvb_adapter, DRIVER_NAME,
+				   THIS_MODULE, &pdev->dev, adapter_nr);
 	if (ret < 0)
 		goto err_i2c_del_adapter;
 
diff --git a/linux/drivers/media/dvb/ttpci/av7110.c b/linux/drivers/media/dvb/ttpci/av7110.c
--- a/linux/drivers/media/dvb/ttpci/av7110.c
+++ b/linux/drivers/media/dvb/ttpci/av7110.c
@@ -111,6 +111,8 @@ MODULE_PARM_DESC(wss_cfg_16_9, "WSS 16:9
 MODULE_PARM_DESC(wss_cfg_16_9, "WSS 16:9 - default 0x0007 - bit 15: disable, 14: burst mode, 13..0: wss data");
 module_param(tv_standard, int, 0444);
 MODULE_PARM_DESC(tv_standard, "TV standard: 0 PAL (default), 1 NTSC");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static void restart_feeds(struct av7110 *av7110);
 
@@ -2461,7 +2463,7 @@ static int __devinit av7110_attach(struc
 		goto err_kfree_0;
 
 	ret = dvb_register_adapter(&av7110->dvb_adapter, av7110->card_name,
-				   THIS_MODULE, &dev->pci->dev);
+				   THIS_MODULE, &dev->pci->dev, adapter_nr);
 	if (ret < 0)
 		goto err_put_firmware_1;
 
diff --git a/linux/drivers/media/dvb/ttpci/budget-core.c b/linux/drivers/media/dvb/ttpci/budget-core.c
--- a/linux/drivers/media/dvb/ttpci/budget-core.c
+++ b/linux/drivers/media/dvb/ttpci/budget-core.c
@@ -56,6 +56,8 @@ module_param_named(bufsize, dma_buffer_s
 module_param_named(bufsize, dma_buffer_size, int, 0444);
 MODULE_PARM_DESC(debug, "Turn on/off budget debugging (default:off).");
 MODULE_PARM_DESC(bufsize, "DMA buffer size in KB, default: 188, min: 188, max: 1410 (Activy: 564)");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /****************************************************************************
  * TT budget / WinTV Nova
@@ -471,9 +473,10 @@ int ttpci_budget_init(struct budget *bud
 		budget->buffer_width, budget->buffer_height);
 	printk("%s: dma buffer size %u\n", budget->dev->name, budget->buffer_size);
 
-	if ((ret = dvb_register_adapter(&budget->dvb_adapter, budget->card->name, owner, &budget->dev->pci->dev)) < 0) {
+	ret = dvb_register_adapter(&budget->dvb_adapter, budget->card->name,
+				   owner, &budget->dev->pci->dev, adapter_nr);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* set dd1 stream a & b */
 	saa7146_write(dev, DD1_STREAM_B, 0x00000000);
diff --git a/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
--- a/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -59,9 +59,10 @@
 */
 
 static int debug;
-
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define dprintk(x...) do { if (debug) printk(KERN_DEBUG x); } while (0)
 
@@ -1681,7 +1682,10 @@ static int ttusb_probe(struct usb_interf
 
 	mutex_unlock(&ttusb->semi2c);
 
-	if ((result = dvb_register_adapter(&ttusb->adapter, "Technotrend/Hauppauge Nova-USB", THIS_MODULE, &udev->dev)) < 0) {
+	result = dvb_register_adapter(&ttusb->adapter,
+				      "Technotrend/Hauppauge Nova-USB",
+				      THIS_MODULE, &udev->dev, adapter_nr);
+	if (result < 0) {
 		ttusb_free_iso_urbs(ttusb);
 		kfree(ttusb);
 		return result;
diff --git a/linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c
--- a/linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/linux/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -54,6 +54,8 @@ MODULE_PARM_DESC(output_pva, "Output PVA
 MODULE_PARM_DESC(output_pva, "Output PVA from dvr device (default:off)");
 module_param(enable_rc, int, 0644);
 MODULE_PARM_DESC(enable_rc, "Turn on/off IR remote control(default: off)");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define dprintk	if (debug) printk
 
@@ -1456,7 +1458,9 @@ static int ttusb_dec_init_dvb(struct ttu
 	dprintk("%s\n", __FUNCTION__);
 
 	if ((result = dvb_register_adapter(&dec->adapter,
-					   dec->model_name, THIS_MODULE, &dec->udev->dev)) < 0) {
+					   dec->model_name, THIS_MODULE,
+					   &dec->udev->dev,
+					   adapter_nr)) < 0) {
 		printk("%s: dvb_register_adapter failed: error %d\n",
 		       __FUNCTION__, result);
 
diff --git a/linux/drivers/media/video/cx23885/cx23885-dvb.c b/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c
@@ -54,6 +54,8 @@ static unsigned int alt_tuner;
 static unsigned int alt_tuner;
 module_param(alt_tuner, int, 0644);
 MODULE_PARM_DESC(alt_tuner, "Enable alternate tuner configuration");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* ------------------------------------------------------------------ */
 
@@ -334,7 +336,7 @@ static int dvb_register(struct cx23885_t
 
 	/* register everything */
 	return videobuf_dvb_register(&port->dvb, THIS_MODULE, port,
-				     &dev->pci->dev);
+				     &dev->pci->dev, adapter_nr);
 }
 
 int cx23885_dvb_register(struct cx23885_tsport *port)
diff --git a/linux/drivers/media/video/cx88/cx88-dvb.c b/linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c
@@ -58,6 +58,8 @@ static unsigned int debug;
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug,"enable debug messages [dvb]");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define dprintk(level,fmt, arg...)	if (debug >= level) \
 	printk(KERN_DEBUG "%s/2-dvb: " fmt, core->name, ## arg)
@@ -869,7 +871,8 @@ static int dvb_register(struct cx8802_de
 	cx88_call_i2c_clients (dev->core, TUNER_SET_STANDBY, NULL);
 
 	/* register everything */
-	return videobuf_dvb_register(&dev->dvb, THIS_MODULE, dev, &dev->pci->dev);
+	return videobuf_dvb_register(&dev->dvb, THIS_MODULE, dev,
+				     &dev->pci->dev, adapter_nr);
 }
 
 /* ----------------------------------------------------------- */
diff --git a/linux/drivers/media/video/saa7134/saa7134-dvb.c b/linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c
@@ -64,6 +64,8 @@ static int debug;
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off module debugging (default:off).");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define dprintk(fmt, arg...)	do { if (debug) \
 	printk(KERN_DEBUG "%s/dvb: " fmt, dev->name , ## arg); } while(0)
@@ -1264,7 +1266,8 @@ static int dvb_init(struct saa7134_dev *
 	}
 
 	/* register everything else */
-	ret = videobuf_dvb_register(&dev->dvb, THIS_MODULE, dev, &dev->pci->dev);
+	ret = videobuf_dvb_register(&dev->dvb, THIS_MODULE, dev, &dev->pci->dev,
+				    adapter_nr);
 
 	/* this sequence is necessary to make the tda1004x load its firmware
 	 * and to enter analog mode of hybrid boards
diff --git a/linux/drivers/media/video/videobuf-dvb.c b/linux/drivers/media/video/videobuf-dvb.c
--- a/linux/drivers/media/video/videobuf-dvb.c
+++ b/linux/drivers/media/video/videobuf-dvb.c
@@ -144,14 +144,16 @@ int videobuf_dvb_register(struct videobu
 int videobuf_dvb_register(struct videobuf_dvb *dvb,
 			  struct module *module,
 			  void *adapter_priv,
-			  struct device *device)
+			  struct device *device,
+			  int *adapter_nr)
 {
 	int result;
 
 	mutex_init(&dvb->lock);
 
 	/* register adapter */
-	result = dvb_register_adapter(&dvb->adapter, dvb->name, module, device);
+	result = dvb_register_adapter(&dvb->adapter, dvb->name, module, device,
+				      adapter_nr);
 	if (result < 0) {
 		printk(KERN_WARNING "%s: dvb_register_adapter failed (errno = %d)\n",
 		       dvb->name, result);
diff --git a/linux/include/media/videobuf-dvb.h b/linux/include/media/videobuf-dvb.h
--- a/linux/include/media/videobuf-dvb.h
+++ b/linux/include/media/videobuf-dvb.h
@@ -35,7 +35,8 @@ int videobuf_dvb_register(struct videobu
 int videobuf_dvb_register(struct videobuf_dvb *dvb,
 			  struct module *module,
 			  void *adapter_priv,
-			  struct device *device);
+			  struct device *device,
+			  int *adapter_nr);
 void videobuf_dvb_unregister(struct videobuf_dvb *dvb);
 
 /*

--Boundary-00=_Nl97HlESVqpWnKP
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_Nl97HlESVqpWnKP--
