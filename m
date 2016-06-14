Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:36512 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcFNIo5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 04:44:57 -0400
Received: by mail-vk0-f43.google.com with SMTP id u64so100782929vkf.3
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 01:44:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <575746EE.3030706@cisco.com>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
 <20160607112235.475c2e4c@recife.lan> <575746EE.3030706@cisco.com>
From: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?=
	<wuchengli@chromium.org>
Date: Tue, 14 Jun 2016 16:44:36 +0800
Message-ID: <CAOMLVLjnktOoDWseZBwsFwLbym8mX7CQzOHW3tbum1yWJjfFNA@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] Add MT8173 Video Decoder Driver
To: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Lin PoChun <PoChun.Lin@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 8, 2016 at 6:13 AM, Hans Verkuil <hansverk@cisco.com> wrote:
>
>
> On 06/07/2016 11:22 PM, Mauro Carvalho Chehab wrote:
>>
>> Em Mon, 30 May 2016 20:29:14 +0800
>> Tiffany Lin <tiffany.lin@mediatek.com> escreveu:
>>
>>> ==============
>>>   Introduction
>>> ==============
>>>
>>> The purpose of this series is to add the driver for video codec hw
>>> embedded in the Mediatek's MT8173 SoCs.
>>> Mediatek Video Codec is able to handle video decoding of in a range of
>>> formats.
>>>
>>> This patch series add Mediatek block format V4L2_PIX_FMT_MT21, the
>>> decoder driver will decoded bitstream to
>>> V4L2_PIX_FMT_MT21 format.
>>>
>>> This patch series rely on MTK VPU driver in patch series "Add MT8173
>>> Video Encoder Driver and VPU Driver"[1]
>>> and patch "CHROMIUM: v4l: Add V4L2_PIX_FMT_VP9 definition"[2] for VP9
>>> support.
>>> Mediatek Video Decoder driver rely on VPU driver to load, communicate
>>> with VPU.
>>>
>>> Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI
>>> both have been merged in v4.6-rc1.
>>>
>>> [1]https://patchwork.linuxtv.org/patch/33734/
>>> [2]https://chromium-review.googlesource.com/#/c/245241/
>>
>>
>> Hmm... I'm not seeing the firmware for this driver at the
>> linux-firmware tree:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/log/
Tiffany. Can you check the license and add the firmware to linux-firmware?

For the information, both encoder and decoder drivers require the
firmware to work.
>>
>> Nor I'm seeing any pull request for them. Did you send it?
>> I'll only merge the driver upstream after seeing such pull request.
>
>
> Mauro, are you confusing the decoder and encoder driver? I haven't
> thoroughly reviewed the decoder driver
> yet, so there is no pull request for the decoder driver.
>
> The only pull request I made was for the encoder driver.
>
> Regards,
>
>         Hans
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
