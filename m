Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:56524 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbcFVMAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 08:00:00 -0400
Subject: Re: [PATCH v4 2/9] [media] v4l2-core: Add VFL_TYPE_TOUCH_SENSOR
To: Florian Echtler <floe@butterbrot.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466172988-3698-3-git-send-email-nick.dyer@itdev.co.uk>
 <5767DAE4.3000202@xs4all.nl> <576A7B03.30206@butterbrot.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	mchehab@osg.samsung.com
From: Nick Dyer <nick.dyer@itdev.co.uk>
Message-ID: <02dea636-03a0-6c45-3c7e-7b01868a0f32@itdev.co.uk>
Date: Wed, 22 Jun 2016 12:59:39 +0100
MIME-Version: 1.0
In-Reply-To: <576A7B03.30206@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/06/2016 12:48, Florian Echtler wrote:
> On 20.06.2016 14:00, Hans Verkuil wrote:
>> On 06/17/2016 04:16 PM, Nick Dyer wrote:
>>> Some touch controllers send out raw touch data in a similar way to a
>>> greyscale frame grabber. Add a new device type for these devices.
>>>
>>> Use a new device prefix v4l-touch for these devices, to stop generic
>>> capture software from treating them as webcams.
>>>
>>> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
>>> ---
>>>  drivers/input/touchscreen/sur40.c    |  4 ++--
>>>  drivers/media/v4l2-core/v4l2-dev.c   | 13 ++++++++++---
>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 15 ++++++++++-----
>>>  include/media/v4l2-dev.h             |  3 ++-
>>>  include/uapi/linux/videodev2.h       |  1 +
> 
> Generally a good idea in my opinion, but I think the SUR40 is a special
> case: the whole point of putting in a V4L2 driver was that software like
> reacTIVision, which already has a V4L2 interface, can then use that
> device like any other camera.

Thanks. I see that reactivision definitely uses this already
(https://github.com/mkalten/reacTIVision/issues/3 ) and we don't want to
break it - I've split the sur40.c change out of this patch now so it can be
considered separately.

> Come to think of it, wouldn't it make sense to expose the other touch
> devices as generic frame grabbers, too, so you can easily view the debug
> output with any generic tool like cheese?

While I like the idea of being able to use the generic tools, I think we
needed to do something to stop these devices turning up in e.g. video
conferencing software - it would cause a lot of confusion. There's nothing
stopping particular tools adding the necessary code to handle touch devices
if they feel their users want it.

Also, the RMI4 and Atmel mXT touchscreens output signed data, which
unfortunately would confuse the generic tools.
