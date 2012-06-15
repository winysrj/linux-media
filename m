Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54130 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758171Ab2FOWyv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 18:54:51 -0400
Message-ID: <4FDBBD36.9020302@iki.fi>
Date: Sat, 16 Jun 2012 01:54:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb_usb_v2: use pointers to properties[REGRESSION]
References: <1339798273.12274.21.camel@Route3278>
In-Reply-To: <1339798273.12274.21.camel@Route3278>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Malcolm,

On 06/16/2012 01:11 AM, Malcolm Priestley wrote:
> Hi Antti
>
> You can't have dvb_usb_device_properties as constant structure pointer.
>
> At run time it needs to be copied to a private area.

Having constant structure for properties was one of main idea of whole 
change. Earlier it causes some problems when driver changes those values 
- for example remote configuration based info from the eeprom.

> Two or more devices of the same type on the system will be pointing to
> the same structure.

Yes and no. You can define struct dvb_usb_device_properties for each USB ID.

> Any changes they make to the structure will be common to all.

For those devices having same USB ID only.
Changing dvb_usb_device_properties is *not* allowed. It is constant and 
should be. That was how I designed it. Due to that I introduced those 
new callbacks to resolve needed values dynamically.

If there is still something that is needed to resolve at runtime I am 
happy to add new callback. For example PID filter configuration is 
static currently as per adapter and if it is needed to to reconfigure at 
runtime new callback is needed.

Could you say what is your problem I can likely say how to resolve it.

regards
Antti
-- 
http://palosaari.fi/


