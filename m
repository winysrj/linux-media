Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:57076 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3CJLoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 07:44:39 -0400
Received: by mail-ea0-f173.google.com with SMTP id h14so755842eak.4
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 04:44:38 -0700 (PDT)
Message-ID: <513C7256.5060804@googlemail.com>
Date: Sun, 10 Mar 2013 12:45:26 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: mchehab@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] bttv: fix audio mute on device close for the
 radio device node
References: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com> <1362915635-5431-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362915635-5431-2-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans, in one of your previous comments you mentioned that radio devices
have to be handled differently, so I'm not sure if this is the right
thing to do...

Am 10.03.2013 12:40, schrieb Frank Schäfer:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |    5 ++++-
>  1 Datei geändert, 4 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)
>
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 2c09bc5..74977f7 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -3227,6 +3227,7 @@ static int radio_open(struct file *file)
>  	v4l2_fh_init(&fh->fh, vdev);
>  
>  	btv->radio_user++;
> +	audio_mute(btv, btv->mute);
>  
>  	v4l2_fh_add(&fh->fh);
>  
> @@ -3248,8 +3249,10 @@ static int radio_release(struct file *file)
>  
>  	bttv_call_all(btv, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
>  
> -	if (btv->radio_user == 0)
> +	if (btv->radio_user == 0) {
>  		btv->has_radio_tuner = 0;
> +		audio_mute(btv, 1);
> +	}

The same here, change to

            if (!btv->users && !btv->radio_user)        ?

Regards,
Frank

>  	return 0;
>  }
>  

