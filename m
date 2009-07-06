Return-path: <linux-media-owner@vger.kernel.org>
Received: from centrodatos.linos.es ([86.109.105.97]:36329 "EHLO linos.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751627AbZGFXWg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jul 2009 19:22:36 -0400
Message-ID: <4A5285AD.700@linos.es>
Date: Tue, 07 Jul 2009 01:15:57 +0200
From: Linos <info@linos.es>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: bttv problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,
	some time ago (2008-10-20) i sent a post to the list 
video4linux-list@redhat.com explaining a problem that still seems to be in the 
last kernel, Daniel Glöckner helped me with a workaround, i will paste here the 
problem and the fix from Daniel.

------------------------------------------------------------------------------------------------ 
Original mail
Hello, i have upgraded a debian machine from kernel 2.6.24 to 2.6.26 and now i 
have this error when try to launch helix producer on the capture input.

producer -vc /dev/video0 -ad 128k -vp "0" -dt -vm sharp -o /tmp/test.rm
Helix DNA(TM) Producer 11.0 Build number: 11.0.0.2013
Info: Starting encode

Error: Could not set image size to 352x288 for color format I420 (15) 
(VIDIOCMCAPTURE: buffer 0)

Warning: Capture Buffer is empty at 445090329ms for last 61 times
Warning: Capture Buffer is empty at 445091549ms for last 61 times


exactly the same producer version with the same command line works ok in 2.6.24, 
previously i have saw this error when i was trying to use from 2 different 
capture programs the same video input but this is not the case, it is the only 
program using /dev/video0, what can be happening?

------------------------------------------------------------------------------------------------ 
Daniel's reply
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
   vmm.width=352;
   vmm.height=288;
   vmm.format=VIDEO_PALETTE_YUV420P;
   vmm.frame=0;
   ioctl(open("/dev/video",O_RDWR),VIDIOCMCAPTURE,&vmm);
}
--------------

   Daniel

------------------------------------------------------------------------------------------------ 



I have upgraded the same machine now to 2.6.30 and still have the same problem 
and i have to use the code Daniel sent the list to make it work, i am missing 
something or still have not been fixed in mainstream kernel? Thanks.

Regards,
Miguel Angel.
