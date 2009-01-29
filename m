Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51950 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZA2UUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 15:20:01 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>
Date: Fri, 30 Jan 2009 01:49:50 +0530
Subject: RE: [REVIEW PATCH 2/2] OMAP3EVM Multi-Media Daughter Card Support
Message-ID: <19F8576C6E063C45BE387C64729E739403FA7901CD@dbde02.ent.ti.com>
In-Reply-To: <200901292032.48972.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Friday, January 30, 2009 1:03 AM
> To: Hiremath, Vaibhav
> Cc: linux-omap@vger.kernel.org; linux-media@vger.kernel.org; Jadav,
> Brijesh R; Shah, Hardik
> Subject: Re: [REVIEW PATCH 2/2] OMAP3EVM Multi-Media Daughter Card
> Support
> 
> On Thursday 29 January 2009 20:22:30 hvaibhav@ti.com wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > This is second version of OMAP3EVM Mulit-Media/Mass Market
> > Daughter Card support.
> >
> > Fixes:
> >     - Cleaned unused header files, struct formating, and unused
> >       comments.
> >     - Pad/mux configuration handled in mux.ch
> >     - mux.ch related changes moved to seperate patch
> >     - Renamed file board-omap3evm-dc.c to board-omap3evm-dc-v4l.c
> >       to make more explicit.
> >     - Added some more meaningful name for Kconfig option
> >
> > TODO:
> >     - Camera sensor support (for future development).
> >     - Driver header file inclusion (dependency on ISP-Camera
> patches)
> >       I am working with Sergio to seperate/move header file to
> standard
> >       location.
> >     - Still need to fix naming convention for DC
> >
> > Tested:
> >     - TVP5146 (BT656) decoder interface on top of
> >       Sergio's ISP-Camera patches.
> >     - Loopback application, capturing image through TVP5146
> >       and saving it to file per frame.
> 
> What is the status of converting tvp5146 to v4l2_subdev? The longer
> it takes
> to convert it, the harder it will be now that you are starting to
> use this
> driver. v4l2_int_device should be phased out, preferably by 2.6.30.
> 
> I'm more than happy to assist in this conversion, but please try to
> do this
> asap!
> 
[Hiremath, Vaibhav] Hans, I understand your concerns here. The TVP driver has strong dependency on ISP-Camera driver (Master) and without which it really doesn't make sense atleast for me. So actually I was trying to finish the ISP-Camera with V4L2-int and then migrate everything to the sub-devices. I am working with Sergio to finish this as early as possible.
As far as sub-device framework is concerned, we have taken pro-active steps. If I understand correctly Davinci team here has already started migrating to the sub-device framework and the patches are under review internally. Soon you will see some patches on v4L mailing list for this.

> Thanks,
> 
> 	Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

