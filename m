Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m62CInlo022282
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 08:18:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m62CIauD026143
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 08:18:36 -0400
Date: Wed, 2 Jul 2008 09:18:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080702091819.031ea3ad@gaivota>
In-Reply-To: <20080630175605.445b7672@gaivota>
References: <20080630175605.445b7672@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Brandon Philips <bphilips@suse.de>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH for 2.6.26] V4L/DVB: Addition of UVC driver
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

On Mon, 30 Jun 2008 17:56:05 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Linus,
> 
> Please pull from:
>         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master
> 
> For USB Video Class (UVC) driver.
> 
> I know that we are very late on 2.6.26 cycle. However,
> 	1) most of modern webcams are based on USB Video Class (UVC). So, this
> driver is important to suport those cams.
> 	2) This is a driver-only addition. There aren't any changes at V4L/DVB
> core. No risk of causing regressions on the already supported devices;
> 	3) The driver were already reviewed by V4L and USB people;
> 	4) The driver is already widely used, since it is merged as an
> out-of-tree driver on several distros. 
> 
> So, on my opinion, we should merge it for 2.6.26.

I got a small but relevant bug at uvc Makefile.

If you decide to apply it, please merge those two patches:

   - USB Video Class driver
   - uvc: Fix compilation breakage for the other drivers, if uvc is selected

So, please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

 MAINTAINERS                          |    8 +
 drivers/media/video/Kconfig          |    8 +
 drivers/media/video/Makefile         |    2 +
 drivers/media/video/uvc/Makefile     |    3 +
 drivers/media/video/uvc/uvc_ctrl.c   | 1256 ++++++++++++++++++++++
 drivers/media/video/uvc/uvc_driver.c | 1955 ++++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvc_isight.c |  134 +++
 drivers/media/video/uvc/uvc_queue.c  |  477 +++++++++
 drivers/media/video/uvc/uvc_status.c |  207 ++++
 drivers/media/video/uvc/uvc_v4l2.c   | 1105 +++++++++++++++++++
 drivers/media/video/uvc/uvc_video.c  |  934 ++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h   |  796 ++++++++++++++
 12 files changed, 6885 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/uvc/Makefile
 create mode 100644 drivers/media/video/uvc/uvc_ctrl.c
 create mode 100644 drivers/media/video/uvc/uvc_driver.c
 create mode 100644 drivers/media/video/uvc/uvc_isight.c
 create mode 100644 drivers/media/video/uvc/uvc_queue.c
 create mode 100644 drivers/media/video/uvc/uvc_status.c
 create mode 100644 drivers/media/video/uvc/uvc_v4l2.c
 create mode 100644 drivers/media/video/uvc/uvc_video.c
 create mode 100644 drivers/media/video/uvc/uvcvideo.h

Laurent Pinchart (1):
      V4L/DVB (8145a): USB Video Class driver

Mauro Carvalho Chehab (1):
      V4L/DVB (8178): uvc: Fix compilation breakage for the other drivers, if uvc is selected

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
