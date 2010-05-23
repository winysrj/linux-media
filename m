Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:59563 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab0EWWCC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 18:02:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 00/15] [RFCv2] [RFC] New control handling framework
Date: Mon, 24 May 2010 00:03:45 +0200
Cc: linux-media@vger.kernel.org
References: <cover.1274015084.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1274015084.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005240003.46988.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the update.

On Sunday 16 May 2010 15:20:43 Hans Verkuil wrote:
> This RFC patch series adds the control handling framework and implements
> it in ivtv and all subdev drivers used by ivtv.
> 
> It is a bare-bones implementation, so no sysfs or debugfs enhancements.
> 
> It is the second version of this framework, incorporating comments from
> Laurent.
> 
> Changes compared to the first version:
> 
> - Updated the documentation, hopefully making it easier to understand.
> - v4l2_ctrl_new_custom now uses a new v4l2_ctrl_config struct instead of
>   a long argument list.
> - v4l2_ctrl_g/s is now renamed to v4l2_ctrl_g/s_ctrl.
> - The v4l2_ctrl.h header now uses kernel doc comments.
> - Removed the 'strict validation' feature.
> - Added a new .init op that allows you to initialize many of the v4l2_ctrl
>   fields on first use. Required by uvc.
> - No longer needed to initialize ctrl_handler in struct video_device. It
>   will copy the ctrl_handler from struct v4l2_device if needed.
> - Renamed the v4l2_sd_* helper functions to v4l2_subdev_*.
> 
> I decided *not* to rename the v4l2_ctrl struct. What does the struct
> describe? A control. Period. So I really don't know what else to call it.
> Every other name I can think of is contrived. It really encapsulates all
> the data and info that describes a control and its state. Yes, it is close
> to struct v4l2_control, but on the other hand any driver that uses this
> framework will no longer use v4l2_control (or v4l2_ext_controls for that
> matter). It will only use v4l2_ctrl. So I do not think there will be much
> cause for confusion here.

OK. It will still be a bit confusing, but renaming the structure might be 
worse.

Should we decide on a naming policy for kernel vs. user structures in V4L2 for 
new APIs ?

> Anyway, comments are welcome.
> 
> Once this is in then we can start migrating all subdev drivers to this
> framework, followed by all bridge drivers. Converted subdev drivers can
> still be used by unconverted bridge drivers. Once all bridge drivers are
> converted the subdev backwards compatibility code can be removed.
> 
> The same is true for the cx2341x module: both converted and unconverted
> bridge drivers are supported. Once all bridge drivers that use this module
> are converted the compat code can be removed from cx2341x (and that will
> save about 1060 lines of hard to understand code).

-- 
Regards,

Laurent Pinchart
