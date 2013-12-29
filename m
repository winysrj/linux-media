Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:42488 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3L2DqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 22:46:19 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYJ00DJUUH7CQ60@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 22:46:19 -0500 (EST)
Date: Sun, 29 Dec 2013 01:42:00 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 06/13] libdvbv5: fix eit times
Message-id: <20131229014200.22234596.m.chehab@samsung.com>
In-reply-to: <1388245561-8751-6-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
 <1388245561-8751-6-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 16:45:54 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/libdvbv5/descriptors/eit.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
> index d13b14c..e70cf3b 100644
> --- a/lib/libdvbv5/descriptors/eit.c
> +++ b/lib/libdvbv5/descriptors/eit.c
> @@ -155,9 +155,8 @@ void dvb_time(const uint8_t data[5], struct tm *tm)
>    tm->tm_mday  = day;
>    tm->tm_mon   = month - 1;
>    tm->tm_year  = year;
> -  tm->tm_isdst = -1;
> -  tm->tm_wday  = 0;
> -  tm->tm_yday  = 0;
> +  tm->tm_isdst = 1; // dst in effect, do not adjust

Please don't use c99 comments.

> +  mktime( tm );

Please remove the extra spaces.

>  }
>  
>  


-- 

Cheers,
Mauro
