Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3533 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZJKWnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2009 18:43:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l2_subdev: rename tuner s_standby operation to core s_power
Date: Mon, 12 Oct 2009 00:42:19 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1254750497-13684-1-git-send-email-laurent.pinchart@ideasonboard.com> <200910120036.37857.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200910120036.37857.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910120042.19506.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 12 October 2009 00:36:37 Laurent Pinchart wrote:
> On Monday 05 October 2009 15:48:17 Laurent Pinchart wrote:
> > Upcoming I2C v4l2_subdev drivers need a way to control the subdevice
> > power state from the core. This use case is already partially covered by
> > the tuner s_standby operation, but no way to explicitly come back from
> > the standby state is available.
> > 
> > Rename the tuner s_standby operation to core s_power, and fix tuner
> > drivers accordingly. The tuner core will call s_power(0) instead of
> > s_standby(). No explicit call to s_power(1) is required for tuners as
> > they are supposed to wake up from standby automatically.
> 
> Mauro, Hans told me he didn't see anything wrong with this patch. As there's 
> no negative feedback so far (but unfortunately no positive feedback either) 
> can it be applied ?
> 

Just in case anyone wants it:

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

This came out of discussions during the LPC and it's a good change.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
