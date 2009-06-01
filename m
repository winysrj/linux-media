Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZFATCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 15:02:05 -0400
Date: Mon, 1 Jun 2009 16:02:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "Paulraj, Sandeep" <s-paulraj@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Grosen, Mark" <mgrosen@ti.com>
Subject: Re: New Driver for DaVinci DM355/DM365/DM6446
Message-ID: <20090601160201.4f3bdd56@pedra.chehab.org>
In-Reply-To: <A24693684029E5489D1D202277BE8944405CFFE6@dlee02.ent.ti.com>
References: <C9D59C82B94F474B872F2092A87F261481797D4B@dlee07.ent.ti.com>
	<A24693684029E5489D1D202277BE8944405CFFE6@dlee02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Jun 2009 13:38:37 -0500
"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com> escreveu:

> > From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org] On Behalf Of Paulraj, Sandeep
> > Sent: Monday, June 01, 2009 5:56 PM
> > To: linux-media@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org; Grosen, Mark
> > Subject: New Driver for DaVinci DM355/DM365/DM6446
> > 
> > Hello,
> > 
> > WE have a module(H3A) on Davinci DM6446,DM355 and DM365.
> > 
> > Customers require a way to collect the data required to perform the Auto Exposure (AE), Auto Focus(AF), and Auto White balance (AWB) in hardware as opposed to software. > This is primarily for performance reasons as there is not enough software processing MIPS (to do 3A statistics) available in
> > an imaging/video system.
> > 
> > Including this block in hardware reduces the load on the processor and bandwidth to the memory as the data is collected on the fly from the imager.
> > 
> > This modules collects statistics and we currently implement it as a character driver.
> 
> This also exists in OMAP3 chips, and is part of the ISP module.
> 
> I maintain, along with Sakari Ailus, a V4L2 camera driver, which is currently just shared through a gitorious repository:
> 
> http://gitorious.org/omap3camera
> 
> The way we offer an interface for the user to be able to request this statistics is with the usage of private IOCTLs declared inside the same V4L2 capturing device driver.
> 
> So, that way we have a V4L2 driver which has a private call, instead of having it separately from the capture driver.

This seems to be a much better approach, provided that the private IOCTL's will
be properly documented on a public document. If there are enough usage for
they, we may even add them as an optional part of V4L2 API.



Cheers,
Mauro
