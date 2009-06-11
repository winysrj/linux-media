Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44759 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbZFKBkX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 21:40:23 -0400
Date: Wed, 10 Jun 2009 22:39:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: linux-media@vger.kernel.org, kraxel@bytesex.org,
	Hans Verkuil <hverkuil@xs4all.nl>, mark@alpha.dyndns.org,
	cpbotha@ieee.org, claudio@conectiva.com
Subject: Re: [PATCH] ov511.c: video_register_device() return zero on success
Message-ID: <20090610223951.3013892b@pedra.chehab.org>
In-Reply-To: <1243752113.3425.12.camel@myhost>
References: <1243752113.3425.12.camel@myhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 31 May 2009 14:41:52 +0800
"Figo.zhang" <figo1802@gmail.com> escreveu:

> video_register_device() return zero on success, it would not return a positive integer.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> --- 
>  drivers/media/video/ov511.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
> index 9af5532..816427e 100644
> --- a/drivers/media/video/ov511.c
> +++ b/drivers/media/video/ov511.c
> @@ -5851,7 +5851,7 @@ ov51x_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  			break;
>  
>  		if (video_register_device(ov->vdev, VFL_TYPE_GRABBER,
> -			unit_video[i]) >= 0) {
> +			unit_video[i]) == 0) {
>  			break;
>  		}
>  	}

Nack.

Errors are always negative. So, any zero or positive value indicates that no error occurred.

Yet, the logic for forcing ov51x to specific minor number seems broken: it will
end by registering the device twice, if used.

So, that part of the function needs a rewrite. I'll fix it.

-- 

Cheers,
Mauro
