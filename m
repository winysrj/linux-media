Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:52362 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752662AbeDQEeX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 00:34:23 -0400
Received: by mail-it0-f65.google.com with SMTP id f6-v6so14270780ita.2
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:34:22 -0700 (PDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id d184-v6sm5276813itd.44.2018.04.16.21.34.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Apr 2018 21:34:22 -0700 (PDT)
Received: by mail-io0-f174.google.com with SMTP id g9so2029685iob.11
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:34:21 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-2-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-2-hverkuil@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 17 Apr 2018 04:34:10 +0000
Message-ID: <CAPBb6MU39sR2LWdOc2x08w8RaFcoj5ry3mdiMmjMPBHEy=OE=g@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 01/29] v4l2-device.h: always expose mdev
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 9, 2018 at 11:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> The mdev field is only present if CONFIG_MEDIA_CONTROLLER is set.
> But since we will need to pass the media_device to vb2 snd the

Typo: s/snd/and

> control framework it is very convenient to just make this field
> available all the time. If CONFIG_MEDIA_CONTROLLER is not set,
> then it will just be NULL.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   include/media/v4l2-device.h | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)

> diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> index 0c9e4da55499..b330e4a08a6b 100644
> --- a/include/media/v4l2-device.h
> +++ b/include/media/v4l2-device.h
> @@ -33,7 +33,7 @@ struct v4l2_ctrl_handler;
>    * struct v4l2_device - main struct to for V4L2 device drivers
>    *
>    * @dev: pointer to struct device.
> - * @mdev: pointer to struct media_device
> + * @mdev: pointer to struct media_device, may be NULL.
>    * @subdevs: used to keep track of the registered subdevs
>    * @lock: lock this struct; can be used by the driver as well
>    *     if this struct is embedded into a larger struct.
> @@ -58,9 +58,7 @@ struct v4l2_ctrl_handler;
>    */
>   struct v4l2_device {
>          struct device *dev;
> -#if defined(CONFIG_MEDIA_CONTROLLER)
>          struct media_device *mdev;
> -#endif
>          struct list_head subdevs;
>          spinlock_t lock;
>          char name[V4L2_DEVICE_NAME_SIZE];
> --
> 2.16.3
