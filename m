Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49792 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab1IHXnl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 19:43:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: [PATCH 1/2 v6] media: Add support for arbitrary resolution
Date: Thu, 8 Sep 2011 18:35:05 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <alpine.DEB.2.02.1109081811510.2127@ipanema>
In-Reply-To: <alpine.DEB.2.02.1109081811510.2127@ipanema>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081835.05551.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastian,

On Thursday 08 September 2011 18:15:24 Bastian Hecht wrote:
> This patch adds the ability to get arbitrary resolutions with a width
> up to 2592 and a height up to 720 pixels instead of the standard 1280x720
> only.
> 
> Signed-off-by: Bastian Hecht <hechtb@gmail.com>
> ---
> This is the same patch as v5 with only an additional boolean check in
> s_power().

I suppose that you use the sensor on a platform that can't control its power 
lines. I won't ask you to implement a real .s_power() handler then :-)

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
