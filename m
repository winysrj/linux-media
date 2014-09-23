Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37183 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbaIWLkD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 07:40:03 -0400
Date: Tue, 23 Sep 2014 08:39:59 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] uapi: dvb: initial support for DVB-C2 standard
Message-ID: <20140923083959.3044cc35@recife.lan>
In-Reply-To: <1406845988-2871-2-git-send-email-crope@iki.fi>
References: <1406845988-2871-1-git-send-email-crope@iki.fi>
	<1406845988-2871-2-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  1 Aug 2014 01:33:06 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Just add delivery system for DVB-C2 standard. Other parameters
> should be added later.

The best is to add the parameters altogether, as:

1) We need to add the corresponding bits at the docbook;
2) We need to add support for it at libdvbv5.

Regards,
Mauro
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
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
