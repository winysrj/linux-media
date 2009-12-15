Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3237 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbZLOVBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 16:01:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: santiago.nunez@ridgerun.com
Subject: Re: [PATCH 0/4 v11] Support for TVP7002 in DM365
Date: Tue, 15 Dec 2009 22:01:45 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Grosen, Mark" <mgrosen@ti.com>,
	Diego Dompe <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>
References: <4B13E9EB.8020309@ridgerun.com> <200912080750.51463.hverkuil@xs4all.nl> <4B27E263.3020707@ridgerun.com>
In-Reply-To: <4B27E263.3020707@ridgerun.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912152201.45659.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 15 December 2009 20:24:19 Santiago Nunez-Corrales wrote:
> Hi Hans,
> 
> 
> I know you'be been busy and in the road lately. Just checking if you had 
> the chance to review this version of the code.

Done!

Regards,

	Hans

> 
> Regards,
> 
> Hans Verkuil wrote:
> > On Tuesday 08 December 2009 01:44:43 Santiago Nunez-Corrales wrote:
> >   
> >> Hans,
> >>
> >>
> >> Hi. Have you had a chance to look at this version of the driver?
> >>     
> >
> > Sorry, no. I hope to have some time on Thursday. I'm abroad for business at
> > the moment and unfortunately that leaves me with little time for reviewing.
> >
> > This is not just true for this driver, but also for the dm365 series that was
> > posted recently. And possibly others that I missed :-(
> >
> > Regards,
> >
> > 	Hans
> >
> >   
> >> Regards,
> >>
> >>
> >> Santiago.
> >>
> >> Santiago Nunez-Corrales wrote:
> >>     
> >>> This series of patches provide support for the TVP7002 decoder in DM365.
> >>>
> >>> Support includes:
> >>>
> >>> * Inclusion of the chip in v4l2 definitions
> >>> * Definition of TVP7002 specific data structures
> >>> * Kconfig and Makefile support
> >>>
> >>> This series corrects many issued pointed out by Snehaprabha Narnakaje,
> >>> Muralidharan Karicheri, Vaibhav Hiremath and Hans Verkuil and solves
> >>> testing problems.  Tested on DM365 TI EVM with resolutions 720p,
> >>> 1080i@60, 576P and 480P with video capture application and video
> >>> output in 480P, 576P, 720P and 1080I. This driver depends upon
> >>> board-dm365-evm.c and vpfe_capture.c to be ready for complete
> >>> integration. Uses the new V4L2 DV API sent by Muralidharan Karicheri.
> >>> Removed shadow register values. Removed unnecesary power down and up
> >>> of the device (tests work fine). Improved readability.
> >>>
> >>>
> >>>       
> >>
> >> Guayabos, Curridabat
> >> San Jose, Costa Rica
> >> +(506) 2271 1487
> >> +(506) 8313 0536
> >> http://www.ridgerun.com
> >>
> >>
> >>
> >>     
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
