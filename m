Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:57650 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcGDQNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 12:13:14 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/2] pxa_camera transition to v4l2 standalone device
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
	<8b280912-1c4b-17f2-167f-1b30dc7e73f9@xs4all.nl>
Date: Mon, 04 Jul 2016 18:05:33 +0200
In-Reply-To: <8b280912-1c4b-17f2-167f-1b30dc7e73f9@xs4all.nl> (Hans Verkuil's
	message of "Mon, 4 Jul 2016 11:15:58 +0200")
Message-ID: <87oa6d8k36.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Hi Robert,
>
> On 04/02/2016 04:26 PM, Robert Jarzmik wrote:
>> Hi Hans and Guennadi,
>> 
>> This is the second opus of this RFC. The goal is still to see how close our
>> ports are to see if there are things we could either reuse of change.
>> 
>> From RFCv1, the main change is cleaning up in function names and functions
>> grouping, and fixes to make v4l2-compliance happy while live tests still show no
>> regression.
>> 
>> For the next steps, I'll have to :
>>  - split the second patch, which will be a headache task, into :
>>    - first functions grouping and renaming
>>      => this to ensure the "internal functions" are almost untouched
>>    - the the port itself
>> 
>> I'm leaving soc_mediabus for now, that's another task.
>> 
>> I'm not seeing a big review traction, especially on the vb2 conversion, so I'll
>> leave this patchset in RFC form until vb2 patch is reviewed and merged, and then
>> will come back to this work.
>
> I have been trying on-and-off to convert the sh_mobile_ceu_camera to a regular
> driver with basically no success. One major problem is that the sh driver doesn't
> use the device tree, so I can't copy code from the new rcar-vin driver. The scaling
> and cropping code is also tightly coupled to soc-camera.
Yeah, I had the same problem and applied a rather "harsh solution" : amputation
:) I'll add back the cropping code later.

> It is of course possible to do given enough time, but I don't think it is worth it.
>
> So instead I am going for plan B: convert all other soc-camera drivers to 'regular'
> drivers so in the end soc-camera is only used by the sh driver. Then I can turn
> soc-camera into an sh driver, making it impossible for other drivers to use the
> framework.
Good plan.

> In other words, it would be great if you can continue this work, because after
> this driver is converted only the atmel-isi driver remains (besides the sh driver,
> of course).
Of course I will, I committed to. As long as I feel having feedback on the other
end I'll push until the conversion is complete, and beyond (ie. adding back lost
functionality and "beautifying the design"). It's very refreshing for my brain
to do this :)

I'll have more spare time in the comming monthes also, and as I'm doing this on
my spare time, that means more hours to dedicate to pxa maintainance.

Cheers.

-- 
Robert
