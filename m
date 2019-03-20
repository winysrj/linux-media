Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6685BC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 16:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2380E2183E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 16:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="kOUPP52C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfCTQKq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:10:46 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46726 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfCTQKq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 12:10:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id y62so2283896lfc.13
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 09:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=MnNuZup5cDQtNfWIuCN8emTls2XhW8g9D+mSLET8Hc8=;
        b=kOUPP52CyQVOfLJSmKWJJ6x4viPFsNWgrviZbA4UXZ+YohlrUz75xIU1W5FG/LNd/L
         FGNSFr4CAWNldIw2UpHRO4eM1tJ04G0EceP6B4fzP+G6HF5z291FoS1mdDNL8u0Eodt4
         sBOBHE7BxxEsNfmnXiBbAP2dxEkWDY4xsxkRh361T0V5fVvc79IPNPcgXZP1/RXVMwsz
         82a4Db013aEJQ4RRc/DO5wAjHN1+Abuuf2qRnQfjpii79JVB0tFVTbm6i68RNgbQ8qnR
         0pmCyGUvt7FQts8vHWStlO8wwNdp7wZgvSK6c/56Lxae2fHphAoasg2JNG4cfeYDOqsG
         4uSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MnNuZup5cDQtNfWIuCN8emTls2XhW8g9D+mSLET8Hc8=;
        b=JvFdrEOipb+HkyVsRJjMsqj2cqITnCUALUnraA653wcpbMLFH07jxR0bPYjHektqE2
         rLa/jyMW2dhUPDWdgNqsStnKO4aFvmEIa5v0w2LllVNRtVJ6BavfdzGS5QrDiKARzlvK
         u51o04CGZTFI4UhZxBfr1I/JYaeWS17sj786SG2zEhZN/iW19tJzu0eL6osCooDlsEl1
         RaQQTybhOriGME4F53ezwvvZvOQcu6uCtEbuKhlqTgUOEJQRVkG5CTvA0cHt7yFnrERC
         D2iAe8xlMoV1OTpSzKJcxug7mJKeZ3hQuD7H/cCsbznWAA5siydGICuiskxfDTTCg/he
         DL2w==
X-Gm-Message-State: APjAAAWRK8aUvNHLkiPjYT6fCxuIUyuu2y7Y47AtxnwPFJ15vQ0grmKS
        Yp0A7hJqcGa4F+zylL3hAIlBlG7+Fnw=
X-Google-Smtp-Source: APXvYqyKKuWzT0A/dN8FFVE0rkxHl9a4IRm/ZLzC3EvDp+ec2jWsq8R2DoeXW3rVgpusLvU/1agmag==
X-Received: by 2002:a19:95cf:: with SMTP id x198mr16300994lfd.73.1553098244745;
        Wed, 20 Mar 2019 09:10:44 -0700 (PDT)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id i24sm411923ljb.31.2019.03.20.09.10.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Mar 2019 09:10:43 -0700 (PDT)
Date:   Wed, 20 Mar 2019 17:10:43 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC 3/8] v4l2-fwnode: Use
 v4l2_async_notifier_add_fwnode_remote_subdev
Message-ID: <20190320161043.GM26015@bigcity.dyn.berto.se>
References: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
 <20190318191653.7197-4-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190318191653.7197-4-sakari.ailus@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thanks for your work.

On 2019-03-18 21:16:48 +0200, Sakari Ailus wrote:
> Shorten v4l2_async_notifier_fwnode_parse_endpoint by using
> v4l2_async_notifier_add_fwnode_remote_subdev.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-fwnode.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 27827842dffd..74af7065996a 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -615,15 +615,6 @@ v4l2_async_notifier_fwnode_parse_endpoint(struct device *dev,
>  	if (!asd)
>  		return -ENOMEM;
>  
> -	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> -	asd->match.fwnode =
> -		fwnode_graph_get_remote_endpoint(endpoint);
> -	if (!asd->match.fwnode) {
> -		dev_dbg(dev, "no remote endpoint found\n");
> -		ret = -ENOTCONN;
> -		goto out_err;
> -	}
> -

This change breaks rcar-vin I'm afraid :-(

A bit further down in v4l2_async_notifier_fwnode_parse_endpoint() we 
have this section.

    ret = parse_endpoint ? parse_endpoint(dev, &vep, asd) : 0;
    if (ret == -ENOTCONN)
        dev_err(dev, "ignoring port@%u/endpoint@%u\n", vep.base.port,
            vep.base.id);
    ...
    if (ret < 0)
        goto out_err;


As rcar-vin uses the information in asd in its parse_endpoint() callback 
and fails if it can't interact with it. So nothing is registers with the 
notifier and not much happens after that. Is the rcar-vin driver wrong 
in assuming the asd should be populated when the callback is called?

>  	ret = v4l2_fwnode_endpoint_alloc_parse(endpoint, &vep);
>  	if (ret) {
>  		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
> @@ -643,7 +634,8 @@ v4l2_async_notifier_fwnode_parse_endpoint(struct device *dev,
>  	if (ret < 0)
>  		goto out_err;
>  
> -	ret = v4l2_async_notifier_add_subdev(notifier, asd);
> +	ret = v4l2_async_notifier_add_fwnode_remote_subdev(notifier, endpoint,
> +							   asd);
>  	if (ret < 0) {
>  		/* not an error if asd already exists */
>  		if (ret == -EEXIST)
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
