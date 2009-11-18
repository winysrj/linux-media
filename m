Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:49557 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbZKRMrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 07:47:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: v4l: Add video_device_node_name function
Date: Wed, 18 Nov 2009 13:48:17 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com> <1258504731-8430-2-git-send-email-laurent.pinchart@ideasonboard.com> <200911180806.22428.hverkuil@xs4all.nl>
In-Reply-To: <200911180806.22428.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181348.18210.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 18 November 2009 08:06:22 Hans Verkuil wrote:
> On Wednesday 18 November 2009 01:38:42 Laurent Pinchart wrote:
> > Many drivers access the device number (video_device::v4l2_devnode::num)
> > in order to print the video device node name. Add and use a helper
> > function to retrieve the video_device node name.
> >
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Can you also add a bit of documentation for this function in
> Documentation/video4linux/v4l2-framework.txt? It should go in the section
> "video_device helper functions".

Sure.

> And update that file as well when the num and minor fields go away.

The fields won't go away completely, as they're still needed by the v4l core. 
I will document them as private when no drivers will be using them anymore.
 
> The same is also true for the new registration function.

Ok.

Thanks for the review.

-- 
Regards,

Laurent Pinchart
