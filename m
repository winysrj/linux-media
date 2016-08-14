Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:58744 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbcHNTbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 15:31:15 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 02/14] media: mt9m111: prevent module removal while in use
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
	<1470684652-16295-3-git-send-email-robert.jarzmik@free.fr>
	<4a60c89e-f183-5c92-8c5d-e5d75767c10b@xs4all.nl>
Date: Sun, 14 Aug 2016 21:31:13 +0200
Message-ID: <87vaz3qha6.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 08/08/2016 09:30 PM, Robert Jarzmik wrote:
>> The mt9m111 can be a removable module : the only case where the module
>> should be kept loaded is while it is used, ie. while an active
>> transation is ongoing on it.
>> 
>> The notion of active transaction is mapped on the power state of the
>> module : if powered on the removal is prohibited.
>
> I don't really see the purpose of this patch: if this driver is loaded
> by a platform driver (such as pxa_camera), then the module count should be
> 1 and it isn't possible to unload.
>
> So you shouldn't need this patch. Am I missing something?
Well, what you are missing is ugly and twisted.

With the current patchset, pxa_camera doesn't acquire the module (see
pxa_camera_sensor_bound()). That is the ugly part.

The reason behind is that if it acquires it, it's totally impossible to rmmod
either pxa_camera or mt9m111 because of the cross-dependency I wasn't able to
solve up to now.

The dependency chain goes as follows :
 - pxa_camera should +1 refcount mt9m111 in pxa_camera_sensor_bound()
 - mt9m111 should +1 refcount pxa_camera through the MCLK get_clock()
   Without MCLK, mt9m111 is not clocked, and no I2C is available, hence no
   control and a total loss of context

The purpose of this patch was the mt9m111 aquired a +1 refcount on pxa_camera so
that pxa_camera is prevented from removal while a transfer is underway, and
while the mt9m111 has the MCLK refcount acquired.

I perfectly know this is suboptimal, but I didn't find a way yet to solve
this. I was thinking to use pxac_fops_camera_open() to refcount +1 mt9m111
module and pxac_fops_camera_release() to refcound -1 mt9m111. But that didn't
work because in order for mt9m111 to probe, the I2C has to be functional, and
therefore the MCLK has to be provided.

> No other driver in drivers/media/i2c does something like this.
Yeah, I would bet either no other driver has the crossed dependency or they can
never be rmmoded.

Let me see how I can drop this patch and still prevent a kernel panic upon an
rmmod of either mt9m111 or pxa_camera.

Cheers.

--
Robert
