Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59422 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab2IMKQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 04/28] DocBook: make the G/S/TRY_FMT specification more strict.
Date: Thu, 13 Sep 2012 04:18:50 +0200
Message-ID: <1876473.Ned5IQmK1Q@avalon>
In-Reply-To: <5c449812e54fff0816282e712ab9e24c8b278cb6.1347023744.git.hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <5c449812e54fff0816282e712ab9e24c8b278cb6.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 September 2012 15:29:04 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> - S/TRY_FMT should always succeed, unless an invalid type field is passed
> in. - TRY_FMT should give the same result as S_FMT, all other things being
> equal. - ENUMFMT may return different formats for different inputs or
> outputs.
> 
> This was decided during the 2012 Media Workshop.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

With the typo fix reported by Sylwester,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

