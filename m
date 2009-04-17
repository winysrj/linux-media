Return-path: <linux-media-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:64216 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167AbZDQTbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 15:31:50 -0400
Message-ID: <49E8D8FD.6090704@gmail.com>
Date: Fri, 17 Apr 2009 21:31:09 +0200
From: =?windows-1252?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
References: <49E5D4DE.6090108@hhs.nl>
In-Reply-To: <49E5D4DE.6090108@hhs.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Hans de Goede wrote:
[snip]
> 
> libv4l-0.5.97
> -------------
> * Some applications / libs (*cough* gstreamer *cough*) will not work
>   correctly with planar YUV formats when the width is not a multiple of 8,
>   so crop widths which are not a multiple of 8 to the nearest multiple of 8
>   when converting to planar YUV

Could you please elaborate how this is supposed to work, because it
doesn't with the gspca_stv06xx driver and a sensor supporting raw
bayer and 356x292.

Best regards,
Erik

> Get it here:
> http://people.atrpms.net/~hdegoede/libv4l-0.5.97.tar.gz
> 
> Regards,
> 
> Hans
> 
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkno2PsACgkQN7qBt+4UG0GdWQCgiHC3jAVJk8znEgAk0cgrt4Cp
Tg0AmQEk4TMJG2l3It7vCa9NKHiZg9eM
=NEdy
-----END PGP SIGNATURE-----
