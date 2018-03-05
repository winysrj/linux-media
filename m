Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-38.mail.aliyun.com ([115.124.20.38]:35436 "EHLO
        out20-38.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933510AbeCEKfr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2018 05:35:47 -0500
Date: Mon, 5 Mar 2018 18:35:35 +0800
From: Yong <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: Re: [PATCH 0/7] media: sun6i: Various fixes and improvements
Message-Id: <20180305183535.b75ec79199efc3cacefc49c2@magewell.com>
In-Reply-To: <20180305093535.11801-1-maxime.ripard@bootlin.com>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
        <20180305093535.11801-1-maxime.ripard@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Mon,  5 Mar 2018 10:35:27 +0100
Maxime Ripard <maxime.ripard@bootlin.com> wrote:

> Hi Yong,
> 
> Here are a bunch of patches I came up with after testing your last
> (v8) version of the CSI patches.
> 
> There's some improvements (patches 1 and 7) and fixes for
> regressions found in the v8 compared to the v7 (patches 2, 3, 4 and
> 5), and one fix that we discussed for the signals polarity for the
> parallel interface (patch 6).
> 
> Feel free to squash them in your serie for the v9.

OK. Thank you!

I notice that your responses have not been listed in google group
since February.

> Thanks!
> Maxime
> 
> Maxime Ripard (7):
>   media: sun6i: Fill dma_pfn_offset to accomodate for the RAM offset
>   media: sun6i: Reduce the error level
>   media: sun6i: Pass the sun6i_csi_dev pointer to our helpers
>   media: sun6i: Don't emit a warning when the configured format isn't
>     found
>   media: sun6i: Support the YUYV format properly
>   media: sun6i: Invert the polarities
>   media: sun6i: Expose controls on the v4l2_device
> 
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 85 ++++++++++++++--------
>  drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h |  2 +
>  .../media/platform/sunxi/sun6i-csi/sun6i_video.c   |  6 ++
>  3 files changed, 63 insertions(+), 30 deletions(-)
> 
> -- 
> 2.14.3


Thanks,
Yong
