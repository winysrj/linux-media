Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43908 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753518AbcIEIWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 04:22:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] v4l: Add metadata buffer type and format
Date: Mon, 05 Sep 2016 11:23:15 +0300
Message-ID: <3474830.2BF5QWV559@avalon>
In-Reply-To: <b7fd41ca-5173-c5cb-20ff-c6dc5542a6c8@xs4all.nl>
References: <1472818023-11536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <b7fd41ca-5173-c5cb-20ff-c6dc5542a6c8@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 05 Sep 2016 09:40:19 Hans Verkuil wrote:
> On 09/02/2016 02:07 PM, Laurent Pinchart wrote:
> > The metadata buffer type is used to transfer metadata between userspace
> > and kernelspace through a V4L2 buffers queue. It comes with a new
> > metadata capture capability and format description.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> 
> Looks good. But include/trace/events/v4l2.h needs to be updated with the new
> buf_type as well.
> 
> I would also like to see patches for v4l2-ctl and v4l2-compliance.

I'll work on that.

> Having some support for it in vivid would be nice as well, but is a lower
> prio.

Feel free to submit patches ;-)

-- 
Regards,

Laurent Pinchart

