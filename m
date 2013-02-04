Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63679 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab3BCPXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:23:04 -0500
Received: by mail-pb0-f41.google.com with SMTP id ro12so2808678pbb.0
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:23:02 -0800 (PST)
Message-ID: <510F387C.4090305@gmail.com>
Date: Sun, 03 Feb 2013 23:26:36 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 05/18] tlg2300: embed video_device instead of allocating
 it.
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <6c7743bffce7a3cb8ea7b6c6f2ae92e79e81dcf4.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <6c7743bffce7a3cb8ea7b6c6f2ae92e79e81dcf4.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-common.h |    2 +-
>  drivers/media/usb/tlg2300/pd-radio.c  |   20 ++++++--------------
>  2 files changed, 7 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
> index 5dd73b7..3a89128 100644
> --- a/drivers/media/usb/tlg2300/pd-common.h
> +++ b/drivers/media/usb/tlg2300/pd-common.h
> @@ -118,7 +118,7 @@ struct radio_data {
>  	int		users;
>  	unsigned int	is_radio_streaming;
>  	int		pre_emphasis;
> -	struct video_device *fm_dev;
> +	struct video_device fm_dev;
>  };
>  
>  #define DVB_SBUF_NUM		4
> diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
> index 4c76e089..719c3da 100644
> --- a/drivers/media/usb/tlg2300/pd-radio.c
> +++ b/drivers/media/usb/tlg2300/pd-radio.c
> @@ -369,31 +369,23 @@ static struct video_device poseidon_fm_template = {
>  	.name       = "Telegent-Radio",
>  	.fops       = &poseidon_fm_fops,
>  	.minor      = -1,
> -	.release    = video_device_release,
> +	.release    = video_device_release_empty,
>  	.ioctl_ops  = &poseidon_fm_ioctl_ops,
>  };
>  
>  int poseidon_fm_init(struct poseidon *p)
>  {
> -	struct video_device *fm_dev;
> -	int err;
> +	struct video_device *vfd = &p->radio_data.fm_dev;
>  
> -	fm_dev = vdev_init(p, &poseidon_fm_template);
> -	if (fm_dev == NULL)
> -		return -ENOMEM;
> +	*vfd = poseidon_fm_template;
> +	vfd->v4l2_dev	= &p->v4l2_dev;
> +	video_set_drvdata(vfd, p);
>  
> -	p->radio_data.fm_dev = fm_dev;
>  	set_frequency(p, TUNER_FREQ_MIN_FM);
> -	err = video_register_device(fm_dev, VFL_TYPE_RADIO, -1);
> -	if (err < 0) {
> -		video_device_release(fm_dev);
> -		return err;
> -	}
> -	return 0;
> +	return video_register_device(vfd, VFL_TYPE_RADIO, -1);
>  }
>  
>  int poseidon_fm_exit(struct poseidon *p)
>  {
> -	destroy_video_device(&p->radio_data.fm_dev);
>  	return 0;
>  }
Acked-by: Huang Shijie <shijie8@gmail.com>
