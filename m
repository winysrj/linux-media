Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39614 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141Ab2CUKvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 06:51:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] V4L: sh_mobile_ceu_camera: maximum image size depends on the hardware version
Date: Wed, 21 Mar 2012 11:52:09 +0100
Message-ID: <2696549.KbXzs1B8nR@avalon>
In-Reply-To: <Pine.LNX.4.64.1203141600210.25284@axis700.grange>
References: <Pine.LNX.4.64.1203141600210.25284@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 14 March 2012 16:02:20 Guennadi Liakhovetski wrote:
> Newer CEU versions, e.g., the one, used on sh7372, support image sizes
> larger than 2560x1920. Retrieve maximum sizes from platform properties.

Isn't there a way you could query the CEU version at runtime instead ?

-- 
Regards,

Laurent Pinchart

