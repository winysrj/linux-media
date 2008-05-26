Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QH0JdJ032681
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 13:00:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QH07T5012594
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 13:00:07 -0400
Date: Mon, 26 May 2008 13:59:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <20080526135951.7989516d@gaivota>
In-Reply-To: <20080522223700.2f103a14@core>
References: <20080522223700.2f103a14@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video4linux: Push down the BKL
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

On Thu, 22 May 2008 22:37:00 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> For most drivers the generic ioctl handler does the work and we update it
> and it becomes the unlocked_ioctl method. Older drivers use the usercopy
> method so we make it do the work. Finally there are a few special cases.

I liked the patch also.

Still, it didn't apply cleanly on my -git tree, probably due to some fixes at
cx18 and ivtv (see the attached log). Also, IMO, it would be better if you
split drivers/net/tun.c into a different changeset.

I think you should add a video_ioctl2_unlocked() function, without BKL (and keeping
BKL explicit locks at video_ioctl2). This would help on migrating the drivers
to the unlocked version, since I suspect that most drivers already have enough
locks for the removal of BKL.

I would just implement video_ioctl2 as:

video_ioctl2_locked (...)
{
	lock_kernel();
	video_ioctl2_unlocked();
	unlock_kernel();
}

The next step can be to add the obvious locks inside video_ioctl2_unlocked(). Like, for
example, locking the VIDIOC_S calls, if someone is calling the corresponding
VIDIOC_G or VIDIOC_TRY ones.

Cheers,
Mauro.


---


patching file drivers/media/video/bt8xx/bttv-driver.c
patching file drivers/media/video/bw-qcam.c
patching file drivers/media/video/c-qcam.c
patching file drivers/media/video/cafe_ccic.c
patching file drivers/media/video/cpia.c
patching file drivers/media/video/cpia2/cpia2_v4l.c
patching file drivers/media/video/cx18/cx18-ioctl.c
patching file drivers/media/video/cx18/cx18-ioctl.h
patching file drivers/media/video/cx18/cx18-streams.c
Hunk #1 FAILED at 39.
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/video/cx18/cx18-streams.c.rej
patching file drivers/media/video/cx23885/cx23885-417.c
patching file drivers/media/video/cx23885/cx23885-video.c
patching file drivers/media/video/cx88/cx88-blackbird.c
patching file drivers/media/video/cx88/cx88-video.c
patching file drivers/media/video/dabusb.c
patching file drivers/media/video/em28xx/em28xx-video.c
patching file drivers/media/video/et61x251/et61x251_core.c
patching file drivers/media/video/ivtv/ivtv-ioctl.c
patching file drivers/media/video/ivtv/ivtv-ioctl.h
Hunk #1 FAILED at 24.
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/video/ivtv/ivtv-ioctl.h.rej
patching file drivers/media/video/ivtv/ivtv-streams.c
Hunk #1 FAILED at 48.
Hunk #2 FAILED at 58.
2 out of 2 hunks FAILED -- saving rejects to file drivers/media/video/ivtv/ivtv-streams.c.rej
patching file drivers/media/video/meye.c
patching file drivers/media/video/ov511.c
patching file drivers/media/video/pms.c
patching file drivers/media/video/pvrusb2/pvrusb2-v4l2.c
Hunk #1 succeeded at 861 (offset -1 lines).
Hunk #2 succeeded at 869 (offset -1 lines).
Hunk #3 succeeded at 1153 (offset -1 lines).
patching file drivers/media/video/pwc/pwc-if.c
patching file drivers/media/video/saa5246a.c
patching file drivers/media/video/saa5249.c
patching file drivers/media/video/saa7134/saa7134-empress.c
patching file drivers/media/video/saa7134/saa7134-video.c
patching file drivers/media/video/se401.c
patching file drivers/media/video/sn9c102/sn9c102_core.c
patching file drivers/media/video/soc_camera.c
patching file drivers/media/video/stk-webcam.c
Hunk #1 succeeded at 1320 (offset 7 lines).
patching file drivers/media/video/stradis.c
patching file drivers/media/video/stv680.c
patching file drivers/media/video/usbvideo/usbvideo.c
patching file drivers/media/video/usbvideo/vicam.c
patching file drivers/media/video/usbvision/usbvision-video.c
patching file drivers/media/video/videodev.c
patching file drivers/media/video/vivi.c
patching file drivers/media/video/w9966.c
patching file drivers/media/video/w9968cf.c
patching file drivers/media/video/zc0301/zc0301_core.c
patching file drivers/media/video/zoran_driver.c
patching file drivers/media/video/zr364xx.c
patching file drivers/net/tun.c
patching file include/media/v4l2-dev.h
Hunk #1 succeeded at 343 (offset -1 lines).
Hunk #2 succeeded at 352 (offset -1 lines).

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
