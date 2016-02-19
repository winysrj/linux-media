Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35090 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbcBSKqq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 05:46:46 -0500
Subject: Re: m88ds3103: Undefined division
To: Peter Rosin <peda@lysator.liu.se>
References: <56C6EA14.7080405@lysator.liu.se>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56C6F292.3090508@iki.fi>
Date: Fri, 19 Feb 2016 12:46:42 +0200
MIME-Version: 1.0
In-Reply-To: <56C6EA14.7080405@lysator.liu.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/2016 12:10 PM, Peter Rosin wrote:
> Hi!
>
> I'm looking at this code in drivers/media/dvb-frontends/m88ds3103.c in
> the m88ds3103_set_frontend() function, line 600 (give or take):
>
> 	s32tmp = 0x10000 * (tuner_frequency - c->frequency);
> 	s32tmp = DIV_ROUND_CLOSEST(s32tmp, priv->mclk_khz);
> 	if (s32tmp < 0)
> 		s32tmp += 0x10000;
>
> There is code that tries to handle negative s32tmp, so I assume that
> negative s32tmp is a possibility. Further, priv->mclk_khz is an unsigned
> type as far as I can tell. But then we have this comment for the
> DIV_ROUND_CLOSEST macro:
>
> /*
>   * Divide positive or negative dividend by positive divisor and round
>   * to closest integer. Result is undefined for negative divisors and
>   * for negative dividends if the divisor variable type is unsigned.
>   */
> #define DIV_ROUND_CLOSEST(x, divisor)(                  \
>
> I don't know how bad this is, and what the consequences of garbage are,
> but from here it looks like a problem waiting to happen...

Divisor type (mclk) needs to be changed signed then somehow...

regards
Antti

-- 
http://palosaari.fi/
