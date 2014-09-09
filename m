Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33362 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaIIRk2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 13:40:28 -0400
Message-ID: <1410284421.3353.47.camel@paszta.hi.pengutronix.de>
Subject: Re: i.MX6 status for IPU/VPU/GPU
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Tim Harvey <tharvey@gateworks.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Tue, 09 Sep 2014 19:40:21 +0200
In-Reply-To: <540F26E5.50609@gmail.com>
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>
	 <20140728185949.GS13730@pengutronix.de> <53D6BD8E.7000903@gmail.com>
	 <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com>
	 <1407153257.3979.30.camel@paszta.hi.pengutronix.de>
	 <CAL8zT=iFatVPc1X-ngQPeY=DtH0GWH76UScVVRrHdk9L27xw5Q@mail.gmail.com>
	 <53FDE9E1.2000108@mentor.com>
	 <CAL8zT=iaMYait1j8C_U1smcRQn9Gw=+hvaObgQRaR_4FomGH8Q@mail.gmail.com>
	 <540F26E5.50609@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Am Dienstag, den 09.09.2014, 09:12 -0700 schrieb Steve Longerbeam:
> Hi Jean-Michel,
> 
> 
> On 09/09/2014 12:49 AM, Jean-Michel Hautbois wrote:
> > 2014-08-27 16:23 GMT+02:00 Steve Longerbeam <steve_longerbeam@mentor.com>:
> >
> >> Hi Jean-Michel, Phillip,
> > Hi Steve,
> >
> >> I've done some work on Philipp's June 12 patchset, converting
> >> the CSI driver to a CSI subdev entity, and fixing some issues here
> >> and there. This June 12 patchset doesn't appear to be a fully working
> >> driver, Phillip correct me if I am wrong. I can post this work as it
> >> exists, it is incomplete but compiles.
> > Dos it compile against a 3.17-rc3 kernel :) ?
> 
> No, not anymore, the original posted driver was against 3.16 IIRC.
> 
> >
> >> I've also worked out what I think is a workable video pipeline graph for i.MX,
> >> suitable for defining the entities, pads, and links. Unfortunately I haven't
> >> been able to spend as much time as I'd like on it.
> > This is very interesting, do you have written this somewhere ?
> 
> Yes, I'll try to find some time to create a pdf image.

I'd be very interested in this, too. I have in the meantime started to
implement everything that has a source or destination selector in the
Frame Synchronization Unit (FSU) as media entity. I wonder which of
these parts should reasonably be unified into a single entity:

	CSI0
	CSI1
	SMFC0
	SMFC1
	SMFC2
	SMFC3
	IC preprocessor (input to VF and ENC, if I understood correctly)
	IC viewfinder task (scaling, csc)
	IC encoding task
	IC post processing task
	IRT viewfinder task (rotation)
	IRT encoding task
	IRT post processing task
	VDIC (deinterlacing, combining)
	(and probably some entry for DP/DC/DMFC for the direct
	 viewfinder path)

I suppose the SMFC channels need to be separate because they can belong
to different pipelines (and each entity can only belong to one).
The three IC task entities could probably be combined with their
corresponding IRT task entity somehow, but that would be at the cost of
not being able to tell the kernel whether to rotate before or after
scaling, which might be useful when handling chroma subsampled formats.

I have put my current state up here:

git://git.pengutronix.de/git/pza/linux.git test/nitrogen6x-ipu-media

So far I've captured video through the SMFC on a Nitrogen6X board with
OV5652 parallel camera with this.

> >> The complete driver I posted to the list does have some minor issues
> >> mostly suggested by Hans Verkuil (switch to new selection API instead
> >> of cropping API for example). It is a full featured driver but it does not
> >> implement the media device framework, i.e. user does not have direct
> >> control of the video pipeline, rather the driver chooses the pipeline based
> >> on the traditional inputs from user (video format and controls).
> >>
> >> If there is interest I can submit another version of the traditional driver
> >> to resolve the issues. But media device is a major rework, so I don't
> >> know whether it would make sense to start from the traditional driver
> >> and then implement media device on top later, since media device
> >> is almost a complete rewrite.
> > I, at least, am interested by this driver, even in its "traditionnal"
> > form :). If you don't want to submit it directly because this is not
> > using media controller, this is ok, you can provide me a git repo in
> > order to get it, or send a patchset.
> 
> I think I'll follow Hans' proposal and submit it again to media-tree as
> a staging driver.

I'm not too fond of adding a staging driver that we know will have to be
replaced. Maybe we could work together to get a media entity based
version up to speed?

regards
Philipp

