Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:52837 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab0AIQPE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2010 11:15:04 -0500
Date: Sat, 9 Jan 2010 17:14:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Daro <ghost-rider@aster.pl>
Cc: LMML <linux-media@vger.kernel.org>,
	V4L and DVB maintainers <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: IR device at I2C address 0x7a
Message-ID: <20100109171457.77439f12@hyperion.delvare>
In-Reply-To: <4B4871C4.10401@aster.pl>
References: <4B324EF0.7090606@aster.pl>
	<20100106153909.6bce3183@hyperion.delvare>
	<4B44CF62.5060405@aster.pl>
	<20100106194059.061636d3@hyperion.delvare>
	<4B44E026.3060906@aster.pl>
	<20100106212140.11b02d0f@hyperion.delvare>
	<4B4871C4.10401@aster.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 09 Jan 2010 13:08:36 +0100, Daro wrote:
> W dniu 06.01.2010 21:21, Jean Delvare pisze:
> > On Wed, 06 Jan 2010 18:58:58 +0100, Daro wrote:
> >> It is not the error message itself that bothers me but the fact that IR
> >> remote control device is not detected and I cannot use it (I checked it
> >> on Windows and it's working). After finding this thread I thought it
> >> could have had something to do with this error mesage.
> >> Is there something that can be done to get my IR remote control working?
> > You could try loading the saa7134 driver with option card=146 and see
> > if it helps.
>
> It works!
> 
> [   15.477875] input: saa7134 IR (ASUSTeK P7131 Analo as 
> /devices/pci0000:00/0000:00:1e.0/0000:05:00.0/input/input8
> 
> Thank you very much fo your help.

Then I would suggest the following patch:

* * * * *

From: Jean Delvare <khali@linux-fr.org>
Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants

Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
Analog (card=146). However, by the time we find out, some
card-specific initialization is missed. In particular, the fact that
the IR is GPIO-based. Set it when we change the card type.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Daro <ghost-rider@aster.pl>
---
 linux/drivers/media/video/saa7134/saa7134-cards.c |    1 +
 1 file changed, 1 insertion(+)

--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-12-11 09:47:47.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-09 16:23:17.000000000 +0100
@@ -7257,6 +7257,7 @@ int saa7134_board_init2(struct saa7134_d
 		       printk(KERN_INFO "%s: P7131 analog only, using "
 						       "entry of %s\n",
 		       dev->name, saa7134_boards[dev->board].name);
+			dev->has_remote = SAA7134_REMOTE_GPIO;
 	       }
 	       break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:


* * * * *

> I have another question regarding this driver:
> 
> [   21.340316] saa7133[0]: dsp access error
> [   21.340320] saa7133[0]: dsp access error
> 
> Do those messages imply something wrong? Can they have something do do 
> with the fact I cannot get the sound out of tvtime application directly 
> and have to use "arecord | aplay" workaround which causes undesirable delay?

Yes, the message is certainly related to your sound problem. Maybe
support for your card is incomplete. But I can't help with this, sorry.

-- 
Jean Delvare
