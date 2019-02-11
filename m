Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FD8C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 17:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D20721B68
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 17:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbfBKRMh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:12:37 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38476 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfBKRMh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 12:12:37 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 081BB260491
Message-ID: <209bafb880bd9410f875f5e6f16923e38ec76df4.camel@collabora.com>
Subject: Re: [PATCH v3 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     nicolas.dufresne@collabora.com, tfiga@chromium.org,
        posciak@chromium.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        jenskuske@gmail.com, jernej.skrabec@gmail.com, jonas@kwiboo.se,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Date:   Mon, 11 Feb 2019 14:12:25 -0300
In-Reply-To: <562aefcd53a1a30d034e97f177096d70fb705f2b.1549895062.git-series.maxime.ripard@bootlin.com>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
         <562aefcd53a1a30d034e97f177096d70fb705f2b.1549895062.git-series.maxime.ripard@bootlin.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 2019-02-11 at 15:39 +0100, Maxime Ripard wrote:
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index d6eed479c3a6..6fc955926bdb 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -645,6 +645,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
>  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
>  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
> +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H264 parsed slices */

Nicolas and I have discussed the pixel format, and came up with
the following proposal.

Given this format represents H264 parsed slices, without any start code,
perhpaps we name it as:

V4L2_PIX_FMT_H264_SLICE_RAW

Then, we'd also add:

V4L2_PIX_FMT_H264_SLICE_ANNEX_B

To represent H264 parsed slices with annex B (3- or 4-byte) start code.
This one is what the Rockchip VPU driver would expose.

Ideas?

