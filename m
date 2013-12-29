Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:31082 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3L2D0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 22:26:06 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYJ00AWNTJH3S50@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 22:26:05 -0500 (EST)
Date: Sun, 29 Dec 2013 01:25:58 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/13] libdvbv5: fix deadlock on missing table sections
Message-id: <20131229012558.4e5687d0.m.chehab@samsung.com>
In-reply-to: <1388245561-8751-4-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
 <1388245561-8751-4-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 16:45:52 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/libdvbv5/dvb-scan.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
> index 76712d4..9751f9d 100644
> --- a/lib/libdvbv5/dvb-scan.c
> +++ b/lib/libdvbv5/dvb-scan.c
> @@ -96,6 +96,10 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
>  	uint8_t *buf = NULL;
>  	uint8_t *tbl = NULL;
>  	ssize_t table_length = 0;
> +
> +	// handle sections
> +	int start_id = -1;
> +	int start_section = -1;

Again, this seems to be part of patch 1.

>  	int first_section = -1;
>  	int last_section = -1;
>  	int table_id = -1;


-- 

Cheers,
Mauro
