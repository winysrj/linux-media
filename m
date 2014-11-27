Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:56278 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaK0FgP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 00:36:15 -0500
Received: by mail-qa0-f49.google.com with SMTP id s7so2829609qap.8
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 21:36:14 -0800 (PST)
Date: Thu, 27 Nov 2014 02:36:10 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: SOLO6x10: fix a race in IRQ handler.
Message-ID: <20141127023610.36d13623@pirotess.bf.iodev.co.uk>
In-Reply-To: <m3lhneez9h.fsf@t19.piap.pl>
References: <m3lhneez9h.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/7klwMzGhsvYPCHwS1R7Zw7_"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/7klwMzGhsvYPCHwS1R7Zw7_
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Nov 2014 13:35:06 +0100
khalasa@piap.pl (Krzysztof Ha=C5=82asa) wrote:
> The IRQs have to be acknowledged before they are serviced, otherwise
> some events may be skipped. Also, acknowledging IRQs just before
> returning from the handler doesn't leave enough time for the device
> to deassert the INTx line, and for bridges to propagate this change.
> This resulted in twice the IRQ rate on ARMv6 dual core CPU.
>=20
> Signed-off-by: Krzysztof Ha=C5=82asa <khalasa@piap.pl>
>=20
> --- a/drivers/media/pci/solo6x10/solo6x10-core.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-core.c
> @@ -105,11 +105,8 @@ static irqreturn_t solo_isr(int irq, void *data)
>  	if (!status)
>  		return IRQ_NONE;
> =20
> -	if (status & ~solo_dev->irq_mask) {
> -		solo_reg_write(solo_dev, SOLO_IRQ_STAT,
> -			       status & ~solo_dev->irq_mask);
> -		status &=3D solo_dev->irq_mask;
> -	}
> +	/* Acknowledge all interrupts immediately */
> +	solo_reg_write(solo_dev, SOLO_IRQ_STAT, status);
> =20
>  	if (status & SOLO_IRQ_PCI_ERR)
>  		solo_p2m_error_isr(solo_dev);
> @@ -132,9 +129,6 @@ static irqreturn_t solo_isr(int irq, void *data)
>  	if (status & SOLO_IRQ_G723)
>  		solo_g723_isr(solo_dev);
> =20
> -	/* Clear all interrupts handled */
> -	solo_reg_write(solo_dev, SOLO_IRQ_STAT, status);
> -
>  	return IRQ_HANDLED;
>  }
> =20
>=20

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>

--Sig_/7klwMzGhsvYPCHwS1R7Zw7_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUdrhKAAoJEBH/VE8bKTLb4TYIANRRAtXUy+tjVMHLca2FEa37
nB37JaElX/uUBMnDLahmdacFZsJDm+IPFvFP64k9H/UvZXGZorT7B20UqzpUr2Jy
kgMrNY4GGMRfXMTssCesgolfToWZSHWHS9ihPhI58im2Z4KsIdAlpJ5LwxEf6Vle
FNi6J7lFzFUe4k//7ySgH6eJMqh4jepp47U59Hm6+NGC1dQVtqVXpZmvTShrktD+
o6Q2Ezjd9t2l3EIOsWeBXtapgAfjpso0Qk0LGVcBltSKtykCkfBoEUdP7aU8vg1/
9vE1atPr72L35vXpDV2eE9HEQsRJDuMbTBdCrmlXsbPg3tEKQeE84oXI9AyDTag=
=2IsW
-----END PGP SIGNATURE-----

--Sig_/7klwMzGhsvYPCHwS1R7Zw7_--
