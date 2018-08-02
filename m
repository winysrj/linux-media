Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36711 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbeHBLmU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 07:42:20 -0400
Message-ID: <1533203515.3516.13.camel@pengutronix.de>
Subject: Re: [PATCH v3 04/14] gpu: ipu-v3: Fix U/V offset macros for planar
 4:2:0
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX"
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Thu, 02 Aug 2018 11:51:55 +0200
In-Reply-To: <1533150747-30677-5-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
         <1533150747-30677-5-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-08-01 at 12:12 -0700, Steve Longerbeam wrote:
> The U and V offset macros for planar 4:2:0 (U_OFFSET, V_OFFSET, and
> UV_OFFSET), are not correct. The height component to the offset was
> calculated as:
> 
> (pix->width * y / 4)
> 
> But this does not produce correct offsets for odd values of y (luma
> line #). The luma line # must be decimated by two to produce the
> correct U/V line #, so the correct formula is:
> 
> (pix->width * (y / 2) / 2)
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Thank you this patch is applied to imx-drm/fixes now.

regards
Philipp
