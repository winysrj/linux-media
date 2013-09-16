Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:50434 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751044Ab3IPX4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 19:56:25 -0400
Received: from smtprelay.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtpgrave05.hostedemail.com (Postfix) with ESMTP id 8B238224C3A7
	for <linux-media@vger.kernel.org>; Mon, 16 Sep 2013 23:49:40 +0000 (UTC)
Message-ID: <1379375332.7083.3.camel@joe-AO722>
Subject: Re: [PATCH] dvb: fix potential format string leak
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Mon, 16 Sep 2013 16:48:52 -0700
In-Reply-To: <20130916233720.GA3967@www.outflux.net>
References: <20130916233720.GA3967@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2013-09-16 at 16:37 -0700, Kees Cook wrote:
> Make sure that a format string cannot accidentally leak into the printk
> buffer.
[]
> diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
[]
> @@ -649,7 +649,7 @@ static int dib9000_risc_debug_buf(struct dib9000_state *state, u16 * data, u8 si
>  	b[2 * (size - 2) - 1] = '\0';	/* Bullet proof the buffer */
>  	if (*b == '~') {
>  		b++;
> -		dprintk(b);
> +		dprintk("%s", b);
>  	} else
>  		dprintk("RISC%d: %d.%04d %s", state->fe_id, ts / 10000, ts % 10000, *b ? b : "<emtpy>");
>  	return 1;

This looks odd.

Perhaps this should be:

	if (*b == '~')
		b++;
	dprintk("etc...);

It'd be nice to fix the <empty> typo too.


