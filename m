Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3C5C282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 21:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 141C22081B
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 21:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731076AbfBLVSG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 16:18:06 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43658 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbfBLVSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 16:18:06 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 20B0327FB65
Message-ID: <fb7e6bf4474583535961712bac5248b43dd47af0.camel@collabora.com>
Subject: Re: [PATCH v3 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jernej.skrabec@gmail.com, jonas@kwiboo.se,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Date:   Tue, 12 Feb 2019 18:17:52 -0300
In-Reply-To: <20190212130548.tytlxmbu4q6qgzzq@flea>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
         <562aefcd53a1a30d034e97f177096d70fb705f2b.1549895062.git-series.maxime.ripard@bootlin.com>
         <716ae1ff-8e62-c723-5b5a-0b018cf6af6a@xs4all.nl>
         <db7a762a-8bc3-0391-036b-1fda2e445023@xs4all.nl>
         <20190212130548.tytlxmbu4q6qgzzq@flea>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-02-12 at 14:05 +0100, Maxime Ripard wrote:
> Hi,
> 
> On Mon, Feb 11, 2019 at 04:21:47PM +0100, Hans Verkuil wrote:
> > > I think the API should be designed with 4k video in mind. So if some of
> > > these constants would be too small when dealing with 4k (even if the
> > > current HW doesn't support this yet), then these constants would have to
> > > be increased.
> > > 
> > > And yes, I know 8k video is starting to appear, but I think it is OK
> > > that additional control(s) would be needed to support 8k.
> > 
> > Hmm, 4k (and up) is much more likely to use HEVC. So perhaps designing this
> > for 4k is overkill.
> > 
> > Does anyone know if H.264 is used for 4k video at all? If not (or if very
> > rare), then just ignore this.
> 
> I don't know the state of it right now, but until quite recently
> youtube at least was encoding their 4k videos in both VP9 and
> H264. They might have moved to h265 since, but considering 4k doesn't
> seem unreasonable.
> 

Just asked the multimedia team here, and they say that 4k videos are in
fact widely used for both H264 and VP9 because of the HEVC licensing issues,
and because gains in compressions are not so impressive.

Regards,
Ezequiel

