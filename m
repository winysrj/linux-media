Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n59.bullet.mail.sp1.yahoo.com ([98.136.44.43])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KJT5J-0007dD-Ay
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 15:00:04 +0200
Date: Thu, 17 Jul 2008 05:59:13 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <209127.78178.qm@web46106.mail.sp1.yahoo.com>
Subject: [linux-dvb] Testers with Medion MD95700 DVB-T wanted
Reply-To: free_beer_for_all@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Moin!

I would like someone with the Medion MD95700 tuner to test
the following patch and report whether anything breaks.

The present kernel codes do not function with my MD95700,
and previously I've had to break supporting those cards that
presently work in order to make mine work.

If you have this DVB-T tuner, can you try this patch, and
report success or failure.  When you attach your device, you
should see one line reporting that alt 6 is a bulk endpoint,
and then you should be able to use your tuner as before.


If this patch has gotten mangled thanks to the convoluted way
I'm mailing, or if it doesn't apply to an older kernel you
may be running, please reply to me personally and I'll point
you to a new diff, thanks.



--- drivers/media/dvb/dvb-usb/cxusb.c-DIST      2008-04-24 19:09:44.000000000 +0200
+++ drivers/media/dvb/dvb-usb/cxusb.c   2008-07-17 13:58:41.000000000 +0200
@@ -535,8 +535,7 @@ static int cxusb_dvico_xc3028_tuner_atta
 static int cxusb_cx22702_frontend_attach(struct dvb_usb_adapter *adap)
 {
        u8 b;
-       if (usb_set_interface(adap->dev->udev, 0, 6) < 0)
-               err("set interface failed");
+/* XXX don't usb_set_interface() here; let new identify routine set interface */
 
        cxusb_ctrl_msg(adap->dev, CMD_DIGITAL, NULL, 0, &b, 1);
 
@@ -712,6 +711,61 @@ static int bluebird_patch_dvico_firmware
        return -EINVAL;
 }
 
+/* XXX another desperate attempt at a hack */
+/*  Use identify_state not for deciding whether the device is cold or not,
+ *  but rather to check the type of data seen from alt setting 6.
+ *  A type of BULK is what the present kernel code expects, and is what
+ *  devices which have been flashed since purchase will deliver.
+ *  Devices out-of-the-box (like mine) present ISOC data on this endpoint
+ *  however, and won't work with the present kernel code -- however, they
+ *  do deliver usable BULK data from alt setting 0.  Move the altsetting
+ *  code to here and set it to 6 for flashed boxes like the present kernel
+ *  code, or set it to 0 for boxes like mine.
+ *  Spew some debuggery that can be deleted or turned into genuine debug
+ */
+static int medion_identify_state(struct usb_device *udev,
+                                      struct dvb_usb_device_properties *props,
+                                      struct dvb_usb_device_description **desc,
+                                      int *cold)
+{
+       struct usb_host_interface *alt;
+       struct usb_host_endpoint  *e;
+
+       if (*cold)
+               return 0;
+
+       /* Check the data type on alt interface 6.  If it's bulk, use it.
+        * If it's isoc, we're looking at a factory-fresh box, on which
+        * bulk data can be found instead at alt 0.
+        */
+       alt = usb_altnum_to_altsetting(usb_ifnum_to_if(udev, 0), 6);
+       e = alt->endpoint + 2; /* ep; */
+
+       switch (e->desc.bmAttributes) {
+               case USB_ENDPOINT_XFER_ISOC:
+/* XXX debug */                err("endpoint ISOC wrong, you have an original box");
+                       alt = usb_altnum_to_altsetting(usb_ifnum_to_if(udev,
+                           0), 0);
+                       e = alt->endpoint + 2;
+
+                       if (e->desc.bmAttributes != USB_ENDPOINT_XFER_BULK) {
+/* XXX this shouldn't happen */        err("NOT BULK ENDPOINT, this is BAD, bailing");
+                               return -EIO;
+                       }
+                       if (usb_set_interface(udev, 0, 0) < 0)
+                               err("set interface failed");
+/* XXX debug */                err("using alt 0 as bulk instead");
+                       break;
+
+               case USB_ENDPOINT_XFER_BULK:
+/* XXX debug */                err("alt 6: endpoint BULK, you have an updated box!");
+               default: /* should not happen... treat as original source */
+                       if (usb_set_interface(udev, 0, 6) < 0)
+                               err("set interface failed");
+               }
+       return 0;
+}
+
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties cxusb_medion_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties;
@@ -772,6 +826,7 @@ static struct dvb_usb_device_properties 
        .caps = DVB_USB_IS_AN_I2C_ADAPTER,
 
        .usb_ctrl = CYPRESS_FX2,
+       .identify_state   = medion_identify_state,
 
        .size_of_priv     = sizeof(struct cxusb_state),
 


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
