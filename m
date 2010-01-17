Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0AQM2M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 07:28:12 -0500
Message-ID: <4B530251.5000204@infradead.org>
Date: Sun, 17 Jan 2010 10:28:01 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Franklin Meng <fmeng2002@yahoo.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Kworld 315U and SAA7113?
References: <245243.78544.qm@web32707.mail.mud.yahoo.com>
In-Reply-To: <245243.78544.qm@web32707.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Franklin Meng wrote:
> Devin, 
> 
>>> I'm actually not really concerned about it's
>> interaction
>>> with a demod.
>>>   I'm more worried about other products that have
>>> saa711[345] that use
>>> a bridge other than em28xx.  The introduction of
>> power
>>> management
>>> could always expose bugs in those bridges (I had this
>>> problem in
>>> several different cases where I had to fix problems
>> in
>>> other drivers
>>> because of the introduction of power management).
>>>
> 
> I retested my device and tried several different GPIO sequences but so far every time I change between the Analog and digital interface, the SAA7113 needs to be reinitialized.  

This happens on several designs. In general, the gpio sequence will turn off either the analog or the digital part of the device,
in order to save power and to avoid overheating the device.

> I tried leaving both the digital and analog interfaces enabled by setting the GPIO to 7c but then the LG demod does not initialize.  

Don't do that. You may burn your device.

> Either way it looks like I will have to reinitialize the device after switching between interfaces.  

The em28xx driver calls em28xx_set_mode(dev, EM28XX_ANALOG_MODE); when the device is opened in analog mode.
It seems that we'll need some code there to also call the analog demod to re-initiate the device, after sending
the gpio commands.

> 
> Other than that do you want me to remove the suspend GPIO?  Since I don't have the equipment to measure the power, 
> I don't know for a fact if the device really has been put in a suspend state or not.  

In suspend state, it will be cooler than when in normal state. It is better to keep the suspend state
to increase the lifetime of the device.
> 
> Thanks,
> Franklin Meng
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

