Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SAZAml028953
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:35:10 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SAYUGJ018739
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:55 -0400
Received: by fg-out-1718.google.com with SMTP id e12so175366fga.7
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 03:34:55 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <patchbomb.1206699511@localhost>
Date: Fri, 28 Mar 2008 03:18:31 -0700
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 0 of 9] videobuf fixes
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

Hello-

Sorry for the mess-up on the first round.  :-(

The following set fixes problems I discovered while tracking down bugs in both
vivi and videobuf.  Hopefully most of these can make it into 2.6.25 since they
all seem pretty critical.

Please take a good look at the set and test if possible.  Particularly:
  [RFC] videobuf: Avoid deadlock with QBUF

Also, is anyone using videobuf-vmalloc besides vivi?  The current videobuf API
feels over extended trying to take on the task of a second backend type. 

Pullable from http://ifup.org/hg/v4l-dvb 

- soc_camera: Introduce a spinlock for use with videobuf
- videobuf: Require spinlocks for all videobuf users
- videobuf: Wakeup queues after changing the state to ERROR
- videobuf: Simplify videobuf_waiton logic and possibly avoid missed wakeup
- videobuf-vmalloc.c: Remove buf_release from videobuf_vm_close
- videobuf-vmalloc.c: Fix hack of postponing mmap on remap failure
- vivi: Simplify the vivi driver and avoid deadlocks
- videobuf: Avoid deadlock with QBUF and bring up to spec for empty queue
- videobuf-dma-sg.c: Avoid NULL dereference and add comment about backwards compatibility

 b/linux/drivers/media/video/pxa_camera.c       |   11 
 b/linux/drivers/media/video/soc_camera.c       |    5 
 b/linux/drivers/media/video/videobuf-core.c    |   46 -
 b/linux/drivers/media/video/videobuf-dma-sg.c  |   16 
 b/linux/drivers/media/video/videobuf-vmalloc.c |    2 
 b/linux/drivers/media/video/vivi.c             |  332 ++--------
 b/linux/include/media/soc_camera.h             |    1 
 b/linux/include/media/videobuf-core.h          |    3 
 linux/drivers/media/video/videobuf-core.c      |  169 +++--
 linux/drivers/media/video/videobuf-vmalloc.c   |   43 -
 linux/include/media/videobuf-core.h            |    2 
 11 files changed, 262 insertions(+), 368 deletions(-)

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
