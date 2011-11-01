Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54232 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1KAMYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Nov 2011 08:24:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC] Monotonic clock usage in buffer timestamps
Date: Tue, 1 Nov 2011 13:24:35 +0100
Cc: robert.swain@collabora.co.uk
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111011324.36742.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

The V4L2 specification documents the v4l2_buffer timestamp field as

"For input streams this is the system time (as returned by the gettimeofday() 
function) when the first data byte was captured."

The system time is a pretty bad clock source to timestamp buffers, as it can 
jump back and forth in time. Using a monotonic clock, as returned by 
clock_gettime(CLOCK_MONOTONIC) (or ktime_get_ts() in the kernel), would be 
much more useful.

Several drivers already use a monotonic clock instead of the system clock, 
which currently violates the V4L2 specification. As those drivers do the right 
thing from a technical point of view, I'd really hate "fixing" them by making 
them use gettimeofday().

We should instead fix the V4L2 specification to mandate the use of a monotonic 
clock (which could then also support hardware timestamps when they are 
available). Would such a change be acceptable ?

-- 
Regards,

Laurent Pinchart
