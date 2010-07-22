Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2640 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0GVIiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 04:38:50 -0400
Message-ID: <a9c8c5ec17c651631c440d096a7fe42a.squirrel@webmail.xs4all.nl>
In-Reply-To: <AANLkTikXKlxppwCP4eBvsx_uR47Nf_zipDlZGewrr3Eo@mail.gmail.com>
References: <AANLkTikXKlxppwCP4eBvsx_uR47Nf_zipDlZGewrr3Eo@mail.gmail.com>
Date: Thu, 22 Jul 2010 10:38:48 +0200
Subject: Re: V4L2 driver
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "liat korner" <liatkorner@gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello,
>
> I'm trying to load the tvp5150 driver with OMAP35.
> I get no /dev/video0 device.
> I have noticed that this driver uses the new subdev mechanism. It
> seems that the driver does not call the function:
> video_register_device (I understand that this is the function that
> creates video0).
>
> Can anyone please help me understand how the subdev supposed to work?
> How it supposed to create video0?

The omap3 driver creates video0 and has to register the tvp5150 subdev
driver. The subdev driver itself doesn't create any video nodes.

See also Documentation/video4linux/v4l2-framework.txt for more information
on the sub-device and v4l2 driver architecture.

Regards,

        Hans

>
> Thanks in advance,
> Liat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

