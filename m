Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:48191 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIKBRH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 21:17:07 -0400
Message-ID: <5410F80F.5060803@mentor.com>
Date: Wed, 10 Sep 2014 18:17:03 -0700
From: Steve Longerbeam <steve_longerbeam@mentor.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>
CC: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Tim Harvey <tharvey@gateworks.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	<linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: i.MX6 status for IPU/VPU/GPU
References: <CAL8zT=jms4ZAvFE3UJ2=+sLXWDsgz528XUEdXBD9HtvOu=56-A@mail.gmail.com>	 <20140728185949.GS13730@pengutronix.de> <53D6BD8E.7000903@gmail.com>	 <CAJ+vNU2EiTcXM-CWTLiC=4c9j-ovGFooz3Mr82Yq_6xX1u2gbA@mail.gmail.com>	 <1407153257.3979.30.camel@paszta.hi.pengutronix.de>	 <CAL8zT=iFatVPc1X-ngQPeY=DtH0GWH76UScVVRrHdk9L27xw5Q@mail.gmail.com>	 <53FDE9E1.2000108@mentor.com>	 <CAL8zT=iaMYait1j8C_U1smcRQn9Gw=+hvaObgQRaR_4FomGH8Q@mail.gmail.com>	 <540F26E5.50609@gmail.com> <1410284421.3353.47.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1410284421.3353.47.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phillip,

On 09/09/2014 10:40 AM, Philipp Zabel wrote:
>
>>>> I've also worked out what I think is a workable video pipeline graph for i.MX,
>>>> suitable for defining the entities, pads, and links. Unfortunately I haven't
>>>> been able to spend as much time as I'd like on it.
>>> This is very interesting, do you have written this somewhere ?
>> Yes, I'll try to find some time to create a pdf image.
> I'd be very interested in this, too.

I should have something to show tomorrow.

>  I have in the meantime started to
> implement everything that has a source or destination selector in the
> Frame Synchronization Unit (FSU) as media entity. I wonder which of
> these parts should reasonably be unified into a single entity:
>
> 	CSI0
> 	CSI1

Yes, we need a CSI subdev/entity, and it can be instantiated twice for
the two CSI ports.

> 	SMFC0
> 	SMFC1
> 	SMFC2
> 	SMFC3

I don't really see the need for an SMFC entity. The SMFC control can
be integrated into the CSI subdev.

> 	IC preprocessor (input to VF and ENC, if I understood correctly)
> 	IC viewfinder task (scaling, csc)
> 	IC encoding task
> 	IC post processing task

I see either three different IC subdev entities (IC prpenc, IC prpvf,
IC pp), or a single IC entity with three sink pads for each IC task.

> 	IRT viewfinder task (rotation)
> 	IRT encoding task
> 	IRT post processing task

well, the IRT is really just a submodule enable bit, I see no need
for an IRT subdev, in fact IRT has already been folded into ipu-ic.c
as a simple submodule enable/disable. Rotation support can be
implemented as part of the IC entities.

> 	VDIC (deinterlacing, combining)

I am thinking VDIC support can be part of the IC prpvf entity (well,
combining is not really on my radar, I haven't given that much thought).

> 	(and probably some entry for DP/DC/DMFC for the direct
> 	 viewfinder path)

Ugh, I've been ignoring that path as well. Freescale's BSP releases
and sample code from their SDK's have no example code for the
direct-to-DP/DC/DMFC camera viewfinder path, so given the quality
of the imx TRM, this could be a challenge to implement. Have you
gotten this path to work?

>
> I suppose the SMFC channels need to be separate because they can belong
> to different pipelines (and each entity can only belong to one).

I see the chosen SMFC channel as an internal decision by the
CSI subdev.

> The three IC task entities could probably be combined with their
> corresponding IRT task entity somehow, but that would be at the cost of
> not being able to tell the kernel whether to rotate before or after
> scaling, which might be useful when handling chroma subsampled formats.

I'm fairly sure IC rotation must always occur _after_ scaling. I.e.
raw frames are first passed through IC prpenc/prpvf/pp for scaling/CSC,
then EOF completion of that task is hardware linked to IRT.

>
> I have put my current state up here:
>
> git://git.pengutronix.de/git/pza/linux.git test/nitrogen6x-ipu-media
>
> So far I've captured video through the SMFC on a Nitrogen6X board with
> OV5652 parallel camera with this.

Thanks Phillip, I'll take a look! Sounds like a good place to start.
I assume this is with the video mux entity and CSI driver? I.e. no
IC entity support yet for scaling, CSC, or rotation.

Steve

