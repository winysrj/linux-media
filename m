Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s38.blu0.hotmail.com ([65.55.111.113]:15700 "EHLO
	blu0-omc2-s38.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802Ab3LEA1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Dec 2013 19:27:17 -0500
Message-ID: <BLU0-SMTP1838921C2F758F2B715A141ADD70@phx.gbl>
Date: Thu, 5 Dec 2013 08:27:18 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Kamil Debski <k.debski@samsung.com>, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, m.chehab@samsung.com,
	jtp.park@samsung.com
Subject: Re: Can't open mfc v5 encode but decode can
References: <BLU0-SMTP92430758342451CF087FC3ADD50@phx.gbl> <058401cef014$b29674e0$17c35ea0$%debski@samsung.com>
In-Reply-To: <058401cef014$b29674e0$17c35ea0$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

? 2013?12?03? 18:44, Kamil Debski ??:
> Hi Randy,
> 
> We also experienced this issue. One of the changes in the v4l2
> core affected the MFC driver. A fix for MFC has been prepared by
> Marek Szyprowski and should be sent out soon.
> 
When it is sending, may you CC me, I will test it.
> Also another tip - in 3.13 a check on bytesused and length fields 
> in planes array has been implemented. So make sure to set them 
> appropriately.
> 
> Best wishes,

Could you give me some example code of using samsung mfc v5 encode?
I only get some sample from samsung BSP's android-4.2.2, in
hardware/samsung_slsi/exynos4/multimedia/ , has
codecs/video/exynos4/mfc_v4l2/enc/src/SsbSipMfcEncAPI.c achived this?
Thanks
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJSn8hmAAoJEPb4VsMIzTzizmgH/jhGpvElUflD7SmBZCyyAvWD
FluwSt/OzpJXd3K+EId1/AnudCF2heh6cofZ7qub1FuQ/BsisbMiYMGFYveJJluX
qFIjmu8840lVGGK5KcPH2wAYNqYQ3izmNkVvlqCBUBC2fZ/n6sby3jQBV4WqBzJ2
owB8Ky1LNO8n4xzYNyrkXNfsl5eMMc7nnL5Gs5L2wt60eR9mcT2aOMkWOzuGeZgn
IqxTUC14oR5H8yvMH8xla9IEHhSWJJWU5VtP/w20Bv2TCoEEXEdxQSjFUyiqfeKJ
zxnToqD9i9K5IQqV7prb21LS5VoDVpEHfFekMaNg23o+xo5w6PWaUbojQ/5oSG8=
=2ws7
-----END PGP SIGNATURE-----
