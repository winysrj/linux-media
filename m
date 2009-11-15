Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1800 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZKOL40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 06:56:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [PATCH 1/5] go7007: Add struct v4l2_device.
Date: Sun, 15 Nov 2009 12:56:19 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1257880887.21307.1103.camel@pete-desktop>
In-Reply-To: <1257880887.21307.1103.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911151256.20031.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Thanks for this patch series! It's looking much better now.

I did find one thing though in this patch:

On Tuesday 10 November 2009 20:21:27 Pete Eberlein wrote:
> From: Pete Eberlein <pete@sensoray.com>
> 
> This adds a struct v4l2_device to the go7007 device struct and registers
> it during v4l2 initialization.  The v4l2_device registration overwrites
> the go->dev device_data, which is a struct usb_interface with intfdata set
> to the struct go7007.  This changes intfdata to point to the struct
> v4l2_device inside struct go7007, which is what v4l2_device_register will
> also set it to (and warn about non-null drvdata on register.)  Since usb
> disconnect can happen any time, this intfdata should always be present.
> 
> Priority: normal
> 
> Signed-off-by: Pete Eberlein <pete@sensoray.com>
> 

...

> diff -r 19c0469c02c3 -r a603ad1e6a1c linux/drivers/staging/go7007/go7007-v4l2.c
> --- a/linux/drivers/staging/go7007/go7007-v4l2.c	Sat Nov 07 15:51:01 2009 -0200
> +++ b/linux/drivers/staging/go7007/go7007-v4l2.c	Tue Nov 10 10:41:56 2009 -0800
> @@ -1827,7 +1827,7 @@
>  	go->video_dev = video_device_alloc();
>  	if (go->video_dev == NULL)
>  		return -ENOMEM;
> -	memcpy(go->video_dev, &go7007_template, sizeof(go7007_template));
> +	*go->video_dev = go7007_template;
>  	go->video_dev->parent = go->dev;
>  	rv = video_register_device(go->video_dev, VFL_TYPE_GRABBER, -1);
>  	if (rv < 0) {
> @@ -1837,6 +1837,8 @@
>  	}
>  	video_set_drvdata(go->video_dev, go);
>  	++go->ref_count;
> +	v4l2_device_register(go->dev, &go->v4l2_dev);

Please check the return code here! 

You should have seen this warning when you compiled:

v4l/go7007-v4l2.c: In function 'go7007_v4l2_init':
v4l/go7007-v4l2.c:1840: warning: ignoring return value of 'v4l2_device_register', declared with attribute warn_unused_result

> +
>  	printk(KERN_INFO "%s: registered device video%d [v4l2]\n",
>  	       go->video_dev->name, go->video_dev->num);
>  
> @@ -1858,4 +1860,5 @@
>  	mutex_unlock(&go->hw_lock);
>  	if (go->video_dev)
>  		video_unregister_device(go->video_dev);
> +	v4l2_device_unregister(&go->v4l2_dev);
>  }
> 

Other than that single warning it looks good!

Can you fix and repost this patch? Then I can prepare a pull request containing
all these changes.

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
