Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35280 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdEPJYq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 05:24:46 -0400
Received: by mail-qk0-f177.google.com with SMTP id a72so121919679qkj.2
        for <linux-media@vger.kernel.org>; Tue, 16 May 2017 02:24:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f0eb8619-e2e3-f5db-bffd-0a51580e725c@xs4all.nl>
References: <1494925280-4527-1-git-send-email-benjamin.gaignard@linaro.org>
 <CA+M3ks6eO7144jNyBQZQfQ=ANwgxQjKKCY03iBnQB4mik6uFMQ@mail.gmail.com> <f0eb8619-e2e3-f5db-bffd-0a51580e725c@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Tue, 16 May 2017 11:24:40 +0200
Message-ID: <CA+M3ks6Ak906eTANudnS9yhOya=JV25wP8_2wMNixJnrp5axCA@mail.gmail.com>
Subject: Re: [PATCH 0/2] cec: STM32 driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alexandre Torgue <alexandre.torgue@st.com>,
        devicetree@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Yannick Fertre <yannick.fertre@st.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-05-16 11:18 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 16/05/17 11:10, Benjamin Gaignard wrote:
>> + Yannick who is the original writer of this driver (sorry)
>>
>> 2017-05-16 11:01 GMT+02:00 Benjamin Gaignard <benjamin.gaignard@linaro.o=
rg>:
>>> This serie of patches add cec driver for STM32 platforms.
>>>
>>> This code doesn't implement cec notifier because STM32 doesn't
>>> provide HDMI yet but it will be added later.
>
> When will that happen? Is that in 4.12?

We have send the patches yesterday for DSI support to dri-devel mailing lis=
t.
I guess the discussions will take some time but cec hardware could
work without it.

>
> Regards,
>
>         Hans
>
>>>
>>> Those patches have been developped on top of media_tree master branch
>>> where STM32 DCMI code has not been merged so conflict in Kconfig and Ma=
kefile
>>> could occur depending of merge ordering.
>>>
>>> Compliance has been tested on STM32F769.
>>>
>>> ~ # cec-ctl -p 1.0.0.0 --playback
>>> Driver Info:
>>>         Driver Name                : stm32-cec
>>>         Adapter Name               : stm32-cec
>>>         Capabilities               : 0x0000000f
>>>                 Physical Address
>>>                 Logical Addresses
>>>                 Transmit
>>>                 Passthrough
>>>         Driver version             : 4.11.0
>>>         Available Logical Addresses: 1
>>>         Physical Address           : 1.0.0.0
>>>         Logical Address Mask       : 0x0010
>>>         CEC Version                : 2.0
>>>         Vendor ID                  : 0x000c03 (HDMI)
>>>         OSD Name                   : 'Playback'
>>>         Logical Addresses          : 1 (Allow RC Passthrough)
>>>
>>>           Logical Address          : 4 (Playback Device 1)
>>>             Primary Device Type    : Playback
>>>             Logical Address Type   : Playback
>>>             All Device Types       : Playback
>>>             RC TV Profile          : None
>>>             Device Features        :
>>>                 None
>>>
>>> ~ # cec-compliance -A
>>> cec-compliance SHA                 : 6acac5cec698de39b9398b66c4f5f4db6b=
2730d8
>>>
>>> Driver Info:
>>>         Driver Name                : stm32-cec
>>>         Adapter Name               : stm32-cec
>>>         Capabilities               : 0x0000000f
>>>                 Physical Address
>>>                 Logical Addresses
>>>                 Transmit
>>>                 Passthrough
>>>         Driver version             : 4.11.0
>>>         Available Logical Addresses: 1
>>>         Physical Address           : 1.0.0.0
>>>         Logical Address Mask       : 0x0010
>>>         CEC Version                : 2.0
>>>         Vendor ID                  : 0x000c03
>>>         Logical Addresses          : 1 (Allow RC Passthrough)
>>>
>>>           Logical Address          : 4
>>>             Primary Device Type    : Playback
>>>             Logical Address Type   : Playback
>>>             All Device Types       : Playback
>>>             RC TV Profile          : None
>>>             Device Features        :
>>>                 None
>>>
>>> Compliance test for device /dev/cec0:
>>>
>>>     The test results mean the following:
>>>         OK                  Supported correctly by the device.
>>>         OK (Not Supported)  Not supported and not mandatory for the dev=
ice.
>>>         OK (Presumed)       Presumably supported.  Manually check to co=
nfirm.
>>>         OK (Unexpected)     Supported correctly but is not expected to =
be supported for this device.
>>>         OK (Refused)        Supported by the device, but was refused.
>>>         FAIL                Failed and was expected to be supported by =
this device.
>>>
>>> Find remote devices:
>>>         Polling: OK
>>>
>>> CEC API:
>>>         CEC_ADAP_G_CAPS: OK
>>>         CEC_DQEVENT: OK
>>>         CEC_ADAP_G/S_PHYS_ADDR: OK
>>>         CEC_ADAP_G/S_LOG_ADDRS: OK
>>>         CEC_TRANSMIT: OK
>>>         CEC_RECEIVE: OK
>>>         CEC_TRANSMIT/RECEIVE (non-blocking): OK (Presumed)
>>>         CEC_G/S_MODE: OK
>>>         CEC_EVENT_LOST_MSGS: OK
>>>
>>> Network topology:
>>>         System Information for device 0 (TV) from device 4 (Playback De=
vice 1):
>>>                 CEC Version                : 1.4
>>>                 Physical Address           : 0.0.0.0
>>>                 Primary Device Type        : TV
>>>                 Vendor ID                  : 0x00903e
>>>                 OSD Name                   : 'TV'
>>>                 Menu Language              : fre
>>>                 Power Status               : On
>>>
>>> Total: 10, Succeeded: 10, Failed: 0, Warnings: 0
>>>
>>> Benjamin Gaignard (2):
>>>   binding for stm32 cec driver
>>>   cec: add STM32 cec driver
>>>
>>>  .../devicetree/bindings/media/st,stm32-cec.txt     |  19 ++
>>>  drivers/media/platform/Kconfig                     |  11 +
>>>  drivers/media/platform/Makefile                    |   2 +
>>>  drivers/media/platform/stm32/Makefile              |   1 +
>>>  drivers/media/platform/stm32/stm32-cec.c           | 368 +++++++++++++=
++++++++
>>>  5 files changed, 401 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/st,stm32-ce=
c.txt
>>>  create mode 100644 drivers/media/platform/stm32/Makefile
>>>  create mode 100644 drivers/media/platform/stm32/stm32-cec.c
>>>
>>> --
>>> 1.9.1
>>>
>



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
