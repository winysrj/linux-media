Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49175 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbeKNTqH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 14:46:07 -0500
Message-ID: <1542188614.4095.5.camel@pengutronix.de>
Subject: Re: [PATCH] media: vb2: Allow reqbufs(0) with "in use" MMAP buffers
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Date: Wed, 14 Nov 2018 10:43:34 +0100
In-Reply-To: <20181113222743.bt452a3xyapuv7ce@valkosipuli.retiisi.org.uk>
References: <20181113150621.22276-1-p.zabel@pengutronix.de>
         <20181113222743.bt452a3xyapuv7ce@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wed, 2018-11-14 at 00:27 +0200, Sakari Ailus wrote:
[...]
> This lets the user to allocate lots of mmap'ed buffers that are pinned in
> physical memory.

This is already possible without this patch, by closing the fd instead
of calling reqbufs(0).

> Considering that we don't really have a proper mechanism
> to limit that anyway,
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> That said, the patch must be accompanied by the documentation change in
> Documentation/media/uapi/v4l/vidioc-reqbufs.rst .

Oh right, thanks. I'll add V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS to
_v4l2-buf-capabilities in v2.

regards
Philipp
