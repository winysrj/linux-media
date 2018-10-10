Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:55389 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726600AbeJJVH4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 17:07:56 -0400
Subject: Re: [PATCH v2 0/2] Add SECO Boards CEC device driver
To: ektor5 <ek5.chimenti@gmail.com>
Cc: luca.pisani@udoo.org, linux-media@vger.kernel.org
References: <cover.1538474121.git.ek5.chimenti@gmail.com>
 <cover.1538760098.git.ek5.chimenti@gmail.com>
 <bdec2327-8c19-8ffb-9862-6df2e6e697c7@xs4all.nl>
 <20181010120928.cx6mlwigrl4zim2c@Ettosoft-T55>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d1027940-5c27-650e-3250-8d75cf496f84@xs4all.nl>
Date: Wed, 10 Oct 2018 15:45:35 +0200
MIME-Version: 1.0
In-Reply-To: <20181010120928.cx6mlwigrl4zim2c@Ettosoft-T55>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/10/18 14:09, ektor5 wrote:
> Hi Hans,
> 
> On Sat, Oct 06, 2018 at 11:54:38AM +0200, Hans Verkuil wrote:
>> Hi Ettore,
>>
>> On 10/05/2018 07:33 PM, ektor5 wrote:
>>> This series of patches aims to add CEC functionalities to SECO
>>> devices, in particular UDOO X86.
>>>
>>> The communication is achieved via Braswell SMBus (i2c-i801) to the
>>> onboard STM32 microcontroller that handles the CEC signals. The driver
>>> use direct access to the PCI addresses, due to the limitations of the
>>> specific driver in presence of ACPI calls.
>>>
>>> The basic functionalities are tested with success with cec-ctl and
>>> cec-compliance.
>>
>> This series looks good to me. But can you do one more test:
>>
>> Update your kernel to the latest media_tree master and also update your
>> v4l-utils repo to the latest master code.
>>
>> With all that in place please run:
>>
>> cec-compliance -A
>>
>> (have the HDMI output connected to a CEC-capable TV when running this test).
>>
>> Please report back the output of cec-compliance.
>>
>> A bunch of CEC bug fixes and improvements were merged yesterday, and the
>> cec-compliance adapter test is improved to check for issues that were hard
>> to find in the past.
>>
>> So it will be good to have a final check of this driver.
> 
> Here it is, compiled media-tree and latest v4l-utils:
> 
> udoo@udoo-UDOO-x86:~/v4l-utils/utils/cec-compliance$ uname -a
> Linux udoo-UDOO-x86 4.19.0-041900rc7-generic #201810071631+cec SMP Tue Oct 9 17:36:11 CEST 2018 x86_64 x86_64 x86_64 GNU/Linux
> udoo@udoo-UDOO-x86:~/v4l-utils/utils/cec-compliance$ ./cec-compliance -A
> cec-compliance SHA                 : 06ad469e966aafaf39c1cc76e6e0953ec7d4f9c9
> Driver Info:
> 	Driver Name                : secocec
> 	Adapter Name               : CEC00001:00
> 	Capabilities               : 0x0000000e
> 		Logical Addresses
> 		Transmit
> 		Passthrough
> 	Driver version             : 4.19.0
> 	Available Logical Addresses: 1
> 	Physical Address           : 3.0.0.0
> 	Logical Address Mask       : 0x0010
> 	CEC Version                : 2.0
> 	Vendor ID                  : 0x000c03 (HDMI)
> 	OSD Name                   : Playback
> 	Logical Addresses          : 1 
> 
> 	  Logical Address          : 4 (Playback Device 1)
> 	    Primary Device Type    : Playback
> 	    Logical Address Type   : Playback
> 	    All Device Types       : Playback
> 	    RC TV Profile          : None
> 	    Device Features        :
> 		None
> 
> Compliance test for device /dev/cec0:
> 
>     The test results mean the following:
>         OK                  Supported correctly by the device.
>         OK (Not Supported)  Not supported and not mandatory for the device.
>         OK (Presumed)       Presumably supported.  Manually check to confirm.
>         OK (Unexpected)     Supported correctly but is not expected to be supported for this device.
>         OK (Refused)        Supported by the device, but was refused.
>         FAIL                Failed and was expected to be supported by this device.
> 
> Find remote devices:
> 	Polling: OK
> 
> CEC API:
> 	CEC_ADAP_G_CAPS: OK
> 	CEC_DQEVENT: OK
> 	CEC_ADAP_G/S_PHYS_ADDR: OK
> 	CEC_ADAP_G/S_LOG_ADDRS: OK
> 	CEC_TRANSMIT: OK
> 	CEC_RECEIVE: OK
> 	CEC_TRANSMIT/RECEIVE (non-blocking): OK (Presumed)
> 	CEC_G/S_MODE: OK
> 		fail: cec-test-adapter.cpp(1042): There were 142 pending messages for 83 transmitted messages

