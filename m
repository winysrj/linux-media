Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:44148 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZDEQkF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 12:40:05 -0400
Date: Sun, 5 Apr 2009 11:53:10 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: =?ISO-8859-15?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l: Possibility of changing the current pixelformat on the
 fly
In-Reply-To: <49D8A58A.2070303@hhs.nl>
Message-ID: <alpine.LNX.2.00.0904051132340.30810@banach.math.auburn.edu>
References: <49D7C17B.80708@gmail.com> <49D87524.9050309@hhs.nl> <49D8955C.8030806@gmail.com> <49D8A58A.2070303@hhs.nl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-769415565-1238950390=:30810"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-769415565-1238950390=:30810
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT



On Sun, 5 Apr 2009, Hans de Goede wrote:

> On 04/05/2009 01:26 PM, Erik Andrén wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>> 
>> 
>> 
>> Hans de Goede wrote:
>>> On 04/04/2009 10:22 PM, Erik Andrén wrote:
>>>> -----BEGIN PGP SIGNED MESSAGE-----
>>>> Hash: SHA1
>>>> 
>>>> Hi,
>>>> 
>>>> While trying to get hflip and vflip working for the stv06xx webcam
>>>> bridge coupled to the vv6410 sensor I've come across the following
>>>> problem.
>>>> 
>>>> When flipping the image horizontally, vertically or both, the sensor
>>>> pixel ordering changes. In the m5602 driver I was able to compensate
>>>> for this in the bridge code. In the stv06xx I don't have this
>>>> option. One way of solving this problem is by changing the
>>>> pixelformat on the fly, i. e V4L2_PIX_FMT_SGRB8 is the normal
>>>> format. When a vertical flip is required, change the format to
>>>> V4L2_SBGGR8.
>>>> 
>>>> My current understanding of libv4l is that it probes the pixelformat
>>>>     upon device open. In order for this to work we would need either
>>>> poll the current pixelformat regularly or implement some kind of
>>>> notification mechanism upon a flipping request.
>>>> 
>>>> What do you think is this the right way to go or is there another
>>>> alternative.
>>>> 
>>> The changing of the pixelformat only happens when you flip the data
>>> before conversion. If you look at the current upside down handling
>>> code you will see it does the rotate 180 degrees after conversion.
>>> 
>>> This is how the vflip / hflip should be handled too. We only have
>>> 4 (2 really since we don't care about r versus b / u versus v while
>>> flippiing) destination formats for which we then need to write flipping
>>> code. Otherwise we need to write flipping code for *all* supported input
>>> formats, not to mention flipping some input formats is close to impossible
>>> (JPEG for example).
>>> 
>> 
>> So you mean we should do the vflip/hflip in software, just exposing
>> one native format?
>> 
>
> Erm, yes that is what I was saying, but that is because I was confusing
> things with the sq905 driver some other people are working on.
>
> Now I understand what you were trying to ask. So the problem is that
> the vv6410 sensor can do flipping in hardware, and then the order in
> which it sends out the pixels changes from gbgbgb (for example)
> to bgbgbg, for the lines which have blue, effectively changing the
> pixelformat, right?


You mention the sq905 cameras, and the general problem of image flipping. 
You comment that the order of the data changes if any kind of flipping 
is done, with the result that the image format (Bayer tiling) changes. One 
difference I do see here is that "the vv6410 sensor can do flipping in 
hardware" which the sq905 cameras obviously can not. However, the fact 
that the Bayer tiling of the image must change in accordance with the 
flipping is equally present. And I do not see how that problem could be 
avoided, on any occasion when flipping is needed.

This brings up an interesting question of what would be the most efficient 
way actually to do the required image flipping:

If the flipping is done before the finished image is produced, then the 
Bayer tiling of the image has changed. Therefore a different treatment is 
needed.

If the flipping is done after the finished image is produced, then there 
is three times as much data, and the flipping might take longer (or might 
not if it were done exactly right?).

Therefore, how best to do this? As I said, I am thinking about the sq905 
driver. One of its peculiarities, as far as I can tell, is that the 
cameras all use the same Bayer tiling before the flipping. But after the 
flipping it is obviously a different story. The approach that was taken in 
the libgphoto2 driver for the sq905 cameras was to do the flipping first, 
and then to apply the right Bayer tiling afterward for the particular 
camera. Clearly, that could also be done here. However, is that the best 
way to go about it? Perhaps in fact it is simpler to do the flipping of an 
entire finished image, instead. Then one would of course have to move 
triples instead of single bytes, in order to leave the color mapping 
unmolested.

It is interesting that this problem comes up with some other cameras, too.

Theodore Kilgore

---863829203-769415565-1238950390=:30810--
