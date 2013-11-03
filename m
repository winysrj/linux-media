Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43335 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3KCJX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 04:23:56 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVO003HQKRVDU20@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 03 Nov 2013 04:23:55 -0500 (EST)
Date: Sun, 03 Nov 2013 07:23:51 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Maik Broemme <mbroemme@parallels.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 01/12] dvb-frontends: Support for DVB-C2 to DVB frontends
Message-id: <20131103072351.5aaed530@samsung.com>
In-reply-to: <20131103002425.GE7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
 <20131103002425.GE7956@parallels.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Nov 2013 01:24:25 +0100
Maik Broemme <mbroemme@parallels.com> escreveu:

> Added support for DVB-C2 to DVB frontends. It will be required
> by cxd2843 and tda18212dd (Digital Devices) frontends.
> 
> Signed-off-by: Maik Broemme <mbroemme@parallels.com>
> ---
>  include/uapi/linux/dvb/frontend.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> index c56d77c..98648eb 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -410,6 +410,7 @@ typedef enum fe_delivery_system {
>  	SYS_DVBT2,
>  	SYS_TURBO,
>  	SYS_DVBC_ANNEX_C,
> +	SYS_DVBC2,
>  } fe_delivery_system_t;
>  
>  /* backward compatibility */

Please update also the documentation, at Documentation/DocBook/media/dvb.

Doesn't DVB-C2 provide any newer property? If so, please add it there as
well, and at frontend.h.

Regards,
Maur
-- 

Cheers,
Mauro
