Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2306 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2JOIBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 04:01:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv10 18/26] v4l: add buffer exporting via dmabuf
Date: Mon, 15 Oct 2012 10:01:17 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <1349880405-26049-19-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1349880405-26049-19-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210151001.17151.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed October 10 2012 16:46:37 Tomasz Stanislawski wrote:
> This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
> descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
> mmap and return a file descriptor on success.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |    1 +
>  drivers/media/v4l2-core/v4l2-dev.c            |    1 +
>  drivers/media/v4l2-core/v4l2-ioctl.c          |   10 +++++++++
>  include/linux/videodev2.h                     |   28 +++++++++++++++++++++++++
>  include/media/v4l2-ioctl.h                    |    2 ++
>  5 files changed, 42 insertions(+)

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
