Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34122 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2C1THs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 15:07:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media ML <linux-media@vger.kernel.org>
Subject: Re: reading config parameters of omap3-isp subdevs
Date: Wed, 28 Mar 2012 17:54:12 +0200
Message-ID: <2457237.l62XdFKgLK@avalon>
In-Reply-To: <4F6856C0.4070404@matrix-vision.de>
References: <4F6348D7.9070409@matrix-vision.de> <6085689.3CUf0tMs8E@avalon> <4F6856C0.4070404@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Tuesday 20 March 2012 11:06:56 Michael Jones wrote:
> On 03/20/2012 12:22 AM, Laurent Pinchart wrote:
> > On Friday 16 March 2012 15:06:15 Michael Jones wrote:
> [snip]
> 
> > Adding a R/W bit to the flag argument should indeed work. However, I'm
> > wondering what your use case for reading parameters back is.
> 
> The simplest use case in my mind is that after the user has fiddled around
> with config parameters, they should be able to set them back to their
> original state. For that, they need to know what the original state was.
> 
> > The preview engine parameter structures seem pretty-much self-contained to
> > me, I'm not sure it would make sense to only modify one of the parameters.
> 
> Why doesn't it make sense to write to only e.g. 'COEF3' in the PRV_WBGAIN
> register? Especially considering the sparse documentation of many of these
> registers, I would like to be able to tweak the existing parameters from
> their defaults, rather than start from scratch.

Because configuring white balance requires modifying all the coefficients.

I agree that querying the default parameters can be useful for experimentation 
purpose, although in that case you could just have a look at the driver source 
code ;-) I've sent a patch that modifies the way the preview engine handles 
the configuration process to the linux-media mailing list. I could try 
implementing read access on top of that, but I'm not sure when I'll have time 
to do so. If you want to give it a try, I'll review your code :-) Be careful 
of the race conditions, they're not trivial.

-- 
Regards,

Laurent Pinchart

