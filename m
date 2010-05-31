Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40065 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab0EaPW5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 11:22:57 -0400
Message-ID: <4C03D449.2020507@iki.fi>
Date: Mon, 31 May 2010 18:22:49 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: dereferencing uninitialized variable in anysee_probe()
References: <20100531150914.GX5483@bicker>
In-Reply-To: <20100531150914.GX5483@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve Dan,

On 05/31/2010 06:09 PM, Dan Carpenter wrote:
> Hi I'm going through some smatch stuff and I had a question.
>
> drivers/media/dvb/dvb-usb/anysee.c +482 anysee_probe(30)
> 	warn: variable dereferenced before check 'd'
>
>     466          ret = dvb_usb_device_init(intf,&anysee_properties, THIS_MODULE,&d,
>     467                  adapter_nr);
>
> 	If we're in a cold state then dvb_usb_device_init() can return
> 	zero but d is uninitialized here.

Anysee is always warm. Its USB-bridge, Cypress FX2, uploads firmware 
from eeprom and due to that it is never cold from the drivers point of view.

*cold means device needs firmware upload from driver
*warm means device is ready. Firmware is already uploaded or it is not 
needed at all.

>     468          if (ret)
>     469                  return ret;
>     470
>     471          alt = usb_altnum_to_altsetting(intf, 0);
>     472          if (alt == NULL) {
>     473                  deb_info("%s: no alt found!\n", __func__);
>     474                  return -ENODEV;
>     475          }
>     476
>     477          ret = usb_set_interface(d->udev, alt->desc.bInterfaceNumber,
>                                          ^^^^^^^
> 	That would lead to an oops here.
>
>     478                  alt->desc.bAlternateSetting);
>
> I'm not sure how to fix this.

After that answer, do you still see problem?

best regards
Antti
-- 
http://palosaari.fi/
