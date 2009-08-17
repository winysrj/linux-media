Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2846 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZHQTEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 15:04:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [Q] sensors, corrupting the top line
Date: Mon, 17 Aug 2009 21:04:14 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.0908171040310.4449@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0908171040310.4449@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908172104.14321.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 17 August 2009 12:09:12 Guennadi Liakhovetski wrote:
> Hi Hans, all
> 
> In soc-camera since its first version we have a parameter "y_skip_top", 
> which the sensor uses to tell the host (bridge) driver "I am sending you 
> that many lines more than what is requested, and you should drop those 
> lines from the top of the image." I never investigated this in detail, 
> originally this was a "strong tip" that the top line is always corrupted. 
> Now I did investigate it a bit by setting this parameter to 0 and looking 
> what the sensors actually produce. I am working with four sensor: mt9m001, 
> mt9v022, mt9t031 and ov7725, of which only the first two had that 
> parameter set to 1 from the beginning, the others didn't have it and also 
> showed no signs of a problem. mt9m001 (monochrome) doesn't have the 
> problem either, but mt9v022 does. It does indeed deliver the first line 
> with "randomly" coloured pixels. Notice - this is not the top line of the 
> sensor, this is the first read-out line, independent of the cropping 
> position. So, it seems we do indeed need a way to handle such sensors. Do 
> you have a suggestion for a meaningful v4l2-subdev API for this?

Hmm, I think that the best way is to make a struct v4l2_subdev_sensor_ops,
move the enum_framesizes/intervals from the video_ops to the sensor_ops
(since these are only used by sensors AFAIK), and add a new op to
sensor_ops: int (*skip_top_lines)(struct v4l2_subdev *sd, u32 *lines).

When we add the op to set the bus_params, then that can be added to
sensor_ops as well. I've always thought that we need sensor-specifc ops
eventually and this is a good reason to do so.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
