Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46152 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3LSOWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 09:22:46 -0500
Date: Thu, 19 Dec 2013 14:22:41 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Frederik Himpe <fhimpe@telenet.be>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: stable regression: tda18271_read_regs: [1-0060|M] ERROR:
 i2c_transfer returned: -19
Message-ID: <20131219142241.GD3866@hercules>
References: <1386969579.3914.13.camel@piranha.localdomain>
 <20131214092443.622b069d@samsung.com>
 <1387223868.2892.1.camel@piranha.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387223868.2892.1.camel@piranha.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 16, 2013 at 08:57:48PM +0100, Frederik Himpe wrote:
> On za, 2013-12-14 at 09:24 -0200, Mauro Carvalho Chehab wrote:
> > Em Fri, 13 Dec 2013 22:19:39 +0100
> > Frederik Himpe <fhimpe@telenet.be> escreveu:
> > 
> > > [My excuses for multiposting, it seems gmane does not permit posting to all
> > > the relevant lists]
> > > 
> > > Since upgrading my system from Linux 3.12 to 3.12.3, my PCTV Systems
> > > nanoStick T2 290e does not work anymore.
> > > 
> > > This happens with 3.12.3:
> > > 
> 
> > > [    3.844020] tda18271 1-0060: creating new instance
> > > [    3.868422] tda18271_read_regs: [1-0060|M] ERROR: i2c_transfer returned: -19
> > > [    3.868492] Error reading device ID @ 1-0060, bailing out.
> > > [    3.868548] tda18271_attach: [1-0060|M] error -5 on line 1285
> > > [    3.868603] tda18271 1-0060: destroying instance
> > > [    3.868666] Em28xx: Initialized (Em28xx dvb Extension) extension
> > > [    3.894687] Registered IR keymap rc-pinnacle-pctv-hd
> > > [    3.894819] input: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/rc/rc0/input23
> > > [    3.894979] rc0: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/rc/rc0
> > > [    3.895570] Em28xx: Initialized (Em28xx Input Extension) extension
> > > 
> > > I see the same problem reported here:
> > > https://github.com/Hexxeh/rpi-firmware/issues/38 where it is mentioned
> > > that this regression also appeared in 3.10 stable series recently.
> > > 
> > > I noticed upstream commit 8393796dfa4cf5dffcceec464c7789bec3a2f471
> > > (media: dvb-frontends: Don't use dynamic static allocation)
> > > entered both 3.10.22 (which is the first version introducing the
> > > regression in 3.10 stable according to the linked bug), and 3.12.3.
> > > This file contains stuff related to tda18271. Could this be the 
> > > culprit?
> > > 
> > 
> > Well, for board EM28174_BOARD_PCTV_290E, it first attaches cxd2820r
> > and then the tuner tda18271.
> > 
> > I suspect that the issue is at cxd2820r. Could you please apply this
> > patch:
> > 	http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0db3fa2741ad8371c21b3a6785416a4afc0cc1d4 
> > and see if it solves the issue?
> 
> I have applied this patch to 3.12.5 and I can confirm it works fine now.
> Can this patch be applied to the stable series in order to fix this
> regression in stable?

I'm also queuing this patch for the 3.11 kernel.

Cheers,
--
Luis
