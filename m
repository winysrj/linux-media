Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39946 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2D3O1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 10:27:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
Date: Mon, 30 Apr 2012 16:27:24 +0200
Message-ID: <2396617.gGNm1rAEoQ@avalon>
In-Reply-To: <201204301615.30954.hverkuil@xs4all.nl>
References: <20120430130413.GL7913@valkosipuli.localdomain> <20120430140615.GM7913@valkosipuli.localdomain> <201204301615.30954.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 30 April 2012 16:15:30 Hans Verkuil wrote:
> On Monday 30 April 2012 16:06:16 Sakari Ailus wrote:

[snip]

> > One option is to keep the reserved fields as array even there was just one
> > of them or if it no longer was there. If so, reserved should have been
> > reserved[1] in the first place. This would make it easier to deal with
> > the changing size of the reserved field.
> 
> Definitely. But I think struct v4l2_buffer has been like this for a long
> time (Laurent would know when the input field was added).

That was 8 to 9 years ago. I'm responsible for that terrible idea, so I'd be 
happy to see the input field removed ;-)

-- 
Regards,

Laurent Pinchart

