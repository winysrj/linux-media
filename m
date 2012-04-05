Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53843 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab2DEXwy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Apr 2012 19:52:54 -0400
Message-ID: <4F7E3052.1050907@iki.fi>
Date: Fri, 06 Apr 2012 02:52:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, m@bues.ch, hfvogt@gmx.net,
	mchehab@redhat.com
Subject: Re: [PATCH] af9033: implement get_frontend
References: <1333644439-1875-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1333644439-1875-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.04.2012 19:47, Gianluca Gennari wrote:
> Implement the get_frontend function.

> +	struct dtv_frontend_properties *p =&fe->dtv_property_cache;

Commonly dtv_property_cache pointer is shorten as a letter c (cache) in 
all demod drivers and old dvb_frontend_parameters used earlier was letter p.

> +	p->inversion = INVERSION_AUTO;
> +	p->frequency = state->frequency;

Fake resolving parameters is not appropriate as I understand. We should 
just return parameters we can read from the hardware and not to guess 
nor default some auto value.

I will applied that and make some changes as I explained.

http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

regards
Antti
-- 
http://palosaari.fi/
