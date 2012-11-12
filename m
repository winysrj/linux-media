Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33282 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2KLL0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 06:26:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andreas Nagel <andreasnagel@gmx.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP: VIDIOC_STREAMON and VIDIOC_QBUF calls fail
Date: Mon, 12 Nov 2012 12:27:33 +0100
Message-ID: <1808493.exW1ZsvWKX@avalon>
In-Reply-To: <509E5B58.1020108@gmx.net>
References: <5097DF9F.6080603@gmx.net> <20121108092905.GF25623@valkosipuli.retiisi.org.uk> <509E5B58.1020108@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Saturday 10 November 2012 14:49:12 Andreas Nagel wrote:
> Sakari Ailus schrieb am 08.11.2012 10:29:
> > On Thu, Nov 08, 2012 at 10:26:11AM +0100, Laurent Pinchart wrote:
> >> media-ctl doesn't show pad formats, that's a bit weird. Are you using a
> >> recent version ?
> > 
> > This could as well be an issue with the kernel API --- I think that kernel
> > has a version which isn't in mainline. So the IOCTL used to access the
> > media bus formats are quite possibly different.
> > 
> > Regards,
> 
> Hi Sakari,
> hi Laurent,
> 
> first, I could resolve my issues.
> 
> When I allocated buffers with the CMEM library from TI (provides aligned
> and contiguous memory buffers), I was able to use user pointers. And
> VIDIOC_STREAMON just failed because of a wrong but similar written
> pixelformat. Since yesterday, I am now able to capture frames and save
> them as YUV data in a file.
> 
> My Technexion kernel is based on the TI linux kernel and they
> (Technexion) probably backported some version of Media Controller into
> that kernel. In order to build Laurents media-ctl application, I had to
> rename all MEDIA_* constants in the source files (e.g. MEDIA_PAD_FL_SINK
> into MEDIA_PAD_FLAG_INPUT).
> It's probably true, that this implementation is quite different from the
> one in mainline or other kernels. That might also be the reason, why
> media-ctl -p does not print pad formats.
> But as long as Technexion keep board support for themselves, I cannot
> use another kernel. I already tried that with some mainline and
> linux-omap versions(3.2, 3.4, 3.6). They don't boot, or if they actually
> do, I don't see anything because network and tty is not available.

You would need to port at least board code from your vendor kernel to mainline 
in order to boot a mainline kernel on your board. That's what I would advise 
you to do if time and resources permit, as the TI kernel should be avoided 
like plague. However, you mentioned CMEM above, which hints that you might be 
using TI's userspace media stack. If that's the case, good luck, I feel your 
pain, but I can't help.

> Lastly, the TVP5146 indeed generates interlaced frames.

We don't have interlaced support in the mainline OMAP3 ISP driver. I don't 
know how the driver got patched in your kernel, but I can't offert support for 
that code.

-- 
Regards,

Laurent Pinchart

