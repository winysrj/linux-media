Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZDVCZ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 22:25:29 -0400
Date: Tue, 21 Apr 2009 23:25:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: vaka@newmail.ru
Cc: hermann pitton <hermann-pitton@arcor.de>,
	akpm@linux-foundation.org, mm-commits@vger.kernel.org,
	mkrufky@linuxtv.org, hartmut.hackmann@t-online.de,
	linux-media@vger.kernel.org
Subject: Re: +
 drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505.patch
 added to -mm tree
Message-ID: <20090421232519.51365265@pedra.chehab.org>
In-Reply-To: <1240356078.22263.33.camel@pc07.localdom.local>
References: <200904202021.n3KKLGvd000469@imap1.linux-foundation.org>
	<1240356078.22263.33.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Apr 2009 01:21:18 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:

> Vasily, your change in saa7134-video.c has broken support for all other
> SECAM standards and users can't change them from the applications
> anymore.
> 
> After years of trouble, it has very good reasons that we have it as it
> is and it was a lot of work to make it usable for all, since different
> Secam auto detection through the tvaudio kernelthread turned out to be
> impossible.
> 
> Here is Hartmut's original patch, on which you touch, after working for
> a weekend with a signal generator to find a resolution suitable for all.
> http://linuxtv.org/hg/v4l-dvb/rev/84a832a5ffc9

The trouble pointed by Hermann is caused by this hunk:

diff -puN drivers/media/video/saa7134/saa7134-video.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 drivers/media/video/saa7134/saa7134-video.c
--- a/drivers/media/video/saa7134/saa7134-video.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
+++ a/drivers/media/video/saa7134/saa7134-video.c
@@ -39,7 +39,7 @@ static unsigned int gbuffers      = 8;
 static unsigned int noninterlaced; /* 0 */
 static unsigned int gbufsize      = 720*576*4;
 static unsigned int gbufsize_max  = 720*576*4;
-static char secam[] = "--";
+static char secam[] = "dk";
 module_param(video_debug, int, 0644);
 MODULE_PARM_DESC(video_debug,"enable debug messages [video]");
 module_param(gbuffers, int, 0444);

This disables SECAM autodetection, forcing the driver to use SECAM/DK. Just
removing this will fix this issue.

> Also please don't jump around with the card #define in saa7134.h.
> We keep it there like they historically do appear.

--- a/drivers/media/video/saa7134/saa7134.h~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
+++ a/drivers/media/video/saa7134/saa7134.h
@@ -159,6 +159,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_DVD_EZMAKER 33
 #define SAA7134_BOARD_NOVAC_PRIMETV7133 34
 #define SAA7134_BOARD_AVERMEDIA_STUDIO_305 35
+#define SAA7134_BOARD_AVERMEDIA_STUDIO_505 158
 #define SAA7134_BOARD_UPMOST_PURPLE_TV 36
 #define SAA7134_BOARD_ITEMS_MTV005     37
 #define SAA7134_BOARD_CINERGY200       38

Agreed. The boards are ordered by number, not by name. Since the board number
should be unique, ordering by something else will likely create duplicate
numbers.

Cheers,
Mauro