That's not good.

If you look in the kernel log, do you see 'timed out' cec messages?

Note: that message is a warning since commit 7ec2b3b941a666a942859684281b5f6460a0c234.
Before that you first need to enable debugging:

echo 1 >/sys/module/cec/parameters/debug

My guess is that this might be a fw bug. Does the firmware handle Signal Free Time
correctly? My guess is that it doesn't do that and that this test causes what is
effectively a 'denial of service' situation: the transmitter gets blocked waiting
for sufficient signal free time.

I have updated cec-compliance to give better information about what was received,
so can you update cec-compliance and run again?

Also, run 'cec-ctl -m >cec.log' at the same time and mail me that log.

There are two types of CEC adapters: those that handle retransmits automatically
(and they determine the Signal Free Time themselves) and those that don't do
automatic retransmits, and there you normally need to program the Signal Free Time
before starting the transmit.

This driver falls in the second category, but the SFT isn't set anywhere.

This particular adapter test actually tests this, and I have seen this
symptom before if the SFT wasn't set correctly.

Regards,

	Hans

> 	CEC_EVENT_LOST_MSGS: FAIL
> 
> Network topology:
> 	System Information for device 0 (TV) from device 4 (Playback Device 1):
> 		CEC Version                : 1.4
> 		Physical Address           : 0.0.0.0
> 		Primary Device Type        : TV
> 		Vendor ID                  : 0x00e091
> 		OSD Name                   : Tx, OK, Rx, Timeout
> 		Menu Language              : kor
> 		Power Status               : On
> 
> Total: 10, Succeeded: 9, Failed: 1, Warnings: 0
> 
> Thanks,
> 	Ettore
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> v2:
>>>  - Removed useless debug prints
>>>  - Added DMI && PCI to dependences
>>>  - Removed useless ifdefs
>>>  - Renamed all irda references to ir
>>>  - Fixed SPDX clause
>>>  - Several style fixes
>>>
>>> Ettore Chimenti (2):
>>>   media: add SECO cec driver
>>>   seco-cec: add Consumer-IR support
>>>
>>>  MAINTAINERS                                |   6 +
>>>  drivers/media/platform/Kconfig             |  22 +
>>>  drivers/media/platform/Makefile            |   2 +
>>>  drivers/media/platform/seco-cec/Makefile   |   1 +
>>>  drivers/media/platform/seco-cec/seco-cec.c | 829 +++++++++++++++++++++
>>>  drivers/media/platform/seco-cec/seco-cec.h | 141 ++++
>>>  6 files changed, 1001 insertions(+)
>>>  create mode 100644 drivers/media/platform/seco-cec/Makefile
>>>  create mode 100644 drivers/media/platform/seco-cec/seco-cec.c
>>>  create mode 100644 drivers/media/platform/seco-cec/seco-cec.h
>>>
>>
