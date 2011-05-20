Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:35961 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab1ETHwk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 03:52:40 -0400
Message-ID: <4DD61DC6.10909@matrix-vision.de>
Date: Fri, 20 May 2011 09:52:38 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [RFC/PATCH 1/2] v4l: Add generic board subdev  registration function
References: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com> <4DD614DC.3070905@samsung.com> <201105200929.33226.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105200929.33226.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/20/2011 09:29 AM, Laurent Pinchart wrote:

[snip]

>> I had an issue when tried to call request_module, to register subdev of
>> platform device type, in probe() of other platform device. Driver's
>> probe() for devices belonging same bus type cannot be nested as the bus
>> lock is taken by the driver core before entering probe(), so this would
>> lead to a deadlock.
>> That exactly happens in __driver_attach().
>>
>> For the same reason v4l2_new_subdev_board could not be called from probe()
>> of devices belonging to I2C or SPI bus, as request_module is called inside
>> of it. I'm not sure how to solve it, yet:)
> 
> Ouch. I wasn't aware of that issue. Looks like it's indeed time to fix the 
> subdev registration issue, including the module load race condition. Michael, 
> you said you have a patch to add platform subdev support, how have you avoided 
> the race condition ?

I spoke too soon. This deadlock is staring me in the face right now,
too.  Ouch, indeed.

[snip]


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
