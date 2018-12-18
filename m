Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241D5C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 14:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDB43217D7
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 14:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbeLROV0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 09:21:26 -0500
Received: from mail.bootlin.com ([62.4.15.54]:60051 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbeLROVZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 09:21:25 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 36642207D9; Tue, 18 Dec 2018 15:21:23 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-38-38.w90-88.abo.wanadoo.fr [90.88.157.38])
        by mail.bootlin.com (Postfix) with ESMTPSA id E58772072C;
        Tue, 18 Dec 2018 15:21:22 +0100 (CET)
Message-ID: <d1be50c07d19713a7813e5fed4b88e56d4d106e8.camel@bootlin.com>
Subject: Re: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Jonas Karlman <jonas@kwiboo.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Jernej =?UTF-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>
Date:   Tue, 18 Dec 2018 15:21:23 +0100
In-Reply-To: <985a4c64-f914-8405-2a78-422bcd8f2139@xs4all.nl>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
         <20181212123901.34109-7-hverkuil-cisco@xs4all.nl>
         <AM0PR03MB4676988BC60352DFDFAD0783ACA70@AM0PR03MB4676.eurprd03.prod.outlook.com>
         <985a4c64-f914-8405-2a78-422bcd8f2139@xs4all.nl>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Thu, 2018-12-13 at 13:28 +0100, Hans Verkuil wrote:
> On 12/12/18 7:28 PM, Jonas Karlman wrote:
> > Hi Hans,
> > 
> > Since this function only return DEQUEUED and DONE buffers,
> > it cannot be used to find a capture buffer that is both used for
> > frame output and is part of the frame reference list.
> > E.g. a bottom field referencing a top field that is already
> > part of the capture buffer being used for frame output.
> > (top and bottom field is output in same buffer)
> > 
> > Jernej Škrabec and me have worked around this issue in cedrus driver by
> > first checking
> > the tag/timestamp of the current buffer being used for output frame.
> > 
> > 
> > // field pictures may reference current capture buffer and is not
> > returned by vb2_find_tag
> > if (v4l2_buf->tag == dpb->tag)
> >     buf_idx = v4l2_buf->vb2_buf.index;
> > else
> >     buf_idx = vb2_find_tag(cap_q, dpb->tag, 0);
> > 
> > 
> > What is the recommended way to handle such case?
> 
> That is the right approach for this. Interesting corner case, I hadn't
> considered that.
> 
> > Could vb2_find_timestamp be extended to allow QUEUED buffers to be returned?
> 
> No, because only the driver knows what the current buffer is.
> 
> Buffers that are queued to the driver are in state ACTIVE. But there may be
> multiple ACTIVE buffers and vb2 doesn't know which buffer is currently
> being processed by the driver.
> 
> So this will have to be checked by the driver itself.

Interesting corner case indeed, we hadn't considered the possibility of
interlaced pictures refeering to the current capture buffer.

Hans, do you want to include that change in a future revision of this
series or should that be a separate follow-up patch?

I'm fine with both options (and could definitely craft the change in
the latter case).

Cheers,

Paul

> > In our sample code we only keep at most one output, one capture buffer
> > in queue
> > and use buffer indices as tag/timestamp to simplify buffer handling.
> > FFmpeg keeps track of buffers/frames referenced and a buffer will not be
> > reused
> > until the codec and display pipeline have released all references to it.
> > 
> > Sample code having interlaced and multi-slice support using previous tag
> > version of this patchset can be found at:
> > https://github.com/jernejsk/LibreELEC.tv/blob/hw_dec_ffmpeg/projects/Allwinner/patches/linux/0025-H264-fixes.patch#L120-L124
> > https://github.com/Kwiboo/FFmpeg/compare/4.0.3-Leia-Beta5...v4l2-request-hwaccel
> > 
> > Regards,
> > Jonas
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

