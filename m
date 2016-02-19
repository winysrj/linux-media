Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:49446 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbcBSKRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 05:17:44 -0500
Message-ID: <56C6EA14.7080405@lysator.liu.se>
Date: Fri, 19 Feb 2016 11:10:28 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Subject: m88ds3103: Undefined division
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I'm looking at this code in drivers/media/dvb-frontends/m88ds3103.c in
the m88ds3103_set_frontend() function, line 600 (give or take):

	s32tmp = 0x10000 * (tuner_frequency - c->frequency);
	s32tmp = DIV_ROUND_CLOSEST(s32tmp, priv->mclk_khz);
	if (s32tmp < 0)
		s32tmp += 0x10000;

There is code that tries to handle negative s32tmp, so I assume that
negative s32tmp is a possibility. Further, priv->mclk_khz is an unsigned
type as far as I can tell. But then we have this comment for the
DIV_ROUND_CLOSEST macro:

/*
 * Divide positive or negative dividend by positive divisor and round
 * to closest integer. Result is undefined for negative divisors and
 * for negative dividends if the divisor variable type is unsigned.
 */
#define DIV_ROUND_CLOSEST(x, divisor)(                  \

I don't know how bad this is, and what the consequences of garbage are,
but from here it looks like a problem waiting to happen...

Cheers,
Peter
