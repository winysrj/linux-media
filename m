Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:40586 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3L2Dp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 22:45:56 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYJ00FI7UGJIE50@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 22:45:55 -0500 (EST)
Date: Sun, 29 Dec 2013 01:45:45 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 11/13] libdvbv5: fix double entry in Makefile.am
Message-id: <20131229014545.011aaf01.m.chehab@samsung.com>
In-reply-to: <1388245561-8751-11-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
 <1388245561-8751-11-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 16:45:59 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/libdvbv5/Makefile.am | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
> index 368baf8..dc5005f 100644
> --- a/lib/libdvbv5/Makefile.am
> +++ b/lib/libdvbv5/Makefile.am
> @@ -47,7 +47,6 @@ libdvbv5_la_SOURCES = \
>    descriptors/desc_partial_reception.c  ../include/descriptors/desc_partial_reception.h \
>    descriptors/nit.c  ../include/descriptors/nit.h \
>    descriptors/sdt.c  ../include/descriptors/sdt.h \
> -  descriptors/vct.c  ../include/descriptors/vct.h \
>    descriptors/atsc_header.c ../include/descriptors/atsc_header.h \
>    descriptors/vct.c  ../include/descriptors/vct.h \
>    descriptors/mgt.c  ../include/descriptors/mgt.h \
> @@ -58,7 +57,7 @@ libdvbv5_la_SOURCES = \
>    descriptors/mpeg_pes.c  ../include/descriptors/mpeg_pes.h \
>    descriptors/mpeg_es.c  ../include/descriptors/mpeg_es.h
>  
> -libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
> +libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC) -std=c99

No. We don't want c99 style.

>  libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
>  libdvbv5_la_LIBADD = $(LTLIBICONV)
>  


-- 

Cheers,
Mauro
