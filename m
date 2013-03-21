Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:43513 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab3CUK4C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:56:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 09/10] bttv: fix mute on last close of the video device node
Date: Thu, 21 Mar 2013 11:56:00 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-10-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-10-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303211156.00584.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 20:24:49 Frank Schäfer wrote:
> Instead of applying the current mute setting on last device node close, always
> mute the device.

I am very pleased with the preceding 8 patches. That does exactly what I had
in mind. For this patch and the next (I would have combined those two into one
patch BTW) I want to do some testing first. Unfortunately due to travel I will
not have access to bttv hardware for the next 10 days or so.

One thing I am considering is adding some basic tuner-ownership functionality
to the v4l2 core. Without that I don't think we can ever get this working as
it should.

It might be an idea to make a pull request for the first 8 patches some time
next week. That's all good stuff and it makes the code much easier to
understand.

Regards,

	Hans

> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |    2 +-
>  1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 2fb2168..469ea06 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -3126,7 +3126,7 @@ static int bttv_release(struct file *file)
>  	bttv_field_count(btv);
>  
>  	if (!btv->users)
> -		audio_mute(btv, btv->mute);
> +		audio_mute(btv, 1);
>  
>  	v4l2_fh_del(&fh->fh);
>  	v4l2_fh_exit(&fh->fh);
> 
