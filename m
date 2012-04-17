Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46155 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2DQA5C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 20:57:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com
Subject: Re: [PATCH v4 09/14] v4l: vb2: add prepare/finish callbacks to allocators
Date: Tue, 17 Apr 2012 02:57:13 +0200
Message-ID: <1556146.Ib2pQWG8jG@avalon>
In-Reply-To: <1334332076-28489-10-git-send-email-t.stanislaws@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-10-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Friday 13 April 2012 17:47:51 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> This patch adds support for prepare/finish callbacks in VB2 allocators.
> These callback are used for buffer flushing.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

