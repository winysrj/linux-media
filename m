Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45315 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab2G1U5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jul 2012 16:57:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: abel@uni-bielefeld.de, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	linux-media@vger.kernel.org, Atsuo Kuwahara <kuwahara@ti.com>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>
Subject: Re: Advice on extending libv4l for media controller support
Date: Sat, 28 Jul 2012 21:11:03 +0200
Message-ID: <2405728.QMNhJU8RvB@avalon>
In-Reply-To: <5013C30B.7030600@redhat.com>
References: <CAC-OdnBNiT35tc_50QAXvVp8+b5tWLMWqc5i1q3qWYTp5c360g@mail.gmail.com> <5011AD6A.9040609@uni-bielefeld.de> <5013C30B.7030600@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Saturday 28 July 2012 12:46:35 Hans de Goede wrote:
> On 07/26/2012 10:49 PM, Robert Abel wrote:
> > Sorry to be late to the party... I wanted to follow up on this discussion,
> > but forgot and haven't read anything about it since...> 
> > On 10.05.2012 17:09, Ivan T. Ivanov wrote:
> >> On Wed, May 9, 2012 at 7:08 PM, Sergio Aguirre
> >> 
> >> <sergio.a.aguirre@gmail.com>  <mailto:sergio.a.aguirre@gmail.com>  wrote:
> >>> I want to create some sort of plugin with specific media
> >>> controller configurations,
> >>> to avoid userspace to worry about component names and specific
> >>> usecases (use sensor resizer, or SoC ISP resizer, etc.).
> >> 
> >> Probably following links can help you. They have been tested
> >> with the OMAP3 ISP.
> >> 
> >> Regards,
> >> iivanov
> >> 
> >> [1]http://www.spinics.net/lists/linux-media/msg31901.html
> >> [2]
> >> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/
> >> 32704> 
> > I recently extended Yordan Kamenov's libv4l-mcplugin to support multiple
> > trees per device with extended configurations (-stolen from- inspired by
> > media-ctl) not tied to specific device nodes (but to device names
> > instead).
> > 
> > I uploaded the patches here
> > <https://sites.google.com/site/rawbdagslair/libv4l-mcplugin.7z?attredirec
> > ts=0&d=1>(16kB). Basically, I used Yordan's patches as a base and worked
> > from there to fix up his source code and Makefile for cross-compiling
> > using OpenEmbedded/Yocto.
> > 
> > There are a ton of minor issues with this, starting with the fact that I
> > did not put proper copyright notices in any of these files. Please advise
> > if this poses a problem. Only integral frame size support and no support
> > for native read() calls. There's a dummy read() function, because for
> > some reason this is required in libv4l2 0.9.0-test though it's not
> > mentioned anywhere. As the original plug-in by Yordan, there is currently
> > no cleaning-up of the internal data structures.
> > 
> > I used this in conjunction with the Gumstix CASPA FS (MT9V032) camera
> > using some of Laurent's patches and some custom patches which add
> > ENUM_FMT support to the driver.
> > 
> > Basically, upon opening a given device, all trees are configured once to
> > load the respective end-point's formats for emulation of setting and
> > getting formats. Then regular format negotiation by the user application
> > takes place.
> As discussed higher up in this thread, since the initial libv4l-mcplugin was
> done for the omap3, we've had several meetings on the topic of libv4l and
> media-controller using devices and we came to the following conclusions:
> 
> 1) The existing mediactl lib would be extended with a libmediactlvideo lib,
> which would be able to control media-ctrl video chains, ie it can:
> -give a list of possibly supported formats / sizes / framerates
> -setup the chain to deliver a requested format
> Since the optimal setup will be hardware specific the idea was to give this
> libs per soc plugins, and a generic plugin for simple socs / as fallback.
> 
> 2) A cmdline utility to set up a chain using libmediactlvideo, so that
> things can be tested using raw devices, ie without libv4l2 coming into
> play, just like apps like v4l2-ctl allow low level control mostly for
> testing purposes
> 
> 3) There would then be a libv4l2 plugin much like the above linked omap3
> plugin, but then generic for any mediactl using video devices, which would
> use libmediactlvideo to do the work of setting up the chain (and which will
> fail to init when the to be opened device is not part of a mediactl
> controlled chain).
> 
> And AFAIK some work was done in this direction. Sakari? Laurent?

I'm currently in a plane to Finland to work on this with Sakari next week. You 
should hopefully hear from us soon :-)

> Eitherway it is about time someone started working on this, and I would
> greatly prefer the above plan to be implemented. Once we have this in place,
> then we can do a new v4l-utils release which officially supports the plugin
> API (which currently only lives in master, not in any releases).

-- 
Regards,

Laurent Pinchart

