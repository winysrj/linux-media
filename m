Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37735
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754619AbdGTOWm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 10:22:42 -0400
Date: Thu, 20 Jul 2017 11:22:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v2 3/3] drm: rcar-du: Repair vblank for DRM page flips
 using the VSP
Message-ID: <20170720112234.295a47eb@vento.lan>
In-Reply-To: <20170711222942.27735-4-laurent.pinchart+renesas@ideasonboard.com>
References: <20170711222942.27735-1-laurent.pinchart+renesas@ideasonboard.com>
        <20170711222942.27735-4-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 12 Jul 2017 01:29:42 +0300
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The driver recently switched from handling page flip completion in the
> DU vertical blanking handler to the VSP frame end handler to fix a race
> condition. This unfortunately resulted in incorrect timestamps in the
> vertical blanking events sent to userspace as vertical blanking is now
> handled after sending the event.
> 
> To fix this we must reverse the order of the two operations. The easiest
> way is to handle vertical blanking in the VSP frame end handler before
> sending the event. The VSP frame end interrupt occurs approximately 50µs
> earlier than the DU frame end interrupt, but this should not cause any
> undue harm.
> 
> As we need to handle vertical blanking even when page flip completion is
> delayed, the VSP driver now needs to call the frame end completion
> callback unconditionally, with a new argument to report whether page
> flip has completed.
> 
> With this new scheme the DU vertical blanking interrupt isn't needed
> anymore, so we can stop enabling it.
> 
> Fixes: d503a43ac06a ("drm: rcar-du: Register a completion callback with VSP1")
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks,
Mauro
