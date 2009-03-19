Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail11d.verio-web.com ([204.202.242.86]:13458 "HELO
	mail11d.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762546AbZCSXzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 19:55:25 -0400
Received: from mx56.stngva01.us.mxservers.net (204.202.242.16)
	by mail11d.verio-web.com (RS ver 1.0.95vs) with SMTP id 2-098196922
	for <linux-media@vger.kernel.org>; Thu, 19 Mar 2009 19:55:22 -0400 (EDT)
Subject: v4l2-subdev missing video ops
From: Pete Eberlein <pete@sensoray.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Thu, 19 Mar 2009 16:55:20 -0700
Message-Id: <1237506920.5572.13.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

I'm looking at converting the go7007 staging driver to use the subdev
API.  I don't see any v4l2_subdev_video_ops for VIDIOC_S_INPUT nor
VIDIOC_S_STD.  Were those overlooked, or should I use the generic
v4l2_subdev_core_ops->ioctl?  (The chip in particular does not have a
tuner, but it does have multiple inputs (svidio, composite) and supports
NTSC or PAL.)

Thanks.
-- 
Pete Eberlein
Sensoray Co., Inc.
Email: pete@sensoray.com
http://www.sensoray.com

