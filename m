Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:50814 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbcFVVWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 17:22:13 -0400
Subject: Re: [PATCH v4 2/9] [media] v4l2-core: Add VFL_TYPE_TOUCH_SENSOR
To: Florian Echtler <floe@butterbrot.org>
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466172988-3698-3-git-send-email-nick.dyer@itdev.co.uk>
 <5767DAE4.3000202@xs4all.nl> <576A7B03.30206@butterbrot.org>
 <02dea636-03a0-6c45-3c7e-7b01868a0f32@itdev.co.uk>
 <alpine.DEB.2.10.1606222234190.2895@butterbrot>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <4acb15eb-7e05-5cfa-5524-afd8ee546a53@itdev.co.uk>
Date: Wed, 22 Jun 2016 22:22:03 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1606222234190.2895@butterbrot>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/06/2016 21:38, Florian Echtler wrote:
> On Wed, 22 Jun 2016, Nick Dyer wrote:
> 
>> On 22/06/2016 12:48, Florian Echtler wrote:
>>> On 20.06.2016 14:00, Hans Verkuil wrote:
>>>> On 06/17/2016 04:16 PM, Nick Dyer wrote:
>>>>>
>>>>> Use a new device prefix v4l-touch for these devices, to stop generic
>>>>> capture software from treating them as webcams.
>>
>>> Come to think of it, wouldn't it make sense to expose the other touch
>>> devices as generic frame grabbers, too, so you can easily view the debug
>>> output with any generic tool like cheese?
>>
>> While I like the idea of being able to use the generic tools, I think we
>> needed to do something to stop these devices turning up in e.g. video
>> conferencing software - it would cause a lot of confusion. There's nothing
>> stopping particular tools adding the necessary code to handle touch devices
>> if they feel their users want it.
> 
> Just to clarify: from the userspace point-of-view, would this change simply
> modify the prefix of the device node (i.e. /dev/video1 -> /dev/v4l-touch1),
> or would it somehow affect the API? If it's just the device node name, then
> that shouldn't be a problem after all, because e.g. reacTIVision requires
> you to specify the exact camera to be used anyway.

With the changes that Hans Verkuil has asked me to do:
* The device node is /dev/v4l-touch0-255
* There are several new formats eg. V4L2_TCH_FMT_DELTA_TD16 (16 bit deltas)
* I've defined new types VFL_TYPE_TOUCH, V4L2_BUF_TYPE_TOUCH_CAPTURE,
V4L2_INPUT_TYPE_TOUCH

We're just testing the changes, I hope to post an updated version soon.
