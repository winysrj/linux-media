Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0AYOfp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 09:35:45 -0500
Message-ID: <4B5DAC3A.6000408@redhat.com>
Date: Mon, 25 Jan 2010 12:35:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
References: <4B547EBF.6080105@arcor.de>
In-Reply-To: <4B547EBF.6080105@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>  
> Hi Davin,
> I have a question. How are loaded the base firmware into xc3028, in
> once or in a split ? It's importent for TM6010, the USB-Analyzer said
> that it load it in once and then send a quitting reqeuest.

The way the original driver for tm6000/tm6010 does varies from firmware
version to firmware version. That part of the driver works fine for
both tm6000 and tm6010, with the devices I used here, with firmwares 1.e 
and 2.7. However, on tm6000, it sends the firmware on packages with
up to 12 or 13 bytes, and it requires a delay before sending the next
packet, otherwise the tm6000 hangs.

Another problem is that the firmware load may fail (due to the bad
implementation of the i2c on tm6000/tm6010). So, the code should ideally
check if the firmware were loaded, by reading the firmware version at the
end. However, reading from i2c is very problematic, since it sometimes
read from the wrong place. On the tests I did here, the original drivers
weren't reading back the firmware version, probably due to this bug.

Cheers,
Mauro.

> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.12 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>  
> iQEcBAEBAgAGBQJLVH6/AAoJEDX/lZlmjdJlA/0H/jkn4I3kELEWPeDDYJvv/+Z0
> LsSLzmDJmQ0WgASjtJQ2QZvsDeuCsbzV9mTHGvI0dOGtOLqcBuMX58ZFTerZodrG
> b/KdwZa2OV0MWXc+5hf2+3wEC1icfMATKiwsT3gLdvP9En4MtUP8ImaXFWwW7ekL
> aH5TD666nGewj4+Ef5eVY0G+FypqzNcs4F04uY5ydBaVDh5XTONhXPaLz/R5JF0K
> ivKT4WL7n8A7bq8iAn6SoMJRV/RbEpGF40m4aApVDd+JdizFIH7xrTGQ4waQO6IN
> mplAcxIhq6bEHhwZRfbbnTNMTWUVPShqqqxC5Z0TxCiUR0RH6JdXagQtw/1/UX0=
> =Qqmr
> -----END PGP SIGNATURE-----
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

