Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35639 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdE2Jid (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 05:38:33 -0400
Received: by mail-wm0-f48.google.com with SMTP id b84so48582987wmh.0
        for <linux-media@vger.kernel.org>; Mon, 29 May 2017 02:38:32 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: yannick.fertre@st.com, alexandre.torgue@st.com, hverkuil@xs4all.nl,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        robh@kernel.org, hans.verkuil@cisco.com
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v5 0/2] cec: STM32 driver
Date: Mon, 29 May 2017 11:38:03 +0200
Message-Id: <1496050685-14301-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

version 5:
- remove cec notifier (to be added for drm driver release)

version 4:
- rebased on Hans cec-config branch
- rework bindings commit message
- add notifier support
- update KConfig

version 2:
- fix typo in compagnie name
- add yannick sign-off
- use cec_message instead of custom struct in cec device
- add monitor mode

I don't change the split between irq handler and irq thread because
it would had mean to handle all errors cases irq handler to keep
a correct sequence. I don't think it is critical as it is since cec is a very
slow protocol.

This serie of patches add cec driver for STM32 platforms.

This code doesn't implement cec notifier because STM32 doesn't
provide HDMI yet but it will be added later.

Those patches have been developped on top of media_tree master branch
where STM32 DCMI code has not been merged so conflict in Kconfig and Makefile
could occur depending of merge ordering.

Compliance has been tested on STM32F769.

~ # cec-ctl -p 1.0.0.0 --playback 
Driver Info:
        Driver Name                : stm32-cec
        Adapter Name               : stm32-cec
        Capabilities               : 0x0000000f
                Physical Address
                Logical Addresses
                Transmit
                Passthrough
        Driver version             : 4.11.0
        Available Logical Addresses: 1
        Physical Address           : 1.0.0.0
        Logical Address Mask       : 0x0010
        CEC Version                : 2.0
        Vendor ID                  : 0x000c03 (HDMI)
        OSD Name                   : 'Playback'
        Logical Addresses          : 1 (Allow RC Passthrough)

          Logical Address          : 4 (Playback Device 1)
            Primary Device Type    : Playback
            Logical Address Type   : Playback
            All Device Types       : Playback
            RC TV Profile          : None
            Device Features        :
                None

~ # cec-compliance -A 
cec-compliance SHA                 : 6acac5cec698de39b9398b66c4f5f4db6b2730d8

Driver Info:
        Driver Name                : stm32-cec
        Adapter Name               : stm32-cec
        Capabilities               : 0x0000000f
                Physical Address
                Logical Addresses
                Transmit
                Passthrough
        Driver version             : 4.11.0
        Available Logical Addresses: 1
        Physical Address           : 1.0.0.0
        Logical Address Mask       : 0x0010
        CEC Version                : 2.0
        Vendor ID                  : 0x000c03
        Logical Addresses          : 1 (Allow RC Passthrough)

          Logical Address          : 4
            Primary Device Type    : Playback
            Logical Address Type   : Playback
            All Device Types       : Playback
            RC TV Profile          : None
            Device Features        :
                None

Compliance test for device /dev/cec0:

    The test results mean the following:
        OK                  Supported correctly by the device.
        OK (Not Supported)  Not supported and not mandatory for the device.
        OK (Presumed)       Presumably supported.  Manually check to confirm.
        OK (Unexpected)     Supported correctly but is not expected to be supported for this device.
        OK (Refused)        Supported by the device, but was refused.
        FAIL                Failed and was expected to be supported by this device.

Find remote devices:
        Polling: OK

CEC API:
        CEC_ADAP_G_CAPS: OK
        CEC_DQEVENT: OK
        CEC_ADAP_G/S_PHYS_ADDR: OK
        CEC_ADAP_G/S_LOG_ADDRS: OK
        CEC_TRANSMIT: OK
        CEC_RECEIVE: OK
        CEC_TRANSMIT/RECEIVE (non-blocking): OK (Presumed)
        CEC_G/S_MODE: OK
        CEC_EVENT_LOST_MSGS: OK

Network topology:
        System Information for device 0 (TV) from device 4 (Playback Device 1):
                CEC Version                : 1.4
                Physical Address           : 0.0.0.0
                Primary Device Type        : TV
                Vendor ID                  : 0x00903e
                OSD Name                   : 'TV'
                Menu Language              : fre
                Power Status               : On

Total: 10, Succeeded: 10, Failed: 0, Warnings: 0

Benjamin Gaignard (2):
  dt-bindings: media: stm32 cec driver
  cec: add STM32 cec driver

 .../devicetree/bindings/media/st,stm32-cec.txt     |  19 ++
 drivers/media/platform/Kconfig                     |  12 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/stm32/Makefile              |   1 +
 drivers/media/platform/stm32/stm32-cec.c           | 361 +++++++++++++++++++++
 5 files changed, 395 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,stm32-cec.txt
 create mode 100644 drivers/media/platform/stm32/Makefile
 create mode 100644 drivers/media/platform/stm32/stm32-cec.c

-- 
1.9.1
