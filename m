Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52729 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2DARY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 13:24:27 -0400
Message-ID: <4F788F49.202@iki.fi>
Date: Sun, 01 Apr 2012 20:24:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH][GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 support for AverTV
 A867R (mxl5007t tuner)
References: <4F75A7FE.8090405@iki.fi> <20120331185217.2c82c4ad@milhouse> <4F77DED5.2040103@iki.fi> <201204011915.47265.hfvogt@gmx.net>
In-Reply-To: <201204011915.47265.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.04.2012 20:15, Hans-Frieder Vogt wrote:
> Support of AVerMedia AVerTV HD Volar, with tuner MxL5007t (needs the i2c read bug fixed patch send earlier).

Could you sent separate patch for I2C read fix?

The only functional comment I has is about ADC frequency. There is 
Xtal/ADC lookup table already in af9033_priv.h. You could use it instead 
of adding new configuration parameter. Demodulator driver generally 
needs only Xtal frequency as a parameter, other can be usually 
discovered by driver.

But if you would not like to fix it, I will apply that as it is. It is 
not so important issue after all.

regards
Antti
-- 
http://palosaari.fi/
