Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:54700 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751160Ab1INGS4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 02:18:56 -0400
Date: Wed, 14 Sep 2011 08:19:22 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: recursive locking problem
Message-ID: <20110914061922.GA1851@minime.bse>
References: <4E68EE98.90201@iki.fi>
 <20110909114634.GA22776@minime.bse>
 <4E6FFD7E.2060500@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E6FFD7E.2060500@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 14, 2011 at 04:03:58AM +0300, Antti Palosaari wrote:
> On 09/09/2011 02:46 PM, Daniel Glöckner wrote:
> >On Thu, Sep 08, 2011 at 07:34:32PM +0300, Antti Palosaari wrote:
> >>I am working with AF9015 I2C-adapter lock. I need lock I2C-bus since
> >>there is two tuners having same I2C address on same bus, demod I2C
> >>gate is used to select correct tuner.
> >
> >Would it be possible to use the i2c-mux framework to handle this?
> >Each tuner will then have its own i2c bus.
> 
> Interesting idea, but it didn't worked. It deadlocks. I think it
> locks since I2C-mux is controlled by I2C "switch" in same I2C bus,
> not GPIO or some other HW.

Take a look at drivers/i2c/muxes/pca954x.c. You need to use
parent->algo->master_xfer/smbus_xfer directly as the lock that
protects you from having both gates open is the lock of the
root i2c bus.

  Daniel
