Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16944 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab3LEJgF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 04:36:05 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXB00F1TUO3Y490@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Dec 2013 09:36:03 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'randy' <lxr1234@hotmail.com>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, m.chehab@samsung.com,
	jtp.park@samsung.com
References: <BLU0-SMTP92430758342451CF087FC3ADD50@phx.gbl>
 <058401cef014$b29674e0$17c35ea0$%debski@samsung.com>
 <BLU0-SMTP1838921C2F758F2B715A141ADD70@phx.gbl>
In-reply-to: <BLU0-SMTP1838921C2F758F2B715A141ADD70@phx.gbl>
Subject: RE: Can't open mfc v5 encode but decode can
Date: Thu, 05 Dec 2013 10:36:01 +0100
Message-id: <06b801cef19d$69da8090$3d8f81b0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

> -----Original Message-----
> From: randy [mailto:lxr1234@hotmail.com]
> Sent: Thursday, December 05, 2013 1:27 AM
> To: linux-media@vger.kernel.org
> Cc: Kamil Debski; m.szyprowski@samsung.com; kyungmin.park@samsung.com;
> m.chehab@samsung.com; jtp.park@samsung.com
> Subject: Re: Can't open mfc v5 encode but decode can
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> ? 2013?12?03? 18:44, Kamil Debski ??:
> > Hi Randy,
> >
> > We also experienced this issue. One of the changes in the v4l2 core
> > affected the MFC driver. A fix for MFC has been prepared by Marek
> > Szyprowski and should be sent out soon.
> >
> When it is sending, may you CC me, I will test it.
> > Also another tip - in 3.13 a check on bytesused and length fields in
> > planes array has been implemented. So make sure to set them
> > appropriately.
> >
> > Best wishes,
> 
> Could you give me some example code of using samsung mfc v5 encode?
> I only get some sample from samsung BSP's android-4.2.2, in
> hardware/samsung_slsi/exynos4/multimedia/ , has
> codecs/video/exynos4/mfc_v4l2/enc/src/SsbSipMfcEncAPI.c achived this?
> Thanks

You can find the example applications here:
http://git.infradead.org/users/kmpark/public-apps

Best wishes, 
-- 
Kamil Debski
Samsung R&D Institute Poland

