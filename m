Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZDFH6H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 03:58:07 -0400
Message-ID: <49D9B6A4.207@redhat.com>
Date: Mon, 06 Apr 2009 10:00:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>,
	=?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l: Possibility of changing the current pixelformat on the
 fly
References: <49D7C17B.80708@gmail.com> <49D87524.9050309@hhs.nl> <49D8955C.8030806@gmail.com> <49D8A58A.2070303@hhs.nl> <alpine.LNX.2.00.0904051132340.30810@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0904051132340.30810@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/05/2009 06:53 PM, Theodore Kilgore wrote:
>
>
> On Sun, 5 Apr 2009, Hans de Goede wrote:
>
>> On 04/05/2009 01:26 PM, Erik Andrén wrote:
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA1
>>>
>>>
>>>
>>> Hans de Goede wrote:
>>>> On 04/04/2009 10:22 PM, Erik Andrén wrote:
>>>>> -----BEGIN PGP SIGNED MESSAGE-----
>>>>> Hash: SHA1
>>>>>
>>>>> Hi,
>>>>>
>>>>> While trying to get hflip and vflip working for the stv06xx webcam
>>>>> bridge coupled to the vv6410 sensor I've come across the following
>>>>> problem.
>>>>>
>>>>> When flipping the image horizontally, vertically or both, the sensor
>>>>> pixel ordering changes. In the m5602 driver I was able to compensate
>>>>> for this in the bridge code. In the stv06xx I don't have this
>>>>> option. One way of solving this problem is by changing the
>>>>> pixelformat on the fly, i. e V4L2_PIX_FMT_SGRB8 is the normal
>>>>> format. When a vertical flip is required, change the format to
>>>>> V4L2_SBGGR8.
>>>>>
>>>>> My current understanding of libv4l is that it probes the pixelformat
>>>>> upon device open. In order for this to work we would need either
>>>>> poll the current pixelformat regularly or implement some kind of
>>>>> notification mechanism upon a flipping request.
>>>>>
>>>>> What do you think is this the right way to go or is there another
>>>>> alternative.
>>>>>
>>>> The changing of the pixelformat only happens when you flip the data
>>>> before conversion. If you look at the current upside down handling
>>>> code you will see it does the rotate 180 degrees after conversion.
>>>>
>>>> This is how the vflip / hflip should be handled too. We only have
>>>> 4 (2 really since we don't care about r versus b / u versus v while
>>>> flippiing) destination formats for which we then need to write flipping
>>>> code. Otherwise we need to write flipping code for *all* supported
>>>> input
>>>> formats, not to mention flipping some input formats is close to
>>>> impossible
>>>> (JPEG for example).
>>>>
>>>
>>> So you mean we should do the vflip/hflip in software, just exposing
>>> one native format?
>>>
>>
>> Erm, yes that is what I was saying, but that is because I was confusing
>> things with the sq905 driver some other people are working on.
>>
>> Now I understand what you were trying to ask. So the problem is that
>> the vv6410 sensor can do flipping in hardware, and then the order in
>> which it sends out the pixels changes from gbgbgb (for example)
>> to bgbgbg, for the lines which have blue, effectively changing the
>> pixelformat, right?
>
>
> You mention the sq905 cameras, and the general problem of image
> flipping. You comment that the order of the data changes if any kind of
> flipping is done, with the result that the image format (Bayer tiling)
> changes. One difference I do see here is that "the vv6410 sensor can do
> flipping in hardware" which the sq905 cameras obviously can not.
> However, the fact that the Bayer tiling of the image must change in
> accordance with the flipping is equally present. And I do not see how
> that problem could be avoided, on any occasion when flipping is needed.
>
> This brings up an interesting question of what would be the most
> efficient way actually to do the required image flipping:
>
> If the flipping is done before the finished image is produced, then the
> Bayer tiling of the image has changed. Therefore a different treatment
> is needed.
>
> If the flipping is done after the finished image is produced, then there
> is three times as much data, and the flipping might take longer (or
> might not if it were done exactly right?).
>

True, still doing the flipping after the conversion is done, is what we are
currently doing for the rotate 180 case (so h-flip + v-flip) and is what I
think we should also do for the regular h-flip and v-flip.

Why? Simplicity! We support 4 different destination formats, which can
be simplified to 3 for the flipping case (we do not need to care about uv
order). So that means writing vflip + hflip + rotate 180 = 3 x 3 9
flipping routines. At the moment we support 23 different source formats,
so doing flipping at the level requires 3 x 23 = 69 flipping routines of which
we can shave of quite a bit by being smart here and there, but then we are
still left with quite a large number. But the most important reason for me
not to want to do this at the source format level, is that I do not want to
make it harder to add new source formats. Currently for a new
source format, conversion routines for all 4 dest formats must be written,
so that is 4 new conversion routines at worst. I do not want to make adding
new formats harder.

Regards,

Hans
