Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50889 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1LFGv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 01:51:28 -0500
Date: Tue, 6 Dec 2011 07:51:19 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stefan Ringel <linuxtv@stefanringel.de>,
	linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 3/5] tm6000: bugfix interrupt reset
Message-ID: <20111206065119.GA26724@avionic-0098.mockup.avionic-design.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
 <1322509580-14460-3-git-send-email-linuxtv@stefanringel.de>
 <20111205072131.GB7341@avionic-0098.mockup.avionic-design.de>
 <4EDCB33E.8090100@redhat.com>
 <20111205153800.GA32512@avionic-0098.mockup.avionic-design.de>
 <4EDD0BBF.3020804@redhat.com>
 <4EDD235A.9000100@stefanringel.de>
 <4EDD268E.9010603@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <4EDD268E.9010603@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Mauro Carvalho Chehab wrote:
> That means that all we need is to get rid of TM6000_QUIRK_NO_USB_DELAY.

I've just reviewed my patches again and it seems that no-USB-delay quirk
patch was only partially applied. The actual location where it was introduced
was in tm6000_read_write_usb() to allow the msleep(5) to be skipped, which on
some devices isn't required and significantly speeds up firmware upload. So I
don't think we should get rid of it.

If it helps I can rebase the code against your branch (which one would that
be exactly?) and resend the rest of the series.

Thierry

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7du2cACgkQZ+BJyKLjJp+7rgCgo/XL8aCZnRl+vRFBKFa8NF1e
sawAn1vCeQCVGN2EEqV3Pof9dkpfJU3E
=7Z52
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
