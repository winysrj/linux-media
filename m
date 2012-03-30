Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40751 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab2C3Nd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Mar 2012 09:33:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-media@vger.kernel.org
Subject: Re: omap3isp & Linux-3.3
Date: Fri, 30 Mar 2012 15:33:19 +0200
Message-ID: <2647564.mZcJGaWXom@avalon>
In-Reply-To: <4F75920C.9060103@mlbassoc.com>
References: <4F75920C.9060103@mlbassoc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Friday 30 March 2012 04:59:24 Gary Thomas wrote:
> Laurent,
> 
> I'm looking at your latest tree.  I've merged my platform support
> that I had working in 3.2, but I never see the TVP5150 sensor driver
> being probed.

Is the OMAP3 ISP driver loaded ? What does it print to the kernel log ?

> Has this changed?  Do you have an example [tree] with working board
> support?  Previously you had a branch with support for the BeagleBoard
> in place.  Is 'omap3isp-sensors-board' up to date?

The branch is up-to-date, yes. It contains support for the Beagleabord-xM with 
the MT9P031 camera module.

-- 
Regards,

Laurent Pinchart

