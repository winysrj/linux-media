Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45681 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1EPGph (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 02:45:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [ANNOUNCE] New OMAP4 V4L2 Camera Project started
Date: Mon, 16 May 2011 08:46:41 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hansverk@cisco.com>, Rob Clark <rob@ti.com>
References: <BANLkTi=RVE0zk83K0hn89H3S6CKEmKSj2A@mail.gmail.com> <4DCDB846.1010204@iki.fi> <BANLkTikswdgo+z0dngcAXBiUH+8EgBEE3Q@mail.gmail.com>
In-Reply-To: <BANLkTikswdgo+z0dngcAXBiUH+8EgBEE3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105160846.42464.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Saturday 14 May 2011 01:23:34 Aguirre, Sergio wrote:
> On Fri, May 13, 2011 at 6:01 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Aguirre, Sergio wrote:

[snip]

> > - As far as I understand, the OMAP 4 ISS is partially similar to the
> > OMAP 3 one in design --- it has a hardware pipeline, that is. Fitting
> > the bus receivers and the ISP under an Media controller graph looks
> > relatively straightforward. The same might apply to SIMCOP, but then the
> > question is: what kind of interface should the SIMCOP have?
> 
> That's a big question :) And I'm yet not sure on that. I'll certainly need
> to think about it, and probably start planning for RFCs.
> 
> BTW, this driver is just implementing a super simple CSI2-A Rx -> MEM
> pipeline so far. I started with this because i wanted to avoid wasting my
> time on developing somethign huge, and having to do heavy rework after
> reviews take place.
> 
> > Being familiar with the history of the OMAP 3 ISP driver, I know this is
> > not a small project. Still, starting to use the Media controller in an
> > early phase would benefit the project in long run since the conversion
> > can be avoided later.
> 
> Agreed.
> 
> > Which parts of the ISS require regular attention from the M3s? Is it the
> > whole ISS or just the SIMCOP, for example?
> 
> In theory, the whole ISS, which includes SIMCOP, cna be driven from either
> A9 or M3 cores.
> 
> Architecturally, it's better to keep the dedicated M3 cores for driving ISS,
> and to save some considerable cycles from A9. Problem is, we have to deal
> with IPC communication channels, and that might make the driver much more
> complex and requiring much more software layers to be in place for that.

The current syslink implementation includes a mandatory userspace layer and 
makes it impossible for drivers to communicate with the M3. I've heard rumour 
that this might change. Do you have more information ?

> The long term vision about this is that, it might be good ot see how easy
> is to keep a Media Controller device, which sends the pipeline and subdevice
> configuration to M3 software, and just keep the Board specific and Usecases
> in A9 side.
> 
> Immediate problems are how to approach this with purely open source tools.
> (As far as I know, it's so far only possible with TI proprietary compilers)

gcc supports Cortex M3, doesn't it ? Is the limitation specific to your M3 
software that uses TI proprietary compiler (not based on gcc I assume ?), or 
are there gcc-specific issues as well ?

> So, it might definitely take this discussion to a much more complex level
> and more complete analysis. Hopefully we can have a good discussion about
> the long term future of this.
> 
> So far, I'm just starting with the simple stuff, ISS CSI2 Rx interface :)
>
> > Ps. I have nothing against SoC camera, but when I look at the ISS
> > overview diagram (section 8.1 in my TRM) I can't avoid thinking that
> > this is exactly what the Media controller was created for. :-)
> 
> The main reason why it started as a soc_camera is because I started this
> driver in a 2.6.35 android kernel, and refused to backport all the Media
> Controller patches to it :)
> 
> But now being based in mainline, that's a different story. ;)

As I've already mentioned, I believe the next step is to port the driver from 
soc_camera to the media controller.

-- 
Regards,

Laurent Pinchart
