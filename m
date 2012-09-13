Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59422 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2IMKQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 10/28] Rename V4L2_(IN|OUT)_CAP_CUSTOM_TIMINGS.
Date: Thu, 13 Sep 2012 04:22:52 +0200
Message-ID: <1460675.kl1J5jUHQS@avalon>
In-Reply-To: <0c01d1164be688b20ae03f51c700a31a7f154acc.1347023744.git.hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <0c01d1164be688b20ae03f51c700a31a7f154acc.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 07 September 2012 15:29:10 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The 'custom' timings are no longer just for custom timings, but also for
> standard CEA/VESA timings. So rename to V4L2_IN/OUT_CAP_DV_TIMINGS.
> 
> The old define is still kept for backwards compatibility.

Should they be added to feature-removal-schedule.txt ?

> This decision was taken during the 2012 Media Workshop.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

-- 
Regards,

Laurent Pinchart

