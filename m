Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab2AZQ4F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 11:56:05 -0500
Message-ID: <4F2185A1.2000402@redhat.com>
Date: Thu, 26 Jan 2012 14:56:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] m88brs2000 DVB-S frontend and tuner module.
References: <1327228731.2540.3.camel@tvbox>
In-Reply-To: <1327228731.2540.3.camel@tvbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-01-2012 08:38, Malcolm Priestley escreveu:
> Support for m88brs2000 chip used in lmedm04 driver.
> 
> Note there are still lock problems.
> 
> Slow channel change due to the large block of registers sent in set_frontend.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---

...
> +static int m88rs2000_set_property(struct dvb_frontend *fe,
> +	struct dtv_property *p)
> +{
> +	dprintk("%s(..)\n", __func__);
> +	return 0;
> +}
> +
> +static int m88rs2000_get_property(struct dvb_frontend *fe,
> +	struct dtv_property *p)
> +{
> +	dprintk("%s(..)\n", __func__);
> +	return 0;
> +}
...

Just don't implement set_property/get_property if you're not using them.

Except for that, the code looks ok on my eyes.

Regards,
Mauro
