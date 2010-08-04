Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42747 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0HDTho (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Aug 2010 15:37:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v3 1/7] v4l: Share code between video_usercopy and video_ioctl2
Date: Wed, 4 Aug 2010 21:37:37 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278948352-17892-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278948352-17892-2-git-send-email-laurent.pinchart@ideasonboard.com> <201008042030.06872.hverkuil@xs4all.nl>
In-Reply-To: <201008042030.06872.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042137.37780.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 04 August 2010 20:30:06 Hans Verkuil wrote:
> On Monday 12 July 2010 17:25:46 Laurent Pinchart wrote:
> > The two functions are mostly identical. They handle the copy_from_user
> > and copy_to_user operations related with V4L2 ioctls and call the real
> > ioctl handler.
> > 
> > Create a __video_usercopy function that implements the core of
> > video_usercopy and video_ioctl2, and call that function from both.
> 
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks for the acks.

> Two notes:
> 
> 1) This change will clash with the multiplane patches.

Obviously, for this patch and the others, I will keep rebasing the code until 
it gets merged.

> 2) Perhaps it is time that we remove the __OLD_VIDIOC_ support?

Fine with me. We need to list that in feature-removal-schedule.txt.

-- 
Regards,

Laurent Pinchart
