Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50726 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1HPRxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 13:53:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: [PATCH] media: Added extensive feature set to the OV5642 camera driver
Date: Tue, 16 Aug 2011 19:53:40 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <alpine.DEB.2.02.1108161255100.16286@ipanema>
In-Reply-To: <alpine.DEB.2.02.1108161255100.16286@ipanema>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161953.40596.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastian,

On Tuesday 16 August 2011 14:58:58 Bastian Hecht wrote:
> The driver now supports arbitray resolutions (width up to 2592, height
> up to 720), automatic/manual gain, automatic/manual white balance,
> automatic/manual exposure control, vertical flip, brightness control,
> contrast control and saturation control. Additionally the following
> effects are available now: rotating the hue in the colorspace, gray
> scale image and solarize effect.

That's a big patch, thus quite hard to review. What about splitting it in one 
patch per feature (or group of features, at least separating format 
configuration and controls) ? :-)

-- 
Regards,

Laurent Pinchart
