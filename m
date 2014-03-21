Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36371 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaCUI2C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 04:28:02 -0400
Message-id: <532BF80F.1080602@samsung.com>
Date: Fri, 21 Mar 2014 09:27:59 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	s.nawrocki@samsung.com, a.hajda@samsung.com,
	kyungmin.park@samsung.com, Bryan Wu <cooloney@gmail.com>
Subject: Re: [PATCH/RFC 1/8] leds: Add sysfs and kernel internal API for flash
 LEDs
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-2-git-send-email-j.anaszewski@samsung.com>
 <1395329301.27611.4.camel@ted>
In-reply-to: <1395329301.27611.4.camel@ted>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/20/2014 04:28 PM, Richard Purdie wrote:
> On Thu, 2014-03-20 at 15:51 +0100, Jacek Anaszewski wrote:
>> Some LED devices support two operation modes - torch and
>> flash. This patch provides support for flash LED devices
>> in the LED subsystem by introducing new sysfs attributes
>> and kernel internal interface. The attributes being
>> introduced are: flash_mode, flash_timeout, max_flash_timeout,
>> flash_fault and hw_triggered.
>> The modifications aim to be compatible with V4L2 framework
>> requirements related to the flash devices management. The
>> design assumes that V4L2 driver can take of the LED class
>> device control and communicate with it through the kernel
>> internal interface. The LED sysfs interface is made
>> unavailable then.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   drivers/leds/led-class.c    |  216 +++++++++++++++++++++++++++++++++++++++++--
>>   drivers/leds/led-core.c     |  124 +++++++++++++++++++++++--
>>   drivers/leds/led-triggers.c |   17 +++-
>>   drivers/leds/leds.h         |    9 ++
>>   include/linux/leds.h        |  136 +++++++++++++++++++++++++++
>>   5 files changed, 486 insertions(+), 16 deletions(-)
>
> It seems rather sad to have to insert that amount of code into the core
> LED files for something which only a small number of LEDs actually use.
> This will increase the footprint of the core LED code significantly.
>
> Is it not possible to add this as a module/extension to the LED core
> rather than completely entangling them?

OK, I'll try to decouple it.

Thanks,
Jacek Anaszewski

