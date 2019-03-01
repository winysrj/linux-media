Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2573DC4360F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1CBB20851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:06:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="h9mB9htx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfCANGW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:06:22 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:37340 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfCANGW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:06:22 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4600F49;
        Fri,  1 Mar 2019 14:06:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551445579;
        bh=x2RKSHUiCmtYH6ggscYDumArX74QtJNPIB2DCZNaV8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h9mB9htxCQOcT4Yq8uB7EdpODTda7ZWBtaV9qaP82ADrnQrAvtgXpyXzdIUrecgeA
         BazBuFpeFHGSnDd1z6azkrw8VLox0xupqPEDPd4L+YuJ0X1ZQWGCZ/D5x4vqxUwJHd
         EoxWnRVWcFJJdDrejh555KUMECMJim9bObaYWo/k=
Date:   Fri, 1 Mar 2019 15:06:13 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Biju Das <biju.das@bp.renesas.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1
 support
Message-ID: <20190301130613.GB32244@pendragon.ideasonboard.com>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-2-git-send-email-biju.das@bp.renesas.com>
 <TYXPR01MB1775F18270FB477D010C180EC0760@TYXPR01MB1775.jpnprd01.prod.outlook.com>
 <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8a5429a0-b4c5-a208-3e56-406bd031b01b@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Fri, Mar 01, 2019 at 01:55:53PM +0100, Hans Verkuil wrote:
> Hi Fabrizio,
> 
> It looks like this series fell through the cracks.
> 
> I looked at it and the main problem is that it is missing a Reviewed-by
> from Rob Herring (devicetree maintainer). It's a bit surprising since he
> is usually fairly prompt.
> 
> I recommend that you rebase and repost it and I'll delegate the v2 series
> to me so we can hopefully get it in for 5.2 (5.1 is likely too late) once
> Rob reviews it.
> 
> BTW, I'm the one who usually processes rcar patches. But it was delegated in
> patchwork to Laurent, so I never saw it.

I handle the VSP and FDP patches. I propose delegating the CSI-2 and VIN
to Niklas.

> On 3/1/19 1:09 PM, Fabrizio Castro wrote:
> > Hello Mauro,
> > 
> > This patch has been around for some time now, do you think you can take it?
> > 
> > Cheers,
> > Fab
> > 
> >> From: Biju Das <biju.das@bp.renesas.com>
> >> Sent: 10 September 2018 15:31
> >> Subject: [PATCH 1/5] media: dt-bindings: media: rcar-csi2: Add r8a774a1 support
> >>
> >> Document RZ/G2M (R8A774A1) SoC bindings.
> >>
> >> The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
> >>
> >> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> >> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> >> ---
> >>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> >> b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> >> index 2d385b6..12fe685 100644
> >> --- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> >> +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> >> @@ -2,12 +2,13 @@ Renesas R-Car MIPI CSI-2
> >>  ------------------------
> >>
> >>  The R-Car CSI-2 receiver device provides MIPI CSI-2 capabilities for the
> >> -Renesas R-Car family of devices. It is used in conjunction with the
> >> -R-Car VIN module, which provides the video capture capabilities.
> >> +Renesas R-Car Gen3 and RZ/G2 family of devices. It is used in conjunction
> >> +with the R-Car VIN module, which provides the video capture capabilities.
> >>
> >>  Mandatory properties
> >>  --------------------
> >>   - compatible: Must be one or more of the following
> >> +   - "renesas,r8a774a1-csi2" for the R8A774A1 device.
> >>     - "renesas,r8a7795-csi2" for the R8A7795 device.
> >>     - "renesas,r8a7796-csi2" for the R8A7796 device.
> >>     - "renesas,r8a77965-csi2" for the R8A77965 device.

-- 
Regards,

Laurent Pinchart
