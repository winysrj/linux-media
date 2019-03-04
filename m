Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A049C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 18:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 629BE206BA
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 18:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfCDSt0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 13:49:26 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50176 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfCDSt0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 13:49:26 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 106F2275683
Message-ID: <4aac6476ffe6a6be021c69a708f19d5da30a79e4.camel@collabora.com>
Subject: Re: [PATCH v4 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jernej.skrabec@gmail.com, jonas@kwiboo.se,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Date:   Mon, 04 Mar 2019 15:49:11 -0300
In-Reply-To: <9817c9875638ed2484d61e6e128e2551cf3bda4c.1550672228.git-series.maxime.ripard@bootlin.com>
References: <cover.1862a43851950ddee041d53669f8979aba863c38.1550672228.git-series.maxime.ripard@bootlin.com>
         <9817c9875638ed2484d61e6e128e2551cf3bda4c.1550672228.git-series.maxime.ripard@bootlin.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2019-02-20 at 15:17 +0100, Maxime Ripard wrote:
> From: Pawel Osciak <posciak@chromium.org>
> 
> Stateless video codecs will require both the H264 metadata and slices in
> order to be able to decode frames.
> 
> This introduces the definitions for a new pixel format for H264 slices that
> have been parsed, as well as the structures used to pass the metadata from
> the userspace to the kernel.
> 
> Co-Developped-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Guenter Roeck <groeck@chromium.org>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/media/uapi/v4l/biblio.rst            |   9 +-
>  Documentation/media/uapi/v4l/extended-controls.rst | 547 ++++++++++++++-

It seems Hans splitted the documentation and so this should now
go to Documentation/media/uapi/v4l/ext-ctrls-codec.rst.

[..]
> 
> +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H264 parsed slices */
>  #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
>  #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
>  #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */

I haven't seen any objections to renaming this to V4L2_PIX_FMT_H264_SLICE_RAW,
so if you could be so kind to push v5 with this rename (or similar), and also
rebasing to the master branch, I could then submit the H264 decoder support for
the Rockchip VPU.

There is still the question brought up by Tomasz, about moving this pixel format
to a non-public header. Perhaps someone has some ideas on this?

Thanks a lot!
Ezequiel

