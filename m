Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:51062 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752199AbdHJI4t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 04:56:49 -0400
Subject: Re: [PATCH 0/4] drm/bridge/adv7511: add CEC support
To: Archit Taneja <architt@codeaurora.org>
References: <20170730130743.19681-1-hverkuil@xs4all.nl>
 <9d1757b3-24f9-2f0f-1971-62d1ef4b79e3@codeaurora.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fa41b1e5-7319-c7f8-32e9-36c291d85a0f@xs4all.nl>
Date: Thu, 10 Aug 2017 10:56:46 +0200
MIME-Version: 1.0
In-Reply-To: <9d1757b3-24f9-2f0f-1971-62d1ef4b79e3@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/08/17 10:49, Archit Taneja wrote:
> Hi Hans,
> 
> On 07/30/2017 06:37 PM, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch series adds CEC support to the drm adv7511/adv7533 drivers.
>>
>> I have tested this with the Qualcomm Dragonboard C410 (adv7533 based)
>> and the Renesas R-Car Koelsch board (adv7511 based).
>>
>> Note: the Dragonboard needs this patch:
>>
>> https://patchwork.kernel.org/patch/9824773/
>>
>> Archit, can you confirm that this patch will go to kernel 4.14?
>>
>> And the Koelsch board needs this 4.13 fix:
>>
>> https://patchwork.kernel.org/patch/9836865/
>>
>> I only have the Koelsch board to test with, but it looks like other
>> R-Car boards use the same adv7511. It would be nice if someone can
>> add CEC support to the other R-Car boards as well. The main thing
>> to check is if they all use the same 12 MHz fixed CEC clock source.
>>
>> Anyone who wants to test this will need the CEC utilities that
>> are part of the v4l-utils git repository:
>>
>> git clone git://linuxtv.org/v4l-utils.git
>> cd v4l-utils
>> ./bootstrap.sh
>> ./configure
>> make
>> sudo make install
>>
>> Now configure the CEC adapter as a Playback device:
>>
>> cec-ctl --playback
>>
>> Discover other CEC devices:
>>
>> cec-ctl -S
> 
> I tried the instructions, and I get the following output. I don't think I have
> any CEC device connected, though. Is this the expected behaviour?
> 
> #cec-ctl -S
> Driver Info:
>         Driver Name                : adv7511
>         Adapter Name               : 3-0039
>         Capabilities               : 0x0000000e
>                 Logical Addresses
>                 Transmit
>                 Passthrough
>         Driver version             : 4.13.0
>         Available Logical Addresses: 3
>         Physical Address           : 1.0.0.0
>         Logical Address Mask       : 0x0000
>         CEC Version                : 2.0
>         Logical Addresses          : 0
> 
> #cec-ctl --playback
> [ 1038.761545] cec-3-0039: cec_thread_func: message 44 timed out!

This isn't right. You shouldn't see this. It never receives an interrupt
when the transmit has finished, which causes these time outs.

What are you testing this on? The Dragonboard c410?

Can you check the cec clock frequency? It should be 19.2 MHz.
Remember to apply this patch: https://patchwork.kernel.org/patch/9824773/
You probably did, but just in case...

Regards,

	Hans

> Driver Info:
>         Driver Name                : adv7511
>         Adapter Name               : 3-0039
>         Capabilities               : 0x0000000e
>                 Logical Addresses
>                 Transmit
>                 Passthrough
>         Driver version             : 4.13.0
>         Available Logical Addresses: 3
>         Physical Address           : 1.0.0.0
>         Logical Address Mask       : 0x0010
>         CEC Version                : 2.0
>         Vendor ID                  : 0x000c03
>         Logical Addresses          : 1 (Allow RC Passthrough)
> 
>           Logical Address          : 4
>             Primary Device Type    : Playback
>             Logical Address Type   : Playback
>             All Device Types       : Playback
>             RC TV Profile          : None
>             Device Features        :
>                 None
> 
> 
> [ 1041.063605] cec-3-0039: cec_thread_func: message 4f a6 06 10 00 00 timed out!
> [ 1043.367482] cec-3-0039: cec_thread_func: message 4f 84 10 00 04 timed out!
> 
> Thanks,
> Archit
> 
>>
>> Regards,
>>
>>     Hans
>>
>> Hans Verkuil (4):
>>    dt-bindings: adi,adv7511.txt: document cec clock
>>    arm: dts: qcom: add cec clock for apq8016 board
>>    arm: dts: renesas: add cec clock for Koelsch board
>>    drm: adv7511/33: add HDMI CEC support
>>
>>   .../bindings/display/bridge/adi,adv7511.txt        |   4 +
>>   arch/arm/boot/dts/r8a7791-koelsch.dts              |   8 +
>>   arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi          |   2 +
>>   drivers/gpu/drm/bridge/adv7511/Kconfig             |   8 +
>>   drivers/gpu/drm/bridge/adv7511/Makefile            |   1 +
>>   drivers/gpu/drm/bridge/adv7511/adv7511.h           |  45 ++-
>>   drivers/gpu/drm/bridge/adv7511/adv7511_cec.c       | 314 +++++++++++++++++++++
>>   drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 152 +++++++++-
>>   drivers/gpu/drm/bridge/adv7511/adv7533.c           |  30 +-
>>   9 files changed, 514 insertions(+), 50 deletions(-)
>>   create mode 100644 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
>>
> 
