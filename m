Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58389 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab0EBR0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 13:26:34 -0400
Received: by vws19 with SMTP id 19so1236886vws.19
        for <linux-media@vger.kernel.org>; Sun, 02 May 2010 10:26:33 -0700 (PDT)
Message-ID: <4BDDB5C3.6020306@gmail.com>
Date: Sun, 02 May 2010 14:26:27 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Bee Hock Goh <beehock@gmail.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tm6000: Prevent Kernel Oops changing channel when stream
 is 	still on.
References: <u2s6e8e83e21005010151ie123c8e5o45e7d0a3bbc8aa64@mail.gmail.com> <4BDD8F65.80602@redhat.com>
In-Reply-To: <4BDD8F65.80602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Hi Bee,
> 
> Bee Hock Goh wrote:
>> do a streamoff before setting standard to prevent kernel oops by
>> irq_callback if changing of channel is done while streaming is still
>> on-going.
> 
> This doesn't seem to be the right thing to do. The problem here is that
> changing a video standard takes a long time to happen. As calling an
> ioctl is protected by KBL, QBUF/DQBUF won't be called, so, the driver
> will run out of the buffers, and *buf will become null. This can eventually
> happen during copy_streams().
> 
> ---
> 
> tm6000: Fix a panic if buffer become NULL
> 
> Changing a video standard takes a long time to happen on tm6000, since it
> needs to load another firmware, and the i2c implementation on this device
> is really slow. As calling an ioctl is protected by KBL, QBUF/DQBUF won't 
> be called, so, the driver will run out of the buffers, and *buf will become 
> NULL. This can eventually happen during copy_streams(). The fix is to leave
> the URB copy loop, if there's no more buffers available.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/linux/drivers/staging/tm6000/tm6000-video.c b/linux/drivers/staging/tm6000/tm6000-video.c

Sorry, I sent the wrong one. That's the proper fix. I've also improved
the comments to better express what's happening.

Tested here with HVR-900H and the Panic disappeared.

---

tm6000: Fix a panic if buffer become NULL

Changing a video standard takes a long time to happen on tm6000, since it
needs to load another firmware, and the i2c implementation on this device
is really slow. When the driver tries to change the video standard, a
kernel panic is produced:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffffa0c7b48a>] tm6000_irq_callback+0x57f/0xac2 [tm6000]
...
Kernel panic - not syncing: Fatal exception in interrupt

By inspecting it with gdb:

(gdb) list *tm6000_irq_callback+0x57f
0x348a is in tm6000_irq_callback (drivers/staging/tm6000/tm6000-video.c:202).
197             /* FIXME: move to tm6000-isoc */
198             static int last_line = -2, start_line = -2, last_field = -2;
199
200             /* FIXME: this is the hardcoded window size
201              */
202             unsigned int linewidth = (*buf)->vb.width << 1;
203
204             if (!dev->isoc_ctl.cmd) {
205                     c = (header >> 24) & 0xff;
206

Clearly, it was the trial to access *buf, at line 202 that caused the
Panic.

As ioctl is serialized, While S_STD is handled,QBUF/DQBUF won't be called.
So, the driver will run out of the buffers, and *buf will become NULL. 

As, on tm6000, the same URB can contain more than one video buffer, it is
likely to hit a condition where no new buffer is available whily copying
the streams. The fix is to leave the URB copy loop, if there's no more buffers 
are available.

The same bug could also be produced by an application that is not fast enough
to request new video buffers.

The same bug were reported by Bee Hock Goh <beehock@gmail.com>.

Thanks-to: Bee Hock Goh <beehock@gmail.com> for reporting the bug
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Index: work.x86-64/drivers/staging/tm6000/tm6000-video.c
===================================================================
--- work.x86-64.orig/drivers/staging/tm6000/tm6000-video.c
+++ work.x86-64/drivers/staging/tm6000/tm6000-video.c
@@ -395,6 +395,8 @@ HEADER:
 					jiffies);
 			return rc;
 		}
+		if (!*buf)
+			return 0;
 	}
 
 	return 0;
@@ -528,7 +530,7 @@ static inline int tm6000_isoc_copy(struc
 				}
 			}
 			copied += len;
-			if (copied>=size)
+			if (copied >= size || !buf)
 				break;
 //		}
 	}
