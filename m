Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60059
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752469AbdDCTqt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 15:46:49 -0400
Date: Mon, 3 Apr 2017 16:46:40 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Paul <seanpaul@chromium.org>
Cc: dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Archit Taneja <architt@codeaurora.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        laurent.pinchart+renesas@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PULL] Synopsys Media Formats
Message-ID: <20170403164640.26f28aff@vento.lan>
In-Reply-To: <20170403163544.kcw5kk52tgku5xua@art_vandelay>
References: <20170403163544.kcw5kk52tgku5xua@art_vandelay>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 3 Apr 2017 12:35:44 -0400
Sean Paul <seanpaul@chromium.org> escreveu:

> Hi Mauro,
> 
> Here's the pull for Neil's new media formats. We're using a topic branch in
> drm-misc, so it will not change. Once you have acked, we'll pull this in and
> apply the rest of Neil's set.

Thanks!

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> Thanks,
> 
> Sean
> 
> 
> The following changes since commit a71c9a1c779f2499fb2afc0553e543f18aff6edf:
> 
>   Linux 4.11-rc5 (2017-04-02 17:23:54 -0700)
> 
> are available in the git repository at:
> 
>   git://anongit.freedesktop.org/git/drm-misc tags/topic/synopsys-media-formats-2017-04-03
> 
> for you to fetch changes up to 3c2507d308afb233dd41387b41512e7aa97535f0:
> 
>   documentation: media: Add documentation for new RGB and YUV bus formats (2017-04-03 11:51:40 -0400)
> 
> ----------------------------------------------------------------
> Media formats for synopsys HDMI  TX Controller
> 
> ----------------------------------------------------------------
> Neil Armstrong (2):
>       media: uapi: Add RGB and YUV bus formats for Synopsys HDMI TX Controller
>       documentation: media: Add documentation for new RGB and YUV bus formats
> 
>  Documentation/media/uapi/v4l/subdev-formats.rst | 3000 +++++++++++++++--------
>  include/uapi/linux/media-bus-format.h           |   13 +-
>  2 files changed, 1990 insertions(+), 1023 deletions(-)
> 



Thanks,
Mauro
