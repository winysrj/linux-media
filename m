Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:57001 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab0EJKxm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 06:53:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/7] [RFC] Move VIDIOC_G/S_PRIORITY handling to the V4L core
Date: Mon, 10 May 2010 12:54:38 +0200
Cc: linux-media@vger.kernel.org
References: <cover.1273432986.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273432986.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005101254.39364.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 09 May 2010 21:29:05 Hans Verkuil wrote:
> Few drivers implement VIDIOC_G/S_PRIORITY and those that do often implement
> it incorrectly.
> 
> Now that we have a v4l2_fh struct it is easy to add support for priority
> handling to the v4l core framework.
> 
> There are three types of drivers:
> 
> 1) Those that use v4l2_fh. There the local priority can be stored in the
>    v4l2_fh struct.
> 
> 2) Those that do not have an open or release function defined in
> v4l2_file_ops. That means that file->private_data will never be filled and
> so we can use that to store the local priority in.
> 
> 3) Others. In all other cases we leave it to the driver. Of course, the
> goal is to eventually move the 'others' into type 1 or 2.
> 
> This patch series shows how it is done and converts ivtv to rely on the
> core framework instead of doing it manually.
> 
> Comments?

I don't think this is right. You're moving the priority ioctls support to 
v4l2_device, while it would make more sense to move it to video_device. If a 
device can capture two independent video streams simultaneously, your patches 
would prevent it from working at all.

-- 
Regards,

Laurent Pinchart
