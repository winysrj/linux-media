Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3318 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2KWOB6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 09:01:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 00/12] Media Controller capture driver for DM365
Date: Fri, 23 Nov 2012 15:01:52 +0100
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	laurent.pinchart@ideasonboard.com
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com> <CA+V-a8t5ZJ2Zb+dWkifjjOHOrv1LAvgaJR2x24xKJXrTJs9+jg@mail.gmail.com> <20121123135753.GB31879@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121123135753.GB31879@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211231501.52852.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri November 23 2012 14:57:53 Sakari Ailus wrote:
> Hi Prabhakar,
> 
> On Fri, Nov 23, 2012 at 06:51:28PM +0530, Prabhakar Lad wrote:
> > Hi Sakari,
> > 
> > On Fri, Nov 23, 2012 at 6:43 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > > Hi Prabhakar and others,
> > >
> > > (Just resending; Laurent's e-mail address corrected, cc Hans, too.)
> > >
> > > On Fri, Nov 16, 2012 at 08:15:02PM +0530, Prabhakar Lad wrote:
> > >> From: Manjunath Hadli <manjunath.hadli@ti.com>
> > >>
> > >> This patch set adds media controller based capture driver for
> > >> DM365.
> > >>
> > >> This driver bases its design on Laurent Pinchart's Media Controller Design
> > >> whose patches for Media Controller and subdev enhancements form the base.
> > >> The driver also takes copious elements taken from Laurent Pinchart and
> > >> others' OMAP ISP driver based on Media Controller. So thank you all the
> > >> people who are responsible for the Media Controller and the OMAP ISP driver.
> > >>
> > >> Also, the core functionality of the driver comes from the arago vpfe capture
> > >> driver of which the isif capture was based on V4L2, with other drivers like
> > >> ipipe, ipipeif and Resizer.
> > >>
> > >> Changes for v2:
> > >> 1: Migrated the driver for videobuf2 usage pointed Hans.
> > >> 2: Changed the design as pointed by Laurent, Exposed one more subdevs
> > >>    ipipeif and split the resizer subdev into three subdevs.
> > >> 3: Rearrganed the patch sequence and changed the commit messages.
> > >> 4: Changed the file architecture as pointed by Laurent.
> > >>
> > >> Manjunath Hadli (12):
> > >>   davinci: vpfe: add v4l2 capture driver with media interface
> > >>   davinci: vpfe: add v4l2 video driver support
> > >>   davinci: vpfe: dm365: add IPIPEIF driver based on media framework
> > >>   davinci: vpfe: dm365: add ISIF driver based on media framework
> > >>   davinci: vpfe: dm365: add IPIPE support for media controller driver
> > >>   davinci: vpfe: dm365: add IPIPE hardware layer support
> > >>   davinci: vpfe: dm365: resizer driver based on media framework
> > >>   davinci: vpss: dm365: enable ISP registers
> > >>   davinci: vpss: dm365: set vpss clk ctrl
> > >>   davinci: vpss: dm365: add vpss helper functions to be used in the
> > >>     main driver for setting hardware parameters
> > >>   davinci: vpfe: dm365: add build infrastructure for capture driver
> > >>   davinci: vpfe: Add documentation
> > >
> > > As discussed, here's the todo list for inclusion to staging.
> > >
> > > - User space interface refinement
> > >         - Controls should be used when possible rather than private ioctl
> > >         - No enums should be used
> > >         - Use of MC and V4L2 subdev APIs when applicable
> > >         - Single interface header might suffice
> > >         - Current interface forces to configure everything at once
> > > - Get rid of the dm365_ipipe_hw.[ch] layer
> > > - Active external sub-devices defined by link configuration; no strcmp
> > >   needed
> > > - More generic platform data (i2c adapters)
> > > - The driver should have no knowledge of possible external subdevs; see
> > >   struct vpfe_subdev_id
> > > - Some of the hardware control should be refactorede
> > > - Check proper serialisation (through mutexes and spinlocks)
> > > - Names that are visible in kernel global namespace should have a common
> > >   prefix (or a few)
> > >
> > > This list likely isn't complete, but some items such as the locking one is
> > > there simply because I'm not certain of the state of it.
> > >
> > Thanks a lot. I'll include this TODO's in documentation patch itself,
> > But I am not sure if the driver is going in staging, the documentation
> > file would still be present under Documentation directory  or even
> > this should go in staging directory itself ?
> 
> I think it should go under staging, the same directory as the driver.
> 
> Hans, Mauro: could you confirm this?

I agree with that, that way things stay together in one directory.

Regards,

	Hans
