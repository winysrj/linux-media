Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:32981 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbaKJLGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 06:06:34 -0500
Message-ID: <54609C32.9040104@xs4all.nl>
Date: Mon, 10 Nov 2014 12:06:26 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sebastian Reichel <sre@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
CC: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFCv2 0/8] [media] si4713 DT binding
References: <1413904027-16767-1-git-send-email-sre@kernel.org> <545CBFE6.3070201@xs4all.nl>
In-Reply-To: <545CBFE6.3070201@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

I've tested the whole 8-part patch series with my si4713 USB dev board, and it
is working fine.

I've accepted patches 1-4. The others need to be reposted since patch 5 had a
change request.

Regards,

	Hans

On 11/07/2014 01:49 PM, Hans Verkuil wrote:
> On 10/21/14 17:06, Sebastian Reichel wrote:
>> Hi,
>>
>> This is the RFCv2 patchset adding DT support to the si4713
>> radio transmitter i2c driver. The changes can be summarized
>> as follows:
>>
>>  * Move regulator information back into the driver. The
>>    regulators needed are documented in the chip and have
>>    nothing to do with boarddata. Instead devm_regulator_get_optional
>>    is used and errors are handled quite loosely now. Maybe the USB
>>    driver should provide dummy regulators.
>>  * GPIO handling is updated to gpiod consumer interface, resulting
>>    in a driver cleanup and easy DT handling
>>  * The driver is updated to use managed resources wherever possible
>>
>> So much about the nice stuff. But there is also
>>
>>  * Instantiation of the platform device from the i2c (sub-)device. Since DT
>>    is not supposed to contain linuxisms the device is a simple i2c node
>>    resulting in the i2c probe function being called. Thus registering the main
>>    v4l device must happen from there.
>>
>> Tested:
>>  * Compilation on torvalds/linux.git:master (based on 52d589a)
>>  * Booting in DT mode
>>  * Some simply driver queries using v4l2-ctl
>>
>> Not tested:
>>  * The USB driver, since I do not own the USB dongle
> 
> I will test this on Monday for the USB device. It looks good, but I need
> to verify that it doesn't break the USB driver.
> 
> Regards,
> 
> 	Hans
> 
>>  * The legacy platform code (only DT boot has been tested).
>>    (The legacy platform code is supposed to removed in the near future anyways)
>>
>> Changes since RFCv1 (requested by Hans Verkuil):
>>  - splitted the patchset into more patches
>>  - replaced dev_info with dev_dbg for missing regulators
>>  - check for ENOSYS value from devm_gpiod_get (disabled GPIOLIB)
>>
>> -- Sebastian
>>
>> Sebastian Reichel (8):
>>   [media] si4713: switch to devm regulator API
>>   [media] si4713: switch reset gpio to devm_gpiod API
>>   [media] si4713: use managed memory allocation
>>   [media] si4713: use managed irq request
>>   [media] si4713: add device tree support
>>   [media] si4713: add DT binding documentation
>>   ARM: OMAP2: RX-51: update si4713 platform data
>>   [media] si4713: cleanup platform data
>>
>>  Documentation/devicetree/bindings/media/si4713.txt |  30 ++++
>>  arch/arm/mach-omap2/board-rx51-peripherals.c       |  69 ++++-----
>>  drivers/media/radio/si4713/radio-platform-si4713.c |  28 +---
>>  drivers/media/radio/si4713/si4713.c                | 167 +++++++++++++--------
>>  drivers/media/radio/si4713/si4713.h                |  15 +-
>>  include/media/radio-si4713.h                       |  30 ----
>>  include/media/si4713.h                             |   4 +-
>>  7 files changed, 186 insertions(+), 157 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/si4713.txt
>>  delete mode 100644 include/media/radio-si4713.h
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

