Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:35550 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbcF0L5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 07:57:42 -0400
Subject: Re: [PATCH v5 0/9] Output raw touch data via V4L2
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
 <30c68dab-b970-03d5-797b-3376d9d0dc10@xs4all.nl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Nick Dyer <nick.dyer@itdev.co.uk>
Message-ID: <8be600b6-a424-ddda-8672-1aed4e925fe8@itdev.co.uk>
Date: Mon, 27 Jun 2016 12:57:26 +0100
MIME-Version: 1.0
In-Reply-To: <30c68dab-b970-03d5-797b-3376d9d0dc10@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans-

Thanks for reviewing this again in such detail.

On 27/06/2016 12:26, Hans Verkuil wrote:
> On 06/23/2016 12:08 AM, Nick Dyer wrote:
>> This is a series of patches to add output of raw touch diagnostic data via V4L2
>> to the Atmel maXTouch and Synaptics RMI4 drivers.
>>
>> It's a rewrite of the previous implementation which output via debugfs: it now
>> uses a V4L2 device in a similar way to the sur40 driver.
>>
>> We have a utility which can read the data and display it in a useful format:
>>     https://github.com/ndyer/heatmap/commits/heatmap-v4l
>>
>> These patches are also available from
>>     https://github.com/ndyer/linux/commits/v4l-touch-2016-06-22
>>
>> Changes in v5 (Hans Verkuil review):
>> - Update v4l2-core:
>>   - Add VFL_TYPE_TOUCH, V4L2_BUF_TYPE_TOUCH_CAPTURE and V4L2_CAP_TOUCH
> 
> The use of V4L2_CAP_TOUCH and V4L2_BUF_TYPE_TOUCH_CAPTURE is very inconsistent.
> What is the rationale of adding V4L2_BUF_TYPE_TOUCH_CAPTURE? I can't remember
> asking for it.

I am afraid that I missed updating atmel_mxt_ts from
V4L2_BUF_TYPE_VIDEO_CAPTURE to V4L2_BUF_TYPE_TOUCH_CAPTURE, which has
confused the situation.

Perhaps I read too much into your request that I look at the way that SDR
is treated. When I started going through the code paths in v4l2-core and
v4l2-compliance, it seemed cleaner to treat touch as completely separate,
hence introducing the new BUF_TYPE. I'm happy to try it without this.

> And wouldn't the use of V4L2_BUF_TYPE_TOUCH_CAPTURE break userspace for sur40?

I think it is likely, yes. And it looks like that would make Florian unhappy.

> I'm ambiguous towards having a V4L2_BUF_TYPE_TOUCH_CAPTURE, to be honest.
> 
> I would also recommend renaming V4L2_CAP_TOUCH to V4L2_CAP_TOUCH_CAPTURE.

Do you agree with the following changes:

- Rename V4L2_CAP_TOUCH to V4L2_CAP_TOUCH_CAPTURE.

- Touch devices should register both V4L2_CAP_VIDEO_CAPTURE and
V4L2_CAP_TOUCH_CAPTURE.

- Get rid of V4L2_BUF_TYPE_TOUCH_CAPTURE and use
V4L2_BUF_TYPE_VIDEO_CAPTURE. In v4l2-ioctl.c if we need to force particular
pix formats for touch, it will need to look at V4L2_CAP_TOUCH_CAPTURE.

Your other review comments look straightforward to address - thanks.

I should say, you can see my current changes to v4l2-compliance here:
https://github.com/ndyer/v4l-utils/commit/07e00c33

Should I post them along with the kernel patches next time?

> 
> I can imagine an embedded usb gadget device that outputs touch data to a PC.
> 
> Regards,
> 
> 	Hans
