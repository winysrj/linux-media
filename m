Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53295 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1LJLrq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 06:47:46 -0500
Message-ID: <4EE346E0.7050606@iki.fi>
Date: Sat, 10 Dec 2011 13:47:44 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 09/10] CXD2820r: Query DVB frontend delivery capabilities
References: <CAHFNz9+=T5XGok+LvhVqeSVdWt=Ng6wgXqcHdtdw19a+whx1bw@mail.gmail.com>
In-Reply-To: <CAHFNz9+=T5XGok+LvhVqeSVdWt=Ng6wgXqcHdtdw19a+whx1bw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Manu,
That patch looks now much acceptable than the older for my eyes, since 
you removed that .set_state() (change from .set_params() to 
.set_state()) I criticized. Thanks!


On 12/10/2011 06:44 AM, Manu Abraham wrote:
>   static int cxd2820r_set_frontend(struct dvb_frontend *fe,
[...]
> +	switch (c->delivery_system) {
> +	case SYS_DVBT:
> +		ret = cxd2820r_init_t(fe);

> +		ret = cxd2820r_set_frontend_t(fe, p);


Anyhow, I don't now like idea you have put .init() calls to 
.set_frontend(). Could you move .init() happen in .init() callback as it 
was earlier?


regards
Antti
-- 
http://palosaari.fi/
