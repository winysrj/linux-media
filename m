Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53591 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2DURRk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 13:17:40 -0400
Received: by iadi9 with SMTP id i9so156149iad.19
        for <linux-media@vger.kernel.org>; Sat, 21 Apr 2012 10:17:40 -0700 (PDT)
Message-ID: <4F92D945.1090805@landley.net>
Date: Sat, 21 Apr 2012 10:59:01 -0500
From: Rob Landley <rob@landley.net>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	linux-doc@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [PATCHv5 00/13] Integration of videobuf2 with dmabuf
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/20/2012 09:45 AM, Tomasz Stanislawski wrote:
> Hello everyone,
> This patchset adds support for DMABUF [2] importing to V4L2 stack.
> The support for DMABUF exporting was moved to separate patchset
> due to dependency on patches for DMA mapping redesign by
> Marek Szyprowski [4].

Would it be an an option to _not_ cc: all 14 patches to the linux-doc
list when 12 of them have nothing to do with documentation? (Or do the
tools not allow for that?)

Just wondering...

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
