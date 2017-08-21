Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60306 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753930AbdHUPwX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 11:52:23 -0400
Date: Mon, 21 Aug 2017 16:52:03 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, laurent.pinchart@ideasonboard.com,
        jonathan.chai@arm.com
Subject: DRM Format Modifiers in v4l2
Message-ID: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I couldn't find this topic talked about elsewhere, but apologies if
it's a duplicate - I'll be glad to be steered in the direction of a
thread.

We'd like to support DRM format modifiers in v4l2 in order to share
the description of different (mostly proprietary) buffer formats
between e.g. a v4l2 device and a DRM device.

DRM format modifiers are defined in include/uapi/drm/drm_fourcc.h and
are a vendor-namespaced 64-bit value used to describe various
vendor-specific buffer layouts. They are combined with a (DRM) FourCC
code to give a complete description of the data contained in a buffer.

The same modifier definition is used in the Khronos EGL extension
EGL_EXT_image_dma_buf_import_modifiers, and is supported in the
Wayland linux-dmabuf protocol.


This buffer information could of course be described in the
vendor-specific part of V4L2_PIX_FMT_*, but this would duplicate the
information already defined in drm_fourcc.h. Additionally, there
would be quite a format explosion where a device supports a dozen or
more formats, all of which can use one or more different
layouts/compression schemes.

So, I'm wondering if anyone has views on how/whether this could be
incorporated?

I spoke briefly about this to Laurent at LPC last year, and he
suggested v4l2_control as one approach.

I also wondered if could be added in v4l2_pix_format_mplane - looks
like there's 8 bytes left before it exceeds the 200 bytes, or could go
in the reserved portion of v4l2_plane_pix_format.

Thanks for any thoughts,
-Brian
