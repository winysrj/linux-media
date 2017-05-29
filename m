Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35937 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdE2JHU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 05:07:20 -0400
Received: by mail-qk0-f180.google.com with SMTP id u75so43804430qka.3
        for <linux-media@vger.kernel.org>; Mon, 29 May 2017 02:07:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5ef1d96d-dc5f-49b9-0650-51d086efc226@xs4all.nl>
References: <1496046855-5809-1-git-send-email-benjamin.gaignard@linaro.org> <5ef1d96d-dc5f-49b9-0650-51d086efc226@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Mon, 29 May 2017 11:07:19 +0200
Message-ID: <CA+M3ks5gdzAGx9suKnz-=4Aw5DiigLGFjOA5xqunzDEL8MmPBg@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] cec: STM32 driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Yannick Fertre <yannick.fertre@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        devicetree@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-05-29 10:54 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Benjamin,
>
> On 05/29/2017 10:34 AM, Benjamin Gaignard wrote:
>>
>> version 4:
>> - rebased on Hans cec-config branch
>> - rework bindings commit message
>> - add notifier support
>
>
> I really don't like this change. This forced me to think about this a bit
> more,
> and I think this requires another change as well.
>
> The problem you have is that the drm driver for this platform isn't ready
> yet,
> so this CEC driver needs userspace to provide a physical address since it
> can't
> use a notifier.
>
> Trying to support both is a bad idea since this runs the risk that we will
> forget
> to remove the CAP_PHYS_ADDR path later.

I would like stm32 cec driver to be able to work with or without
notifier support.
stm32 are small platforms and not everybody will use hdmi because of memory
consomption but cec can be used anyway.

