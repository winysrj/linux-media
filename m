Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:43142 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756527Ab1INMVp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 08:21:45 -0400
Date: Wed, 14 Sep 2011 14:22:12 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: recursive locking problem
Message-ID: <20110914122212.GB2161@minime.bse>
References: <4E68EE98.90201@iki.fi>
 <20110909114634.GA22776@minime.bse>
 <4E6FFD7E.2060500@iki.fi>
 <20110914061922.GA1851@minime.bse>
 <4E7085DB.2050809@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7085DB.2050809@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 14, 2011 at 01:45:47PM +0300, Antti Palosaari wrote:
> >>Interesting idea, but it didn't worked. It deadlocks. I think it
> >>locks since I2C-mux is controlled by I2C "switch" in same I2C bus,
> >>not GPIO or some other HW.
> >
> >Take a look at drivers/i2c/muxes/pca954x.c. You need to use
> >parent->algo->master_xfer/smbus_xfer directly as the lock that
> >protects you from having both gates open is the lock of the
> >root i2c bus.
> 
> Ah yes, rather similar case. I see it as commented in pca954x.c:
> /* Write to mux register. Don't use i2c_transfer()/i2c_smbus_xfer()
>    for this as they will try to lock adapter a second time */
> 
> This looks even more hackish solution than calling existing demod
> .i2c_gate_ctrl() callback from USB-interface driver. But yes, it
> must work - not beautiful but workable workaround.

This is not a hack. This is the official way to do it.
The I2C mux framework was designed to allow multiplexers controlled
through the same I2C bus.

  Daniel

