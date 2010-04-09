Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:41209 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0DII1X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 04:27:23 -0400
Message-ID: <4BBEE27E.5000007@linuxtv.org>
Date: Fri, 09 Apr 2010 10:17:02 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: mchehab@redhat.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] Add RC6 support to ir-core
References: <20100408230246.14453.97377.stgit@localhost.localdomain> <20100408230440.14453.36936.stgit@localhost.localdomain>
In-Reply-To: <20100408230440.14453.36936.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello David,

David Härdeman wrote:
> --- a/drivers/media/IR/ir-core-priv.h
> +++ b/drivers/media/IR/ir-core-priv.h
> @@ -109,4 +109,11 @@ void ir_raw_init(void);
>  #define load_rc5_decode()	0
>  #endif
>  
> +/* from ir-rc6-decoder.c */
> +#ifdef CONFIG_IR_RC5_DECODER_MODULE
> +#define load_rc6_decode()	request_module("ir-rc6-decoder")
> +#else
> +#define load_rc6_decode()	0
> +#endif
> +
>  #endif /* _IR_RAW_EVENT */

you probably intended to use CONFIG_IR_RC6_DECODER_MODULE instead.

Regards,
Andreas
