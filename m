Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:29164 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaAGRXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 12:23:51 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ100KPAKBPNC50@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 12:23:50 -0500 (EST)
Date: Tue, 07 Jan 2014 15:23:45 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 11/18] libdvbv5: cleanup coding style
Message-id: <20140107152345.1fe8e170@samsung.com>
In-reply-to: <1388407731-24369-11-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
 <1388407731-24369-11-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Dec 2013 13:48:44 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/libdvbv5/descriptors.c          | 2 +-
>  lib/libdvbv5/descriptors/mpeg_pes.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
> index 226349e..f46aa4a 100644
> --- a/lib/libdvbv5/descriptors.c
> +++ b/lib/libdvbv5/descriptors.c
> @@ -1359,6 +1359,6 @@ void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned c
>  		for (i = strlen(hex); i < 49; i++)
>  			strncat(spaces, " ", sizeof(spaces));
>  		ascii[j] = '\0';
> -		dvb_log("%s %s %s %s", prefix, hex, spaces, ascii);
> +		dvb_log("%s%s %s %s", prefix, hex, spaces, ascii);
>  	}
>  }
> diff --git a/lib/libdvbv5/descriptors/mpeg_pes.c b/lib/libdvbv5/descriptors/mpeg_pes.c
> index 1b518a3..98364a3 100644
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

Please merge this one with the patches that introduced the changes,
if they weren't merged yet. The second hunk doesn't apply, as I
requested changes on the patch that added the PES parser.

-- 

Cheers,
Mauro
