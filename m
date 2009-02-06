Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60515 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbZBFI1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2009 03:27:49 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sakari Ailus <sakari.ailus@nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
CC: "Nagalla, Hari" <hnagalla@ti.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 6 Feb 2009 13:57:26 +0530
Subject: RE: [REVIEW PATCH 00/14] OMAP3 camera + ISP + MT9P012 sensor driver
 v2
Message-ID: <19F8576C6E063C45BE387C64729E739403FA81B0D0@dbde02.ent.ti.com>
In-Reply-To: <497453DC.6020102@nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> bounces@redhat.com] On Behalf Of Sakari Ailus
> Sent: Monday, January 19, 2009 3:50 PM
> To: Aguirre Rodriguez, Sergio Alberto
> Cc: Nagalla, Hari; video4linux-list@redhat.com; linux-
> omap@vger.kernel.org; Tuukka.O Toivonen; linux-media@vger.kernel.org
> Subject: Re: [REVIEW PATCH 00/14] OMAP3 camera + ISP + MT9P012
> sensor driver v2
> 
> Aguirre Rodriguez, Sergio Alberto wrote:
> > Hi,
> >
> > I'm sending the following patchset for review to the relevant
> lists (linux-omap, v4l, linux-media).
> >
> > Includes:
> >  - Omap3 camera core + ISP drivers.
> >  - MT9P012 sensor driver (adapted to 3430SDP)
> >  - DW9710 lens driver (adapted to work with MT9P012 for SDP)
> >  - Necessary v4l2-int-device changes to make above drivers work
> >  - Redefine OMAP3 ISP platform device.
> >  - Review comments fixed from: (Thanks a lot for their time and
> help)
> >    - Hans Verkuil
> >    - Tony Lindgreen
> >    - Felipe Balbi
> >    - Vaibhav Hiremath
> >    - David Brownell
> 
> Hi Sergio,
> 
> We should try to figure out how we could synchronise our version of
> the
> ISP and camera ASAP before making any more changes... I wouldn't
> want to
> start posting a competing version. ;-)
> 
[Hiremath, Vaibhav] Sakari,
Can you share your version of code (either in form of patches or source) here onto the mailing list, so that everybody those who are interested will be aware of changes?

Atleast for me I would get prior view of changes which might affect BT656 support (posted on top of Sergio's patch).

Again one more thing I would like to bring to your notice is about sub-device framework. Also we need to plan for the migration from V4L2-int to sub-device framework, which is of equal important. I feel the more time we spend in merging and aligning offline, more we are carrying risk.

According to me as I mentioned before, the plan should be to push ISP-Camera with V4L2-int interface as early as possible with whatever minimal sensor/decoder support we have today, which will make sure that our underneath ISP-library is in place. Once that is placed in, we can have additional patches on top of it to add more features. 

In this way, we can plan for migration to sub-device framework and also be easier and simpler. Even if any customers are interested, they can pick it up the ISP library and start development on top of it.


> --
> Sakari Ailus
> sakari.ailus@nokia.com
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-
> request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

