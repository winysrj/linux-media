Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52993 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGOIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:08:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv1 PATCH 5/5] DocBook v4l2: update the G/S_EDID documentation
Date: Fri, 07 Mar 2014 15:09:45 +0100
Message-ID: <1636382.IFSev3egjD@avalon>
In-Reply-To: <1394187679-7345-6-git-send-email-hverkuil@xs4all.nl>
References: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl> <1394187679-7345-6-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 07 March 2014 11:21:19 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Document that it is now possible to call G/S_EDID from video nodes, not
> just sub-device nodes. Add a note that -EINVAL will be returned if
> the pad does not support EDIDs.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/v4l2.xml           |   2 +-
>  .../DocBook/media/v4l/vidioc-subdev-g-edid.xml     | 152 ------------------
>  2 files changed, 1 insertion(+), 153 deletions(-)
>  delete mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml

The patch just removes the EDID ioctls documentation, I highly doubt that this 
is what you intended :-)

-- 
Regards,

Laurent Pinchart

