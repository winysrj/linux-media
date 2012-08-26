Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2HZQ4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 12:56:47 -0400
Message-ID: <503A554B.6080003@gmail.com>
Date: Sun, 26 Aug 2012 18:56:43 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	oselas@community.pengutronix.de,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 0/1] S3C244X/S3C64XX SoC camera host interface driver
References: <50269F15.4030504@gmail.com> <9609498.7r78ladCdh@flatron> <5026B33F.3030605@gmail.com> <1744040.LQ4tYRekV8@flatron>
In-Reply-To: <1744040.LQ4tYRekV8@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 08/12/2012 12:22 AM, Tomasz Figa wrote:
> On Saturday 11 of August 2012 21:32:15 Sylwester Nawrocki wrote:
>> On 08/11/2012 08:39 PM, Tomasz Figa wrote:
>>> Hi,
>>>
>>> On Saturday 11 of August 2012 20:06:13 Sylwester Nawrocki wrote:
>>>> Hi all,
>>>>
>>>> This patch adds a driver for Samsung S3C244X/S3C64XX SoC series camera
>>>> host interface. My intention was to create a V4L2 driver that would
>>>> work
>>>> with standard applications like Gstreamer or mplayer, and yet exposing
>>>> possibly all features available in the hardware.
>>>>
>>>> It took me several weeks to do this work in my (limited) spare time.
>>>> Finally I've got something that is functional and I think might be
>>>> useful for others, so I'm publishing this initial version. It
>>>> hopefully doesn't need much tweaking or corrections, at least as far
>>>> as S3C244X is concerned. It has not been tested on S3C64XX SoCs, as I
>>>> don't have the hardware. However, the driver has been designed with
>>>> covering S3C64XX as well in mind, and I've already taken care of some
>>>> differences between S3C2444X and S3C64XX. Mem-to-mem features are not
>>>> yet supported, but these are quite separate issue and could be easily
>>>> added as a next step.>
>>> I will try to test it on S3C6410 in some reasonably near future and
>>> report any needed corrections.
>>
>> Sounds great, thanks.
> 
> I have not tested the driver yet, but I am looking through the code and it
> seems like S3C6410 (at least according to the documentation) supports far
> more pixel formats than defined in the driver.
> 
> Both preview and scaler paths are supposed to support 420/422 planar, 422
> interleaved and 565/666/888 formats.

Indeed, somehow I missed that s3c64xx supports most of the pixel formats
on both: the preview and the codec data paths. I've updated the pixel 
format definitions to reflect that, but it still needs to be verified 
with proper tests. I just didn't add YUV422 packed format, I expect it 
to be done by someone who actually verifies that it works, after 
checking/updating camif-regs.c as well.

> Also two distinct planar 420 formats exist that simply differ by plane
> order YUV420 (currently supported in your driver) and YVU420 (with Cb and
> Cr planes swapped). It should be pretty straightforward to add support for
> the latter.

Yeah, thanks for the suggestion. I've added support for YVU420 - it yields 
more options where setting up gstreamer pipelines, along with a few fixes 
for issues I've found after some more testing, including LKM build. It can 
be pulled from following git tree:

git://linuxtv.org/snawrocki/media.git s3c-camif-devel

It's based off of staging/for_v3.7 branch (3.6-rc3). I consider it more or
less stable. The final branch for mainline is 's3c-camif', the difference
is only that the fixes were squashed to a single commit adding the whole 
driver there.

--

Thanks,
Sylwester
