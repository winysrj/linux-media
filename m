Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54316 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2IZLlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 07:41:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andreas Nagel <andreasnagel@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Integrate camera interface of OMAP3530 in Angstrom Linux
Date: Wed, 26 Sep 2012 13:41:44 +0200
Message-ID: <1545584.uHsE0d20W1@avalon>
In-Reply-To: <5048E4A4.40901@gmx.net>
References: <5048E4A4.40901@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Thursday 06 September 2012 20:00:04 Andreas Nagel wrote:
> Hello,
> 
> I am using an embedded module called TAO-3530 from Technexion, which has
> an OMAP3530 processor.
> This processor has a camera interface, which is part of the ISP
> submodule. For an ongoing project I want to capture a video signal from
> this interface. After several days of excessive research I still don't
> know, how to access it.
> I configured the Angstrom kernel (2.6.32), so that the driver for OMAP 3
> camera controller (and all other OMAP 3 related things) is integrated,
> but I don't see any new device nodes in the filesystem.

You should upgrade to a much more recent kernel, as the driver for the OMAP3 
ISP included in the Angstrom 2.6.32 kernel is just bad legacy code that should 
be burried in a very deep cave.

> I also found some rumors, that the Media Controller Framework or driver
> provides the device node /dev/media0, but I was not able to install it.

You will need to upgrade your kernel for that. I'd advise going for the latest 
mainline kernel.

> I use OpenEmbedded, but I don't have a recipe for Media Controller. On
> the Angstrom website ( http://www.angstrom-distribution.org/repo/ )
> there's actually a package called "media-ctl", but due to the missing
> recipe, i can't install it. Can't say, I am an expert in OE.
> 
> Can you help me point out, what's necessary to make the camera interface
> accessible?

-- 
Regards,

Laurent Pinchart

