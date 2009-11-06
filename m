Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1905 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZKFGZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2009 01:25:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: santiago.nunez@ridgerun.com
Subject: Re: [PATCH 0/4 v6] Support for TVP7002 in DM365
Date: Fri, 6 Nov 2009 07:25:53 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Grosen, Mark" <mgrosen@ti.com>,
	Diego Dompe <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>
References: <4AF1B89C.5000108@ridgerun.com> <200911051721.58407.hverkuil@xs4all.nl> <4AF3217E.5030802@ridgerun.com>
In-Reply-To: <4AF3217E.5030802@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911060725.53572.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 November 2009 20:03:26 Santiago Nunez-Corrales wrote:
> My apologies, found that I had the wrong mailing list email for linux-media.
> 
> Sending patches (hopefully) for the last time.

Sorry, but I still do not see any patches on either linux-media or
davinci-linux-open-source...

Regards,

	Hans

> 
> 
> Santiago.
> 
> Hans Verkuil wrote:
> > On Wednesday 04 November 2009 18:23:40 Santiago Nunez-Corrales wrote:
> >   
> >> This series of patches provide support for the TVP7002 decoder in DM365.
> >>
> >> Support includes:
> >>
> >> * Inclusion of the chip in v4l2 definitions
> >> * Definition of TVP7002 specific data structures
> >> * Kconfig and Makefile support
> >>
> >> This series corrects many issued pointed out by Snehaprabha Narnakaje,
> >> Muralidharan Karicheri, Vaibhav Hiremath and Hans Verkuil and solves
> >> testing problems.  Tested on DM365 TI EVM with resolutions 720p,
> >> 1080i@60, 576P and 480P with video capture application and video
> >> output in 480P, 576P, 720P and 1080I. This driver depends upon 
> >> board-dm365-evm.c and vpfe_capture.c to be ready for complete 
> >> integration. Uses the new V4L2 DV API sent by Muralidharan Karicheri.
> >>
> >>
> >>     
> >
> > Erm, where is the rest of the series? :-)
> >
> > Regards,
> >
> > 	Hans
> >
> >   
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
