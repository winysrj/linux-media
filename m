Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48274 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbcBHLNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:13:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Franck Jullien <franck.jullien@gmail.com>
Cc: linux-media@vger.kernel.org, Chris Kohn <christian.kohn@xilinx.com>
Subject: Re: Use xilinx video drivers in PCIe device
Date: Mon, 08 Feb 2016 13:14:10 +0200
Message-ID: <3104943.upkGDP3not@avalon>
In-Reply-To: <CAJfOKBymfpRHx5XXLPP1+zAJ+N_C7bzW-pJTvj8S8uGWixNw0w@mail.gmail.com>
References: <CAJfOKByVva72g_1kJyMKGFHr2Jz+Yo6BgZPp_EENj9m4vXOHBA@mail.gmail.com> <1672061.k75230d3Eh@avalon> <CAJfOKBymfpRHx5XXLPP1+zAJ+N_C7bzW-pJTvj8S8uGWixNw0w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

On Monday 08 February 2016 08:40:11 Franck Jullien wrote:
> 2016-02-04 10:45 GMT+01:00 Laurent Pinchart:
> > On Tuesday 02 February 2016 17:05:06 Franck Jullien wrote:
> >> Hi,
> >> 
> >> I need to use a Xilinx video infrastructure on a PCIe board.
> >> As far as I understand it, all Xilinx video drivers make use of the
> >> device-tree for configuration.
> > 
> > Correct. Those drivers target the Xilinx SoC FPGAs, no standalone FPGAs
> > connected to an external CPU.
> > 
> >> However, my idea is to create a MFD device to bind video drivers. That
> >> would require Xilinx video drivers to check platform_data and continue
> >> with device tree configuration if it is null or use platform data if
> >> available.
> >> 
> >> Do you think such a change in Xilinx drivers can be considered
> >> upstream ? Is this the way to go ?
> > 
> > Your use case is certainly valid, so I'm certainly open to supporting it
> > in the drivers.
> > 
> > I'm wondering whether your MFD decide driver could create a DT fragment to
> > describe the IP cores topology. That way we could reuse the existing DT
> > support in individual drivers.
> 
> I'm working on such a solution (DT framgent, or more precisely
> devitree dynamic feature).
> I'll keep you informed whenever I get something usable.

Thank you. If you're faced with design choices please feel free to pick our 
brains at any time without waiting for a complete implementation.

-- 
Regards,

Laurent Pinchart

