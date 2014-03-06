Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41927 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbaCFBnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 20:43:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com
Subject: Re: [RFCv1 PATCH 0/4] add G/S_EDID support for video nodes
Date: Thu, 06 Mar 2014 02:45:23 +0100
Message-ID: <2313806.6Mf9nE69NY@avalon>
In-Reply-To: <1393932659-13817-1-git-send-email-hverkuil@xs4all.nl>
References: <1393932659-13817-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patches.

On Tuesday 04 March 2014 12:30:55 Hans Verkuil wrote:
> Currently the VIDIOC_SUBDEV_G/S_EDID and struct v4l2_subdev_edid are subdev
> APIs. However, that's in reality quite annoying since for simple video
> pipelines there is no need to create v4l-subdev device nodes for anything
> else except for setting or getting EDIDs.
> 
> What happens in practice is that v4l2 bridge drivers add explicit support
> for VIDIOC_SUBDEV_G/S_EDID themselves, just to avoid having to create
> subdev device nodes just for this.
> 
> So this patch series makes the ioctls available as regular ioctls as
> well. In that case the pad field should be set to 0 and the bridge driver
> will fill in the right pad value internally depending on the current
> input or output and pass it along to the actual subdev driver.

Would it make sense to allow usage of the pad field on video nodes as well ?

Apart from that and minor issues with patch 2/4 this series looks good to me.

-- 
Regards,

Laurent Pinchart

