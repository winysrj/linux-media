Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3NGLEQx019902
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 12:21:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3NGKaUE024147
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 12:20:47 -0400
Date: Wed, 23 Apr 2008 13:20:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Edward J. Sheldrake" <ejs1920@yahoo.co.uk>
Message-ID: <20080423132023.062388d9@gaivota>
In-Reply-To: <920100.36100.qm@web27910.mail.ukl.yahoo.com>
References: <20080422183740.5aac8772@gaivota>
	<920100.36100.qm@web27910.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: em28xx/xc3028: changeset 7651 breaks analog audio?
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

On Wed, 23 Apr 2008 09:08:41 +0100 (BST)
"Edward J. Sheldrake" <ejs1920@yahoo.co.uk> wrote:

> --- Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > I'm enclosing two hacks. please, re-apply 7651, and try first
> > hack1.patch.
> > Then, revert it and apply hack2.patch.
> > 
> > Please tell me if both hacks work or not, and send me the dmesgs for
> > each case
> > (after loading mplayer).
> > 
> Hi Mauro
> 
> I started with a fresh copy of the v4l-dvb repo updated to changeset
> 7673 each time.
> 
> hack1: works
> hack2: works
> 
> I opened and closed mplayer twice for each test, so there are some
> normal "resubmit of audio urb failed" messages included. Dmesg output
> is attached, hack1 first.

I think I got the issue. Not sure yet about the proper solution.

What happens is that there are two firmwares for PAL/I: One is mono (IF=6.0)
and another for stereo (IF=6.24).

The current code handles it properly, while the previous one were probably
using mono.

For stereo to work, you need to load the non-mts firmware.

Please, try again, with with the enclosed patch. Let's see if stereo will work
on your board.

This should load the IF=6.24 firmware, non-MTS mode.

Cheers,
Mauro

diff -r 8e992045c18e linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Wed Apr 23 12:28:01 2008 -0300
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Wed Apr 23 13:18:38 2008 -0300
@@ -157,7 +157,7 @@
 		.vchannels    = 3,
 		.tda9887_conf = TDA9887_PRESENT,
 		.tuner_type   = TUNER_XC2028,
-		.mts_firmware = 1,
+		.mts_firmware = 0,
 		.decoder      = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
