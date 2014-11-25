Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60620 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbaKYSAi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 13:00:38 -0500
Date: Tue, 25 Nov 2014 16:00:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Malcolm Priestley <malcolmpriestley@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] lmed04: add missing breaks
Message-ID: <20141125160033.4d613dd7@recife.lan>
In-Reply-To: <5474B7E8.5020402@gmail.com>
References: <d442b15fb4deb2b5d516e2dae1f569b1d5472399.1416914348.git.mchehab@osg.samsung.com>
	<5474B7E8.5020402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Nov 2014 17:10:00 +0000
Malcolm Priestley <malcolmpriestley@gmail.com> escreveu:

> On 25/11/14 11:19, Mauro Carvalho Chehab wrote:
> > drivers/media/usb/dvb-usb-v2/lmedm04.c:828 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'
> > drivers/media/usb/dvb-usb-v2/lmedm04.c:849 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> > index 9f2c5459b73a..99587418f4f0 100644
> > --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
> > +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> > @@ -826,6 +826,7 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
> >   				break;
> >   			}
> >   			st->dvb_usb_lme2510_firmware = TUNER_LG;
> > +			break;
> >   		case TUNER_LG:
> >   			fw_lme = fw_lg;
> >   			ret = request_firmware(&fw, fw_lme, &udev->dev);
> > @@ -847,6 +848,7 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
> >   				break;
> >   			}
> >   			st->dvb_usb_lme2510_firmware = TUNER_LG;
> > +			break;
> >   		case TUNER_LG:
> >   			fw_lme = fw_c_lg;
> >   			ret = request_firmware(&fw, fw_lme, &udev->dev);
> >
> The break is not missing it's three lines above.
> 
> All these switches are fall through until it finds firmware the user has.
> 
> The switch comes into play when the firmware needs to changed.

Oh! Well, I was so sure that the patch was right that I merged it already.
My bad.

Anyway, smatch complains if dvb_usb_lme2510_firmware is rewritten,
and that bothers people that use static analyzers. So, IMO, the best
is to rework the code in order to:
- document that the breaks should not be used there;
- remove smatch warning.

What do you think about the following patch?

Revert "[media] lmed04: add missing breaks"
 
According with Malcolm, the missing breaks are intentional.
    
So, let's revert commit d442b15fb4deb2b5d516e2dae1f569b1d5472399,
add some comments to document it and fix the two smatch warnings:

drivers/media/usb/dvb-usb-v2/lmedm04.c:828 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'
drivers/media/usb/dvb-usb-v2/lmedm04.c:850 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'

using a different strategy to avoid reassign values to
st->dvb_usb_lme2510_firmware.

Requested-by: Malcolm Priestley <malcolmpriestley@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 99587418f4f0..994de53a574b 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -817,21 +817,22 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
 	case 0x1122:
 		switch (st->dvb_usb_lme2510_firmware) {
 		default:
-			st->dvb_usb_lme2510_firmware = TUNER_S0194;
 		case TUNER_S0194:
 			fw_lme = fw_s0194;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
 			if (ret == 0) {
+				st->dvb_usb_lme2510_firmware = TUNER_S0194;
 				cold = 0;
 				break;
 			}
-			st->dvb_usb_lme2510_firmware = TUNER_LG;
-			break;
+			/* fall through */
 		case TUNER_LG:
 			fw_lme = fw_lg;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
-			if (ret == 0)
+			if (ret == 0) {
+				st->dvb_usb_lme2510_firmware = TUNER_LG;
 				break;
+			}
 			st->dvb_usb_lme2510_firmware = TUNER_DEFAULT;
 			break;
 		}
@@ -839,27 +840,30 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
 	case 0x1120:
 		switch (st->dvb_usb_lme2510_firmware) {
 		default:
-			st->dvb_usb_lme2510_firmware = TUNER_S7395;
 		case TUNER_S7395:
 			fw_lme = fw_c_s7395;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
 			if (ret == 0) {
+				st->dvb_usb_lme2510_firmware = TUNER_S7395;
 				cold = 0;
 				break;
 			}
-			st->dvb_usb_lme2510_firmware = TUNER_LG;
-			break;
+			/* fall through */
 		case TUNER_LG:
 			fw_lme = fw_c_lg;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
-			if (ret == 0)
+			if (ret == 0) {
+				st->dvb_usb_lme2510_firmware = TUNER_LG;
 				break;
-			st->dvb_usb_lme2510_firmware = TUNER_S0194;
+			}
+			/* fall through */
 		case TUNER_S0194:
 			fw_lme = fw_c_s0194;
 			ret = request_firmware(&fw, fw_lme, &udev->dev);
-			if (ret == 0)
+			if (ret == 0) {
+				st->dvb_usb_lme2510_firmware = TUNER_S0194;
 				break;
+			}
 			st->dvb_usb_lme2510_firmware = TUNER_DEFAULT;
 			cold = 0;
 			break;
