Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47248 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986AbbGTOca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 10:32:30 -0400
Message-ID: <55AD063A.1030705@xs4all.nl>
Date: Mon, 20 Jul 2015 16:31:22 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC v3 02/19] media/v4l2-core: add new ioctl VIDIOC_G_DEF_EXT_CTRLS
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com> <1434127598-11719-3-git-send-email-ricardo.ribalda@gmail.com> <55ACF994.3010101@xs4all.nl> <CAPybu_2a+z6ZVY=-ZXE6Usmoe0nsLjUzw3AE5=K9vQ6OCDgKaw@mail.gmail.com>
In-Reply-To: <CAPybu_2a+z6ZVY=-ZXE6Usmoe0nsLjUzw3AE5=K9vQ6OCDgKaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2015 03:52 PM, Ricardo Ribalda Delgado wrote:
> Hello
> 
> I have no preference over the two implementations, but I see an issue
> with this suggestion.
> 
> 
> What happens to out out tree drivers, or drivers that don't support
> this functionality?
> 
> With the ioctl, the user receives a -ENOTTY. So he knows there is
> something wrong with the driver.
> 
> With this class, the driver might interpret this a simple G_VAL and
> return he current value with no way for the user to know what is going
> on.

Drivers that implement the current API correctly will return an error
if V4L2_CTRL_WHICH_DEF_VAL was specified. Such drivers will interpret
the value as a control class, and no control classes in that range exist.
See also class_check() in v4l2-ctrls.c.

The exception here is uvc which doesn't have this class check and it will
just return the current value :-(

I don't see a way around this, unfortunately.

Out-of-tree drivers that use the control framework are fine, and I don't
really care about drivers (out-of-tree or otherwise) that do not use the
control framework.

> Regarding the new implementation.... I can make some code next week,
> this week I am 120% busy :)

Wait until there is a decision first :-)

It's not a lot of work, I think.

Regards,

	Hans

> What do you think?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

