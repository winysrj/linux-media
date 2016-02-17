Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:36005 "EHLO
	mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423525AbcBQQMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 11:12:16 -0500
Received: by mail-yw0-f170.google.com with SMTP id e63so16693452ywc.3
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 08:12:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455705771-25771-1-git-send-email-jung.zhao@rock-chips.com>
References: <1455705673-25484-1-git-send-email-jung.zhao@rock-chips.com>
	<1455705771-25771-1-git-send-email-jung.zhao@rock-chips.com>
Date: Wed, 17 Feb 2016 08:12:15 -0800
Message-ID: <CAD=FV=V8tZvvqVCC4CMD9T-PYL+_3DojGq8jBEtm1raMYzw=3Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] [NOT FOR REVIEW] videobuf2-dc: Let drivers specify
 DMA attrs
From: Doug Anderson <dianders@chromium.org>
To: Jung Zhao <jung.zhao@rock-chips.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	"open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Feb 17, 2016 at 2:42 AM, Jung Zhao <jung.zhao@rock-chips.com> wrote:
> From: Tomasz Figa <tfiga@chromium.org>
>
> DMA allocations might be subject to certain reqiurements specific to the
> hardware using the buffers, such as availability of kernel mapping (for
> contents fix-ups in the driver). The only entity that knows them is the
> driver, so it must share this knowledge with vb2-dc.
>
> This patch extends the alloc_ctx initialization interface to let the
> driver specify DMA attrs, which are then stored inside the allocation
> context and will be used for all allocations with that context.
>
> As a side effect, all dma_*_coherent() calls are turned into
> dma_*_attrs() calls, because the attributes need to be carried over
> through all DMA operations.
>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Jung Zhao <jung.zhao@rock-chips.com>
> ---
> Changes in v2: None
>
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 33 +++++++++++++++++---------
>  include/media/videobuf2-dma-contig.h           | 11 ++++++++-
>  2 files changed, 32 insertions(+), 12 deletions(-)

This patch is already present in linuxnext.  I submitted it to Russell
King's Patch Tracking System a bit ago and got notice that it landed.
Checking linuxnext today I see:

ccc66e738252 ARM: 8508/2: videobuf2-dc: Let drivers specify DMA attrs

-Doug
