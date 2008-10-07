Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9750CGE028102
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 01:00:12 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m974xtgE025362
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 00:59:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 7 Oct 2008 06:59:01 +0200
References: <20081005002701.31a2ee5f@pedra.chehab.org>
In-Reply-To: <20081005002701.31a2ee5f@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810070659.01415.hverkuil@xs4all.nl>
Cc: linux-dvb-maintainer@linuxtv.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [GIT PATCHES for 2.6.27] V4L/DVB fixes
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

Mauro, Linus,

Please revert this patch for 2.6.27:

>    - cx88: add missing unlock_kernel;

It was a patch for 2.6.28 where the BKL was pushed down from v4l core to 
the drivers, not for 2.6.27!

The patch below reverts it:

diff --git a/drivers/media/video/cx88/cx88-blackbird.c 
b/drivers/media/video/cx88/cx88-blackbird.c
index 6b92206..9a1374a 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1070,7 +1070,6 @@ static int mpeg_open(struct inode *inode, struct 
file *file)
 		err = drv->request_acquire(drv);
 		if(err != 0) {
 			dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
-			unlock_kernel();
 			return err;
 		}
 	}

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

         Hans

On Sunday 05 October 2008 05:27:01 Mauro Carvalho Chehab wrote:
> Linus,
>
> Please pull from:
>        
> ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
> fixes
>
> For a series of trivial fixes:
>
>    - Several trivial fixes at gspca;
>    - Several memory leak fixes at wm8739, w9968cf, em28xx-audio,
> cpia_usb, ov511, gspca;
>    - pvrusb2: Add support for a missing USB ID;
>    - cx88: add missing unlock_kernel;
>    - ov511: fix exposure sysfs attribute bug;
>    - cx18: Fix tuner audio input for Compro H900 cards;
>    - em28xx: Remove duplicate entry, fix detection of Kworld 310u;
>    - em28xx-alsa: fix clicking;
>    - bttv: Prevent NULL pointer dereference in radio_open;
>    - zr36067: several API non-conformance fixes;
>    - drivers/media/video/cafe_ccic.c needs mm.h
>    - s2255drv field count fix;
>    - Use correct XC3028L firmware for AMD ATI TV Wonder 600 to avoid
> overheating; - sms1xxx: fix product name for Hauppauge and add proper
> USB ID for WinTV MiniStick; - Fix deadlock in demux code;
>    - Fix support for Hauppauge Nova-S SE;
>    - S5H1420: Fix size of shadow-array to avoid overflow;
>    - fix buffer overflow in uvc-video.
>
> Cheers,
> Mauro.
>
> ---
>
>  Documentation/video4linux/CARDLIST.em28xx     |    2 +-
>  Documentation/video4linux/gspca.txt           |    1 +
>  drivers/media/common/tuners/tuner-xc2028.h    |    1 +
>  drivers/media/dvb/b2c2/flexcop-fe-tuner.c     |    1 +
>  drivers/media/dvb/dvb-core/dmxdev.c           |   16 ++++---
>  drivers/media/dvb/dvb-core/dvb_demux.c        |   16 +++++---
>  drivers/media/dvb/frontends/s5h1420.c         |   11 +++--
>  drivers/media/dvb/frontends/s5h1420.h         |    8 ++-
>  drivers/media/dvb/siano/sms-cards.c           |    4 +-
>  drivers/media/video/bt8xx/bttv-driver.c       |    2 +-
>  drivers/media/video/cafe_ccic.c               |    1 +
>  drivers/media/video/cpia2/cpia2_usb.c         |    5 ++-
>  drivers/media/video/cx18/cx18-cards.c         |    2 +-
>  drivers/media/video/cx88/cx88-blackbird.c     |    1 +
>  drivers/media/video/em28xx/em28xx-audio.c     |   12 ++++-
>  drivers/media/video/em28xx/em28xx-cards.c     |   55
> ++++++++++++------------- drivers/media/video/em28xx/em28xx-dvb.c    
>   |    9 ++++
>  drivers/media/video/gspca/gspca.c             |    3 +-
>  drivers/media/video/gspca/pac7311.c           |    1 +
>  drivers/media/video/gspca/sonixb.c            |    4 +-
>  drivers/media/video/gspca/sonixj.c            |   19 ++++++--
>  drivers/media/video/gspca/spca561.c           |    2 +-
>  drivers/media/video/gspca/zc3xx.c             |    4 +-
>  drivers/media/video/ov511.c                   |    6 ++-
>  drivers/media/video/pvrusb2/pvrusb2-devattr.c |    2 +
>  drivers/media/video/s2255drv.c                |    3 +-
>  drivers/media/video/uvc/uvc_ctrl.c            |    2 +-
>  drivers/media/video/w9968cf.c                 |    2 +-
>  drivers/media/video/wm8739.c                  |    4 +-
>  drivers/media/video/zoran_card.c              |    2 +-
>  drivers/media/video/zoran_driver.c            |   15 +++----
>  31 files changed, 130 insertions(+), 86 deletions(-)
>
> Andreas Oberritter (1):
>       V4L/DVB (9029): Fix deadlock in demux code
>
> Andrew Morton (1):
>       V4L/DVB (8960): drivers/media/video/cafe_ccic.c needs mm.h
>
> Costantino Leandro (1):
>       V4L/DVB (8933): gspca: Disable light frquency for zc3xx cs2102
> Kokom.
>
> Darron Broad (1):
>       V4L/DVB (9099): em28xx: Add detection for K-WORLD DVB-T 310U
>
> Dean Anderson (1):
>       V4L/DVB (8963): s2255drv field count fix
>
> Devin Heitmueller (1):
>       V4L/DVB (8967): Use correct XC3028L firmware for AMD ATI TV
> Wonder 600
>
> Douglas Schilling Landgraf (6):
>       V4L/DVB (8883): w9968cf: Fix order of usb_alloc_urb validation
>       V4L/DVB (8884): em28xx-audio: fix memory leak
>       V4L/DVB (8885): cpia2_usb: fix memory leak
>       V4L/DVB (8886): ov511: fix memory leak
>       V4L/DVB (8887): gspca: fix memory leak
>       V4L/DVB (8935): em28xx-cards: Remove duplicate entry
> (EM2800_BOARD_KWORLD_USB2800)
>
> Hans Verkuil (4):
>       V4L/DVB (8789): wm8739: remove wrong kfree
>       V4L/DVB (8904): cx88: add missing unlock_kernel
>       V4L/DVB (8905): ov511: fix exposure sysfs attribute bug
>       V4L/DVB (8919): cx18: Fix tuner audio input for Compro H900
> cards
>
> Hans de Goede (1):
>       V4L/DVB (8909): gspca: PAC 7302 webcam 093a:262a added.
>
> Jean Delvare (4):
>       V4L/DVB (8955): bttv: Prevent NULL pointer dereference in
> radio_open V4L/DVB (8957): zr36067: Restore the default pixel format
> V4L/DVB (8958): zr36067: Return proper bytes-per-line value V4L/DVB
> (8961): zr36067: Fix RGBR pixel format
>
> Jean-Francois Moine (3):
>       V4L/DVB (8926): gspca: Bad fix of leak memory (changeset
> 43d2ead315b1). V4L/DVB (9080): gspca: Add a delay after writing to
> the sonixj sensors. V4L/DVB (9092): gspca: Bad init values for sonixj
> ov7660.
>
> Mauro Carvalho Chehab (1):
>       V4L/DVB (8559a): Fix a merge conflict at gspca/sonixb
>
> Michael Krufky (2):
>       V4L/DVB (8978): sms1xxx: fix product name for Hauppauge WinTV
> MiniStick V4L/DVB (8979): sms1xxx: Add new USB product ID for
> Hauppauge WinTV MiniStick
>
> Mike Isely (1):
>       V4L/DVB (8892): pvrusb2: Handle USB ID 2040:2950 same as
> 2040:2900
>
> Patrick Boettcher (2):
>       V4L/DVB (9037): Fix support for Hauppauge Nova-S SE
>       V4L/DVB (9043): S5H1420: Fix size of shadow-array to avoid
> overflow
>
> Ralph Loader (1):
>       V4L/DVB (9053): fix buffer overflow in uvc-video
>
> Shane (1):
>       V4L/DVB (9075): gspca: Bad check of returned status in
> i2c_read() spca561.
>
> Wiktor Grebla (1):
>       V4L/DVB (9103): em28xx: HVR-900 B3C0 - fix audio clicking issue
>
> ---------------------------------------------------
> V4L/DVB development is hosted at http://linuxtv.org
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
