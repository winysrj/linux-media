Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:58349 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab3KCMqE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Nov 2013 07:46:04 -0500
Date: Sun, 3 Nov 2013 13:46:01 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/12] DDBridge 0.9.10 driver updates
Message-ID: <20131103124601.GS7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
 <20131103085822.08e8406e@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131103085822.08e8406e@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> Em Sun, 3 Nov 2013 01:22:35 +0100
> Maik Broemme <mbroemme@parallels.com> escreveu:
> 
> > I've updated the current DDBridge to latest version 0.9.10 from Ralph
> > Metzler available at:
> > 
> > http://www.metzlerbros.de/dddvb/dddvb-0.9.10.tar.bz2
> > 
> > I've merged the driver to work with current v4l/dvb tree and I will
> > maintain the driver for v4l/dvb in future. 
> 
> Works for me.
> 
> > The coming patch series is
> > the first version and I explicitly want to get feedback and hints if
> > some parts are merged at wrong places, etc... The following changes
> > were made:
> > 
> >   - MSI enabled by default (some issues left with i2c timeouts)
> >   - no support for Digital Devices Octonet
> >   - no support for DVB Netstream
> >   - removed unused module parameters 'tt' and 'vlan' (used by Octonet)
> >   - removed unused registers to cleanup code (might be added later again
> >     if needed)
> 
> Be sure to not remove any feature that are currently needed for the
> already supported devices to work.

Of course I won't do. The Octonet and DVB Netstream weren't supported in
current driver. MSI is already supported but was not enabled by default
because the old 0.5 version currently in kernel had some problems with
it. However new one works fine with MSI - at least for me I'm using the
patchset myself already - but needs some further testing.

> > 
> > The following devices are supported by the driver update:
> > 
> >   - Octopus DVB adapter
> >   - Octopus V3 DVB adapter
> >   - Octopus LE DVB adapter
> >   - Octopus OEM
> >   - Octopus Mini
> >   - Cine S2 V6 DVB adapter
> >   - Cine S2 V6.5 DVB adapter
> >   - Octopus CI
> >   - Octopus CI single
> >   - DVBCT V6.1 DVB adapter
> >   - DVB-C modulator
> >   - SaTiX-S2 V3 DVB adapter
> > 
> > I might merge the Octonet and DVB Netstream drivers from Ralphs source
> > later once the current committed DDBridge driver updates are merged in
> > mainline.
> > 
> > Signed-off-by: Maik Broemme <mbroemme@parallels.com>
> > 
> > Maik Broemme (12):
> >   dvb-frontends: Support for DVB-C2 to DVB frontends
> >   tda18271c2dd: Fix description of NXP TDA18271C2 silicon tuner
> >   stv0367dd: Support for STV 0367 DVB-C/T (DD) demodulator
> >   tda18212dd: Support for NXP TDA18212 (DD) silicon tuner
> >   cxd2843: Support for CXD2843ER demodulator for DVB-T/T2/C/C2
> >   dvb-core: export dvb_usercopy and new DVB device constants
> >   ddbridge: Updated ddbridge registers
> >   ddbridge: Moved i2c interfaces into separate file
> >   ddbridge: Support for the Digital Devices Resi DVB-C Modulator card
> >   ddbridge: Update ddbridge driver to version 0.9.10
> >   ddbridge: Update ddbridge header for 0.9.10 changes
> >   ddbridge: Kconfig and Makefile fixes to build latest ddbridge
> > 
> >  drivers/media/dvb-core/dvbdev.c              |    1 
> >  drivers/media/dvb-core/dvbdev.h              |    2 
> >  drivers/media/dvb-frontends/Kconfig          |   31 
> >  drivers/media/dvb-frontends/Makefile         |    3 
> >  drivers/media/dvb-frontends/cxd2843.c        | 1647 ++++++++++++
> >  drivers/media/dvb-frontends/cxd2843.h        |   47 
> >  drivers/media/dvb-frontends/stv0367dd.c      | 2329 ++++++++++++++++++
> >  drivers/media/dvb-frontends/stv0367dd.h      |   48 
> >  drivers/media/dvb-frontends/stv0367dd_regs.h | 3442 +++++++++++++++++++++++++++
> >  drivers/media/dvb-frontends/tda18212dd.c     |  934 +++++++
> >  drivers/media/dvb-frontends/tda18212dd.h     |   37 
> >  drivers/media/pci/ddbridge/Kconfig           |   21 
> >  drivers/media/pci/ddbridge/Makefile          |    2 
> >  drivers/media/pci/ddbridge/ddbridge-core.c   | 3085 +++++++++++++++++-------
> >  drivers/media/pci/ddbridge/ddbridge-i2c.c    |  239 +
> >  drivers/media/pci/ddbridge/ddbridge-mod.c    | 1033 ++++++++
> >  drivers/media/pci/ddbridge/ddbridge-regs.h   |  273 +-
> >  drivers/media/pci/ddbridge/ddbridge.h        |  408 ++-
> >  include/uapi/linux/dvb/frontend.h            |    1 
> >  19 files changed, 12555 insertions(+), 1028 deletions(-)
> > 
> > --Maik
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Thanks for your submission.
> 
> I'm seeing this entire patch series as an RFC. There are simply too much
> changes required for us to be able to do a more detailed review on it.
> 

Many thanks for the feedback.

> Please do the pointed changes, in special:
> 
> 	- Don't let any patch to break compilation;
> 
> 	- Please verify the Documentation/CodingStyle and check it with
> 		./scripts/checkpatch.pl;
> 
> 	- Please discuss on a separate thread the API changes for CI,
> 	  modulator and DVB-C2;
> 
> 	- Please try to break the ddbridge changes into one change per
> 	  patch. If not possible, please try to at least break them more,
> 	  to help us to review the changes;
> 
> 	- Please don't duplicate existing drivers without a very very good
> 	  reason.
> 

I will address the concerns with re-submission of the patches. Most
probably it is worth to split the patchset a bit. The CXD2843
demodulator can also be used by other drivers so I will address your
feedback on this driver first and re-submit. Once it is fine I will
re-send changes for ddbridge. Hope it is a good approach. :)

> Thanks!
> Mauro

--Maik
