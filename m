Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3075 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaGZRJl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 13:09:41 -0400
Message-ID: <53D3E0A2.90101@xs4all.nl>
Date: Sat, 26 Jul 2014 19:08:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 2/3] [media] coda: fix coda_g_selection
References: <1406385272-425-1-git-send-email-philipp.zabel@gmail.com>	<1406385272-425-2-git-send-email-philipp.zabel@gmail.com>	<53D3C578.8000802@xs4all.nl> <CA+gwMcd2hETKbkqM5yeJiVDzadHyQX=qgPTqobFXTN4JQ-+vdA@mail.gmail.com>
In-Reply-To: <CA+gwMcd2hETKbkqM5yeJiVDzadHyQX=qgPTqobFXTN4JQ-+vdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/26/2014 06:37 PM, Philipp Zabel wrote:
> On Sat, Jul 26, 2014 at 5:12 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 07/26/2014 04:34 PM, Philipp Zabel wrote:
>>> Crop targets are valid on the capture side and compose targets are valid
>>> on the output side, not the other way around.
>>
>> Are you sure about this? Usually for m2m devices the capture side supports
>> compose (i.e. the result of the m2m operation can be composed into the capture
>> buffer) and the output side supports crop (i.e. the m2m operates on the cropped
>> part of the output buffer instead of on the full buffer), like the coda driver
>> does today.
> 
> You are right, I haven't thought this through. Please ignore this patch.
> 
>> As a result of that the old G/S_CROP API cannot be used with most m2m devices
>> since it does the opposite operation, which does not apply to m2m devices.
> 
> I have tried the GStreamer v4l2videodec element with the coda driver and
> noticed that GStreamer calls VIDIOC_CROPCAP to obtain the pixel aspect
> ratio. This always fails with -EINVAL because of this issue. Currently GStreamer
> throws a warning if the return value is an error other than -ENOTTY.

I never ever liked it that pixelaspect was part of cropcap since it is really
unrelated to cropping. Now that the compound control support is in it might
be time to create a pair of read-only controls that report the pixelaspect
ratio, one for video capture, one for video output. That would be a much
cleaner solution.

Regards,

	Hans

> 
> regards
> Philipp
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

