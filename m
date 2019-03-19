Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A10C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 20:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DCD0213F2
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 20:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfCSUVG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 16:21:06 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38574 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfCSUVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 16:21:06 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id A7DFB281416;
        Tue, 19 Mar 2019 20:21:04 +0000 (GMT)
Date:   Tue, 19 Mar 2019 21:21:00 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Brian Starkey <Brian.Starkey@arm.com>
Cc:     Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Hirokazu Honda <hiroh@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>, nd <nd@arm.com>
Subject: Re: [RFC PATCH 2/3] media: v4l2: Extend pixel formats to unify
 single/multi-planar handling (and more)
Message-ID: <20190319212100.22caf119@collabora.com>
In-Reply-To: <20190319173758.kerufidooegbhtyf@DESKTOP-E1NTVVP.localdomain>
References: <20190319145243.25047-1-boris.brezillon@collabora.com>
        <20190319145243.25047-3-boris.brezillon@collabora.com>
        <20190319173758.kerufidooegbhtyf@DESKTOP-E1NTVVP.localdomain>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 19 Mar 2019 17:37:59 +0000
Brian Starkey <Brian.Starkey@arm.com> wrote:

> Hi Boris,
> 
> On Tue, Mar 19, 2019 at 03:52:42PM +0100, Boris Brezillon wrote:
> > This is part of the multiplanar and singleplanar unification process.
> > v4l2_ext_pix_format is supposed to work for both cases.
> > 
> > We also add the concept of modifiers already employed in DRM to expose
> > HW-specific formats (like tiled or compressed formats) and allow
> > exchanging this information with the DRM subsystem in a consistent way.  
> 
> I'm quite happy to see modifiers working their way into v4l2, thank
> you for picking up that torch.
> 
> I didn't see anything about format enumeration here - do you have any
> thoughts on how you think it would work?

You mean extending format enumeration to also expose supported
modifiers? I intentionally left that on the side as my primary goal was
not to support modifiers. One solution would be to mimic the DRM
approach [1] where each modifier is attached a bitmap encoding which
formats they can be applied to. But, if the number of formats and
modifiers is relatively small, we can go for something simpler to parse
with an EXT_ENUMFMT that would return the list of supported formats and
for each format entry the number of modifiers that can be applied to
this format. With another ioctl (V4L2_FMT_ENUM_MODS?) you would
retrieve the modifiers that can be applied to a specific format.

[1]https://elixir.bootlin.com/linux/v5.1-rc1/source/include/uapi/drm/drm_mode.h#L779
