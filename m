Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3541 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2JOH75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 03:59:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv10 17/26] Documentation: media: description of DMABUF exporting in V4L2
Date: Mon, 15 Oct 2012 09:59:35 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com,
	linux-doc@vger.kernel.org
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <1349880405-26049-18-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1349880405-26049-18-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210150959.35878.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed October 10 2012 16:46:36 Tomasz Stanislawski wrote:
> This patch adds description and usage examples for exporting
> DMABUF file descriptor in V4L2.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: linux-doc@vger.kernel.org
> ---
>  Documentation/DocBook/media/v4l/compat.xml        |    3 +
>  Documentation/DocBook/media/v4l/io.xml            |    3 +
>  Documentation/DocBook/media/v4l/v4l2.xml          |    1 +
>  Documentation/DocBook/media/v4l/vidioc-expbuf.xml |  212 +++++++++++++++++++++
>  4 files changed, 219 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-expbuf.xml
> 

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
