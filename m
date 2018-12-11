Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4CCC04EB8
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 02:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 426632064D
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 02:01:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="VJvaJfpL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 426632064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ragnatech.se
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbeLKCBU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 21:01:20 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44534 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbeLKCBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 21:01:20 -0500
Received: by mail-lf1-f66.google.com with SMTP id z13so9523058lfe.11
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 18:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=rpavOHoYVOD9aFk6Of4jko/V+yblDtpcBgskZ1ndeJY=;
        b=VJvaJfpLcbajmjyXCi2NrbCmsv08Xm5n6JPmfD03XqPu+4yQdXHF6NAyy6MQ7+C0I9
         q3cQTPKg+VWe5fjtkQ0tf+BgszTTA5rO/LHe752tWuti/wPNdLomkT5BH2ODG9KeOwI1
         sQIhW0yu6FOKvGWGUfv/LGrYQfw3IyCHas0+vD4j/8eiJCjiOO5XHE4mfVkbbFwu1/Je
         W5u61PdZA9h2RydvSR21XhtoZxgUKIZ+wQqt6/x19TCtCKr+bwnca4AWMODmGoAN520T
         et6/hHcnHZQcCk+eJyvmldoIDy9EhZARNJMgjJw/yiPa8PxL3Vzmzqy8TNlGR6jOqziC
         MQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=rpavOHoYVOD9aFk6Of4jko/V+yblDtpcBgskZ1ndeJY=;
        b=iEx6wRyQWEPtpJJD/1BNApSjWdyuO+8CqlsVq0S6X+6zyCpQcf0XQWCj0GfyIqu2kU
         x+4G5O3hn03eDsx4vKiptN2ZrXMFVOQvCPn5Mob/c0/+IQv/y8gqiOATPjydHqNLtY5y
         g83FBqEd/Dqea56ZDskaqGvXmncJUC070ai+o0ju6LH5EGHEz3EKPcP3gGWzjvNtujqH
         ++5pDiS4PUOCFWiBilqsjCrQ44kZcpjqojf5LXDjrpgwt+ZxH9bI+MBkdgcCCuc5ajYl
         bp/3M+q/mI1PjrkrzSb2ukxUEuQH3/NWftkK6gVk9aw1FvR21dB/hxvAJzKIVI8V9zuk
         zcIg==
X-Gm-Message-State: AA+aEWbG19J23kNsymA2C6rKEILcjKwbNCStZowpPqT8wyw4MZbrwYRl
        QRrjYx6cvfcMMuB7X+uJSs1Y8kOJoKc=
X-Google-Smtp-Source: AFSGD/WYTBIr7r1joYJ8FPs7UNBtLTxYYMvdzWo9qBK93QYGxMPaBx+ER5bvTbW77gFj1hidB3PhVA==
X-Received: by 2002:a19:d5:: with SMTP id 204mr7586683lfa.116.1544493677241;
        Mon, 10 Dec 2018 18:01:17 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id u21-v6sm2446930lju.46.2018.12.10.18.01.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 18:01:16 -0800 (PST)
Date:   Tue, 11 Dec 2018 03:01:15 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: rcar-csi2: Fix PHTW table values for E3/V3M
Message-ID: <20181211020115.GK17972@bigcity.dyn.berto.se>
References: <1544453635-16359-1-git-send-email-jacopo+renesas@jmondi.org>
 <2063363.Wr8td8jMvS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2063363.Wr8td8jMvS@avalon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thanks for your feedback,

On 2018-12-10 22:16:52 +0200, Laurent Pinchart wrote:
> Hi Jacopo,
> 
> Thank you for the patch.
> 
> On Monday, 10 December 2018 16:53:55 EET Jacopo Mondi wrote:
> > The PHTW selection algorithm implemented in rcsi2_phtw_write_mbps() checks
> > for lower bound of the interval used to match the desired bandwidth. Use
> > that in place of the currently used upport bound.
> 
> The rcsi2_phtw_write_mbps() function performs the following (error handling 
> removed):
> 
>         const struct rcsi2_mbps_reg *value;
> 
>         for (value = values; value->mbps; value++)
>                 if (value->mbps >= mbps)
>                         break;
> 
>         return rcsi2_phtw_write(priv, value->reg, code);
> 
> With this patch, an mbps value of 85 will match the second entry in the 
> phtw_mbps_v3m_e3 table:
> 
> [0]	{ .mbps =   80, .reg = 0x00 },
> [1]	{ .mbps =   90, .reg = 0x20 },
> ...
> 
> The datasheet however documents the range 80-89 to map to 0x00.
> 
> What am I missing ?

I'm afraid you are missing a issue with the original implementation of 
the rcar-csi2 driver (my fault). The issue you point out is a problem 
with the current freq selection logic not the tables themself which 
needs to be corrected.

