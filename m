Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36727 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1CEXXd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 18:23:33 -0500
Received: by wyg36 with SMTP id 36so3221174wyg.19
        for <linux-media@vger.kernel.org>; Sat, 05 Mar 2011 15:23:31 -0800 (PST)
Message-ID: <4D72C5F0.6090209@gmail.com>
Date: Sun, 06 Mar 2011 00:23:28 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: David Cohen <dacohen@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
References: <201102171606.58540.laurent.pinchart@ideasonboard.com>	<201103031125.06419.laurent.pinchart@ideasonboard.com>	<4D71471D.6060808@redhat.com>	<201103051252.12342.hverkuil@xs4all.nl> <AANLkTi=SS3CBkKUdovU33SQi=s9gNprZszKaMrkRGqGy@mail.gmail.com> <4D7248B4.9090003@gmail.com> <4D727D6E.2070602@redhat.com>
In-Reply-To: <4D727D6E.2070602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On 03/05/2011 07:14 PM, Mauro Carvalho Chehab wrote:
> Em 05-03-2011 11:29, Sylwester Nawrocki escreveu:
>> Hi David,
>>
>> On 03/05/2011 02:04 PM, David Cohen wrote:
>>> Hi Hans,
>>>
>>> On Sat, Mar 5, 2011 at 1:52 PM, Hans Verkuil<hverkuil@xs4all.nl>   wrote:
>>>> On Friday, March 04, 2011 21:10:05 Mauro Carvalho Chehab wrote:
>>>>> Em 03-03-2011 07:25, Laurent Pinchart escreveu:
>> ...
>>>>>>         v4l: Group media bus pixel codes by types and sort them alphabetically
>>>>>
>>>>> The presence of those mediabus names against the traditional fourcc codes
>>>>> at the API adds some mess to the media controller. Not sure how to solve,
>>>>> but maybe the best way is to add a table at the V4L2 API associating each
>>>>> media bus format to the corresponding V4L2 fourcc codes.
>>>>
>>>> You can't do that in general. Only for specific hardware platforms. If you
>>>> could do it, then we would have never bothered creating these mediabus fourccs.
>>>>
>>>> How a mediabus fourcc translates to a pixelcode (== memory format) depends
>>>> entirely on the hardware capabilities (mostly that of the DMA engine).
>>>
>>> May I ask you one question here? (not entirely related to this patch set).
>>> Why pixelcode != mediabus fourcc?
>>> e.g. OMAP2 camera driver talks to sensor through subdev interface and
>>> sets its own output pixelformat depending on sensor's mediabus fourcc.
>>> So it needs a translation table mbus_pixelcode ->   pixelformat. Why
>>> can't it be pixelformat ->   pixelformat ?
>>>
>>
>> Let me try to explain, struct v4l2_mbus_framefmt::code (pixelcode)
>> describes how data is transfered/sampled on the camera parallel or serial bus.
>> It defines bus width, data alignment and how many data samples form a single
>> pixel.
>>
>> struct v4l2_pix_format::pixelformat (fourcc) on the other hand describes how
>> the image data is stored in memory.
>>
>> As Hans pointed out there is not always a 1:1 correspondence, e.g.
> 
> The relation may not be 1:1 but they are related.
> 
> It should be documented somehow how those are related, otherwise, the API
> will be obscure.

Yeah, I agree this is a good point now when the media bus formats have become
public. Perhaps by a misunderstanding I just thought it is all more about some
utility functions in the v4l core rather than the documentation.

> 
> Of course, the output format may be different than the internal formats,
> since some bridges have format converters.
> 
>>
>> 1. Both V4L2_MBUS_FMT_YUYV8_1x16 and V4L2_MBUS_FMT_YUYV8_2x8 may being
>> translating to V4L2_PIX_FMT_YUYV fourcc,
> 
> Ok, so there is a relationship between them.
> 
>> 2. Or the DMA engine in the camera host interface might be capable of
>> converting single V4L2_MBUS_FMT_RGB555 pixelcode to V4L2_PIX_FMT_RGB555
>> and V4L2_PIX_FMT_RGB565 fourcc's. So the user can choose any of them they
>> seem most suitable and the hardware takes care of the conversion.
> 
> No. You can't create an additional bit. if V4L2_MBUS_FMT_RGB555 provides 5
> bits for all color channels, the only corresponding format is V4L2_PIX_FMT_RGB555,
> as there's no way to get 6 bits for green, if the hardware sampled it with
> 5 bits. Ok, some bridge may fill with 0 an "extra" bit for green, but this
> is the bridge doing a format conversion.
> 
> In general, for all RGB formats, a mapping between MBUS_FMT_RGBxxx and the
> corresponding fourcc formats could be mapped on two formats only:
> V4L2_PIX_FMT_RGBxxx or V4L2_PIX_FMT_BGRxxx.

OK, that might not have been a good example, of one mbus pixel code to many
fourccs relationship. 
There will be always conversion between media bus pixelcode and fourccs 
as they are in completely different domains. And the method of conversion 
from media bus formats may be an intrinsic property of a bridge, changing
across various bridges, e.g. different endianness may be used.

So I think in general it is good to clearly specify the relationships 
in the API but we need to be aware of varying "correlation ratio" across 
the formats and that we should perhaps operate on ranges rather than single
formats. Perhaps the API should provide guidelines of which formats should
be used when to obtain best results.

> 
>> What translations are available really depends on the hardware, so how
>> could we define a standard translation table? IMO it should be realized
>> in each driver on an individual basis.

