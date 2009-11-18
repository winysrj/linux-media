Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51532 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbZKRJc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:32:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: v4l: Use the video_drvdata function in drivers
Date: Wed, 18 Nov 2009 10:32:52 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com> <1258504731-8430-8-git-send-email-laurent.pinchart@ideasonboard.com> <200911180801.48950.hverkuil@xs4all.nl>
In-Reply-To: <200911180801.48950.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181032.52676.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 November 2009 08:01:48 Hans Verkuil wrote:
> On Wednesday 18 November 2009 01:38:48 Laurent Pinchart wrote:
> > Fix all device drivers to use the video_drvdata function instead of
> > maintaining a local list of minor to private data mappings. Call
> > video_set_drvdata to register the driver private pointer when not
> > already done.
> >
> > Where applicable, the local list of mappings is completely removed when
> > it becomes unused.
> >
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Very nice cleanup!

Thank you.

> But you need to check the lock_kernel calls carefully, I think one is now
> unbalanced:

[snip]

Thanks for catching this. I tried to be quite careful but this one slipped in. 
I was planning to recheck all the patches for this kind of issue, so now is a 
good time to do so :-)

-- 
Regards,

Laurent Pinchart
