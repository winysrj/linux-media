Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:39457 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbeA1OMq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Jan 2018 09:12:46 -0500
Received: by mail-qk0-f169.google.com with SMTP id c69so2528351qkg.6
        for <linux-media@vger.kernel.org>; Sun, 28 Jan 2018 06:12:45 -0800 (PST)
MIME-Version: 1.0
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Sun, 28 Jan 2018 09:12:44 -0500
Message-ID: <CAGoCfixnHv-b3CbjqXLkFuK0J+_ejFnGRyxNJoywxuqQKBr_=Q@mail.gmail.com>
Subject: Regression in VB2 alloc prepare/finish balancing with em28xx/au0828
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I recently updated to the latest kernel, and I am seeing the following
dumped to dmesg with both au0828 and em28xx based devices whenever I
exit tvtime (my kernel is compiled with CONFIG_VIDEO_ADV_DEBUG=y by
default):

[  129.219666] vb2: counters for queue ffff88026463ac48:
[  129.219667] vb2:     setup: 1 start_streaming: 2 stop_streaming: 2
[  129.219667] vb2:     wait_prepare: 0 wait_finish: 0
[  129.219668] vb2:   counters for queue ffff88026463ac48, buffer 0: UNBALANCED!
[  129.219669] vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 14
buf_finish: 14
[  129.219669] vb2:     buf_queue: 13 buf_done: 13
[  129.219673] vb2:     alloc: 1 put: 1 prepare: 14 finish: 13 mmap: 1
[  129.219674] vb2:     get_userptr: 0 put_userptr: 0
[  129.219674] vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf:
0 unmap_dmabuf: 0
[  129.219675] vb2:     get_dmabuf: 0 num_users: 0 vaddr: 13 cookie: 0
[  129.219676] vb2:   counters for queue ffff88026463ac48, buffer 1: UNBALANCED!
[  129.219676] vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 13
buf_finish: 13
[  129.219677] vb2:     buf_queue: 12 buf_done: 12
[  129.219678] vb2:     alloc: 1 put: 1 prepare: 13 finish: 12 mmap: 1
[  129.219678] vb2:     get_userptr: 0 put_userptr: 0
[  129.219679] vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf:
0 unmap_dmabuf: 0
[  129.219679] vb2:     get_dmabuf: 0 num_users: 0 vaddr: 12 cookie: 0
[  129.219680] vb2:   counters for queue ffff88026463ac48, buffer 2: UNBALANCED!
[  129.219680] vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 13
buf_finish: 13
[  129.219681] vb2:     buf_queue: 12 buf_done: 12
[  129.219682] vb2:     alloc: 1 put: 1 prepare: 13 finish: 12 mmap: 1
[  129.219682] vb2:     get_userptr: 0 put_userptr: 0
[  129.219683] vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf:
0 unmap_dmabuf: 0
[  129.219683] vb2:     get_dmabuf: 0 num_users: 0 vaddr: 12 cookie: 0
[  129.219684] vb2:   counters for queue ffff88026463ac48, buffer 3: UNBALANCED!
[  129.219684] vb2:     buf_init: 1 buf_cleanup: 1 buf_prepare: 13
buf_finish: 13
[  129.219685] vb2:     buf_queue: 12 buf_done: 12
[  129.219686] vb2:     alloc: 1 put: 1 prepare: 13 finish: 12 mmap: 1
[  129.219686] vb2:     get_userptr: 0 put_userptr: 0
[  129.219687] vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf:
0 unmap_dmabuf: 0
[  129.219687] vb2:     get_dmabuf: 0 num_users: 0 vaddr: 12 cookie: 0

The above suggests that the prepare/finish calls are unbalanced.  I
added a bit of debug and identified that it only occurs with the video
node; it's not happening with the VBI node (which when using tvtime
makes use of the read() emulation done by videobuf2).

I went through a git bisect, and came up with the following patch
which introduced the issue:

commit a136f59c0a1f1b09eb203951975e3fc5e8d3e722
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Wed May 31 11:17:26 2017 -0300

    [media] vb2: Move buffer cache synchronisation to prepare from queue

    The buffer cache should be synchronised in buffer preparation, not when
    the buffer is queued to the device. Fix this.

    Mmap buffers do not need cache synchronisation since they are always
    coherent.

    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

It's not clear to me whether this is really a regression in videobuf2,
or if it's a change in behavior that exposes some improper handling in
em28xx/au0828 when the device node is closed.

To reproduce:

1.  compile kernel with CONFIG_VIDEO_ADV_DEBUG=y
2.  Plug in au0828 or em28xx device (reproduced with HVR-950 and HVR-950q)
3.  start tvtime
4.  exit tvtime

I don't claim to be videobuf2 expert, so any advice that could be
offered with regards to a fix (either in videobuf2 or in au0828) would
certainly be welcome.

Thanks in advance,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
