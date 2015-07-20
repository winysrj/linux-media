Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36617 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbbGTNwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:52:25 -0400
Received: by lbbqi7 with SMTP id qi7so15286977lbb.3
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 06:52:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55ACF994.3010101@xs4all.nl>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
 <1434127598-11719-3-git-send-email-ricardo.ribalda@gmail.com> <55ACF994.3010101@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 20 Jul 2015 15:52:04 +0200
Message-ID: <CAPybu_2a+z6ZVY=-ZXE6Usmoe0nsLjUzw3AE5=K9vQ6OCDgKaw@mail.gmail.com>
Subject: Re: [RFC v3 02/19] media/v4l2-core: add new ioctl VIDIOC_G_DEF_EXT_CTRLS
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I have no preference over the two implementations, but I see an issue
with this suggestion.


What happens to out out tree drivers, or drivers that don't support
this functionality?

With the ioctl, the user receives a -ENOTTY. So he knows there is
something wrong with the driver.

With this class, the driver might interpret this a simple G_VAL and
return he current value with no way for the user to know what is going
on.


Regarding the new implementation.... I can make some code next week,
this week I am 120% busy :)


What do you think?
