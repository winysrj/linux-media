Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55929 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab0L1Pjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 10:39:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale sensors
Date: Tue, 28 Dec 2010 16:40:04 +0100
Cc: linux-media@vger.kernel.org
References: <1292337823-15994-1-git-send-email-martin@neutronstar.dyndns.org> <201012150201.31635.laurent.pinchart@ideasonboard.com> <20101215095136.GI32435@neutronstar.dyndns.org>
In-Reply-To: <20101215095136.GI32435@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012281640.05998.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Martin,

On Wednesday 15 December 2010 10:51:36 martin@neutronstar.dyndns.org wrote:
> On Wed, Dec 15, 2010 at 02:01:31AM +0100, Laurent Pinchart wrote:
> > Hi Martin,
> > 
> > Thanks for the patch.
> > 
> > On Tuesday 14 December 2010 15:43:43 Martin Hostettler wrote:
> > > Adds support for V4L2_MBUS_FMT_Y8_1X8 format and 8bit data width in
> > > syncronous interface.
> 
> [...]
> 
> > I got a similar patch for 12bit support. I'll try to push a new version
> > of the ISP driver with that patch included in the next few days (it
> > needs to go through internal review first), could you then rebase your
> > patch on top of it ? The core infrastructure will be set up, you will
> > just have to add 8-bit support.
> 
> Will do, i'll have a look at it when the new version is out.

Sorry the the long delay.

12-bit support is now available in http://git.linuxtv.org/pinchartl/media.git 
(in the usual media-0004-omap3isp branch).

Could you please rebase your patches on top of that ?

-- 
Regards,

Laurent Pinchart
