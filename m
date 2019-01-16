Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADD0C43612
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 791B720859
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="CNH++qln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392057AbfAPM2i (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:28:38 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38891 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390142AbfAPM2i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 07:28:38 -0500
Received: by mail-lj1-f194.google.com with SMTP id c19-v6so5284328lja.5
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 04:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6WjB9xYaB4I7bP51SXl45tbk7E2+ChT8cCjZP51n32I=;
        b=CNH++qlnP1Bv37xBLfwXwntm1BLob/CAaix7JQxR5SafuxqFdCTrJcvIEtq7jG42mS
         iYhx6RM2H6m/BjweJ+hTF8b6jrFWrv3k+w8UtabHJa6ZTEeDBTylCxcLEv7Os0n4Zd60
         nQuWW9TuZH3/igJ3zw5ycz/f0/qhcBvXGzuXqrlVV7gfbNCProCH9wqr+h3nEZbIgaLS
         rk7IGkL4p4duJrhEzzNZR9w3n8x99Zs5UXI15LDiKj+IxIWRA9/dNOdKaiLD/fumR94f
         j04rHVcJwBlqtQucn/F1FseHTPfR/zmh5K67z2nPYuoBno/9gjyH/slTad4QlGRuB2QA
         SQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6WjB9xYaB4I7bP51SXl45tbk7E2+ChT8cCjZP51n32I=;
        b=Q4oE9tldTQ0Wcdcbf3l8rkc0sAI6WQEWSAyaZ1fp1FUpkBg7lD8P4SIDQiqXmuBALz
         5JWbn/+nqY8tI873d+AX/nXs/vtHorrqs5muuaipSup2N/F5ou7zIOo3olF8zkRFH9qV
         WnkWpSuaED0ag7MyBt6pkxJ9A4me5idRpG0RrHPfcIfTA83W74qCrrjy8gLwotySnlZL
         PH/d722G9QhTfhFYBa/9+2LDTNKxKScyV68MR+LvEKu3i1btRpRBYem4/V/sLti53EzA
         dBFXSkDc00KMcv9viT+ySXkRzTOZ2qpqu49VmX5dJHu4cgVnKXaC3hD7GIyZhAVZTM3A
         InSw==
X-Gm-Message-State: AJcUukfvmxoBKsGl/jqvFNv5hOy4FlezbIjHobjMb+KRouZHcSLlAELU
        Td6HLpODwe7elRzwex4m1keFAg==
X-Google-Smtp-Source: ALg8bN5AU4nsexcCtZ7mJx8F9V+ungn4scjxb09HIFAXP9Wafwt23VXjEGxi4Tzh/4vLWYxgwydAFQ==
X-Received: by 2002:a2e:5054:: with SMTP id v20-v6mr6554821ljd.45.1547641716298;
        Wed, 16 Jan 2019 04:28:36 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id k20sm1159694lfe.3.2019.01.16.04.28.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 04:28:35 -0800 (PST)
Date:   Wed, 16 Jan 2019 13:28:34 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 3/6] media: adv748x: csi2: Link AFE with TXA and TXB
Message-ID: <20190116122834.GN7393@bigcity.dyn.berto.se>
References: <20190110140213.5198-1-jacopo+renesas@jmondi.org>
 <20190110140213.5198-4-jacopo+renesas@jmondi.org>
 <20190114145533.GK30160@bigcity.dyn.berto.se>
 <20190116091049.v2y4nbvyio5jskgr@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190116091049.v2y4nbvyio5jskgr@uno.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On 2019-01-16 10:10:49 +0100, Jacopo Mondi wrote:
> Hi Niklas,
> 
> On Mon, Jan 14, 2019 at 03:55:33PM +0100, Niklas Söderlund wrote:
> 
> [snip]
> 
> > > +	/* Register link to HDMI for TXA only. */
> > > +	if (is_txb(tx) || !is_hdmi_enabled(state))
> >
> > Small nit, I would s/is_txb(tx)/!is_txa(tx)/ here as to me it becomes
> > easier to read. With or without this change,
> >
> > Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >
> 
> Would you want me to resend for this or can this series be collected?

I plan to resume review of the last patches in this series today. After 
that I leave it to you and Kieran to discuss whether or not this needs a 
resend :-)

> 
> Thanks
>   j
> 
> > > +		return 0;
> > > +
> > > +	return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
> > > +					  ADV748X_HDMI_SOURCE, true);
> > >  }
> > >
> > >  static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
> > > --
> > > 2.20.1
> > >
> >
> > --
> > Regards,
> > Niklas Söderlund



-- 
Regards,
Niklas Söderlund
