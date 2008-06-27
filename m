Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5RKkugm009856
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 16:46:56 -0400
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net
	[151.189.21.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5RKkVLX002967
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 16:46:32 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
	Peter Missel <peter.missel@onlinehome.de>
In-Reply-To: <loom.20080627T025843-957@post.gmane.org>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161724.20459.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
	<200803161840.37910.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.49.51.923202@gimpelevich.san-francisco.ca.us>
	<1206573402.3912.50.camel@pc08.localdom.local>
	<653f28469c9babb5326973c119fd78db@gimpelevich.san-francisco.ca.us>
	<loom.20080627T025843-957@post.gmane.org>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 22:43:18 +0200
Message-Id: <1214599398.2640.23.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

Am Freitag, den 27.06.2008, 03:00 +0000 schrieb Daniel Gimpelevich:
> Daniel Gimpelevich <daniel <at> gimpelevich.san-francisco.ca.us> writes:
> > On Mar 26, 2008, at 4:16 PM, hermann pitton wrote:
> > 
> > > [snip]
> > 
> > I have since returned the card to its owner, but I did try the 
> > composite-over-S setting, and I saw the S-video source when I did that, 
> > but in monochrome. Therefore, I can only assume that setting works the 
> > way it's designed, because I did not bother to jury-rig an S-video 
> > connector that carries a true composite signal. I already had a 
> > Signed-off-by in what I submitted, and you're welcome to carry that 
> > forward to changes you make to the patch. As far as I'm concerned, 
> > 5169/1502 needs to be recognized as card 39, notwithstanding any 
> > differences from 5168/1502.
> 
> Hermann and Peter, I'm curious as to what remaining objections there were to 
> adding the 5169/1502 subsystem ID to saa7134-cards.c, pointing to card #39. I 
> can repeat my assurances that that was indeed absolutely the correct card 
> definition.
> 

Daniel I'm fine with it, except what already was said.

Signed-off by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
diff -ru v4l-dvb-2e9a92dbe2be/linux/drivers/media/video/saa7134/saa7134-cards.c v4l-dvb-lvtg/linux/drivers/media/video/saa7134/saa7134-cards.c
--- v4l-dvb-2e9a92dbe2be/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Mar 16 08:14:12 2008
+++ v4l-dvb-lvtg/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Mar 16 08:38:08 2008
@@ -5141,19 +5141,19 @@
 		.subvendor    = 0x4e42,
 		.subdevice    = 0x3502,
 		.driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1822, /*Twinhan Technology Co. Ltd*/
 		.subdevice    = 0x0022,
 		.driver_data  = SAA7134_BOARD_TWINHAN_DTV_DVB_3056,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x16be,
 		.subdevice    = 0x0010, /* Medion version CTX953_V.1.4.3 */
 		.driver_data  = SAA7134_BOARD_CREATIX_CTX953,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1462, /* MSI */
@@ -5165,25 +5165,43 @@
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf436,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_CARDBUS_506,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf936,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_A16D,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xa836,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_M115,
-	}, {
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x185b,
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_T750,
-	}, {
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = 0x5169,
+		.subdevice    = 0x1502, /* possible variant of below */
+		.driver_data  = SAA7134_BOARD_FLYTVPLATINUM_MINI,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5169,
+		.subdevice    = 0x1502, /* LifeView LifeVideo To-Go */
+		.driver_data  = SAA7134_BOARD_FLYTVPLATINUM_MINI,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x5169,
+		.subdevice    = 0x1502, /* possible variant of above */
+		.driver_data  = SAA7134_BOARD_FLYTVPLATINUM_MINI,
+	},{
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,


Don't touch the spaces after commas on previous entries, add only
support for the saa7133 device you really tested on, run "make
checkpatch" and add spaces after commas ;)

Peter had more of the recent LifeView devices.

Seems he is pointing to some difference concerning the s-video inputs on
cardbus and Mini PCI devices I'm not aware of. I'm not sure what he
likes us to do.

And as said, send at least relevant dmesg output when loading the driver
and tuner modules, preferably with i2c_scan=1 enabled.

As just seen with an early Compro saa7133, we have no safety, that not
later on devices appear with the same PCI subsystem, which are in fact
different, and have no means then to keep the auto detection working
without such potentially useful information.

That it has no remote and no radio support I likely already asked.

Send a copy directly to Mauro and Hartmut too.
I'll ack it, if Peter doesn't have objections.

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
