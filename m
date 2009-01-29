Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3317 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbZA2Llg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 06:41:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Compiler warnings in pxa_camera.c
Date: Thu, 29 Jan 2009 12:41:28 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200901291029.27243.hverkuil@xs4all.nl> <Pine.LNX.4.64.0901291110100.5474@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0901291110100.5474@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291241.28756.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 January 2009 11:19:39 Guennadi Liakhovetski wrote:
> On Thu, 29 Jan 2009, Hans Verkuil wrote:
> > Hi Guennadi,
>
> Hi Hans,
>
> > For some time now I see the following warnings in pxa_camera.c under
> > kernels 2.6.27 and 2.6.28 in the daily build:
> >
> >   CC [M]  /marune/build/v4l-dvb-master/v4l/soc_camera.o
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:54:1: warning: "CICR0"
> > redefined In file included from
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:43:
> > arch/arm/mach-pxa/include/mach/pxa-regs.h:615:1: warning: this is the
> > location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:55:1: warning: "CICR1"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:616:1: warning:
> > this is the location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:56:1: warning: "CICR2"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:617:1: warning:
> > this is the location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:57:1: warning: "CICR3"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:618:1: warning:
> > this is the location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:58:1: warning: "CICR4"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:619:1: warning:
> > this is the location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:59:1: warning: "CISR"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:620:1: warning:
> > this is the location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:60:1: warning: "CIFR"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:621:1: warning:
> > this is the location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:61:1: warning: "CITOR"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:622:1: warning:
> > this is the location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:62:1: warning: "CIBR0"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:623:1: warning:
> > this is the location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:63:1: warning: "CIBR1"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:624:1: warning:
> > this is the location of the previous definition
> > /marune/build/v4l-dvb-master/v4l/pxa_camera.c:64:1: warning: "CIBR2"
> > redefined arch/arm/mach-pxa/include/mach/pxa-regs.h:625:1: warning:
> > this is the location of the previous definition
> >
> > It compiles fine under 2.6.29.
> >
> > Can you either try to fix this for kernels 2.6.27/28, or can I assume
> > that this driver will only compile correctly under 2.6.29?
>
> I don't have extra time to fix the driver for kernels < 2.6.29 nor do I
> know about anyone using soc-camera drivers from mercurial, compiling them
> externally.
>
> soc-camera drivers so far only include embedded platforms, and there you
> most usually have to work with complete kernel sources, and, to be
> honest, this backwards compatibility patching only adds work for me -
> when trying to merge patches created with git against a complete kernel
> git tree, because often so created patches don't apply cleanly (or at
> all) because of the compatibility delta. And then this delta has to be
> cleaned up by Mauro again before pushing upstream. Yes, Mauro does use
> scripts for this, still, separating original patches from the
> compatibility code can be non-trivial, I think, and, I guess, those
> scripts do not manage it in 100% of cases - as we have seen with a recent
> breakage exactly with these PXA register definitions.
>
> So, I would be perfectly happy if we find a way to only allow compilation
> of soc-camera drivers against the "current" kernel, and remove all the
> compatibility code from them.

No problem, I've modified it so that the daily build only compiles this 
driver from 2.6.29 and up.

Regards,

	Hans

>
> > I don't know what the status is of this driver for these older kernels,
> > so I don't dare touch this without input from you.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
