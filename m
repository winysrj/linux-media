Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1196 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZDBH3w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 03:29:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [RFC] BKL in open functions in drivers
Date: Thu, 2 Apr 2009 09:29:22 +0200
Cc: linux-media@vger.kernel.org,
	Alessio Igor Bogani <abogani@texware.it>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1238619656.3986.88.camel@tux.localhost>
In-Reply-To: <1238619656.3986.88.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904020929.22359.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 01 April 2009 23:00:56 Alexey Klimov wrote:
> Hello,
>
> Few days ago Alessio Igor Bogani<abogani@texware.it> sent me patch
> that removes BKLs like lock/unlock_kernel() in open call and place mutex
> there in media/radio/radio-mr800.c.
> This patch broke the driver, so we figured out new approah. We added one
> more mutex lock that was used in open call. The patch is below:
>
> diff -r ffa5df73ebeb linux/drivers/media/radio/radio-mr800.c
> --- a/linux/drivers/media/radio/radio-mr800.c Fri Mar 13 00:43:34 2009
> +0000
> +++ b/linux/drivers/media/radio/radio-mr800.c	Thu Apr 02 00:40:56 2009
> +0400
> @@ -163,6 +163,7 @@
>
>  	unsigned char *buffer;
>  	struct mutex lock;	/* buffer locking */
> +	struct mutex open;
>  	int curfreq;
>  	int stereo;
>  	int users;
> @@ -570,7 +571,7 @@
>  	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
>  	int retval;
>
> -	lock_kernel();
> +	mutex_lock(&radio->open);
>
>  	radio->users = 1;
>  	radio->muted = 1;
> @@ -580,7 +581,7 @@
>  		amradio_dev_warn(&radio->videodev->dev,
>  			"radio did not start up properly\n");
>  		radio->users = 0;
> -		unlock_kernel();
> +		mutex_unlock(&radio->open);
>  		return -EIO;
>  	}
>
> @@ -594,7 +595,7 @@
>  		amradio_dev_warn(&radio->videodev->dev,
>  			"set frequency failed\n");
>
> -	unlock_kernel();
> +	mutex_unlock(&radio->open);
>  	return 0;
>  }
>
> @@ -735,6 +736,7 @@
>  	radio->stereo = -1;
>
>  	mutex_init(&radio->lock);
> +	mutex_init(&radio->open);
>
>  	video_set_drvdata(radio->videodev, radio);
>  	retval = video_register_device(radio->videodev, VFL_TYPE_RADIO,
> radio_nr);
>
> I tested such approach using stress tool that tries to open /dev/radio0
> few hundred times. Looks fine.
>
> So, questions are:
>
> 1) What for is lock/unlock_kernel() used in open?

It's pointless. Just remove it.

> 2) Can it be replaced by mutex, for example?

No need.

> Please, comments, exaplanations are more than welcome.

But what is really wrong is the way the 'users' field is used: that should 
be an atomic counter: on the first-time-open you set up the device, and 
when the last user goes away you can close it down.

Currently if you open the device a second time and then close that second 
fh, the first gets muted by that close. Not what you want!

Actually, I don't see why this stuff is in the open/close at all, unless 
this saves some measurable amount of power consumption. I'd just move the 
setup code in the open() to the probe() and after that both the open() and 
close() functions become no-ops.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
