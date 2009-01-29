Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:33265 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbZA2UGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 15:06:11 -0500
Message-ID: <49820C26.5090309@free.fr>
Date: Thu, 29 Jan 2009 21:05:58 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Support faulty USB IDs on DIBUSB_MC
References: <484A72D3.7070500@free.fr> <4974E4BE.2060107@free.fr> <20090129074735.76e07d47@caramujo.chehab.org> <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

Patrick Boettcher wrote:
> Hi,
> 
> sorry for not answering ealier, recently I became the master of 
> postponing things. :(
> 
> On Thu, 29 Jan 2009, Mauro Carvalho Chehab wrote:
> 
>>> +/* 14 */    { USB_DEVICE(USB_VID_CYPRESS,        
>>> USB_PID_ULTIMA_TVBOX_USB2_FX_COLD) },
>>> +#endif
>>
>> It doesn't sound a very good approach the need of recompiling the 
>> driver to
>> allow it to work with a broken card. The better would be to have some 
>> modprobe
>> option to force it to accept a certain USB ID as a valid ID for the card.
> 
> The most correct way would be to reprogram the eeprom, by simply writing 
> to 0xa0 (0x50 << 1) I2C address... There was a thread on the linux-dvb 
> some time ago.
> 
Why not, I only don't want to maintain a patch for my device.

I wonder why didn't they use WP pin of the eeprom to avoid write.

Do you know what should be written.
After a quick search, I found [1]. Is that ok ?


Matthieu

[1]
EEPROM Address            Contents
       0        0xC0
       1        Vendor ID (VID) L
       2        Vendor ID (VID) H
       3        Product ID (PID) L
       4        Product ID (PID) H
       5        Device ID (DID) L
       6        Device ID (DID) H
       7        Configuration byte

