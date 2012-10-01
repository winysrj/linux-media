Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33882 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2JAOIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 10:08:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andreas Nagel <andreasnagel@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Integrate camera interface of OMAP3530 in Angstrom Linux
Date: Mon, 01 Oct 2012 16:08:50 +0200
Message-ID: <3292965.2Sq8LgAABn@avalon>
In-Reply-To: <5069958E.3090407@gmx.net>
References: <5048E4A4.40901@gmx.net> <1545584.uHsE0d20W1@avalon> <5069958E.3090407@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Monday 01 October 2012 15:07:26 Andreas Nagel wrote:
> Hi Laurent,
> 
> thanks for your reply.
> 
> Using a current mainline kernel is a little problematic. Recently I
> compiled the 2.6.39 and it wasn't able to boot at all. The reason for
> this are probably the chips, that are built on the CPU module. Usually,
> a working kernel for this module was undergoing some modifications by
> Technexion because of these chips.

That's why vendors should push board support to the mainline kernel.

> Currently, Technexion only offers the 2.6.32. and 2.6.37 kernel. The
> latter one makes a new device node /dev/media0 available (after
> activating some 'experimental' marked options in the kernel config), but
> I wasn't able to capture any signal.
> 
> I'm going to try the latest mainline kernel, but I doubt it will work.

Probably not out of the box, you will likely have to port board support from 
the vendor-specific kernel to mainline.

-- 
Regards,

Laurent Pinchart

