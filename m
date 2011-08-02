Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38513 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1HBNob (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 09:44:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 0/2] Frame synchronisation events and support for them in the OMAP 3 ISP driver
Date: Tue, 2 Aug 2011 15:44:39 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
References: <4E37D415.8060000@iki.fi>
In-Reply-To: <4E37D415.8060000@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108021544.40281.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 02 August 2011 12:40:21 Sakari Ailus wrote:
> Hi all,
> 
> This is the second version of the frame synchronisation patchset which
> contains fixes based on the comments from Laurent. The patches are on
> top of this tree which contains acked patches:
> 
> http://linuxtv.org/git/sailus/media_tree.git media-for-3.1-misc-1

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Shortlog is available here:
> 
> <URL:http://git.linuxtv.org/sailus/media_tree.git/shortlog/refs/heads/media
> -for-3.1-misc-1>
> 
> Changes since the first one:
> 
> - Fixed the description of the second patch.
> - Clarified the documentation.
> - v4l2_event_frame_sync.buffer_sequence renamed to frame_sequence
> 
> Changes to the RFC:
> 
> - Renamed V4L2_EVENT_FRAME_START to V4L2_EVENT_FRAME_SYNC.
> - Removed extra reference to V4L2_EVENT_FRAME_START in documentation; it
> is mentioned in the same page struct v4l2_event_frame_sync is related to
> it.
> - The OMAP 3 ISP driver check that the id field is zero in anticipation of
> such events.

-- 
Regards,

Laurent Pinchart
