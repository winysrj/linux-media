Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab1IYTpP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 15:45:15 -0400
Message-ID: <4E7F84C8.6010505@redhat.com>
Date: Sun, 25 Sep 2011 16:45:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <1316978885.75743.YahooMailClassic@web121708.mail.ne1.yahoo.com>
In-Reply-To: <1316978885.75743.YahooMailClassic@web121708.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-09-2011 16:28, Chris Rankin escreveu:
> --- On Sun, 25/9/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>> Ok, I've applied it, but it doesn't sound a good idea to me
>> to do:
>>
>> +    mutex_unlock(&dev->lock);
>>      em28xx_init_extension(dev);
>> +    mutex_lock(&dev->lock);
>>
> 
> Yes, I suppose it's the logical equivalent of moving the em28xx_init_extension(dev) call from em28xx_init_dev(), and placing it immediately after the final mutex_unlock(&dev->lock) call in em28xx_usb_probe() instead. Which would be cleaner, quite frankly.
> 
> Which stage of the v4l2 initialisation triggers the race with udev? v4l2_device_register()? 

Yes. Just after creating a device, udev tries to access it. This bug is more sensitive on
multi-CPU machines, as udev may run on another CPU.

> 
> Cheers,
> Chris
> 

