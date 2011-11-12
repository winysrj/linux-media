Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52920 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab1KLQyH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:54:07 -0500
Message-ID: <4EBEA4AD.4070906@iki.fi>
Date: Sat, 12 Nov 2011 18:54:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/7] af9015 usb bus repeater.
References: <4ebe9728.4dc6e30a.47c5.ffff8fc3@mx.google.com>
In-Reply-To: <4ebe9728.4dc6e30a.47c5.ffff8fc3@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 05:56 PM, Malcolm Priestley wrote:
> This a bus repeater for af9015 devices. Commands usually fail because of other
> activity on the usb bus.
>
> Afatech drivers can repeat up to ten times on the usb bus.
>
> bulk failures that report -ETIMEDOUT or -EBUSY are repeated. If the device fails
> it usually return 0x55 in the first byte.
>
> I am working on a patch to move parts of this to the dvb-usb common area to
> be used by other drivers.

Repeating does not help for those I2C errors. I have already tested it. 
IIRC 01 and 02 was the error codes returned in case of I2C read / write.

Which command gives 0x55 for failing?

And generally only very first command will fail. There is already repeat 
for that. Generally I think it is good idea to add some repeating, since 
it is needed. But it does not make much sense to repeat for those common 
I2C errors since it does not matter - you can repeat forever it still 
fails. So first need to fix main error source.

And it is indeed good idea to generalize it, but I think it is possible 
only for error situations when error is returned by platform call.
1. general repeat for platform calls
2. repeat for firmware command fail (is there need?)

regards
Antti

-- 
http://palosaari.fi/
