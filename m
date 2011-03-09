Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57573 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1CIVz1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 16:55:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Subject: Re: [RFC] davinci: vpfe: mdia controller implementation for capture
Date: Wed, 9 Mar 2011 22:55:48 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
References: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF727@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF727@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103092255.49885.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Manjunath,

On Tuesday 08 March 2011 06:43:59 Hadli, Manjunath wrote:
> On Sun, Mar 06, 2011 at 22:59:40, Laurent Pinchart wrote:
> > On Sunday 06 March 2011 16:36:05 Manjunath Hadli wrote:
> > > Introduction
> > > ------------
> > > This is the proposal of the initial version of design and
> > > implementation of the Davinci family (dm644x,dm355,dm365)VPFE (Video
> > > Port Front End) drivers using Media Controloler , the initial version
> > > which supports the following:
> > > 1) dm365 vpfe
> > > 2) ccdc,previewer,resizer,h3a,af blocks
> > > 3) supports only continuous mode and not on-the-fly
> > > 4) supports user pointer exchange and memory mapped modes for buffer
> > > allocation
> > > 
> > > This driver bases its design on Laurent Pinchart's Media Controller
> > > Design whose patches for Media Controller and subdev enhancements form
> > > the base. The driver also takes copious elements taken from Laurent
> > > Pinchart and others' OMAP ISP driver based on Media Controller. So
> > > thank you all the people who are responsible for the Media Controller
> > > and the OMAP ISP driver.
> > 
> > You're welcome :-)
> > 
> > > Also, the core functionality of the driver comes from the arago vpfe
> > > capture driver of which the CCDC capture was based on V4L2, with other
> > > drivers like Previwer, Resizer and other being individual character
> > > drivers.
> > 
> > The CCDC, preview and resizer modules look very similar to their OMAP3
> > counterparts. I think we should aim at sharing code between the drivers.
> > It's hard enough to develop, review and maintain one driver, let's not
> > duplicate the effort.
> 
> Laurent, the modules in DM365 and DM355 are based on ISIF (for image
> capture) IPIPEIF, IPIPE and these modules are very different from that of
> their OMAP3 counterparts both in terms of hardware features,
> implementation and registers. The naming is done as CCDC, Previewer and
> Resizer only because to make it simple in understanding and making it
> comfortable for the API users of DM644X. I am aware of the discussion you
> and Vaibhav had, where he mentioned your point to make these drivers
> similar, and after Poring through the specs in detail we concluded that
> the approach can be the same but code-re-use is be minimal. So, we have
> derived the top level approach from you while the core implementation of
> hardware programming comes from arago.

I haven't checked all chips, but the DM644x ISP is very similar to the OMAP3 
ISP.

[snip]

> > > TODOs:
> > > ======
> > > 1. Single shot implementation for previewer and resizer.
> > > 2. Seperation of v4l2 video related structures and routines to aid
> > > single shot implementation.
> > > 3. Support NV12 format
> > > 4. Move the files from char folder to drivers/media/video along with
> > > headers
> > 
> > Why are the drivers in drivers/char for ?
> 
> This is WIP where some of the files are in char dir from arago
> implementation. You can see item 4 in the TODO list where this movement is
> pending.

OK. I'll review the driver when the code in drivers/char will be removed then 
:-)

-- 
Regards,

Laurent Pinchart
