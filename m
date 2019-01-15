Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A640DC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 20:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64C7F20657
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 20:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547585945;
	bh=weef29UFvHPdf9nf6iEYU132pvXsaIAKyQgBjM2y3jY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hmzwfuYGTHNFEx+DppuSIkI7BOm9swXdTmViNJVpXpMZvfL8yVdsP27OvkLgLDo8+
	 Nr6G7zVsfl25KA76dZSoU/8Vip/K3Fz+Ocmo7ih9t6rR2XzBxYhMIwj8l0IlTzSiTh
	 QUehPP5NohYfmXO7tXQjOSFD3fp2FTcOaAY4xPWg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390096AbfAOU7E (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 15:59:04 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46497 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730050AbfAOU7E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 15:59:04 -0500
Received: by mail-oi1-f193.google.com with SMTP id x202so3230425oif.13;
        Tue, 15 Jan 2019 12:59:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AKD+IlUaxoU7KMCes5naemOcYgALrs9d6qcyY+yFaIQ=;
        b=MSFavwtYbq3njTZmgnaX5XWHVwBEuK6ORLiXjwuQTd9llMruAhgnE6P2d3hUMxiihj
         oIg8r+Z1zJAFN8aTOYkylkalQQSv/kH4tUx67Rd5MxqkIrSGKdWKkYkGMB23Uo76q36j
         BpRqkvQ/rpMebE366Dx/DeaOfxK2nMh1VDZPd8+OjXKjebiILqncabUMez5wpl4We1pY
         quzrFo4dSlJpc1sWKwzGVM9d/f4CpwG7PT10zpFkcTIz5Jj5oiTqdRYqA+fjtFxZQPPs
         w+DCnGMLINGma41fME58pGCHr1Z0+NatSJ6mfBhc/78l3iGLFty4H8y6jEbzN98kwtH0
         rEsw==
X-Gm-Message-State: AJcUukeeGMdZUs2RPKhUtnMOGcYHJCeXlo4Dmzr38MO9GORWHNrmkeNY
        gBXlS9/IF3sXkPWDyQ5mUw==
X-Google-Smtp-Source: ALg8bN60GvD1kmVJrcgpwL/bkELu8igIQ6FRqKO/+Q2POMF/mzESabmuAS9uQksi+fVKbQO/+H48fQ==
X-Received: by 2002:aca:c649:: with SMTP id w70mr3096336oif.186.1547585943508;
        Tue, 15 Jan 2019 12:59:03 -0800 (PST)
Received: from localhost ([70.231.7.113])
        by smtp.gmail.com with ESMTPSA id b18sm1864764otl.33.2019.01.15.12.59.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jan 2019 12:59:02 -0800 (PST)
Date:   Tue, 15 Jan 2019 14:59:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Akinobu Mita <akinobu.mita@gmail.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 02/13] media: i2c: mt9m001: dt: add binding for mt9m001
Message-ID: <20190115205902.GA12058@bogus>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
 <1546959110-19445-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546959110-19445-3-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue,  8 Jan 2019 23:51:39 +0900, Akinobu Mita wrote:
> Add device tree binding documentation for the MT9M001 CMOS image sensor.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v2
> - Update binding doc suggested by Rob Herring.
> 
>  .../devicetree/bindings/media/i2c/mt9m001.txt      | 38 ++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m001.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
