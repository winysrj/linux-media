Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:53131 "EHLO
	omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753687AbbLVRBd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 12:01:33 -0500
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: next-20151222 - compile failure in drivers/media/usb/uvc/uvc_driver.c
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <567944CB.4070505@osg.samsung.com>
References: <75073.1450779516@turing-police.cc.vt.edu>
 <567944CB.4070505@osg.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1450803682_2476P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Dec 2015 12:01:22 -0500
Message-ID: <3484.1450803682@turing-police.cc.vt.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--==_Exmh_1450803682_2476P
Content-Type: text/plain; charset=us-ascii

On Tue, 22 Dec 2015 09:40:43 -0300, Javier Martinez Canillas said:

> It was my forgetting to test with !CONFIG_MEDIA_CONTROLLER...
>
> Anyways, I've already posted a fix for this:
>
> https://lkml.org/lkml/2015/12/21/224

Thanks, that fixed it.  When I posted, Google hadn't indexed that post
yet (or wasn't telling me about it), and it had escaped landing in my
mailbox by then.  Now that you reply, both Google and my mailbox have
it. :)


--==_Exmh_1450803682_2476P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVnmB4gdmEQWDXROgAQIY3A//TkH8t2jiY59hqI9mqb05kUDUO96/hWYC
eBl8UC+wNzP8w5jyyP1EZZC2wnSFNpxq6nkJF+a4+rf/8VNOapjVll1WNaZVKbgX
PlCEWYNmN+LNO9P3zQYYyl6qr+cCRikydUv6ieaHyh1Cbwb9dVLYbZkIQKSo8zXO
ODfmAjQ/j+i/blS6CWrM6RowmcXvZDYrmXCGMfM++YBj23nRSsK+rhr1vyHhNdnu
2PTA/+G5iKv+QUwQhQK+DtYLC7C3cRn8aKxpK8MvG+3XdHLLvzZyZIWKXb26JqfZ
p5TATNv4erT560bx0gQivlpE9mvbk+zyojy8OizXUTMXF5GL6kdQkEPo9oxSV3zf
BLaBXJ2SeanZNsdtHYKS9EMMrHcCDf+ai1M/+dtI+viiXOiUn3fdeax8kb/jK5uJ
PexoMfxSBK3Q4mmZ33Sd+3pc1n5ZiaKwMg+wCfMgZVEDwcA2qw5vyUNvOsZwOY27
7Zsy6pAzeiKwzsF9060WlGkosDMmQT4ITBaeFeqOTMBRn8Cpz0Nfql9QKUcgogE0
vSkZeszxvZSMB7oowc5NRcrs//cVD6qbqOT9i0ty83/1w1RJ5uzYaZus2Xsh3hmb
FgV8kWybCGIN9HjPYZFZocqvpEpbq4+iLRKeccr148xzbPdFlOF2wINKQPXdkRnZ
Q32zVxvYZfo=
=UxMt
-----END PGP SIGNATURE-----

--==_Exmh_1450803682_2476P--
