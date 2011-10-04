Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35009 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab1JDLDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2011 07:03:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Paul Chiha" <paul.chiha@greyinnovation.com>
Subject: Re: Help with omap3isp resizing
Date: Tue, 4 Oct 2011 13:03:02 +0200
Cc: linux-media@vger.kernel.org
References: <51A4F524D105AA4C93787F33E2C90E62EE5203@greysvr02.GreyInnovation.local>
In-Reply-To: <51A4F524D105AA4C93787F33E2C90E62EE5203@greysvr02.GreyInnovation.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110041303.03055.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Monday 03 October 2011 07:51:34 Paul Chiha wrote:
> Hi,
> 
> I've been having trouble getting the resizer to work, and mainly because
> I don't know how to correctly configure it.
> I'm using kernel 2.6.37 on arm DM37x board.
> 
> I've been able to configure the media links sensor=>ccdc=>ccdc_output
> (all with 640x480 V4L2_MBUS_FMT_UYVY8_2X8) and VIDIOC_STREAMON works on
> /dev/video2.
> But if I configure media links sensor=>ccdc=>resizer=>resizer_output,
> then VIDIOC_STREAMON fails on /dev/video6 (with pixelformat mismatch).
> I noticed that the resizer driver only supports V4L2_MBUS_FMT_UYVY8_1X16
> & V4L2_MBUS_FMT_YUYV8_1X16, so I tried again with all the links set to
> V4L2_MBUS_FMT_UYVY8_1X16 instead, but then ioctl VIDIOC_SUBDEV_S_FMT
> fails on /dev/v4l-subdev8, because the sensor driver doesn't support
> 1X16.
> Then I tried using V4L2_MBUS_FMT_UYVY8_2X8 for the sensor and
> V4L2_MBUS_FMT_UYVY8_1X16 for the resizer, but it either failed with
> pixelformat mismatch or link pipeline mismatch, depending on which pads
> were different.
> 
> Can someone please tell me what I need to do to make this work?

Long story short, I don't think that pipeline has ever been tested. I'm 
unfortunately lacking hardware to work on that, as none of my OMAP3 hardware 
has a YUV input.

-- 
Regards,

Laurent Pinchart
