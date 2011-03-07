Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42565 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1CGVTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 16:19:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: David Cohen <dacohen@gmail.com>
Subject: Re: [PATCH] omap: iommu: disallow mapping NULL address
Date: Mon, 7 Mar 2011 22:19:32 +0100
Cc: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
	Hiroshi.DOYU@nokia.com,
	Michael Jones <michael.jones@matrix-vision.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org
References: <4D6D219D.7020605@matrix-vision.de> <AANLkTi=KncNfW0NEEoV+mrT_Ft2j-c=rQG=qbeR6tLQK@mail.gmail.com> <AANLkTimac512Gu0_vyPjThvNxXHsXTRD73B0d1bHnnAg@mail.gmail.com>
In-Reply-To: <AANLkTimac512Gu0_vyPjThvNxXHsXTRD73B0d1bHnnAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103072219.32938.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi David,

On Monday 07 March 2011 20:41:21 David Cohen wrote:
> On Mon, Mar 7, 2011 at 9:25 PM, Guzman Lugo, Fernando wrote:
> > On Mon, Mar 7, 2011 at 1:19 PM, David Cohen wrote:
> >> On Mon, Mar 7, 2011 at 9:17 PM, Guzman Lugo, Fernando wrote:
> >>> On Mon, Mar 7, 2011 at 7:10 AM, Michael Jones wrote:
> >>>> From e7dbe4c4b64eb114f9b0804d6af3a3ca0e78acc8 Mon Sep 17 00:00:00 2001
> >>>> From: Michael Jones <michael.jones@matrix-vision.de>
> >>>> Date: Mon, 7 Mar 2011 13:36:15 +0100
> >>>> Subject: [PATCH] omap: iommu: disallow mapping NULL address
> >>>> 
> >>>> commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
> >>>> the NULL address if da_start==0.  Force da_start to exclude the
> >>>> first page.
> >>> 
> >>> what about devices that uses page 0? ipu after reset always starts
> >>> from 0x00000000 how could we map that address??
> >> 
> >> from 0x0? The driver sees da == 0 as error. May I ask you why do you
> >> want it?
> > 
> > unlike DSP that you can load a register with the addres the DSP will
> > boot, IPU core always starts from address 0x00000000, so if you take
> > IPU out of reset it will try to access address 0x0 if not map it,
> > there will be a mmu fault.
> 
> Hm. Looks like the iommu should not restrict any da. The valid da
> range should rely only on pdata.
> Michael, what about just update ISP's da_start on omap-iommu.c file?
> Set it to 0x1000.

What about patching the OMAP3 ISP driver to use a non-zero value (maybe -1) as 
an invalid/freed pointer ?

-- 
Regards,

Laurent Pinchart
