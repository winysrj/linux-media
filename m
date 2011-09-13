Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47277 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab1IMRwM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 13:52:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4] V4L: dynamically allocate video_device nodes in subdevices
Date: Tue, 13 Sep 2011 19:52:07 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1109091701060.915@axis700.grange> <201109131116.35408.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1109131318450.17902@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109131318450.17902@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109131952.08202.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 13 September 2011 16:48:10 Guennadi Liakhovetski wrote:
> Currently only very few drivers actually use video_device nodes, embedded
> in struct v4l2_subdev. Allocate these nodes dynamically for those drivers
> to save memory for the rest.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I will try to test the patch tomorrow on an OMAP3 system.

-- 
Regards,

Laurent Pinchart
