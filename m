Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57073 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2DUSdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 14:33:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steve Lindell <Steve.Lindell@se.flextronics.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: Mipi csi2
Date: Sat, 21 Apr 2012 20:11:17 +0200
Message-ID: <2555152.KT4mQxaHCg@avalon>
In-Reply-To: <414D8776B339BF44ADF9839A98A591A00467F154@EUDUCEX3.europe.ad.flextronics.com>
References: <414D8776B339BF44ADF9839A98A591A00467F115@EUDUCEX3.europe.ad.flextronics.com> <Pine.LNX.4.64.1204191507100.2110@axis700.grange> <414D8776B339BF44ADF9839A98A591A00467F154@EUDUCEX3.europe.ad.flextronics.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thursday 19 April 2012 15:31:23 Steve Lindell wrote:
> Hi Guennadi!
> 
> Adding Laurent to the loop.
> 
> Thanks for your quick answer!
> You wrote OMAP 4330 but I believe you meant Omap4430.
> 
> A longshot, is it possible to use Omap3isp driver on the omap4430, as the
> Omap4430 has mipi-csi2 support by hardware?

You can't use the OMAP3 ISP driver on the OMAP4, but you can use the OMAP4 ISS 
driver (git://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera.git). Please 
note that the driver is currently under development. Many hardware features 
are not supported yet, and you might experience crashes. Patches are of course 
welcome :-)

-- 
Regards,

Laurent Pinchart

