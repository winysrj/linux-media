Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43517 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461Ab1IINY4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 09:24:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/9 v7] V4L: document the new VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF ioctl()s
Date: Fri, 9 Sep 2011 15:24:37 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1109080942172.31156@axis700.grange> <Pine.LNX.4.64.1109080945290.31156@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109080945290.31156@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109091524.41716.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

As discussed over jabber, we're suffering from an AB-BA deadlock that this 
patch could make worse.

The mmap code path takes mm->mmap_sem in the kernel' mmap handler before 
calling the driver's mmap handler. The driver will then lock the queue mutex 
before calling vb2_mmap (or let the core lock the vdev mutex).

In the VIDIOC_QBUF code path, the driver will first lock the queue mutex (or 
let the core lock the vdev mutex) and call vb2_qbuf. This will then take mm-
>mmap_sem to call get_user_pages for USERPTR buffers. The two locks are taken 
in different orders depending on the code paths, resulting in a possible AB-BA 
deadlock.

mmap'ing USERPTR buffers doesn't make sense, so application will likely not 
experience any deadlock. However, if VIDIOC_CREATE_BUFS allows mixing MMAP and 
USERPTR buffers, we could suddenly see a rise of deadlock issues resulting 
from valid use cases.

This problem needs to be fixed anyway, as a rogue application can currently 
produce a kernel deadlock. The fix can probably be pretty simple if we decide 
not to support mixing MMAP and USERPTR buffers, but it might become more 
complex if we need to support that.

I'm interested in hearing what others think about this.

-- 
Regards,

Laurent Pinchart
