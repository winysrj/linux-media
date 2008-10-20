Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KGFjha014710
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 12:15:45 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9KGEuA3010847
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 12:14:56 -0400
Date: Mon, 20 Oct 2008 18:14:36 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Linos <info@linos.es>
Message-ID: <20081020161436.GB1298@daniel.bse>
References: <48FC8DF1.8010807@linos.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FC8DF1.8010807@linos.es>
Cc: video4linux-list@redhat.com
Subject: Re: bttv 2.6.26 problem
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

On Mon, Oct 20, 2008 at 03:56:01PM +0200, Linos wrote:
> Error: Could not set image size to 352x288 for color format I420 (15) 
> (VIDIOCMCAPTURE: buffer 0)

The problem is that the v4l1-compat code for VIDIOCMCAPTURE calls
VIDIOC_S_FMT. At the beginning of bttv_s_fmt_vid_cap the call to
bttv_switch_type fails because the buffers have already been mmap'ed
by the application. I'd say this is a bug in bttv.

In which case does the videobuf_queue_is_busy test prevent bad things
from happening?


A workaround is to set the resolution and image format before the
buffers are mapped, f.ex. with this small program:
--------------
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/videodev.h>

void main()
{
  struct video_mmap vmm;
  vmm.height=352;
  vmm.width=288;
  vmm.format=VIDEO_PALETTE_YUV420P;
  vmm.frame=0;
  ioctl(open("/dev/video",O_RDWR),VIDIOCMCAPTURE,&vmm);
}
--------------

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
