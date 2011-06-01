Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47423 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161201Ab1FAJaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 05:30:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: Capabilities of the Omap3 ISP driver
Date: Wed, 1 Jun 2011 11:30:05 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Felix v. Hundelshausen" <felix.v.hundelshausen@live.de>
References: <BANLkTineUffG1yd3Ey30wr0xzAj3_Zd1KQ@mail.gmail.com> <201105302347.24554.laurent.pinchart@ideasonboard.com> <BANLkTi=MY2soJTW50AgXHL4zQfoYRBzn3Q@mail.gmail.com>
In-Reply-To: <BANLkTi=MY2soJTW50AgXHL4zQfoYRBzn3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106011130.06049.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Wednesday 01 June 2011 10:18:21 Bastian Hecht wrote:
> 2011/5/30 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Monday 30 May 2011 23:39:13 Bastian Hecht wrote:
> >> 2011/5/30 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> >> > On Sunday 29 May 2011 15:27:23 Bastian Hecht wrote:
> >> >> Hello Laurent,
> >> >> 
> >> >> I'm on to a project that needs two synced separate small cameras for
> >> >> stereovision.
> >> >> 
> >> >> I was thinking about realizing this on an DM3730 with 2 aptina csi2
> >> >> cameras that are used in snapshot mode.
> >> > 
> >> > As far as I know, the DM3730 doesn't have CSI2 interfaces.
> >> 
> >> If I don't mix up datasheets, it is stated very clearly that 2 csi2
> >> interfaces are supported. I took the datasheet at
> >> http://www.ti.com/litv/pdf/sprugn4k declared as AM/DM37x Multimedia
> >> Device Technical Reference Manual (Silicon Revision 1.x) (Rev. K)
> >> (PDF  26851 KB).
> >> "The camera ISP implements three receivers which are named CSI2A,
> >> CSI1/CCP2B, and CSI2C. The CSI2A and CSI2C are MIPI D-PHY CSI2
> >> compatible." on page 1070.
> > 
> > Chapter 6 starts with the following disclaimer:
> > 
> > "NOTE: This chapter gives information about all modules and features in
> > the high-tier device. To check availability of modules and features, see
> > Section 1.5, AM/DM37x Family, and the device-specific data manual. In
> > unavailable modules and features, the memory area is reserved, read is
> > undefined, and write can lead to unpredictable behavior."
> > 
> > And if you look at table 1-3 on page 195, the CSI2 receivers are not
> > supported.
> 
> OK, that potentially saved me tons of work! I saw that the omap4 has 2
> csi2 interfaces (and I checked this note :). Unfortunately the panda
> board only leads out 1 csi2 channel.

And the OMAP4 ISS doesn't have a V4L2 driver :-(

> >> >> The questions that arise are:
> >> >> 
> >> >> - is the ISP driver capable of running 2 concurrent cameras?
> >> > 
> >> > Yes it can, but only one of them can use the CCDC, preview engine and
> >> > resizer. The other will be captured directly to memory as raw data.
> >> > You could capture both raw streams to memory, and then feed them
> >> > alternatively through the rest of the pipeline. Whether this can work
> >> > will depend on the image size and frame rate.
> >> 
> >> Ok I will check if it is sufficient to do any conversions on the cpu.
> >> 
> >> >> - is it possible to simulate a kind of video stream that is
> >> >> externally triggered (I would use a gpio line that simply triggers
> >> >> 10 times a sec) or would there arise problems with the csi2
> >> >> protocoll (timeouts or similar)?
> >> > 
> >> > I don't think there will be CSI2 issues (although I'm not an expert
> >> > there) if you trigger the sensors externally.
> >> 
> >> Nice, when the ISP side is probably no problem - do you have any
> >> experience with snapshot mode and know if cameras are capable of doing
> >> it at framerates about 10fps? It is just because snapshot mode sounds
> >> like taking 1 frame every now and then... can't they call it "trigger
> >> mode"? :)
> > 
> > I haven't personally tried it, but 10fps doesn't sound impossible to
> > reach with external triggers.
> 
> Nice.

-- 
Regards,

Laurent Pinchart