>
> Instead, just drop the notifier support. And move this driver to staging,
> just
> as we did with the st-cec driver. Once the drm driver arrives this cec
> driver
> can switch to using the notifier and be moved out of staging.
>
> Add a TODO file explaining that this is waiting for the drm driver so the
> CEC_CAP_PHYS_ADDR capability can be removed after switching to using
> CEC_NOTIFIER.
>
> I should have realized this when reviewing v2, sorry about that.
>
> The reason why I don't want CEC drivers using CEC_CAP_PHYS_ADDR in mainline
> (except
> if it is obviously required such as for the usb CEC dongles) is that it puts
> a
> major burden on the application to discover the physical address from the
> EDID. It
> should only be used if there is no other way. In this case this is just a
> temporary situation, so staging is the right place.
>
> BTW, if the stm32 drm driver is going to be accepted for 4.13, then that
> would
> change things, but I don't think that's the case.
>
> Regards,
>
>         Hans
>
>
>> - update KConfig
>>
>> version 2:
>> - fix typo in compagnie name
>> - add yannick sign-off
>> - use cec_message instead of custom struct in cec device
>> - add monitor mode
>>
>> I don't change the split between irq handler and irq thread because
>> it would had mean to handle all errors cases irq handler to keep
>> a correct sequence. I don't think it is critical as it is since cec is a
>> very
>> slow protocol.
>>
>> This serie of patches add cec driver for STM32 platforms.
>>
>> This code doesn't implement cec notifier because STM32 doesn't
>> provide HDMI yet but it will be added later.
>>
>> Those patches have been developped on top of media_tree master branch
>> where STM32 DCMI code has not been merged so conflict in Kconfig and
>> Makefile
>> could occur depending of merge ordering.
>>
>> Compliance has been tested on STM32F769.
>>
>> ~ # cec-ctl -p 1.0.0.0 --playback
>> Driver Info:
>>          Driver Name                : stm32-cec
>>          Adapter Name               : stm32-cec
>>          Capabilities               : 0x0000000f
>>                  Physical Address
>>                  Logical Addresses
>>                  Transmit
>>                  Passthrough
>>          Driver version             : 4.11.0
>>          Available Logical Addresses: 1
>>          Physical Address           : 1.0.0.0
>>          Logical Address Mask       : 0x0010
>>          CEC Version                : 2.0
>>          Vendor ID                  : 0x000c03 (HDMI)
>>          OSD Name                   : 'Playback'
>>          Logical Addresses          : 1 (Allow RC Passthrough)
>>
>>            Logical Address          : 4 (Playback Device 1)
>>              Primary Device Type    : Playback
>>              Logical Address Type   : Playback
>>              All Device Types       : Playback
>>              RC TV Profile          : None
>>              Device Features        :
>>                  None
>>
>> ~ # cec-compliance -A
>> cec-compliance SHA                 :
>> 6acac5cec698de39b9398b66c4f5f4db6b2730d8
>>
>> Driver Info:
>>          Driver Name                : stm32-cec
>>          Adapter Name               : stm32-cec
>>          Capabilities               : 0x0000000f
>>                  Physical Address
>>                  Logical Addresses
>>                  Transmit
>>                  Passthrough
>>          Driver version             : 4.11.0
>>          Available Logical Addresses: 1
>>          Physical Address           : 1.0.0.0
>>          Logical Address Mask       : 0x0010
>>          CEC Version                : 2.0
>>          Vendor ID                  : 0x000c03
>>          Logical Addresses          : 1 (Allow RC Passthrough)
>>
>>            Logical Address          : 4
>>              Primary Device Type    : Playback
>>              Logical Address Type   : Playback
>>              All Device Types       : Playback
>>              RC TV Profile          : None
>>              Device Features        :
>>                  None
>>
>> Compliance test for device /dev/cec0:
>>
>>      The test results mean the following:
>>          OK                  Supported correctly by the device.
>>          OK (Not Supported)  Not supported and not mandatory for the
>> device.
>>          OK (Presumed)       Presumably supported.  Manually check to
>> confirm.
>>          OK (Unexpected)     Supported correctly but is not expected to be
>> supported for this device.
>>          OK (Refused)        Supported by the device, but was refused.
>>          FAIL                Failed and was expected to be supported by
>> this device.
>>
>> Find remote devices:
>>          Polling: OK
>>
>> CEC API:
>>          CEC_ADAP_G_CAPS: OK
>>          CEC_DQEVENT: OK
>>          CEC_ADAP_G/S_PHYS_ADDR: OK
>>          CEC_ADAP_G/S_LOG_ADDRS: OK
>>          CEC_TRANSMIT: OK
>>          CEC_RECEIVE: OK
>>          CEC_TRANSMIT/RECEIVE (non-blocking): OK (Presumed)
>>          CEC_G/S_MODE: OK
>>          CEC_EVENT_LOST_MSGS: OK
>>
>> Network topology:
>>          System Information for device 0 (TV) from device 4 (Playback
>> Device 1):
>>                  CEC Version                : 1.4
>>                  Physical Address           : 0.0.0.0
>>                  Primary Device Type        : TV
>>                  Vendor ID                  : 0x00903e
>>                  OSD Name                   : 'TV'
>>                  Menu Language              : fre
>>                  Power Status               : On
>>
>> Total: 10, Succeeded: 10, Failed: 0, Warnings: 0
>>
>>
>> Benjamin Gaignard (2):
>>    dt-bindings: media: stm32 cec driver
>>    cec: add STM32 cec driver
>>
>>   .../devicetree/bindings/media/st,stm32-cec.txt     |  22 ++
>>   drivers/media/platform/Kconfig                     |  13 +
>>   drivers/media/platform/Makefile                    |   2 +
>>   drivers/media/platform/stm32/Makefile              |   1 +
>>   drivers/media/platform/stm32/stm32-cec.c           | 392
>> +++++++++++++++++++++
>>   5 files changed, 430 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/media/st,stm32-cec.txt
>>   create mode 100644 drivers/media/platform/stm32/Makefile
>>   create mode 100644 drivers/media/platform/stm32/stm32-cec.c
>>
>
