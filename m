Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38180 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2FYTPP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 15:15:15 -0400
Message-ID: <4FE8B8BC.3020702@iki.fi>
Date: Mon, 25 Jun 2012 22:15:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com> <4FE37194.30407@redhat.com>
In-Reply-To: <4FE37194.30407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/21/2012 10:10 PM, Mauro Carvalho Chehab wrote:
> Em 21-06-2012 10:36, Mauro Carvalho Chehab escreveu:
>> The firmware blob may not be available when the driver probes.
>>
>> Instead of blocking the whole kernel use request_firmware_nowait() and
>> continue without firmware.
>>
>> This shouldn't be that bad on drx-k devices, as they all seem to have an
>> internal firmware. So, only the firmware update will take a little longer
>> to happen.
>
> While thinking on converting another DVB frontend driver, I just realized
> that a patch like that won't work fine.
>
> As most of you know, there are _several_ I2C chips that don't tolerate any
> usage of the I2C bus while a firmware is being loaded (I dunno if this is the
> case of drx-k, but I won't doubt).
>
> The current approach makes the device probe() logic is serialized. So, there's
> no chance that two different I2C drivers to try to access the bus at the same
> time, if the bridge driver is properly implemented.
>
> However, now that firmware is loaded asynchronously, several other I2C drivers
> may be trying to use the bus at the same time. So, events like IR (and CI) polling,
> tuner get_status, etc can happen during a firmware transfer, causing the firmware
> to not load properly.
>
> A fix for that will require to lock the firmware load I2C traffic into a single
> transaction.

How about deferring registration or probe of every bus-interface (usb, 
pci, firewire) drivers we have. If we defer interface driver using work 
or some other trick we don't need to touch any other chip-drivers that 
are chained behind interface driver. Demodulator, tuner, decoder, remote 
and all the other peripheral drivers can be left as those are currently 
because those are deferred by bus interface driver.

regards
Antti

-- 
http://palosaari.fi/


