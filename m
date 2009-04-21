Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32107.mail.mud.yahoo.com ([68.142.207.121]:27105 "HELO
	web32107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751644AbZDUJg7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 05:36:59 -0400
Message-ID: <182771.15423.qm@web32107.mail.mud.yahoo.com>
Date: Tue, 21 Apr 2009 02:36:59 -0700 (PDT)
From: Agustin <gatoguan-os@yahoo.com>
Reply-To: gatoguan-os@yahoo.com
Subject: Re: [PATCH] v4l2-subdev: add a v4l2_i2c_new_dev_subdev() function
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

--- On 21/4/09, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Video (sub)devices, connecting to SoCs over generic i2c busses cannot 
> provide a pointer to struct v4l2_device in i2c-adapter driver_data, and 
> provide their own i2c_board_info data, including a platform_data field. 
> Add a v4l2_i2c_new_dev_subdev() API function that does exactly the same
> as v4l2_i2c_new_subdev() but uses different parameters, and make 
> v4l2_i2c_new_subdev() a wrapper around it.

[snip]

I am wondering about this ongoing effort and its pursued goal: is it to hierarchize the v4l architecture, adding new abstraction levels? If so, what for?

To me, as an eventual driver developer, this makes it harder to integrate my own drivers, as I use I2C and V4L in my system but I don't want them to be tightly coupled.

Of course I can ignore this "subdev" stuff and just link against soc-camera which is what I need, and manage I2C without V4L knowing about it. Which is what I do.

So, which is the point I am missing?

Regards,
--Agustín.

--
Agustin Ferrin Pozuelo
Embedded Systems Consultant
http://embedded.ferrin.org
Tel. +34 610502587
