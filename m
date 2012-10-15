Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1695 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2JOHyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 03:54:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv10 02/26] Documentation: media: description of DMABUF importing in V4L2
Date: Mon, 15 Oct 2012 09:53:54 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com,
	linux-doc@vger.kernel.org
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <1349880405-26049-3-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1349880405-26049-3-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210150953.54929.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed October 10 2012 16:46:21 Tomasz Stanislawski wrote:
> This patch adds description and usage examples for importing
> DMABUF file descriptor in V4L2.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: linux-doc@vger.kernel.org
> ---
>  Documentation/DocBook/media/v4l/compat.xml         |    4 +
>  Documentation/DocBook/media/v4l/io.xml             |  181 +++++++++++++++++++-
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |   16 +-
>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   17 ++
>  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 ++---
>  5 files changed, 235 insertions(+), 30 deletions(-)
> 

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
