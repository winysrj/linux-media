Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993A2C282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 18:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 671C620855
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 18:20:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="ANiDUlW7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfBISUq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 13:20:46 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:60990 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfBISUp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 13:20:45 -0500
Received: from pendragon.ideasonboard.com (85-76-143-97-nat.elisa-mobile.fi [85.76.143.97])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2F0D52E2;
        Sat,  9 Feb 2019 19:20:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549736443;
        bh=fB5PYIrIDjVSImRKcoB9DsvNiOCKyRJu5HSSqcAvC7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ANiDUlW7J8jD++Uw4IrhM54ol3lm91ecLi58Jh1RIOKboI9Vdhr0SiFMI3Hk/cTIG
         n8qvgB9zQIhtn5f9rqBQiGSmy8+3EYTTyV26bG/yhTdwKkBV3YaCUxrhmL6ITZOaJ6
         BN4zVlilg4CcyWyDBCD0q0UXoTTNwk+norg9zABc=
Date:   Sat, 9 Feb 2019 20:20:34 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     Frederic Chen <frederic.chen@mediatek.com>, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com, tfiga@chromium.org,
        matthias.bgg@gmail.com, mchehab@kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Sean.Cheng@mediatek.com,
        sj.huang@mediatek.com, christie.yu@mediatek.com,
        holmes.chiou@mediatek.com, Jerry-ch.Chen@mediatek.com,
        jungo.lin@mediatek.com, Rynn.Wu@mediatek.com,
        linux-media@vger.kernel.org, srv_heupstream@mediatek.com
Subject: Re: [RFC PATCH V0 3/7] [media] dt-bindings: mt8183: Added DIP-SMEM
 dt-bindings
Message-ID: <20190209182034.GC4505@pendragon.ideasonboard.com>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
 <1549020091-42064-4-git-send-email-frederic.chen@mediatek.com>
 <20190209155935.afrrtf3twjmj23sm@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190209155935.afrrtf3twjmj23sm@valkosipuli.retiisi.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Frederic,

On Sat, Feb 09, 2019 at 05:59:35PM +0200, Sakari Ailus wrote:
> Hi Frederic,
> 
> Thanks for the patchset.
> 
> Could you also cc the devicetree list, please?
> 
> On Fri, Feb 01, 2019 at 07:21:27PM +0800, Frederic Chen wrote:
> > This patch adds the DT binding documentation for the shared memory
> > between DIP (Digital Image Processing) unit of the camera ISP system
> > and the co-processor in Mediatek SoCs.
> > 
> > Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
> > ---
> >  .../bindings/media/mediatek,dip_smem.txt           | 29 ++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt b/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
> > new file mode 100644
> > index 0000000..5533721
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
> > @@ -0,0 +1,29 @@
> > +Mediatek ISP Shared Memory Device
> > +
> > +Mediatek ISP Shared Memory Device is used to manage shared memory
> > +among CPU, ISP IPs and coprocessor. It is associated with a reserved
> > +memory region (Please see Documentation\devicetree\bindings\
> > +reserved-memory\mediatek,reserve-memory-isp_smem.txt) and
> 
> s/\\/\//g;
> 
> > +and provide the context to allocate memory with dma addresses.

Does this represent a real device (as in IP core) in the SoC ? There
seems to be no driver associated with the compatible string defined
herein in this patch series, what is this node used for ?

> > +Required properties:
> > +- compatible: Should be "mediatek,isp_smem"
> 
> s/Should/Shall/
> 
> > +
> > +- iommus: should point to the respective IOMMU block with master port
> 
> s/should/shall/
> 
> > +  as argument. Please set the ports which may be accessed
> > +  through the common path. You can see
> > +  Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
> > +  for the detail.
> > +
> > +- mediatek,larb: must contain the local arbiters in the current Socs.
> 
> Perhaps "SoCs"?
> 
> > +  Please set the larb of camsys for Pass 1 and imgsys for DIP, or both
> > +  if you are using all the camera function. You can see
> > +  Documentation/devicetree/bindings/memory-controllers/
> > +  mediatek,smi-larb.txt for the detail.
> > +
> > +Example:
> > +	isp_smem: isp_smem {
> > +		compatible = "mediatek,isp_smem";
> > +		mediatek,larb = <&larb5>;
> > +		iommus = <&iommu M4U_PORT_CAM_IMGI>;
> > +	};

-- 
Regards,

Laurent Pinchart
