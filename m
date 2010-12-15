Return-path: <mchehab@gaivota>
Received: from dslb-088-076-052-180.pools.arcor-ip.net ([88.76.52.180]:58416
	"HELO neutronstar.dyndns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750795Ab0LOJ6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 04:58:19 -0500
Date: Wed, 15 Dec 2010 10:51:36 +0100
From: martin@neutronstar.dyndns.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale
	sensors
Message-ID: <20101215095136.GI32435@neutronstar.dyndns.org>
References: <1292337823-15994-1-git-send-email-martin@neutronstar.dyndns.org> <201012150201.31635.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012150201.31635.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, Dec 15, 2010 at 02:01:31AM +0100, Laurent Pinchart wrote:
> Hi Martin,
> 
> Thanks for the patch.
> 
> On Tuesday 14 December 2010 15:43:43 Martin Hostettler wrote:
> > Adds support for V4L2_MBUS_FMT_Y8_1X8 format and 8bit data width in
> > syncronous interface.
> > 
[...]
> 
> I got a similar patch for 12bit support. I'll try to push a new version of the 
> ISP driver with that patch included in the next few days (it needs to go 
> through internal review first), could you then rebase your patch on top of it 
> ? The core infrastructure will be set up, you will just have to add 8-bit 
> support.

Will do, i'll have a look at it when the new version is out.

 - Martin Hostettler
