Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55290 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752898AbcFTWLN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 18:11:13 -0400
Date: Tue, 21 Jun 2016 00:59:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sre@kernel.org,
	linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	mchehab@osg.samsung.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20160620215938.GN24980@valkosipuli.retiisi.org.uk>
References: <1465659593-16858-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1465659593-16858-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160618152259.GC8392@amd>
 <201606181737.33116@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201606181737.33116@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pali,

On Sat, Jun 18, 2016 at 05:37:33PM +0200, Pali Rohár wrote:
> On Saturday 18 June 2016 17:22:59 Pavel Machek wrote:
> > > +/*
> > > + *
> > > + * Stingray sensor mode settings for Scooby
> > > + *
> > > + *
> > > + */
> > 
> > I'd fix it to normal comment style... and possibly remove it. Can you
> > understand what it says?
> > 
> > > +	},
> > > +	.regs = {
> > > +		{ ET8EK8_REG_8BIT, 0x1239, 0x4F },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x1238, 0x02 },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x123B, 0x70 },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x123A, 0x05 },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x121B, 0x63 },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x1220, 0x85 },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x1221, 0x00 },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x1222, 0x58 },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x1223, 0x00 },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x121D, 0x63 },	/*        */
> > > +		{ ET8EK8_REG_8BIT, 0x125D, 0x83 },	/*        */
> > > +		{ ET8EK8_REG_TERM, 0, 0}
> > > +	}
> > 
> > I'd remove the empty comments...
> > 
> > > +struct et8ek8_meta_reglist meta_reglist = {
> > > +	.version = "V14 03-June-2008",
> > 
> > Do we need the version?
> > 
> > > +	.reglist = {
> > > +		{ .ptr = &mode1_poweron_mode2_16vga_2592x1968_12_07fps },
> > > +		{ .ptr = &mode1_16vga_2592x1968_13_12fps_dpcm10_8 },
> > > +		{ .ptr = &mode3_4vga_1296x984_29_99fps_dpcm10_8 },
> > > +		{ .ptr = &mode4_svga_864x656_29_88fps },
> > > +		{ .ptr = &mode5_vga_648x492_29_93fps },
> > > +		{ .ptr = &mode2_16vga_2592x1968_3_99fps },
> > > +		{ .ptr = &mode_648x492_5fps },
> > > +		{ .ptr = &mode3_4vga_1296x984_5fps },
> > > +		{ .ptr = &mode_4vga_1296x984_25fps_dpcm10_8 },
> > > +		{ .ptr = 0 }
> > > +	}
> > > +};
> > 
> > I'd say .ptr = NULL.
> > 
> 
> Anyway, this code was generated from configuration ini files and perl 
> script available from: https://gitorious.org/omap3camera/camera-firmware
> 
> Originally in Maemo above C structure is compiled into binary file and 
> via request_firmware() loaded from userspace to kernel driver.
> 
> For me this sounds like a big overkill, so I included above reglist code 
> direcly into et8ek8 kernel driver to avoid request_firmware() and 
> separate userspace storage...

The idea at the time was that it'd be possible to support changes in the
register list without software changes as well as using different register
lists on a different device.

That's not really how device drivers are written. Considering that the use
cases for this very sensor driver seem rather different now than they did
then, I think it's safe to assume there won't be significant (if any at all)
changes to these configurations going forward.

I don't think there's really any value as such in maintaining the
compatibility with the data structures used in the camera-firmware
repository above.

> 
> And for smia-sensor (front webcam) in that gitorious repository is also 
> reglist structure. It is not needed? Can somebody investigate why it is 
> not needed?

The front camera is SMIA compliant and works (at least should!) with the
smiapp driver. I vaguely remember using it with platform data long, long
time ago. And I'm sure someone was working on it, I just don't remember now
who. :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
