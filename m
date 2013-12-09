Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s31.blu0.hotmail.com ([65.55.111.106]:9510 "EHLO
	blu0-omc2-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932909Ab3LIKit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Dec 2013 05:38:49 -0500
Message-ID: <BLU0-SMTP479D8750DBFA66B9D41FE4AADD30@phx.gbl>
Date: Mon, 9 Dec 2013 18:38:36 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Kamil Debski <k.debski@samsung.com>
Subject: Re: Can't open mfc v5 encode but decode can
References: <BLU0-SMTP92430758342451CF087FC3ADD50@phx.gbl> <058401cef014$b29674e0$17c35ea0$%debski@samsung.com> <BLU0-SMTP1838921C2F758F2B715A141ADD70@phx.gbl> <06b801cef19d$69da8090$3d8f81b0$%debski@samsung.com>
In-Reply-To: <06b801cef19d$69da8090$3d8f81b0$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

? 2013?12?05? 17:36, Kamil Debski ??:
> Hi Randy,
> 
>> -----Original Message----- From: randy
>> [mailto:lxr1234@hotmail.com] Sent: Thursday, December 05, 2013
>> 1:27 AM To: linux-media@vger.kernel.org Cc: Kamil Debski;
>> m.szyprowski@samsung.com; kyungmin.park@samsung.com; 
>> m.chehab@samsung.com; jtp.park@samsung.com Subject: Re: Can't
>> open mfc v5 encode but decode can
>> 
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> ? 2013?12?03? 18:44, Kamil Debski ??:
>>> Hi Randy,
>>> 
>>> We also experienced this issue. One of the changes in the v4l2
>>> core affected the MFC driver. A fix for MFC has been prepared
>>> by Marek Szyprowski and should be sent out soon.
>>> 
>> When it is sending, may you CC me, I will test it.
>>> Also another tip - in 3.13 a check on bytesused and length
>>> fields in planes array has been implemented. So make sure to
>>> set them appropriately.
>>> 
>>> Best wishes,
>> 
>> Could you give me some example code of using samsung mfc v5
>> encode? I only get some sample from samsung BSP's android-4.2.2,
>> in hardware/samsung_slsi/exynos4/multimedia/ , has 
>> codecs/video/exynos4/mfc_v4l2/enc/src/SsbSipMfcEncAPI.c achived
>> this? Thanks
> 
> You can find the example applications here: 
> http://git.infradead.org/users/kmpark/public-apps
> 
> Best wishes,
Thank you.
Well, mem2mem device seems hard to use for me, I never use streaming
before(I always use libv4l to do a read/write wrapper). I will some time
to make it work in my program :)
Thank you again for your help and work.
						Ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJSpZ2mAAoJEPb4VsMIzTzioU0IAMWLh0keqK5z0C/FVPS8nJRA
yoaeMRwU0TTMe0gqsWkys+rg4o4Aec0aSQAhstolQuj80Btc511WKueq0e+l6R3/
wVsBiGaPNzsG5bgbcLwk5grY8R1I1ID534rMiKIBiz/2uW1D+OMYTq6mvnAExJMG
OdeGalb/KWm4SFMSHXj8iGr6f+8x7YzrrHaBfJB16KUEKDLcH0VdKWgDxmAgRrUY
fTzBtum2tvld/EYZhOt7QrPkVq1z0/s9xiZoPE2eIDEC42XGbmAwOZClUzFMD6cV
KAfRAWI3uWp4QetZMXh4X/rynYc8ppL0otjDnCUcWhdtmN/+QR2NDeyqO3EQfNY=
=YL7b
-----END PGP SIGNATURE-----
