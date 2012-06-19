Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38818 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2FSVQc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 17:16:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCHv7 00/15] Integration of videobuf2 with dmabuf
Date: Tue, 19 Jun 2012 23:16:43 +0200
Message-ID: <2332183.EmVoCWmVgb@avalon>
In-Reply-To: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thursday 14 June 2012 15:37:34 Tomasz Stanislawski wrote:
> Hello everyone,
> This patchset adds support for DMABUF [2] importing to V4L2 stack.
> The support for DMABUF exporting was moved to separate patchset
> due to dependency on patches for DMA mapping redesign by
> Marek Szyprowski [4]. This patchset depends on new scatterlist
> constructor [5].

There are very few remaining issues with the patch set, I think the next 
iteration will be the right one.

[snip]

> [5]
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/47983

What's the status of that patch ? Is it ready for v3.6 ? I'd like to see 
DMABUF import support in V4L2 in v3.6.

-- 
Regards,

Laurent Pinchart

