Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35963 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbcINJXM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 05:23:12 -0400
Received: by mail-wm0-f50.google.com with SMTP id b187so36760609wme.1
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 02:23:11 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: kernel@stlinux.com, arnd@arndb.de, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 0/4] STIH CEC driver
Date: Wed, 14 Sep 2016 11:22:00 +0200
Message-Id: <1473844924-13895-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those patches implement HDMI CEC driver for stih4xx SoCs.
I have used media_tree/fixes and the lastest v4l-utils branch.

The compliance tools have been run with the following sequence:
cec-ctl --tuner -p 1.0.0.0
cec-compliance -A
and cec-follower running in a separate shell

Compliance logs:
cec-ctl --tuner -p 1.0.0.0 
Driver Info:
	Driver Name                : stih-cec
	Adapter Name               : stih-cec
	Capabilities               : 0x0000000f
		Physical Address
		Logical Addresses
		Transmit
		Passthrough
	Driver version             : 4.8.0
	Available Logical Addresses: 1
	Physical Address           : 1.0.0.0
	Logical Address Mask       : 0x0008
	CEC Version                : 2.0
	Vendor ID                  : 0x000c03
	OSD Name                   : 'Tuner'
	Logical Addresses          : 1

	  Logical Address          : 3 (Tuner 1)
	    Primary Device Type    : Tuner
	    Logical Address Type   : Tuner
	    All Device Types       : Tuner
	    RC TV Profile          : None
	    Device Features        :
		None

cec-compliance -A 
cec-compliance SHA                 : 56075a41f9294b21aa6bd80dc5e94cbd2b44087a

Driver Info:
	Driver Name                : stih-cec
	Adapter Name               : stih-cec
	Capabilities               : 0x0000000f
		Physical Address
		Logical Addresses
		Transmit
		Passthrough
	Driver version             : 4.8.0
	Available Logical Addresses: 1
	Physical Address           : 1.0.0.0
	Logical Address Mask       : 0x0008
	CEC Version                : 2.0
	Vendor ID                  : 0x000c03
	Logical Addresses          : 1

	  Logical Address          : 3
	    Primary Device Type    : Tuner
	    Logical Address Type   : Tuner
	    All Device Types       : Tuner
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
	System Information for device 0 (TV) from device 3 (Tuner 1):
		CEC Version                : 1.4
		Physical Address           : Tx, OK, Not Acknowledged (1), Rx, Timeout
		Vendor ID                  : 0x00903e
		OSD Name                   : 'TV'
		Menu Language              : fre
		Power Status               : On

Total: 10, Succeeded: 10, Failed: 0, Warnings: 0

cec-follower 
cec-follower SHA                   : 56075a41f9294b21aa6bd80dc5e94cbd2b44087a

Driver Info:
	Driver Name                : stih-cec
	Adapter Name               : stih-cec
	Capabilities               : 0x0000000f
		Physical Address
		Logical Addresses
		Transmit
		Passthrough
	Driver version             : 4.8.0
	Available Logical Addresses: 1
	Physical Address           : 1.0.0.0
	Logical Address Mask       : 0x0008
	CEC Version                : 2.0
	Vendor ID                  : 0x000c03
	Logical Addresses          : 1

	  Logical Address          : 3
	    Primary Device Type    : Tuner
	    Logical Address Type   : Tuner
	    All Device Types       : Tuner
	    RC TV Profile          : None
	    Device Features        :
		None

Initial Event: State Change: PA: 1.0.0.0, LA mask: 0x0008
Event: State Change: PA: 1.0.0.0, LA mask: 0x0000
Event: State Change: PA: 1.0.0.0, LA mask: 0x4000
Event: State Change: PA: 1.0.0.0, LA mask: 0x0000
Event: State Change: PA: 1.0.0.0, LA mask: 0x4000
Event: State Change: PA: 1.0.0.0, LA mask: 0x0000
Event: State Change: PA: 1.0.0.0, LA mask: 0x0008

Benjamin Gaignard (4):
  bindings for stih-cec driver
  add stih-cec driver
  add stih-cec driver into DT
  add maintainer for stih-cec driver

 .../devicetree/bindings/media/stih-cec.txt         |  25 ++
 MAINTAINERS                                        |   7 +
 arch/arm/boot/dts/stih410.dtsi                     |  12 +
 drivers/staging/media/Kconfig                      |   2 +
 drivers/staging/media/Makefile                     |   1 +
 drivers/staging/media/st-cec/Kconfig               |   8 +
 drivers/staging/media/st-cec/Makefile              |   1 +
 drivers/staging/media/st-cec/stih-cec.c            | 377 +++++++++++++++++++++
 8 files changed, 433 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/stih-cec.txt
 create mode 100644 drivers/staging/media/st-cec/Kconfig
 create mode 100644 drivers/staging/media/st-cec/Makefile
 create mode 100644 drivers/staging/media/st-cec/stih-cec.c

-- 
1.9.1

