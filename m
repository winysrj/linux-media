Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9343 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbaEEOPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 May 2014 10:15:18 -0400
Message-id: <53679CE7.3070202@samsung.com>
Date: Mon, 05 May 2014 16:15:03 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org, t.figa@samsung.com,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	robh+dt@kernel.org, arnd@arndb.de, grant.likely@linaro.org,
	kgene.kim@samsung.com, rdunlap@infradead.org, ben-linux@fluff.org
Subject: Re: [PATCH 0/2] Add support for sii9234 chip
References: <1397216910-15904-1-git-send-email-t.stanislaws@samsung.com>
 <20140503231726.GA20212@kroah.com>
In-reply-to: <20140503231726.GA20212@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/04/2014 01:17 AM, Greg KH wrote:
> On Fri, Apr 11, 2014 at 01:48:28PM +0200, Tomasz Stanislawski wrote:
>> Hi everyone,
>> This patchset adds support for sii9234 HD Mobile Link Bridge.  The chip is used
>> to convert HDMI signal into MHL.  The driver enables HDMI output on Trats and
>> Trats2 boards.
>>
>> The code is based on the driver [1] developed by:
>>        Adam Hampson <ahampson@sta.samsung.com>
>>        Erik Gilling <konkers@android.com>
>> with additional contributions from:
>>        Shankar Bandal <shankar.b@samsung.com>
>>        Dharam Kumar <dharam.kr@samsung.com>
>>
>> The drivers architecture was greatly simplified and transformed into a form
>> accepted (hopefully) by opensource community.  The main differences from
>> original code are:
>> * using single I2C client instead of 4 subclients
>> * remove all logic non-related to establishing HDMI link
>> * simplify error handling
>> * rewrite state machine in interrupt handler
>> * wakeup and discovery triggered by an extcon event
>> * integrate with Device Tree
>>
>> For now, the driver is added to drivers/misc/ directory because it has neigher
>> userspace nor kernel interface.  The chip is capable of receiving and
>> processing CEC events, so the driver may export an input device in /dev/ in the
>> future.  However CEC could be also handled by HDMI driver.
>>
>> I kindly ask for suggestions about the best location for this driver.
> 
> It really is an extcon driver, so why not put it in drivers/extcon?  And
> that might solve any build issues you have if you don't select extcon in
> your .config file and try to build this code :)
> 
> thanks,

Hi Greg,
Thank you for your comments.

As I understand, drivers/extcon contains only extcon providers.
This driver is an extcon client, so mentioned location may not be adequate.

I am surprised that there are no comments about this driver.
Sii9234 chip is present on many exynos based boards/phones
and HDMI subsystem will not work without this code.

Regards,
Tomasz Stanislawski

> 
> greg k-h
> 

