Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5S1k5G9024760
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 21:46:05 -0400
Received: from mail9.dslextreme.com (mail9.dslextreme.com [66.51.199.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5S1jjOp020928
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 21:45:46 -0400
Message-ID: <486597B6.2010300@gimpelevich.san-francisco.ca.us>
Date: Fri, 27 Jun 2008 18:45:26 -0700
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161724.20459.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
	<200803161840.37910.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.49.51.923202@gimpelevich.san-francisco.ca.us>
	<1206573402.3912.50.camel@pc08.localdom.local>
	<653f28469c9babb5326973c119fd78db@gimpelevich.san-francisco.ca.us>
	<loom.20080627T025843-957@post.gmane.org>
	<1214599398.2640.23.camel@pc10.localdom.local>
In-Reply-To: <1214599398.2640.23.camel@pc10.localdom.local>
Content-Type: multipart/mixed; boundary="------------070502050909010407070407"
Cc: video4linux-list@redhat.com, mchehab@infradead.org
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

This is a multi-part message in MIME format.
--------------070502050909010407070407
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

hermann pitton wrote:
> Don't touch the spaces after commas on previous entries, add only
> support for the saa7133 device you really tested on, run "make
> checkpatch" and add spaces after commas ;)

Done; attached.

> Peter had more of the recent LifeView devices.
> 
> Seems he is pointing to some difference concerning the s-video inputs on
> cardbus and Mini PCI devices I'm not aware of. I'm not sure what he
> likes us to do.

As I said before, I addressed that and more before I even said anything 
about it on the list at all.

> And as said, send at least relevant dmesg output when loading the driver
> and tuner modules, preferably with i2c_scan=1 enabled.

I would need to borrow the card again to do that, and I'm not sure it 
would be all that useful for differentiation.

> As just seen with an early Compro saa7133, we have no safety, that not
> later on devices appear with the same PCI subsystem, which are in fact
> different, and have no means then to keep the auto detection working
> without such potentially useful information.

Seems to me that the contents of the tveeprom may be a more reliable 
mechanism.

> That it has no remote and no radio support I likely already asked.

It has whatever Card 39 has.

> Send a copy directly to Mauro and Hartmut too.
> I'll ack it, if Peter doesn't have objections.

Done.

--------------070502050909010407070407
Content-Type: text/x-patch;
 name="lifevideo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lifevideo.patch"

Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>

diff -r aef02567c2d9 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jun 27 16:25:56 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jun 27 17:54:07 2008 -0700
@@ -5407,6 +5407,12 @@
 		.subvendor    = 0x185b,
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_T750,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5169,
+		.subdevice    = 0x1502,
+		.driver_data  = SAA7134_BOARD_FLYTVPLATINUM_MINI,
 	}, {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,

--------------070502050909010407070407
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------070502050909010407070407--
