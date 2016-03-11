Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36006 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153AbcCKQHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 11:07:51 -0500
Subject: Re: [PATCH] media: platform: pxa_camera: convert to vb2
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <1457543851-17823-1-git-send-email-robert.jarzmik@free.fr>
 <56E2BD79.9080405@xs4all.nl> <8760wtdtda.fsf@belgarion.home>
 <56E2CF64.9040809@xs4all.nl> <87oaal81ls.fsf@belgarion.home>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E2ED51.8050400@xs4all.nl>
Date: Fri, 11 Mar 2016 17:07:45 +0100
MIME-Version: 1.0
In-Reply-To: <87oaal81ls.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2016 04:40 PM, Robert Jarzmik wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> On 03/11/2016 02:41 PM, Robert Jarzmik wrote:
>>> Hans Verkuil <hverkuil@xs4all.nl> writes:
>> One area where I would like to see some helper functions is with respect to
>> format/media bus processing. I played with this a little bit but it is surprisingly
>> hard to do. A lot of devices have all sorts of weird and wonderful exceptions
>> that make this quite problematic.
> 
> I'm also worried about the initial probing, where the subdevice, be that an I2C
> sensor or something else has to be available, ie. the v4l2_async_notifier and
> its implications.
> 
>>> Ah, that's a special case we need to discuss.
>>> I've written in the commit message a chapter about a "special port of this
>>> code". This is it.
>>>
>>> This usecase is when a user does the following :
>>>  - set format to 1280x1024, RGB565
>>>  - REQBUF for MMAP buffers
>>>  - QBUF, capture, DQBUF
>>>
>>>  - then set format to 640x480, RGB565
>>>    => here the new format fits in the previously allocated video buffer
>>>  - QBUF
>>>    => the test in pxa_vb2_prepare() detects this, and calls pxa_buffer_init()
>>>    again
>>>
>>> Now if this usecase is impossible, then I'll do as you say to simplify the code
>>> : use icd->sizeimage, remove the code in pxa_vb2_prepare(), etc ...
>>
>> Does this actually work with soc-camera? As far as I can see soc-camera returns
>> -EBUSY in soc_camera_s_fmt_vid_cap() if you attempt to change the format while
>> streaming.
> 
> It's not "while streaming" in the described usecase, it's after streaming is
> finished actually. I should have added in the third dash VIDIOC_STREAMON before
> "capture" and VIDIOC_STREAMOFF after DQBUF. I think it's working, even if I had
> not tried recently. I certainly don't care that much about the usecase, and I
> won't feel sad dropping it :)

Ah, OK. This use-case will probably work with soc-camera.

What I would prefer is to remove the feature for this vb2 conversion and the
following soc-camera removal. If you decide that the feature is desirable, then
add it back in a final patch.

The reason for this is that it is much easier for me to review this once the driver
is no longer dependent on soc-camera. I don't have to jump from the pxa driver to
the soc-camera framework and back just to trace if there are no corner cases that
were forgotten.

This feature is unusual (very few drivers support it) and so I would like to take
a close look at it, ensuring everything is done correctly.

Regards,

	Hans

