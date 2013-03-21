Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:64212 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3CUKjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:39:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 08/10] bttv: apply mute settings on open
Date: Thu, 21 Mar 2013 11:39:52 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-9-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303211139.52921.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 20:24:48 Frank Schäfer wrote:
> Previously, this has been done implicitly for video device nodes by calling
> set_input() (which calls audio_input() and also modified the mute
> setting).
> Since input and mute setting are now untangled (as much as possible), we need to
> apply the mute setting with an explicit call to audio_mute().
> Also apply the mute setting when the radio device node gets opened.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |    3 ++-
>  1 Datei geändert, 2 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 55eab61..2fb2168 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -3065,7 +3065,7 @@ static int bttv_open(struct file *file)
>  			    fh, &btv->lock);
>  	set_tvnorm(btv,btv->tvnorm);
>  	set_input(btv, btv->input, btv->tvnorm);
> -
> +	audio_mute(btv, btv->mute);
>  
>  	/* The V4L2 spec requires one global set of cropping parameters
>  	   which only change on request. These are stored in btv->crop[1].
> @@ -3230,6 +3230,7 @@ static int radio_open(struct file *file)
>  	v4l2_fh_init(&fh->fh, vdev);
>  
>  	btv->radio_user++;
> +	audio_mute(btv, btv->mute);
>  
>  	v4l2_fh_add(&fh->fh);
>  
> 
