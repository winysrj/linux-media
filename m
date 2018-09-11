Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:37992 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727781AbeIKMwW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 08:52:22 -0400
Subject: Re: [GIT PULL FOR v4.20 (request_api branch)] Add Allwinner cedrus
 decoder driver
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
References: <8c00abfd-3f15-eab5-7d0b-5a4f7580d1f0@xs4all.nl>
 <20180911074723.wioe7fnm6mrxsgjt@flea>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7a31ccb3-71b0-d131-4f0b-6a9fe4af3a80@xs4all.nl>
Date: Tue, 11 Sep 2018 09:54:13 +0200
MIME-Version: 1.0
In-Reply-To: <20180911074723.wioe7fnm6mrxsgjt@flea>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/18 09:47, Maxime Ripard wrote:
> Hi Hans,
> 
> On Mon, Sep 10, 2018 at 10:34:53AM +0200, Hans Verkuil wrote:
>> This is the cedrus Allwinner decoder driver. It is for the request_api topic
>> branch, but it assumes that this pull request is applied first:
>> https://patchwork.linuxtv.org/patch/51889/
>>
>> The last two patches could optionally be squashed with the main driver patch:
>> they fix COMPILE_TEST issues. I decided not to squash them and leave the choice
>> to you.
>>
>> This won't fully fix the COMPILE_TEST problems, for that another patch is needed:
>>
>> https://lore.kernel.org/patchwork/patch/983848/
>>
>> But that's going through another subsystem.
>>
>> Many, many thanks go to Paul for working on this, trying to keep up to date with
>> the Request API changes at the same time. It was a pleasure working with you on
>> this!
>>
>> Regards,
>>
>> 	Hans
>>
>> The following changes since commit 051dfd971de1317626d322581546257b748ebde1:
>>
>>   media-request: update documentation (2018-09-04 11:34:57 +0200)
>>
>> are available in the Git repository at:
>>
>>   git://linuxtv.org/hverkuil/media_tree.git cedrus
>>
>> for you to fetch changes up to e035b190fac3735e5f9d3c96cee5afc82aa1a94d:
>>
>>   media: cedrus: Select the sunxi SRAM driver in Kconfig (2018-09-10 10:22:07 +0200)
>>
>> ----------------------------------------------------------------
>> Paul Kocialkowski (13):
>>       media: videobuf2-core: Rework and rename helper for request buffer count
>>       media: v4l: Add definitions for MPEG-2 slice format and metadata
>>       media: v4l: Add definition for the Sunxi tiled NV12 format
>>       dt-bindings: media: Document bindings for the Cedrus VPU driver
>>       media: platform: Add Cedrus VPU decoder driver
>>       ARM: dts: sun5i: Add Video Engine and reserved memory nodes
>>       ARM: dts: sun7i-a20: Add Video Engine and reserved memory nodes
>>       ARM: dts: sun8i-a33: Add Video Engine and reserved memory nodes
>>       ARM: dts: sun8i-h3: Add Video Engine and reserved memory nodes
>>       media: cedrus: Fix error reporting in request validation
>>       media: cedrus: Add TODO file with tasks to complete before unstaging
>>       media: cedrus: Wrap PHYS_PFN_OFFSET with ifdef and add dedicated comment
>>       media: cedrus: Select the sunxi SRAM driver in Kconfig
>>
>>  Documentation/devicetree/bindings/media/cedrus.txt |  54 +++++
>>  Documentation/media/uapi/v4l/extended-controls.rst | 176 ++++++++++++++++
>>  Documentation/media/uapi/v4l/pixfmt-compressed.rst |  16 ++
>>  Documentation/media/uapi/v4l/pixfmt-reserved.rst   |  15 +-
>>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  14 +-
>>  Documentation/media/videodev2.h.rst.exceptions     |   2 +
>>  MAINTAINERS                                        |   7 +
>>  arch/arm/boot/dts/sun5i.dtsi                       |  26 +++
>>  arch/arm/boot/dts/sun7i-a20.dtsi                   |  26 +++
>>  arch/arm/boot/dts/sun8i-a33.dtsi                   |  26 +++
>>  arch/arm/boot/dts/sun8i-h3.dtsi                    |  25 +++
> 
> Sorry for not noticing it earlier, but we'll want to merge the
> arch/arm/boot/dts/* changes through arm-soc, to reduce the merge
> conflicts.
> 
> I guess we can do it through several ways, depending on what's the
> most convenient for you:
> 
>   - Drop the patches in your PR,

I'll do this.

Apologies, completely my mistake.

Regards,

	Hans

>   - Send a revert patch as an additional patch on top of your current PR
>   - Or just merge the same patches in our tree and let git figure it out.
> 
> Maxime
> 
