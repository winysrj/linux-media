Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59417 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2IMKQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 13/28] Add V4L2_CAP_MONOTONIC_TS where applicable.
Date: Thu, 13 Sep 2012 03:27:24 +0200
Message-ID: <2207739.BysYlheGG5@avalon>
In-Reply-To: <753ddb14136b19372f3a533961fc90b5adbfb07a.1347023744.git.hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <753ddb14136b19372f3a533961fc90b5adbfb07a.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 07 September 2012 15:29:13 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add the new V4L2_CAP_MONOTONIC_TS capability to those drivers that
> use monotomic timestamps instead of the system time.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

For uvcvideo,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

