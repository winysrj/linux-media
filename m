Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48279 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZKJMyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 07:54:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/9] v4l: add new v4l2-subdev sensor operations, use g_skip_top_lines in soc-camera
Date: Tue, 10 Nov 2009 13:55:28 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange> <Pine.LNX.4.64.0910301403550.4378@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910301403550.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911101355.28339.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Friday 30 October 2009 15:01:06 Guennadi Liakhovetski wrote:
> Introduce new v4l2-subdev sensor operations, move .enum_framesizes() and
> .enum_frameintervals() methods to it,

I understand that we need sensor-specific operations, but I'm not sure if 
those two are really unneeded for "non-sensor" video.

Speaking about enum_framesizes() and enum_frameintervals(), wouldn't it be 
better to provide a static array of data instead of a callback function ? That 
should be dealt with in another patch set of course.

> add a new .g_skip_top_lines() method and switch soc-camera to use it instead
> of .y_skip_top soc_camera_device member, which can now be removed.

BTW, the lines of "garbage" you get at the beginning of the image is actually 
probably meta-data (such as exposure settings). Maybe the g_skip_top_lines() 
operation could be renamed to something meta-data related. Applications could 
also be interested in getting the data.

-- 
Regards,

Laurent Pinchart
