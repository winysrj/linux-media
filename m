Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57798 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030814Ab2CULFq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:05:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] V4L: sh_mobile_ceu_camera: maximum image size depends on the hardware version
Date: Wed, 21 Mar 2012 12:06:13 +0100
Message-ID: <148041421.OMs5SD2LFA@avalon>
In-Reply-To: <Pine.LNX.4.64.1203211157340.31443@axis700.grange>
References: <Pine.LNX.4.64.1203141600210.25284@axis700.grange> <2696549.KbXzs1B8nR@avalon> <Pine.LNX.4.64.1203211157340.31443@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 21 March 2012 11:59:59 Guennadi Liakhovetski wrote:
> On Wed, 21 Mar 2012, Laurent Pinchart wrote:
> > On Wednesday 14 March 2012 16:02:20 Guennadi Liakhovetski wrote:
> > > Newer CEU versions, e.g., the one, used on sh7372, support image sizes
> > > larger than 2560x1920. Retrieve maximum sizes from platform properties.
> > 
> > Isn't there a way you could query the CEU version at runtime instead ?
> 
> I'm not aware of any. And even if it were possible, I'm not sure putting
> tables with "version - feature-set" tables into the driver proper would be
> a very good idea. It used to be like that (or almost like that with
> dependencies on the chip-type) in other drivers (e.g., shdma) and we
> dropped it in favour of platform data.

I would have voted for doing it the other way around. The driver should know 
about the different hardware versions it supports. Putting that in platform 
data just moves the burden to board code developers and duplicates the 
information in lots of places. At worse, if you can't detect the version at 
runtime, I would put a version field in the platform data and map that to 
hardware features in the driver.

-- 
Regards,

Laurent Pinchart

