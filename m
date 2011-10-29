Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1J2Hvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Oct 2011 03:51:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Subject: Re: Switching input during capture
Date: Sat, 29 Oct 2011 09:52:17 +0200
Cc: Gilles Gigan <gilles.gigan@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CAJWu0HN8WC-xfAy3cNnA_o3YPj7+9Eo5+YCvNtqRNs9dG18+8A@mail.gmail.com> <201110281442.21776.laurent.pinchart@ideasonboard.com> <4EAB2CF4.4040007@gmail.com>
In-Reply-To: <4EAB2CF4.4040007@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110290952.17916.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Saturday 29 October 2011 00:30:12 Mauro Carvalho Chehab wrote:
> Em 28-10-2011 14:42, Laurent Pinchart escreveu:
> > On Friday 28 October 2011 03:31:53 Gilles Gigan wrote:
> >> Hi,
> >> I would like to know what is the correct way to switch the current
> >> video input during capture on a card with a single BT878 chip and 4
> >> inputs
> >> (http://store.bluecherry.net/products/PV%252d143-%252d-4-port-video-capt
> >> ur e-card-%2830FPS%29-%252d-OEM.html). I tried doing it in two ways: -
> >> using VIDIOC_S_INPUT to change the current input. While this works, the
> >> next captured frame shows video from the old input in its top half and
> >> video from the new input in the bottom half.
> 
> This is is likely easy to fix. The driver has already a logic to prevent
> changing the buffer while in the middle of a buffer filling. I suspect
> that the BKL removal patches might have broken it somewhat, allowing
> things like that. basically, it should be as simple as not allowing
> changing the input at the top half.

This will work optimally only if the input analog signals are synchronized, 
right ? If we switch to a new input right when the frame start, can the first 
frame captured on the new input be corrupted ?

> Please try the enclosed patch.
> 
> Regards,
> Mauro
> 
> -
> 
> bttv: Avoid switching the video input at the top half.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c
> b/drivers/media/video/bt8xx/bttv-driver.c index 3dd0660..6a3be6f 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -3978,7 +3978,7 @@ bttv_irq_switch_video(struct bttv *btv)
>  	bttv_set_dma(btv, 0);
> 
>  	/* switch input */
> -	if (UNSET != btv->new_input) {
> +	if (! btv->curr.top && UNSET != btv->new_input) {
>  		video_mux(btv,btv->new_input);
>  		btv->new_input = UNSET;
>  	}

-- 
Regards,

Laurent Pinchart
