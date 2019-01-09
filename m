Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D128C43444
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4E67205F4
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="ncrZaivL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfAIAC5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:02:57 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:41604 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbfAIAC5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:02:57 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 291DA586;
        Wed,  9 Jan 2019 01:02:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1546992175;
        bh=YZPLIwpcVxn0UHk7raqNSqHxaEXckWiIDAan/k6pjHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncrZaivL4+Rgh0rCuz3/xoE7tDUeLCCQ1RoQYLGP3EDXHo5ug+qDXYAtM2JEJDp6E
         +fqXpZmLzq6BQ0WKHZKDscPc11ld9wxhpPIleIDdj1cdMkYXGz2FDrJjNiMUYSbG0a
         5PNlX+yfP8vwLHZvCWG7iomqk0kv+oKpX9nm+F0Q=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo@jmondi.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/6] media: adv748x: Add is_txb()
Date:   Wed, 09 Jan 2019 02:04:04 +0200
Message-ID: <1894450.eWBzjVUvsQ@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <475dc354-012a-30ff-7763-c7bad237ccea@ideasonboard.com>
References: <20190106155413.30666-1-jacopo+renesas@jmondi.org> <20190107100542.5qszrtydqzowhzlp@uno.localdomain> <475dc354-012a-30ff-7763-c7bad237ccea@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

On Monday, 7 January 2019 12:38:39 EET Kieran Bingham wrote:
> On 07/01/2019 10:05, Jacopo Mondi wrote:
> > Hi Kieran,
> 
> <snip>
> 
> >>> diff --git a/drivers/media/i2c/adv748x/adv748x.h
> >>> b/drivers/media/i2c/adv748x/adv748x.h index b482c7fe6957..bc2da1b5ce29
> >>> 100644
> >>> --- a/drivers/media/i2c/adv748x/adv748x.h
> >>> +++ b/drivers/media/i2c/adv748x/adv748x.h
> >>> @@ -89,8 +89,12 @@ struct adv748x_csi2 {
> >>> 
> >>>  #define notifier_to_csi2(n) container_of(n, struct adv748x_csi2,
> >>>  notifier)
> >>>  #define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2,
> >>>  sd)
> >>> 
> >>> +
> >>> 
> >>>  #define is_tx_enabled(_tx) ((_tx)->state->endpoints[(_tx)->port] !=
> >>>  NULL)
> >>> 
> >>> -#define is_txa(_tx) ((_tx) == &(_tx)->state->txa)
> >>> +#define __is_tx(_tx, _ab) ((_tx) == &(_tx)->state->tx##_ab)
> >>> +#define is_txa(_tx) __is_tx(_tx, a)
> >>> +#define is_txb(_tx) __is_tx(_tx, b)
> >> 
> >> I would have just duplicated the is_txa() line here... but this is good
> >> too :)
> > 
> > I agree it might seem more complex than necessary. I initially made it
> > like this as I started from the 'is_tx()' macro this series adds in
> > 6/6.
> > 
> > If it is easier to have an '((_tx) == &(_tx)->state->txb)' I can
> > change this.

I would find it cleaner to write out is_txa and is_txb explicitly instead of 
hiding the implementation behind an __is_tx macro, especially given that we 
won't have to extend this in the future.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> It's fine for me as you've got it.
> 
> It's still clear and readable, and implements the required functionality.
> 
> <snip>

-- 
Regards,

Laurent Pinchart



