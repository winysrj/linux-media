Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8SGZj4E025485
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 12:35:45 -0400
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net
	[151.189.21.53])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8SGZVrL015951
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 12:35:31 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Thomas Genty <tomlohave@gmail.com>, dabby bentam <db260179@hotmail.com>
In-Reply-To: <20080928014346.4da4b86e@mchehab.chehab.org>
References: <BLU116-W13E3E5DA492C7A08D36C3FC2470@phx.gbl>
	<1222490394.2668.10.camel@pc10.localdom.local>
	<20080928014346.4da4b86e@mchehab.chehab.org>
Content-Type: multipart/mixed; boundary="=-nIWnBfsaxhvkyfhndrPG"
Date: Sun, 28 Sep 2008 18:29:51 +0200
Message-Id: <1222619391.3423.30.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] saa7134: add support for Tv(working
	config), radio and analog audio in on the Hauppauge HVR-1110
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


--=-nIWnBfsaxhvkyfhndrPG
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Am Sonntag, den 28.09.2008, 01:43 -0300 schrieb Mauro Carvalho Chehab:
> On Sat, 27 Sep 2008 06:39:54 +0200
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> > Mauro,
> > 
> > wait a little.
> 
> OK. Please forward it to me again, after everything being ok with the patch.
> 
> Cheers,
> Mauro

Thomas mailed me that he has some trouble with his current setup and
might not be able to test that soon too.

The patch is already OK and tested by David.

David,
as told, we need also your email in signed-off-by.
I take it from the card's entry. Please give your OK.

Here is it again with some cleanup for spaces.
Mauro, please take it from the attachment.
Evolution inline converts tabs to spaces or I must force it into a mode
it does not like.

Cheers,
Hermann


saa7134: Hauppauge HVR-1110, support for radio and analog audio in

From: David Bentham <db260179@hotmail.com>

The audio switch is at 0x100 and radio on gpio 21.

Priority: normal

Signed-off-by: David Bentham <db260179@hotmail.com>
Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>

diff -r 8e6cda021e0e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Sep 26 11:29:03 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Sep 28 17:21:45 2008 +0200
@@ -3299,6 +3299,7 @@
 	},
 	[SAA7134_BOARD_HAUPPAUGE_HVR1110] = {
 		/* Thomas Genty <tomlohave@gmail.com> */
+		/* David Bentham <db260179@hotmail.com> */
 		.name           = "Hauppauge WinTV-HVR1110 DVB-T/Hybrid",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
@@ -3307,23 +3308,26 @@
 		.radio_addr     = ADDR_UNSET,
 		.tuner_config   = 1,
 		.mpeg           = SAA7134_MPEG_DVB,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 1,
-			.amux = TV,
-			.tv   = 1,
-		},{
-			.name   = name_comp1,
-			.vmux   = 3,
-			.amux   = LINE2, /* FIXME: audio doesn't work on svideo/composite */
-		},{
-			.name   = name_svideo,
-			.vmux   = 8,
-			.amux   = LINE2, /* FIXME: audio doesn't work on svideo/composite */
-		}},
-		.radio = {
-			.name = name_radio,
-			.amux   = TV,
+		.gpiomask       = 0x0200100,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+			.gpio = 0x0000100,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200100,
 		},
 	},
 	[SAA7134_BOARD_CINERGY_HT_PCMCIA] = {


--=-nIWnBfsaxhvkyfhndrPG
Content-Description: 
Content-Disposition: inline;
	filename*0=saa7134_hauppauge-hvr-1110_enable_analog_audio_in_and_radio.p;
	filename*1=atch
Content-Type: text/x-patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff -r 8e6cda021e0e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Sep 26 11:29:03 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Sep 28 17:21:45 2008 +0200
@@ -3299,6 +3299,7 @@
 	},
 	[SAA7134_BOARD_HAUPPAUGE_HVR1110] = {
 		/* Thomas Genty <tomlohave@gmail.com> */
+		/* David Bentham <db260179@hotmail.com> */
 		.name           = "Hauppauge WinTV-HVR1110 DVB-T/Hybrid",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
@@ -3307,23 +3308,26 @@
 		.radio_addr     = ADDR_UNSET,
 		.tuner_config   = 1,
 		.mpeg           = SAA7134_MPEG_DVB,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 1,
-			.amux = TV,
-			.tv   = 1,
-		},{
-			.name   = name_comp1,
-			.vmux   = 3,
-			.amux   = LINE2, /* FIXME: audio doesn't work on svideo/composite */
-		},{
-			.name   = name_svideo,
-			.vmux   = 8,
-			.amux   = LINE2, /* FIXME: audio doesn't work on svideo/composite */
-		}},
-		.radio = {
-			.name = name_radio,
-			.amux   = TV,
+		.gpiomask       = 0x0200100,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+			.gpio = 0x0000100,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200100,
 		},
 	},
 	[SAA7134_BOARD_CINERGY_HT_PCMCIA] = {

--=-nIWnBfsaxhvkyfhndrPG
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-nIWnBfsaxhvkyfhndrPG--
