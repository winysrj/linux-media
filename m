Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59417 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab2IMKQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 06/28] v4l2-core: deprecate V4L2_BUF_TYPE_PRIVATE
Date: Thu, 13 Sep 2012 04:21:14 +0200
Message-ID: <3896855.5Ed4GMDzB4@avalon>
In-Reply-To: <673c927597decb682b3ca4b732ffbb306bc99496.1347023744.git.hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <673c927597decb682b3ca4b732ffbb306bc99496.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 07 September 2012 15:29:06 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This buffer type isn't used at all, and since it is effectively undefined
> what it should do it is deprecated. The define still exists, but any
> internal support for such buffers is removed.
> 
> The decisions to deprecate this was taken during the 2012 Media Workshop.

What about also adding V4L2_BUF_TYPE_PRIVATE to Documentation/feature-removal-
schedule.txt ?

-- 
Regards,

Laurent Pinchart

