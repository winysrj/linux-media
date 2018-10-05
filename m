Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44675 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbeJERP1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:15:27 -0400
Message-ID: <1538734639.3545.11.camel@pengutronix.de>
Subject: Re: [PATCH v4 04/11] media: imx: Fix field negotiation
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 05 Oct 2018 12:17:19 +0200
In-Reply-To: <20181004185401.15751-5-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
         <20181004185401.15751-5-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-10-04 at 11:53 -0700, Steve Longerbeam wrote:
> IDMAC interlaced scan, a.k.a. interweave, should be enabled in the
> IDMAC output channels only if the IDMAC output pad field type is
> 'seq-bt' or 'seq-tb', and field type at the capture interface is
> 'interlaced*'.
> 
> V4L2_FIELD_HAS_BOTH() macro should not be used on the input to determine
> enabling interlaced/interweave scan. That macro includes the 'interlaced'
> field types, and in those cases the data is already interweaved with
> top/bottom field lines.
> 
> The CSI will capture whole frames when the source specifies alternate
> field mode. So the CSI also enables interweave for alternate input
> field type and the field type at capture interface is interlaced.
> 
> Fix the logic for setting field type in try_fmt in CSI entity.
> The behavior should be:
> 
> - No restrictions on field type at sink pad.
> 
> - At the output pads, allow sequential fields in TB order, if the sink pad
>   field type is sequential or alternate. Otherwise passthrough the field
>   type from sink to source pad.
> 
> Move this logic to new function csi_try_field().
> 
> These changes result in the following allowed field transformations
> from CSI sink -> source pads (all other field types at sink are passed
> through to source):
> 
> seq-tb -> seq-tb
> seq-bt -> seq-tb
> alternate -> seq-tb
> 
> In a future patch, the CSI sink -> source will allow:
> 
> seq-tb -> seq-bt
> seq-bt -> seq-bt
> alternate -> seq-bt
> 
> This will require supporting interweave with top/bottom line swapping.
> Until then seq-bt is not allowed at the CSI source pad because there is
> no way to swap top/bottom lines when interweaving to INTERLACED_BT --
> note that despite the name, INTERLACED_BT is top-bottom order in memory.
> The BT in this case refers to field dominance: the bottom lines are
> older in time than the top lines.
> 
> The capture interface device allows selecting IDMAC interweave by
> choosing INTERLACED_TB if the CSI/PRPENCVF source pad is seq-tb and
> INTERLACED_BT if the source pad is seq-bt (for future support of seq-bt).
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
