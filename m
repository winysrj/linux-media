Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39264 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2AWOhq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 09:37:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 05/10] v4l: add buffer exporting via dmabuf
Date: Mon, 23 Jan 2012 15:37:49 +0100
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, pawel@osciak.com
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com> <4F1D6F88.5080202@redhat.com>
In-Reply-To: <4F1D6F88.5080202@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201231537.51678.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 23 January 2012 15:32:40 Mauro Carvalho Chehab wrote:
> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
> > This patch adds extension to V4L2 api. It allow to export a mmap buffer
> > as file descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer
> > offset used by mmap and return a file descriptor on success.
> 
> This requires more discussions.
> 
> The usecase for this new API seems to replace the features previously
> provided by the overlay mode. There, not only the buffer were exposed to
> userspace, but some control were provided, in order to control the overlay
> window.
> 
> Please start a separate thread about that, explaining how are you imagining
> that a V4L2 application would use such ioctl.

I think this is currently just a proof of concept. I'm sure Tomasz will 
discuss the V4L2 API extension on the linux-media list when the code will be 
stabilized.

-- 
Regards,

Laurent Pinchart
