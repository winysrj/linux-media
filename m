Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38773 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1IZImv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 04:42:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LS400CY8G7CAG00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Sep 2011 09:42:48 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LS4005MKG7CGH@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 Sep 2011 09:42:48 +0100 (BST)
Date: Mon, 26 Sep 2011 10:42:43 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [GIT PULL] Selection API and fixes for v3.2
In-reply-to: <4E7D5561.6080303@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4E803B03.5090702@samsung.com>
References: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com>
 <4E7D5561.6080303@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2011 05:58 AM, Mauro Carvalho Chehab wrote:

Hi Mauro
Thank you for your comments. Please refer to the answers below.
> Em 22-09-2011 12:13, Marek Szyprowski escreveu:
>> Hello Mauro,
>>
>> I've collected pending selection API patches together with pending
>> videobuf2 and Samsung driver fixes to a single git branch. Please pull
>> them to your media tree.
>>
>
>> Marek Szyprowski (1):
>>        staging: dt3155v4l: fix build break
>
> I've applied this one previously, from the patch you sent me.
>
>
>> Tomasz Stanislawski (6):
>>        v4l: add support for selection api
>>        v4l: add documentation for selection API
>
> I need more time to review those two patches. I'll probably do it at the next week.
> I generally start analyzing API changes based on the DocBook, so, let me point a few
> things I've noticed on a quick read, at the vidioc-g-selection.html DocBook-generated page:
>
> 1) "The coordinates are expressed in driver-dependant units"
>
> Why? coordinates should be expressed in pixels, as otherwise there's no way to
> use this API on a hardware-independent way.
The documentation for existing cropping API contains following sentence:

"To support a wide range of hardware this specification does not define 
an origin or units."

I decided to follow the same convention for the selection API.
I thought that the only exception would be images in memory buffers, 
whose coordinated would be pixels.

However, as Laurent mentioned, some devices are capable of sub-pixel 
cropping. Moreover, there are image exotic formats that have no 
well-defined resolution (fractal or vector graphics). Now I am still not 
sure if the requirement for resolution in pixels should be used any 
more. The problem is that this requirement is very intuitive and useful 
in "let's say" 95% of cases.

>
> 2)
>      0 - driver is free to adjust size, it is recommended to choose the crop/compose rectangle as close as possible to the original one
>
>      SEL_SIZE_GE - driver is not allowed to shrink the rectangle. The original rectangle must lay inside the adjusted one
>
>      SEL_SIZE_LE - drive is not allowed to grow the rectangle. The adjusted rectangle must lay inside the original one
>
>      SEL_SIZE_GE | SEL_SIZE_LE - choose size exactly the same as in desired rectangle.
>
> The macro names above don't match the definition, as they aren't prefixed by V4L2_.
ok.. I will fix it.
>
> 3) There was no hyperlink for the struct v4l2_selection, as on other API definitions.
ok.. I will fix it.
>
> 4) the language doesn't seem too consistent with the way other ioctl's are defined. For example,
> you're using struct::field for a field at the struct. Other parts of the API just say "field foo of struct bar".
ok.. I will fix it.

> 5) There's not a single mention at the git commit or at the DocBook about why the old crop API
> is being deprecated. You need to convince me about such need (ok, I followed a few discussions in
> the past, but, my brain patch buffer is shorter than the 7000 patchwork patches I reviewed just on
> this week). Besides that: do we really need to obsolete the crop API for TV cards? If so, why? If not,
> you need to explain why a developer should opt between one ioctl set of the other.

There are a few reasons to drop support for the cropping ioctls.

First, the selection API covers existing crop API. Therefore there is no 
need to implement {S/G}_CROP and G_CROPCAP. The {S/G}_SELECTION is 
enough to provide the same functionality. We should avoiding duplication 
inside the api, therefore S_CROP should be dropped.

Second, there is a patch that adds simulation of old crop API using 
selection API. Therefore there is no need to change code of the existing 
applications.

Third, the selection is much more powerful API, and it could be extended 
in future. There no more reserved fields inside structures
used by current cropping api. Moreover cropping is very inconsistent. 
For output devices cropping into display actually means composing into 
display. Moreover it not possible to select only the part of the image 
from the buffer to be inserted or filled by the hardware. The selection 
API introduced the idea of the constraints flags, that are used for 
precise control of the coordinates' rounding policy.

I could split commit 'v4l: add documentation for selection API' into two 
commits. One that deprecates S_CROP, and another one that introduces 
selection.

>
> 6) You should add a note about it at hist-v4l2.html page, stating what happened, and why a new crop
> ioctl set is needed.
ok.. I missed it. Sorry.
>
> 7) You didn't update the Experimental API Elements or the Obsolete API Elements at the hist-v4l2.html
ok.. I missed it. Sorry.
>
> Thanks,
> Mauro

Thank again for your comments.
I hope that my answers will convince you to the selection API.

Best regards,
Tomasz Stanislawski

