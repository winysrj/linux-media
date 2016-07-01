Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53562 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869AbcGAMBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 08:01:00 -0400
Subject: Re: [PATCH v3 0/9] Add MT8173 Video Decoder Driver
To: andrew-ct chen <andrew-ct.chen@mediatek.com>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
 <20160607112235.475c2e4c@recife.lan> <575746EE.3030706@cisco.com>
 <1465902488.27938.7.camel@mtksdaap41> <20160616075428.0fde4aaa@recife.lan>
 <8a46c1e7-1f27-1e67-8c05-b133598b6a66@xs4all.nl>
 <1467373995.17297.2.camel@mtksdaap41>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	tiffany lin <tiffany.lin@mediatek.com>,
	devicetree@vger.kernel.org, daniel.thompson@linaro.org,
	linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
	Hans Verkuil <hansverk@cisco.com>, PoChun.Lin@mediatek.com,
	Rob Herring <robh+dt@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Pawel Osciak <posciak@chromium.org>,
	linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7ee128a2-f026-5404-bbac-6b5c1bee51e7@xs4all.nl>
Date: Fri, 1 Jul 2016 14:00:54 +0200
MIME-Version: 1.0
In-Reply-To: <1467373995.17297.2.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2016 01:53 PM, andrew-ct chen wrote:
> On Fri, 2016-07-01 at 12:11 +0200, Hans Verkuil wrote:
>> On 06/16/2016 12:54 PM, Mauro Carvalho Chehab wrote:
>>> Em Tue, 14 Jun 2016 19:08:08 +0800
>>> tiffany lin <tiffany.lin@mediatek.com> escreveu:
>>>
>>>> Hi Mauro,
>>>>
>>>>
>>>> On Wed, 2016-06-08 at 07:13 +0900, Hans Verkuil wrote:
>>>>>
>>>>> On 06/07/2016 11:22 PM, Mauro Carvalho Chehab wrote:  
>>>>>> Em Mon, 30 May 2016 20:29:14 +0800
>>>>>> Tiffany Lin <tiffany.lin@mediatek.com> escreveu:
>>>>>>  
>>>>>>> ==============
>>>>>>>   Introduction
>>>>>>> ==============
>>>>>>>
>>>>>>> The purpose of this series is to add the driver for video codec hw embedded in the Mediatek's MT8173 SoCs.
>>>>>>> Mediatek Video Codec is able to handle video decoding of in a range of formats.
>>>>>>>
>>>>>>> This patch series add Mediatek block format V4L2_PIX_FMT_MT21, the decoder driver will decoded bitstream to
>>>>>>> V4L2_PIX_FMT_MT21 format.
>>>>>>>
>>>>>>> This patch series rely on MTK VPU driver in patch series "Add MT8173 Video Encoder Driver and VPU Driver"[1]
>>>>>>> and patch "CHROMIUM: v4l: Add V4L2_PIX_FMT_VP9 definition"[2] for VP9 support.
>>>>>>> Mediatek Video Decoder driver rely on VPU driver to load, communicate with VPU.
>>>>>>>
>>>>>>> Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI both have been merged in v4.6-rc1.
>>>>>>>
>>>>>>> [1]https://patchwork.linuxtv.org/patch/33734/
>>>>>>> [2]https://chromium-review.googlesource.com/#/c/245241/  
>>>>>>
>>>>>> Hmm... I'm not seeing the firmware for this driver at the
>>>>>> linux-firmware tree:
>>>>>> 	https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/log/
>>>>>>
>>>>>> Nor I'm seeing any pull request for them. Did you send it?
>>>>>> I'll only merge the driver upstream after seeing such pull request.  
>>>>>   
>>>> Sorry, I am not familiar with how to upstream firmware.
>>>> Do you mean we need to upstream vpu firmware first before merge encoder
>>>> driver upstream?
>>>
>>> Please look at this page:
>>> 	https://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches#Firmware_submission
>>>
>>> The information here can also be useful:
>>> 	https://www.kernel.org/doc/readme/firmware-README.AddingFirmware
>>>
>>> In summary, you need to provide redistribution rights for the
>>> firmware blob. You can either submit it to me or directly to
>>> linux-firmware. In the latter, please c/c me on such patch.
>>
>> Tiffany, what is the status of the firmware submission?
>>
>> Regards,
>>
>> 	Hans
> 
> Hi Hans,
> We are working on firmware test to make sure that both decoder and
> encoder work well. Hopes it can be ready (firmware submission) on July 4
> or July 5.

OK, great! Just wanted to make sure that this work was progressing and not stalled.

Thanks!

	Hans
