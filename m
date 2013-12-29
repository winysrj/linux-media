Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:42482 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3L2DqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 22:46:13 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYJ00FI1UH04O60@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 22:46:12 -0500 (EST)
Date: Sun, 29 Dec 2013 01:44:04 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 10/13] libdvbv5: cleanup coding style
Message-id: <20131229014404.600e5e05.m.chehab@samsung.com>
In-reply-to: <1388245561-8751-10-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
 <1388245561-8751-10-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 16:45:58 +0100
André Roth <neolynx@gmail.com> escreveu:


Please merge it with the original patch. That makes easier to review.

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/libdvbv5/descriptors.c          | 2 +-
>  lib/libdvbv5/descriptors/mpeg_pes.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
> index 6df8b8b..b5bc9b2 100644
> --- a/lib/libdvbv5/descriptors.c
> +++ b/lib/libdvbv5/descriptors.c
> @@ -1358,6 +1358,6 @@ void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned c
>  		for (i = strlen(hex); i < 49; i++)
>  			strncat(spaces, " ", sizeof(spaces));
>  		ascii[j] = '\0';
> -		dvb_log("%s %s %s %s", prefix, hex, spaces, ascii);
> +		dvb_log("%s%s %s %s", prefix, hex, spaces, ascii);
>  	}
>  }
> diff --git a/lib/libdvbv5/descriptors/mpeg_pes.c b/lib/libdvbv5/descriptors/mpeg_pes.c
> index c717297..0f0cde0 100644
> --- a/lib/libdvbv5/descriptors/mpeg_pes.c
> +++ b/lib/libdvbv5/descriptors/mpeg_pes.c
> @@ -33,7 +33,7 @@ void dvb_mpeg_pes_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_
>  	bswap32(pes->bitfield);
>  	bswap16(pes->length);
>  
> -	if (pes->sync != 0x000001 ) {
> +	if (pes->sync != 0x000001) {
>  		dvb_logerr("mpeg pes invalid");
>  		return;
>  	}


-- 

Cheers,
Mauro
