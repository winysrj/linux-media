Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:53360 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0EaTOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 15:14:07 -0400
Received: by ewy8 with SMTP id 8so1044025ewy.28
        for <linux-media@vger.kernel.org>; Mon, 31 May 2010 12:14:04 -0700 (PDT)
Date: Mon, 31 May 2010 21:13:23 +0200
From: Dan Carpenter <error27@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: dereferencing uninitialized variable in anysee_probe()
Message-ID: <20100531191323.GY5483@bicker>
References: <20100531150914.GX5483@bicker> <4C03D449.2020507@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C03D449.2020507@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 31, 2010 at 06:22:49PM +0300, Antti Palosaari wrote:
> Terve Dan,
>
> On 05/31/2010 06:09 PM, Dan Carpenter wrote:
>> Hi I'm going through some smatch stuff and I had a question.
>>
>> drivers/media/dvb/dvb-usb/anysee.c +482 anysee_probe(30)
>> 	warn: variable dereferenced before check 'd'
>>
>>     466          ret = dvb_usb_device_init(intf,&anysee_properties, THIS_MODULE,&d,
>>     467                  adapter_nr);
>>
>> 	If we're in a cold state then dvb_usb_device_init() can return
>> 	zero but d is uninitialized here.
>
> Anysee is always warm. Its USB-bridge, Cypress FX2, uploads firmware  
> from eeprom and due to that it is never cold from the drivers point of 
> view.
>
> *cold means device needs firmware upload from driver
> *warm means device is ready. Firmware is already uploaded or it is not  
> needed at all.
>

Wow.  Thanks for the quick response.  I was just auditing the code and
noticed some extra null checking which made me confused.  I'll send a
patch for that.

regards,
dan carpenter
