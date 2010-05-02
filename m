Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336Ab0EBOmu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 May 2010 10:42:50 -0400
Message-ID: <4BDD8F65.80602@redhat.com>
Date: Sun, 02 May 2010 11:42:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Bee Hock Goh <beehock@gmail.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tm6000: Prevent Kernel Oops changing channel when stream
 is 	still on.
References: <u2s6e8e83e21005010151ie123c8e5o45e7d0a3bbc8aa64@mail.gmail.com>
In-Reply-To: <u2s6e8e83e21005010151ie123c8e5o45e7d0a3bbc8aa64@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bee,

Bee Hock Goh wrote:
> do a streamoff before setting standard to prevent kernel oops by
> irq_callback if changing of channel is done while streaming is still
> on-going.
> 
> 
> Signed-off-by: Bee Hock Goh <beehock@gmail.com>
> 
> diff --git a/drivers/staging/tm6000/tm6000-video.c
> b/drivers/staging/tm6000/tm6000-video.c
> index c53de47..32f625d 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> 
> @@ -1081,8 +1086,8 @@ static int vidioc_s_std (struct file *file, void
> *priv, v4l2_std_id *norm)
>  	struct tm6000_fh   *fh=priv;
>  	struct tm6000_core *dev = fh->dev;
> 
> +	vidioc_streamoff(file, priv, V4L2_BUF_TYPE_VIDEO_CAPTURE);
>  	rc=tm6000_set_standard (dev, norm);
> -
>  	fh->width  = dev->width;
>  	fh->height = dev->height;

This doesn't seem to be the right thing to do. The problem here is that
changing a video standard takes a long time to happen. As calling an
ioctl is protected by KBL, QBUF/DQBUF won't be called, so, the driver
will run out of the buffers, and *buf will become null. This can eventually
happen during copy_streams().

---

tm6000: Fix a panic if buffer become NULL

Changing a video standard takes a long time to happen on tm6000, since it
needs to load another firmware, and the i2c implementation on this device
is really slow. As calling an ioctl is protected by KBL, QBUF/DQBUF won't 
be called, so, the driver will run out of the buffers, and *buf will become 
NULL. This can eventually happen during copy_streams(). The fix is to leave
the URB copy loop, if there's no more buffers available.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/linux/drivers/staging/tm6000/tm6000-video.c b/linux/drivers/staging/tm6000/tm6000-video.c
--- a/linux/drivers/staging/tm6000/tm6000-video.c
+++ b/linux/drivers/staging/tm6000/tm6000-video.c
@@ -539,7 +539,7 @@ static inline int tm6000_isoc_copy(struc
 				}
 			}
 			copied += len;
-			if (copied>=size)
+			if (copied >= size || !buf)
 				break;
 //		}
 	}