This patch aligns the table with the other tables in the driver and is 
sound. A patch (Jacopo care to submit it?) is needed to resolve the 
faulty logic in the driver. It should select the range according to 
Laurents findings and not the range above it as the current code does.

> 
> > Fixes: 10c08812fe60 ("media: rcar: rcar-csi2: Update V3M/E3 PHTW tables")
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-csi2.c | 62 ++++++++++++-------------
> >  1 file changed, 31 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > b/drivers/media/platform/rcar-vin/rcar-csi2.c index
> > 80ad906d1136..7e9cb8bcfe70 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -152,37 +152,37 @@ static const struct rcsi2_mbps_reg
> > phtw_mbps_h3_v3h_m3n[] = { };
> > 
> >  static const struct rcsi2_mbps_reg phtw_mbps_v3m_e3[] = {
> > -	{ .mbps =   89, .reg = 0x00 },
> > -	{ .mbps =   99, .reg = 0x20 },
> > -	{ .mbps =  109, .reg = 0x40 },
> > -	{ .mbps =  129, .reg = 0x02 },
> > -	{ .mbps =  139, .reg = 0x22 },
> > -	{ .mbps =  149, .reg = 0x42 },
> > -	{ .mbps =  169, .reg = 0x04 },
> > -	{ .mbps =  179, .reg = 0x24 },
> > -	{ .mbps =  199, .reg = 0x44 },
> > -	{ .mbps =  219, .reg = 0x06 },
> > -	{ .mbps =  239, .reg = 0x26 },
> > -	{ .mbps =  249, .reg = 0x46 },
> > -	{ .mbps =  269, .reg = 0x08 },
> > -	{ .mbps =  299, .reg = 0x28 },
> > -	{ .mbps =  329, .reg = 0x0a },
> > -	{ .mbps =  359, .reg = 0x2a },
> > -	{ .mbps =  399, .reg = 0x4a },
> > -	{ .mbps =  449, .reg = 0x0c },
> > -	{ .mbps =  499, .reg = 0x2c },
> > -	{ .mbps =  549, .reg = 0x0e },
> > -	{ .mbps =  599, .reg = 0x2e },
> > -	{ .mbps =  649, .reg = 0x10 },
> > -	{ .mbps =  699, .reg = 0x30 },
> > -	{ .mbps =  749, .reg = 0x12 },
> > -	{ .mbps =  799, .reg = 0x32 },
> > -	{ .mbps =  849, .reg = 0x52 },
> > -	{ .mbps =  899, .reg = 0x72 },
> > -	{ .mbps =  949, .reg = 0x14 },
> > -	{ .mbps =  999, .reg = 0x34 },
> > -	{ .mbps = 1049, .reg = 0x54 },
> > -	{ .mbps = 1099, .reg = 0x74 },
> > +	{ .mbps =   80, .reg = 0x00 },
> > +	{ .mbps =   90, .reg = 0x20 },
> > +	{ .mbps =  100, .reg = 0x40 },
> > +	{ .mbps =  110, .reg = 0x02 },
> > +	{ .mbps =  130, .reg = 0x22 },
> > +	{ .mbps =  140, .reg = 0x42 },
> > +	{ .mbps =  150, .reg = 0x04 },
> > +	{ .mbps =  170, .reg = 0x24 },
> > +	{ .mbps =  180, .reg = 0x44 },
> > +	{ .mbps =  200, .reg = 0x06 },
> > +	{ .mbps =  220, .reg = 0x26 },
> > +	{ .mbps =  240, .reg = 0x46 },
> > +	{ .mbps =  250, .reg = 0x08 },
> > +	{ .mbps =  270, .reg = 0x28 },
> > +	{ .mbps =  300, .reg = 0x0a },
> > +	{ .mbps =  330, .reg = 0x2a },
> > +	{ .mbps =  360, .reg = 0x4a },
> > +	{ .mbps =  400, .reg = 0x0c },
> > +	{ .mbps =  450, .reg = 0x2c },
> > +	{ .mbps =  500, .reg = 0x0e },
> > +	{ .mbps =  550, .reg = 0x2e },
> > +	{ .mbps =  600, .reg = 0x10 },
> > +	{ .mbps =  650, .reg = 0x30 },
> > +	{ .mbps =  700, .reg = 0x12 },
> > +	{ .mbps =  750, .reg = 0x32 },
> > +	{ .mbps =  800, .reg = 0x52 },
> > +	{ .mbps =  850, .reg = 0x72 },
> > +	{ .mbps =  900, .reg = 0x14 },
> > +	{ .mbps =  950, .reg = 0x34 },
> > +	{ .mbps = 1000, .reg = 0x54 },
> > +	{ .mbps = 1050, .reg = 0x74 },
> >  	{ .mbps = 1125, .reg = 0x16 },
> >  	{ /* sentinel */ },
> >  };
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

-- 
Regards,
Niklas Söderlund
