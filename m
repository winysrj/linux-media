Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF80C282CA
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 16:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C05222BA
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 16:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392704AbfBMQ2t (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:28:49 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47850 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392690AbfBMQ2t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 11:28:49 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 14D8227F765
Message-ID: <2e468fd22b577f1a5fd5d3186d6cc88e442e07ec.camel@collabora.com>
Subject: Re: [PATCH v3 0/2] media: cedrus: Add H264 decoding support
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg "
         "Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jonas Karlman <jonas@kwiboo.se>, linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date:   Wed, 13 Feb 2019 13:28:34 -0300
In-Reply-To: <CAAFQd5DE+T6KJ0TXcQUxLSnog5enQf5G0SVM+5t6f60VjcovFw@mail.gmail.com>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
         <CAAFQd5AcqiwAb30ajLxmj6LZoabVygUsAB8A+drpityOAvY60A@mail.gmail.com>
         <4a1346315224850faf31345b577ce3a29c069f3a.camel@collabora.com>
         <CAAFQd5DE+T6KJ0TXcQUxLSnog5enQf5G0SVM+5t6f60VjcovFw@mail.gmail.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2019-02-13 at 12:02 +0900, Tomasz Figa wrote:
> On Wed, Feb 13, 2019 at 6:22 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > Hey Tomasz,
> > 
> > On Tue, 2019-02-12 at 21:50 +0900, Tomasz Figa wrote:
> > > Hi Maxime,
> > > 
> > > On Mon, Feb 11, 2019 at 11:39 PM Maxime Ripard
> > > <maxime.ripard@bootlin.com> wrote:
> > > > Hi,
> > > > 
> > > > Here is a new version of the H264 decoding support in the cedrus
> > > > driver.
> > > 
> > > Thanks for working on this. Please see my comments below.
> > > 
> > > > As you might already know, the cedrus driver relies on the Request
> > > > API, and is a reverse engineered driver for the video decoding engine
> > > > found on the Allwinner SoCs.
> > > > 
> > > > This work has been possible thanks to the work done by the people
> > > > behind libvdpau-sunxi found here:
> > > > https://github.com/linux-sunxi/libvdpau-sunxi/
> > > > 
> > > > I've tested the various ABI using this gdb script:
> > > > http://code.bulix.org/jl4se4-505620?raw
> > > > 
> > > > And this test script:
> > > > http://code.bulix.org/8zle4s-505623?raw
> > > > 
> > > > The application compiled is quite trivial:
> > > > http://code.bulix.org/e34zp8-505624?raw
> > > > 
> > > > The output is:
> > > > arm:    builds/arm-test-v4l2-h264-structures
> > > >         SHA1: 88cbf7485ba81831fc3b93772b215599b3b38318
> > > > x86:    builds/x86-test-v4l2-h264-structures
> > > >         SHA1: 88cbf7485ba81831fc3b93772b215599b3b38318
> > > > x64:    builds/x64-test-v4l2-h264-structures
> > > >         SHA1: 88cbf7485ba81831fc3b93772b215599b3b38318
> > > > arm64:  builds/arm64-test-v4l2-h264-structures
> > > >         SHA1: 88cbf7485ba81831fc3b93772b215599b3b38318
> > > > 
> > > > Let me know if there's any flaw using that test setup, or if you have
> > > > any comments on the patches.
> > > > 
> > > > Maxime
> > > > 
> > > > Changes from v2:
> > > >   - Simplified _cedrus_write_ref_list as suggested by Jernej
> > > >   - Set whether the frame is used as reference using nal_ref_idc
> > > >   - Respect chroma_format_idc
> > > >   - Fixes for the scaling list and prediction tables
> > > >   - Wrote the documentation for the flags
> > > >   - Added a bunch of defines to the driver bit fields
> > > >   - Reworded the controls and data format descriptions as suggested
> > > >     by Hans
> > > >   - Reworked the controls' structure field size to avoid padding
> > > >   - Removed the long term reference flag
> > > 
> > > This and...
> > > 
> > 
> > Maxime has dropped this because of Ayaka's mail about long term references
> > not making much sense in stateless decoders.
> 
> I haven't seen any argument confirming that thesis, though. I should
> have kicked in earlier, sorry.
> 

OK, in that case, we need to have this flag back.

> > I noticed that RK3399 TRM has a field to specify long term refs and
> > so was wondering about this item as well.
> > 
> > > >   - Reintroduced the neighbor info buffer
> > > >   - Removed the ref_pic_list_p0/b0/b1 arrays that are redundant with the
> > > >     one in the DPB
> > > 
> > > these are used in our Rockchip VDEC driver.
> > > 
> > > Could you elaborate on the reasons why they got removed?
> > > 
> > 
> > If I understood correctly, there are two reference picture lists.
> > P-frames will populate ref_pic_list0 and B-frames will populate both.
> > 
> > According to this, v4l2_ctrl_h264_slice_param.ref_pic_list0 and .ref_pic_list1
> > should be enough and ref_pic_list_p0/b0/b1 are not needed.
> > 
> > What do you think?
> 
> The lists in v4l2_ctrl_h264_slice_param are expected to be past the
> per-slice modification stage (which is quite complicated and better
> done in userspace),

The fact that these are RefPicList0 and RefPicList1, after
the reordering stage should be better documented.

> while the ones in v4l2_ctrl_h264_decode_param just
> in the original order. Rockchip VPU expects them in the original order
> and does the modification in the hardware.
> 

OK, I see.

So, we have RefPicList0 and RefPicList1, and there is an initialization
stage and a modification/reordering process.

One could argue that it's more generic to just pass the initial list,
but that would mean doing in the kernel something that is easier
done in userspace (and parsers doing this are already available).

The question would be what is the most generic way of passing
the RefPicList0 and RefPicList1 in its initial state.

1/ We create additional controls for these.

2/ We put them on some of the other controls. Putting them on
v4l2_ctrl_h264_decode_param didn't seem too wrong.

Any objections to put them back in there?

Regards,
Ezequiel

