Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:20817 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaCFL7O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 06:59:14 -0500
Date: Thu, 06 Mar 2014 08:59:07 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
	Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Message-id: <20140306085907.0e4bc30a@samsung.com>
In-reply-to: <6116451.L9roNDfSqL@avalon>
References: <1391958577.25424.22.camel@x220> <2136780.FIdBGb725A@avalon>
 <20140306044529.GA6466@kroah.com> <6116451.L9roNDfSqL@avalon>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 06 Mar 2014 12:00:30 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Greg,
> 
> On Wednesday 05 March 2014 20:45:29 Greg Kroah-Hartman wrote:
> > On Thu, Mar 06, 2014 at 01:48:29AM +0100, Laurent Pinchart wrote:
> > > On Wednesday 05 March 2014 16:28:03 Joe Perches wrote:
> > > > On Thu, 2014-03-06 at 00:50 +0100, Laurent Pinchart wrote:
> > > > > Please note that -DDEBUG is equivalent to '#define DEBUG', not to
> > > > > '#define CONFIG_DEBUG'. 'DEBUG' needs to be defined for dev_dbg() to
> > > > > have any effect.
> > > > 
> > > > Not quite.  If CONFIG_DYNAMIC_DEBUG is set, these
> > > > dev_dbg statements are compiled in but not by default
> > > > set to emit output.  Output can be enabled by using
> > > > dynamic_debug controls like:
> > > > 
> > > > # echo -n 'file omap4iss/* +p' > <debugfs>/dynamic_debug/control
> > > > 
> > > > See Documentation/dynamic-debug-howto.txt for more details.
> > > 
> > > Thank you for the additional information.
> > > 
> > > Would you recommend to drop driver-specific Kconfig options related to
> > > debugging and use CONFIG_DYNAMIC_DEBUG instead ?
> > 
> > Yes, please do that, no one wants to rebuild drivers and subsystems with
> > different options just for debugging.

I agree that this is the best solution.

> 
> Is CONFIG_DYNAMIC_DEBUG lean enough to be used on embedded systems ? Note that 
> people would still have to rebuild their kernel to enable CONFIG_DYNAMIC_DEBUG 
> anyway :-)

Some distros, like Fedora, ships two different kernels: one compiled with
most of those DEBUG macros disabled, and another one with them enabled:

	kernel.x86_64 : The Linux kernel
	kernel-debug.x86_64 : The Linux kernel compiled with extra debugging enabled

That helps to have a "production" kernel using less memory, yet allowing
one to boot with the debug Kernel, if he needs to debug some driver(s).

PS.: In Fedora, in the specific case of CONFIG_DYNAMIC_DEBUG, it has it
enabled since, at least, 2010 (when they changed the SCM to git) at the 
"production" kernel even for ARM. So, I suspect that the extra amount of
memory required for it is not much, but I never actually bothered to check.

On my view, except on embedded systems with very very limited memory
constraints, it makes sense to keep CONFIG_DYNAMIC_DEBUG always enabled.

Btw, I would expect a reasonable amount of RAM on any embedded system
that supports v4l, because video buffers require a lot of memory.
Comparing to the size of those buffers, I suspect that the extra amount
of memory for the debug strings and code is negligible.

-- 

Cheers,
Mauro
