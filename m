Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2224 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZEDNDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 09:03:42 -0400
Message-ID: <18097.62.70.2.252.1241442220.squirrel@webmail.xs4all.nl>
Date: Mon, 4 May 2009 15:03:40 +0200 (CEST)
Subject: Re: [questions] dmesg: Non-NULL drvdata on register
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Alexey Klimov" <klimov.linux@gmail.com>
Cc: linux-media@vger.kernel.org,
	"Douglas Schilling Landgraf" <dougsland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello,
>
> Not so many time ago i noticed such line in dmesg:
>
> radio-mr800 2-1:1.0: Non-NULL drvdata on register
>
> Quick review showed that it appears in usb_amradio_probe fucntions. Then
> i found such code in v4l2_device_register() function (v4l2-device.c
> file):
>
> /* Set name to driver name + device name if it is empty. */
>         if (!v4l2_dev->name[0])
>                 snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s %
> s",
>                         dev->driver->name, dev_name(dev));
>         if (dev_get_drvdata(dev))
>                 v4l2_warn(v4l2_dev, "Non-NULL drvdata on register\n");
>         dev_set_drvdata(dev, v4l2_dev);
>         return 0;
>
> The questions is - should i deal with this warning in dmesg? Probably
> the order of callbacks in radio-mr800 probe function is incorrect.

I (or you :-) should look into this: I think the usb subsystem is calling
dev_set_drvdata as well, so we could have a clash here.

> The second questions - should i make atomic_t users counter instead of
> int users counter? Then i can use atomic_inc(), atomic_dec(),
> atomic_set(). It helps me to remove lock/unlock_kernel() functions.

'users' can go away completely: if you grep for it, then you'll see that
it is only set, but never used.

I think I've commented on the kernel lock before: I think it is bogus
here. And that the amradio_set_mute handling is wrong as well: you open
the radio device twice, then close one file descriptor, and suddenly the
audio will be muted, even though there still is a file descriptor open.

Regards,

        Hans

>
> --
> Best regards, Klimov Alexey
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

