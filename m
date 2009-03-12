Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50859 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbZCLXQm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 19:16:42 -0400
Subject: Re: Fwd: [stable] [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885
 video_open
From: Andy Walls <awalls@radix.net>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	LMML <linux-media@vger.kernel.org>
In-Reply-To: <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com>
References: <200902241700.56099.jarod@redhat.com>
	 <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 19:03:53 -0400
Message-Id: <1236899033.3261.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-03-12 at 16:24 -0400, Michael Krufky wrote:
> Can we have this merged into -stable?  Jarod Wilson sent this last
> month, but he left off the cc to stable@kernel.org
> 
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

Mike,

A version of this is already in the v4l-dvb hg development repository:

hg log -vp --limit 1 linux/drivers/media/video/cx23885/cx23885-417.c
hg log -vp --limit 2 linux/drivers/media/video/cx23885/cx23885-video.c 

I helped Mark work through the solution: I coded some of it, he coded
some of it and he also tested it.

Regards,
Andy


> 
> ---------- Forwarded message ----------
> From: Jarod Wilson <jarod@redhat.com>
> Date: Tue, Feb 24, 2009 at 6:00 PM
> Subject: [stable] [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885 video_open
> To: linux-kernel@vger.kernel.org
> Cc: Mike Krufky <mkrufky@linuxtv.org>
> 
> 
> From: Mark Jenks
> https://www.redhat.com/mailman/private/video4linux-list/2009-January/msg00041.html
> 
> The Hauppauge WinTV HVR-1800 tv tuner card has both digital and analog
> abilities, both of which are supported by v4l/dvb under 2.6.27.y. The analog
> side also features a hardware mpeg2 encoder. The HVR-1250 tv tuner card
> has both digital and analog abilities, but analog isn't currently supported
> under any kernel. These cards both utilize the cx23885 driver, but with
> slightly different usage. When the code paths for each card is executed,
> they wind up poking a cx23885_devlist, which contains devices from both
> of the cards, and access attempts are made to portions of 'struct
> cx23885_dev' that aren't valid for that device. Simply add some extra
> checks before trying to access these structs.
> 
> More gory details:
>  http://article.gmane.org/gmane.linux.drivers.dvb/46630
> 
> This was triggering on my own system at home w/both cards in it, and
> no longer happens with this patch included.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
> 
> ---
> 
>  drivers/media/video/cx23885/cx23885-417.c   |    2 +-
>  drivers/media/video/cx23885/cx23885-video.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/cx23885/cx23885-417.c
> b/drivers/media/video/cx23885/cx23885-417.c
> index 7b0e8c0..19154b6 100644
> --- a/drivers/media/video/cx23885/cx23885-417.c
> +++ b/drivers/media/video/cx23885/cx23885-417.c
> @@ -1585,7 +1585,7 @@ static int mpeg_open(struct inode *inode, struct
> file *file)
> 
>        list_for_each(list, &cx23885_devlist) {
>                h = list_entry(list, struct cx23885_dev, devlist);
> -               if (h->v4l_device->minor == minor) {
> +               if (h->v4l_device && h->v4l_device->minor == minor) {
>                        dev = h;
>                        break;
>                }
> diff --git a/drivers/media/video/cx23885/cx23885-video.c
> b/drivers/media/video/cx23885/cx23885-video.c
> index 6047c78..a2b5a0c 100644
> --- a/drivers/media/video/cx23885/cx23885-video.c
> +++ b/drivers/media/video/cx23885/cx23885-video.c
> @@ -733,7 +733,7 @@ static int video_open(struct inode *inode, struct
> file *file)
> 
>        list_for_each(list, &cx23885_devlist) {
>                h = list_entry(list, struct cx23885_dev, devlist);
> -               if (h->video_dev->minor == minor) {
> +               if (h->video_dev && h->video_dev->minor == minor) {
>                        dev  = h;
>                        type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>                }
> 
> 
> --
> Jarod Wilson
> jarod@redhat.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

