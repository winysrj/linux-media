Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:51545 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab0CEUxF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 15:53:05 -0500
Message-ID: <4B916F0B.40602@arcor.de>
Date: Fri, 05 Mar 2010 21:52:27 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: tm6000 and Hauppauge HVR-900H
References: <4B913F2E.1080703@arcor.de> <4B9144E6.5000109@redhat.com>
In-Reply-To: <4B9144E6.5000109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Am 05.03.2010 18:52, schrieb Mauro Carvalho Chehab:
> Stefan,
>
> Stefan Ringel wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>>
>> Hi Mauro, Devin,
>>
>> I study the tm6000 source and I have any questions.
>>
>> 1. I tested my stick (terratec cinery hybrid) with the windows
>> driver from the Hauppauge HVR-900H and it's work. So I think that
>> have the same driver setting.
>
> It is very likely that the original driver has some code to probe
> the devices and to read certain configurations at the board's
> eeprom. At least on the USB sniffs I've saw, some probing is
> noticed, and several eeprom addresses are read. So, the fact that
> both devices work with the same driver doesn't mean that both use
> the same GPIO's.
>
The orginal driver hasn't some code to probe the drvices and to read
certain configurations at the board's eeprom.! I have analysed both
windows driver I have not see any probing or eeprom reading. What I
see is, that it reads the usb configuration and then the driver! Both
driver has the same code and the same identification "DTV-DVB USB 2.0
AZWAVE". The different is the file name (Hauppauge HVR-900H the
hcw66xxx.sys and terratec cinergy hybrid the udxttm6010.sys).
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJLkW8LAAoJEDX/lZlmjdJlvrQH/22VpRhq5t8Gxa+jv48/uTgF
G+9JS97wXNPozj+Ui7FX/WCGGE2r2+PYk3pJGf1P7oRYS8vSLOrT7dknpjxsCDlz
WcacfbRFZrD/8BHWjahtFi16nTSYyKe9yjCQy3QEz6bkDvh2c4DSdTnjBCB+/VOD
ScvYP7nXkgCtDRtkRTMzK4MnP6xZ8kcZAwlGzKaMtjx+mN3Cfjqkix5vnP0PPoNU
A9KF89Cs5mwJwBS5QrB1L9uxXhx0ZHxutAWz1e+Da/OF/A45v4bH3QmIDFaAyFte
ARO5XL4nC0D2XYYyXQ8fQgpQhRXqcsTCO+2uQ6zLAt519An6eOSF9C9xUbAy6SA=
=BxG5
-----END PGP SIGNATURE-----

