Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:56699 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3KCNL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 08:11:58 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21110.19353.955592.163450@morden.metzler>
Date: Sun, 3 Nov 2013 14:11:53 +0100
To: Maik Broemme <mbroemme@parallels.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/12] DDBridge 0.9.10 driver updates
In-Reply-To: <20131103124601.GS7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
	<20131103085822.08e8406e@samsung.com>
	<20131103124601.GS7956@parallels.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maik Broemme writes:
 > Hi Mauro,
 > 
 > Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
 > > Em Sun, 3 Nov 2013 01:22:35 +0100
 > > Maik Broemme <mbroemme@parallels.com> escreveu:
 > > 
 > > > I've updated the current DDBridge to latest version 0.9.10 from Ralph
 > > > Metzler available at:
 > > > 
 > > > http://www.metzlerbros.de/dddvb/dddvb-0.9.10.tar.bz2
 > > > 
 > > > I've merged the driver to work with current v4l/dvb tree and I will
 > > > maintain the driver for v4l/dvb in future. 
 > > 
 > > Works for me.
 > > 
 > > > The coming patch series is
 > > > the first version and I explicitly want to get feedback and hints if
 > > > some parts are merged at wrong places, etc... The following changes
 > > > were made:
 > > > 
 > > >   - MSI enabled by default (some issues left with i2c timeouts)
 > > >   - no support for Digital Devices Octonet
 > > >   - no support for DVB Netstream
 > > >   - removed unused module parameters 'tt' and 'vlan' (used by Octonet)
 > > >   - removed unused registers to cleanup code (might be added later again
 > > >     if needed)
 > > 
 > > Be sure to not remove any feature that are currently needed for the
 > > already supported devices to work.
 > 
 > Of course I won't do. The Octonet and DVB Netstream weren't supported in
 > current driver. MSI is already supported but was not enabled by default
 > because the old 0.5 version currently in kernel had some problems with
 > it. However new one works fine with MSI - at least for me I'm using the
 > patchset myself already - but needs some further testing.

Some people still have problems with MSI. I am not sure if it depends on the 
board type and/or BIOS version, etc. 


Regards,
Ralph
