Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50890 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2K1Ne5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 08:34:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Reset subdev v4l2_dev field to NULL if registration fails
Date: Wed, 28 Nov 2012 14:36:02 +0100
Message-ID: <6841513.2rQ6d3CPlS@avalon>
In-Reply-To: <50B544B0.9000207@gmail.com>
References: <1353804080-25492-1-git-send-email-laurent.pinchart@ideasonboard.com> <50B544B0.9000207@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tuesday 27 November 2012 23:54:40 Sylwester Nawrocki wrote:
> On 11/25/2012 01:41 AM, Laurent Pinchart wrote:
> > When subdev registration fails the subdev v4l2_dev field is left to a
> > non-NULL value. Later calls to v4l2_device_unregister_subdev() will
> > consider the subdev as registered and will module_put() the subdev
> > module without any matching module_get().
> > 
> > Fix this by setting the subdev v4l2_dev field to NULL in
> > v4l2_device_register_subdev() when the function fails.
> > 
> > Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> 
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Thank you.

> I'm just wondering whether including this patch in stable kernel releases
> could potentially break anything.

I don't think it would, the patch only touches error paths, and clearly fixes 
a bug. So

Cc: stable@vger.kernel.org

looks like a good idea.

-- 
Regards,

Laurent Pinchart

