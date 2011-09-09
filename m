Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:59384 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758154Ab1IILqP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 07:46:15 -0400
Date: Fri, 9 Sep 2011 13:46:34 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: recursive locking problem
Message-ID: <20110909114634.GA22776@minime.bse>
References: <4E68EE98.90201@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E68EE98.90201@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 08, 2011 at 07:34:32PM +0300, Antti Palosaari wrote:
> I am working with AF9015 I2C-adapter lock. I need lock I2C-bus since
> there is two tuners having same I2C address on same bus, demod I2C
> gate is used to select correct tuner.

Would it be possible to use the i2c-mux framework to handle this?
Each tuner will then have its own i2c bus.

  Daniel
