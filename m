Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp16.protectedservice.net ([217.154.106.151]:50044 "EHLO
	smtp16.protectedservice.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbZE2H5w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 03:57:52 -0400
Cc: linux-media@vger.kernel.org
Message-Id: <981EF3D9-3DB5-4F2B-B7A5-F23533A5BEFE@lauresconseil.fr>
From: =?ISO-8859-1?Q?Guillaume_Laur=E8s?= <glaures@lauresconseil.fr>
To: Steven Toth <stoth@kernellabs.com>
In-Reply-To: <4A11D48A.1030209@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: no tuning with an hvr-1700
Date: Fri, 29 May 2009 09:57:50 +0200
References: <C9D3D945-05BF-48DA-9CEF-CF7D4DFE8053@lauresconseil.fr> <4A11D48A.1030209@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Le 18 mai 09 à 23:35, Steven Toth a écrit :

> Clone this tree and try again:
>
> http://kernellabs.com/hg/~stoth/tda10048-merge
>
> Better, or not?

Hi,

I finally got it working with an offset (+166KHz), with stock 2.6.28  
kernel (didn't worked with this tree).

Thanks,

GoM
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)

iEYEARECAAYFAkoflX4ACgkQxnIJde5abSmkTwCdHqY0+CeZemwYPZHZsNeqIj+Q
RuYAn2pISoVdoThWD5PIt8KcrnO/JsBY
=pTpM
-----END PGP SIGNATURE-----
