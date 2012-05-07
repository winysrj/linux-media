Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:55505 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab2EGVOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 17:14:01 -0400
Received: from basile.localnet (ip6-localhost [IPv6:::1])
	by oyp.chewa.net (Postfix) with ESMTP id 140D7201BF
	for <linux-media@vger.kernel.org>; Mon,  7 May 2012 23:13:39 +0200 (CEST)
From: "=?iso-8859-15?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add fc0011 tuner driver
Date: Tue, 8 May 2012 00:13:58 +0300
References: <20120402181432.74e8bd50@milhouse> <4FA81C3A.1020108@iki.fi> <20120507230031.2b1e9e3c@milhouse>
In-Reply-To: <20120507230031.2b1e9e3c@milhouse>
MIME-Version: 1.0
Message-Id: <201205080013.58509.remi@remlab.net>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 8 mai 2012 00:00:31 Michael Büsch, vous avez écrit :
> > > +	dev_dbg(&priv->i2c->dev, "Tuned to "
> > > +		"fa=%02X fp=%02X xin=%02X%02X vco=%02X vcosel=%02X "
> > > +		"vcocal=%02X(%u) bw=%u\n",
> > > +		(unsigned int)regs[FC11_REG_FA],
> > > +		(unsigned int)regs[FC11_REG_FP],
> > > +		(unsigned int)regs[FC11_REG_XINHI],
> > > +		(unsigned int)regs[FC11_REG_XINLO],
> > > +		(unsigned int)regs[FC11_REG_VCO],
> > > +		(unsigned int)regs[FC11_REG_VCOSEL],
> > > +		(unsigned int)vco_cal, vco_retries,
> > > +		(unsigned int)bandwidth);
> > 
> > Just for the interest, is there any reason you use so much casting or is
> > that only your style?
> 
> Well it makes sure the types are what the format string and thus vararg
> code expects. it is true that most (probably all) of those explicit casts
> could be removed and instead rely on implicit casts and promotions. But I
> personally prefer explicit casts in this case (and only this case).

Not sure Linux printk supports it, but C specifies the "hh" prefix for 'char', 
and the "h" prefix for 'short' for instance "%02hhX", and this would also work 
for u8 and u16.

The pedantic in me needs to add that the official prefixes for uint8_t and 
uint16_t are the PRIX8 and PRIX16 macros from <inttypes.h>, e.g.:
	printf("%02"PRIX8"\n", regs[0]);
...but that's definitely not valid in kernel.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
