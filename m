Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55816 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751463AbdHJJvt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 05:51:49 -0400
Subject: Re: [PATCH 0/4] drm/bridge/adv7511: add CEC support
To: Archit Taneja <architt@codeaurora.org>
References: <20170730130743.19681-1-hverkuil@xs4all.nl>
 <9d1757b3-24f9-2f0f-1971-62d1ef4b79e3@codeaurora.org>
 <fa41b1e5-7319-c7f8-32e9-36c291d85a0f@xs4all.nl>
 <75a39db0-a5cc-9a20-2bbf-ebfc3573efca@codeaurora.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <319342e7-a07a-5cac-a5d2-f822c98630bd@xs4all.nl>
Date: Thu, 10 Aug 2017 11:51:46 +0200
MIME-Version: 1.0
In-Reply-To: <75a39db0-a5cc-9a20-2bbf-ebfc3573efca@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/17 11:08, Archit Taneja wrote:
> 
> 
> On 08/10/2017 02:26 PM, Hans Verkuil wrote:
>> On 10/08/17 10:49, Archit Taneja wrote:
>>> Hi Hans,
>>>
>>> On 07/30/2017 06:37 PM, Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> This patch series adds CEC support to the drm adv7511/adv7533 drivers.
>>>>
>>>> I have tested this with the Qualcomm Dragonboard C410 (adv7533 based)
>>>> and the Renesas R-Car Koelsch board (adv7511 based).
>>>>
>>>> Note: the Dragonboard needs this patch:
>>>>
>>>> https://patchwork.kernel.org/patch/9824773/
>>>>
>>>> Archit, can you confirm that this patch will go to kernel 4.14?
>>>>
>>>> And the Koelsch board needs this 4.13 fix:
>>>>
>>>> https://patchwork.kernel.org/patch/9836865/
>>>>
>>>> I only have the Koelsch board to test with, but it looks like other
>>>> R-Car boards use the same adv7511. It would be nice if someone can
>>>> add CEC support to the other R-Car boards as well. The main thing
>>>> to check is if they all use the same 12 MHz fixed CEC clock source.
>>>>
>>>> Anyone who wants to test this will need the CEC utilities that
>>>> are part of the v4l-utils git repository:
>>>>
>>>> git clone git://linuxtv.org/v4l-utils.git
>>>> cd v4l-utils
>>>> ./bootstrap.sh
>>>> ./configure
>>>> make
>>>> sudo make install
>>>>
>>>> Now configure the CEC adapter as a Playback device:
>>>>
>>>> cec-ctl --playback
>>>>
>>>> Discover other CEC devices:
>>>>
>>>> cec-ctl -S
>>>
>>> I tried the instructions, and I get the following output. I don't think I have
>>> any CEC device connected, though. Is this the expected behaviour?
>>>
>>> #cec-ctl -S
>>> Driver Info:
>>>          Driver Name                : adv7511
>>>          Adapter Name               : 3-0039
>>>          Capabilities               : 0x0000000e
>>>                  Logical Addresses
>>>                  Transmit
>>>                  Passthrough
>>>          Driver version             : 4.13.0
>>>          Available Logical Addresses: 3
>>>          Physical Address           : 1.0.0.0
>>>          Logical Address Mask       : 0x0000
>>>          CEC Version                : 2.0
>>>          Logical Addresses          : 0
>>>
>>> #cec-ctl --playback
>>> [ 1038.761545] cec-3-0039: cec_thread_func: message 44 timed out!
>>
>> This isn't right. You shouldn't see this. It never receives an interrupt
>> when the transmit has finished, which causes these time outs.
>>
>> What are you testing this on? The Dragonboard c410?
> 
> Yes.

On top of which kernel tree are these patches applied? I can try and reproduce
it.

Regards,

	Hans
