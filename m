Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51529 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbZKRJaE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:30:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: v4l: Use the new video_device_node_name function
Date: Wed, 18 Nov 2009 10:30:26 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com> <1258504731-8430-3-git-send-email-laurent.pinchart@ideasonboard.com> <200911180729.40424.hverkuil@xs4all.nl>
In-Reply-To: <200911180729.40424.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181030.26577.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 18 November 2009 07:29:40 Hans Verkuil wrote:
> On Wednesday 18 November 2009 01:38:43 Laurent Pinchart wrote:
> > Fix all device drivers to use the new video_device_node_name function.
> >
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Using video_device_node_name() is a great improvement! Excellent work!

Thanks.

> One suggestion, though: I have to agree with the discussion you had with
>  Mauro on irc yesterday about the /dev/ prefix. I think that should be
>  removed and doing that in this patch as well makes a lot of sense. No need
>  for a separate patch to do that as far as I am concerned.

Ok, I'll update the patch.

-- 
Regards,

Laurent Pinchart
