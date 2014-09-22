Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:39808 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaIVQuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 12:50:23 -0400
Message-ID: <5420534C.7070701@soulik.info>
Date: Tue, 23 Sep 2014 00:50:20 +0800
From: ayaka <ayaka@soulik.info>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: kyungmin.park@samsung.com, jtp.park@samsung.com,
	m.chehab@samsung.com
Subject: Re: [PATCH] s5p-mfc: correct the formats info for encoder
References: <1406132104-6430-1-git-send-email-ayaka@soulik.info> <1406132104-6430-2-git-send-email-ayaka@soulik.info> <072d01cfd682$4cf2b220$e6d81660$%debski@samsung.com>
In-Reply-To: <072d01cfd682$4cf2b220$e6d81660$%debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



 2014/09/23 00:28, Kamil Debski wrote:
> Hi Ayaka,
> 
> Sorry for such a late reply - I just noticed this patch.
> 
>> The NV12M is supported by all the version of MFC, so it is better
>> to use it as default OUTPUT format. MFC v5 doesn't support NV21,
>> I have tested it, for the SEC doc it is not supported either.
> 

> A proper Sign-off is missing here.
> 
Sorry  to miss it again.
> According to the documentation of MFC v5 I have non-tiled format
> is supported. Which documentation were you looking at?
> 
But the V4L2_PIX_FMT_NV12MT is only supported by MFC_V5_BIT from your
code, V4L2_PIX_FMT_NV12M is supported by all the version.

>> From my documentation:
> ++++++++++++++ ENC_MAP_FOR_CUR	0xC51C Memory structure setting
> register of the current frame.	R/W	0x00000000
> 
> Bits	Name	Description	Reset Value [31:2]	RESERVED	Reserved	0 [1:0]
> ENC_MAP_FOR_CUR	Memory structure of the current frame 0 : Linear
> mode 3 : 64x32 tiled mode	0 ++++++++++++++
> 
In the page 2277. The same result.
I think the V4L2_PIX_FMT_NV12MT is 64x32 Tiles mode, but what I remove
for MFC v5 is V4L2_PIX_FMT_NV21M.
> Best wishes,
> 

- -- 
ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIFNLAAoJEPsGh4kgR4i5HcIP/2qwn7uIFq66qpSajXmtcLx3
3/wt8n26u6GhTMUnIJKZS07FGtv7qizUVqeY3WmfWQw3jLaUjZeVviVH08y3DrE8
+7Vjq2rxz57ou4bBtc4qIgTWB7z2yuVSpBOYUB94laItQ7KDap4EgLf89m4KaKTt
5nULR0byxXh+RuUOw80v0eP/TBz7SRfYZnulASV9QlGS6T3Xp6v4U6W8LbSbieR5
63PwPxYP7aDVb5R6qzaLIVXNuI53vn5VhrQ6JJUfKee5YSbkV/Ff6XK+7/P162Pn
5cVt06X+RUeZXHGqCroMNb9cdm+7JHOZL458NPn4NmTJnFcPNu6JzW9iLymHeHC8
iFmNhpDuHJBulKsW44lqKe1fHT22a5C/oJAI1ZS9c3yrH+TqHkfEkUJjglSRByzj
ptTFFZVTCdiL5VwnDlfowR4ZzrkZuoWzHIn5cGeHogvbLbxCbtV67+IFpWlXfyJu
rKnCI+DKYb5cjEiHm7kzGbAO04AfNMT79sNwrD+sPuvnaFyRiy2rjKv3ubnPFRVp
3agNRzAcCgmsW3K10P3ism4ceJUqeZtFvieCQrjiQdxj8EB7QAcgOhgn3K//zrQ1
mQP7xuVQcwpaRIOx/3jSlVWYFrkFs2+tmgS9oEn+v40gXOQXk8rML21gHvpDuCnf
qJXx0UVYQRV7Bhgv8EFW
=SNTL
-----END PGP SIGNATURE-----
