Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58163 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595Ab0ECLGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 07:06:54 -0400
Received: by gwj19 with SMTP id 19so1041585gwj.19
        for <linux-media@vger.kernel.org>; Mon, 03 May 2010 04:06:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1O8pN6-00064z-3C@www.linuxtv.org>
References: <E1O8pN6-00064z-3C@www.linuxtv.org>
Date: Mon, 3 May 2010 19:06:52 +0800
Message-ID: <h2t6e8e83e21005030406jcd534b9dm1eaabbc68bf1bb1c@mail.gmail.com>
Subject: Re: [git:v4l-dvb/master] V4L/DVB: tm6000: Fix a panic if buffer
	become NULL
From: Bee Hock Goh <beehock@gmail.com>
To: linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I think this patch of yours nailed the issue. No more crash switching channels.

I will need to let it run for a while to see if solve the one machine
freeze that I encountered after running for more than 30 mins.

thanks,
 Hock.

On Mon, May 3, 2010 at 2:42 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/v4l-dvb.git tree:
>
> Subject: V4L/DVB: tm6000: Fix a panic if buffer become NULL
> Author:  Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:    Sun May 2 11:42:45 2010 -0300
>
> Changing a video standard takes a long time to happen on tm6000, since it
> needs to load another firmware, and the i2c implementation on this device
> is really slow. When the driver tries to change the video standard, a
> kernel panic is produced:
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffffa0c7b48a>] tm6000_irq_callback+0x57f/0xac2 [tm6000]
> ...
> Kernel panic - not syncing: Fatal exception in interrupt
>
> By inspecting it with gdb:
>
> (gdb) list *tm6000_irq_callback+0x57f
> 0x348a is in tm6000_irq_callback (drivers/staging/tm6000/tm6000-video.c:202).
> 197             /* FIXME: move to tm6000-isoc */
> 198             static int last_line = -2, start_line = -2, last_field = -2;
> 199
> 200             /* FIXME: this is the hardcoded window size
> 201              */
> 202             unsigned int linewidth = (*buf)->vb.width << 1;
> 203
> 204             if (!dev->isoc_ctl.cmd) {
> 205                     c = (header >> 24) & 0xff;
> 206
>
> Clearly, it was the trial to access *buf, at line 202 that caused the
> Panic.
>
> As ioctl is serialized, While S_STD is handled,QBUF/DQBUF won't be called.
> So, the driver will run out of the buffers, and *buf will become NULL.
>
> As, on tm6000, the same URB can contain more than one video buffer, it is
> likely to hit a condition where no new buffer is available whily copying
> the streams. The fix is to leave the URB copy loop, if there's no more buffers
> are available.
>
> The same bug could also be produced by an application that is not fast enough
> to request new video buffers.
>
> The same bug were reported by Bee Hock Goh <beehock@gmail.com>.
>
> Thanks-to: Bee Hock Goh <beehock@gmail.com> for reporting the bug
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>  drivers/staging/tm6000/tm6000-video.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> ---
>
> http://git.linuxtv.org/v4l-dvb.git?a=commitdiff;h=41e3a700fab5f67011ede3e3ac04106b6a2ddea5
>
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index 96358b2..3317220 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -395,6 +395,8 @@ HEADER:
>                                        jiffies);
>                        return rc;
>                }
> +               if (!*buf)
> +                       return 0;
>        }
>
>        return 0;
> @@ -528,7 +530,7 @@ static inline int tm6000_isoc_copy(struct urb *urb)
>                                }
>                        }
>                        copied += len;
> -                       if (copied>=size)
> +                       if (copied >= size || !buf)
>                                break;
>  //             }
>        }
>
