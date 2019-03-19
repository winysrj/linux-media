Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 105B8C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 20:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D71352075C
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 20:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfCSUCj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 16:02:39 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38518 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfCSUCj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 16:02:39 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 9868D281363;
        Tue, 19 Mar 2019 20:02:37 +0000 (GMT)
Date:   Tue, 19 Mar 2019 21:02:33 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        Hirokazu Honda <hiroh@chromium.org>
Subject: Re: [RFC PATCH 2/3] media: v4l2: Extend pixel formats to unify
 single/multi-planar handling (and more)
Message-ID: <20190319210233.7542d3b3@collabora.com>
In-Reply-To: <53351fc1d3be8a268171162bc68939d38953d13a.camel@ndufresne.ca>
References: <20190319145243.25047-1-boris.brezillon@collabora.com>
        <20190319145243.25047-3-boris.brezillon@collabora.com>
        <53351fc1d3be8a268171162bc68939d38953d13a.camel@ndufresne.ca>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 19 Mar 2019 14:07:32 -0400
Nicolas Dufresne <nicolas@ndufresne.ca> wrote:

> Le mardi 19 mars 2019 à 15:52 +0100, Boris Brezillon a écrit :
> > +/**
> > + * struct v4l2_plane_ext_pix_format - additional, per-plane format definition
> > + * @modifier:          modifier applied to the format (used for tiled formats
> > + *                     and other kind of HW-specific formats, like compressed
> > + *                     formats)  
> 
> I have never seen HW that would allow per-plane modifiers on the DRM
> side, and I believe the newer API (enumeration) ignores this per-plane
> idea. Would be nice to investigate/verify this and avoid doing the same
> mistake.

I just check and you're right. I'll move the modifier field to
v4l2_ext_buffer.

> 
> > + * @sizeimage:         maximum size in bytes required for data, for which
> > + *                     this plane will be used
> > + * @bytesperline:      distance in bytes between the leftmost pixels in two
> > + *                     adjacent lines
> > + */
> > +struct v4l2_plane_ext_pix_format {
> > +       __u64 modifier;
> > +       __u32 sizeimage;
> > +       __u32 bytesperline;
> > +};  

