Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:38970 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162AbaJ3Keh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 06:34:37 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] [media] rc5-decoder: BZ#85721: Fix RC5-SZ decoding
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 30 Oct 2014 11:34:34 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?Q?=5C=22Antti_Sepp=C3=A4l=C3=A4=5C=22?=
	<a.seppala@gmail.com>
In-Reply-To: <799eec4754378141225f1997a581fb42818fcfb4.1414662837.git.mchehab@osg.samsung.com>
References: <799eec4754378141225f1997a581fb42818fcfb4.1414662837.git.mchehab@osg.samsung.com>
Message-ID: <4f58bcf7d137c89be08e70f12c2a55e5@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-10-30 10:54, Mauro Carvalho Chehab wrote:
> changeset e87b540be2dd broke RC5-SZ decoding, as it forgot to add
> the extra bit check for the enabled protocols at the beginning of
> the logic.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: David Härdeman <david@hardeman.nu>

> 
> diff --git a/drivers/media/rc/ir-rc5-decoder.c
> b/drivers/media/rc/ir-rc5-decoder.c
> index 2ef763928ca4..84fa6e9b59a1 100644
> --- a/drivers/media/rc/ir-rc5-decoder.c
> +++ b/drivers/media/rc/ir-rc5-decoder.c
> @@ -53,7 +53,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct
> ir_raw_event ev)
>  	u32 scancode;
>  	enum rc_type protocol;
> 
> -	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
> +	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X | 
> RC_BIT_RC5_SZ)))
>  		return 0;
> 
>  	if (!is_timing_event(ev)) {
