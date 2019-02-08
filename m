Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A425BC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B52C218D9
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfBHJsA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 04:48:00 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37769 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfBHJsA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 04:48:00 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gs2lI-0000jJ-FU; Fri, 08 Feb 2019 10:47:56 +0100
Message-ID: <1549619274.3305.3.camel@pengutronix.de>
Subject: Re: [PATCH 4/4] media: imx-pxp: Start using the format VUYA32
 instead of YUV32
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        linux-media@vger.kernel.org
Date:   Fri, 08 Feb 2019 10:47:54 +0100
In-Reply-To: <5119be5b-4480-68f5-bb50-900eca9eb10f@xs4all.nl>
References: <20190208031846.14453-1-vivek.kasireddy@intel.com>
         <20190208031846.14453-5-vivek.kasireddy@intel.com>
         <5119be5b-4480-68f5-bb50-900eca9eb10f@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, 2019-02-08 at 10:15 +0100, Hans Verkuil wrote:
> On 2/8/19 4:18 AM, Vivek Kasireddy wrote:
> > Buffers generated with YUV32 format seems to be incorrect, hence use
> > VUYA32 instead.
> > 
> > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> 
> Philipp, I wonder whether VUYA32 or VUYX32 should be used? I think the alpha
> channel is completely ignored on the source side and on the destination side
> it is probably set by some fixed value?
>
> Note that there exists a control V4L2_CID_ALPHA_COMPONENT that can be used
> to let userspace specify the generated alpha value.

Oh, that is correct. V4L2_CID_ALPHA_COMPONENT is wired up in the imx-pxp 
driver to the alpha output override, and the value correctly appears in
the VUYA32 output.

> What if both source and destination formats have an alpha channel? Can the
> hardware preserved the alpha values?

The hardware should support preserving the alpha channel, but the driver
currently always enables the V4L2_CID_ALPHA_COMPONENT override. Right
now it would be correct to allow only VUYX32 on the output queue and
both VUYA32 and VUYX32 on the capture queue.

For VUYA32 on the output queue we'd have to disable the alpha override
and check whether the hardware properly preserves the alpha channel.

regards
Philipp
