Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37294 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539AbaHVPRa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 11:17:30 -0400
Message-ID: <53F75F02.2030300@iki.fi>
Date: Fri, 22 Aug 2014 18:17:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Autoselecting SPI for MEDIA_SUBDRV_AUTOSELECT?
References: <53F75B26.2020101@suse.com>
In-Reply-To: <53F75B26.2020101@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 08/22/2014 06:00 PM, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi Antti -
>
> Commit e4462ffc160 ([media] Kconfig: sub-driver auto-select SPI bus)
> enables CONFIG_SPI globally for a driver that won't even be enabled in
> many cases.
>
> Is there a reason USB_MSI2500 doesn't select SPI instead of
> MEDIA_SUBDRV_AUTOSELECT?

Nothing but I decided to set it similarly as I2C, another more common 
bus. IIRC same was for I2C_MUX too.

You could still disable media subdriver autoselect and then disable SPI 
and select all the media drivers (excluding MSSi2500) manually.

I have feeling that media auto-select was added to select everything 
needed for media.

regards
Antti

-- 
http://palosaari.fi/
