Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:34418 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab0C2Hb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 03:31:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: What would be a good time to move subdev drivers to a subdev directory?
Date: Mon, 29 Mar 2010 09:31:39 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201003281224.17678.hverkuil@xs4all.nl>
In-Reply-To: <201003281224.17678.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003290931.39614.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 28 March 2010 12:24:17 Hans Verkuil wrote:
> Hi Mauro,
> 
> Currently drivers/media/video is a mix of subdev drivers and
> bridge/platform drivers. I think it would be good to create a
> drivers/media/subdev directory where subdev drivers can go.
> 
> We discussed in the past whether we should have categories for audio
> subdevs, video subdevs, etc. but I think that will cause problems,
> especially with future multifunction devices.

Would have been nice though. Maybe a multifunction subdir would do ? :-)

> What is your opinion on this, and what would be a good time to start moving
> drivers?

-- 
Regards,

Laurent Pinchart
