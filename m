Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB8EC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 20:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9932D2086C
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 20:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545251885;
	bh=eWvyJBBYN0fAuhpjwov9ACCGeqUpOUGGtHgzWICM4DM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Z6xHPnLI+t07/5ghHU6XjhizTkvS0xylHwtHirdxKkMoYCF+4ygr4U0cJK6IQtuYP
	 2Q9giBmzW287TL5Z2DvLYESxByNtITTUHkDqmh9D3RdHqDdqU0pf42MCDtu8qLICPZ
	 t+2imKbMLVkha0D9qttQHy2dJZFJ2HtRTOjITJf0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbeLSUh7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 15:37:59 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45810 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbeLSUh7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 15:37:59 -0500
Received: by mail-oi1-f195.google.com with SMTP id y1so2696506oie.12;
        Wed, 19 Dec 2018 12:37:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=viso4VjcJ6vxD3i5+8KcRCIdWRW6qJD4fiP3njk0uL8=;
        b=jQgaScH1m5CQ8xxHa8sVogtAk1CK6TExsZkVgrxInZ8mxYxG3cpduEUlENvWZ4oq/b
         fi9WGjME1QPD889PGFSv5cWSjNPbe3PXJ+kf0/266WwtGcKprTJr6ui/jHdf0JKA+sCl
         LBpn5ncflxiYQ0Tnlc1F5HEkO6dl+J441SRLXtrwDy6U6jgxzDxi4jizkYhsOAS/p0DR
         Sok0cPMm4N5tW8pQa9FHw7cfZW5LUnoW0byLMvO/7NRsCKWALjXTKilq6Lqs/V40EZlX
         koa9g/exOhkNYx5VqTsL9Ou8+oVK45E3I40GTY/YQRnXS3Uny8VS6gyPmoe8alPLTggn
         pLPA==
X-Gm-Message-State: AA+aEWYiknEdfd6V3MvPB/DCgzZeTy5PRm+I2B8y4HcFsWLKwamg5356
        E75GaPX8NT1xc79LzRvJNw==
X-Google-Smtp-Source: AFSGD/XzeduizDAKcuK6/RPPnWQ8Y5Agx+B8lydJAQPyEmc4a59rnke5Rb2BFRm3qKmnABkg6jic3w==
X-Received: by 2002:aca:d4c9:: with SMTP id l192mr226436oig.307.1545251877637;
        Wed, 19 Dec 2018 12:37:57 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id d10sm8594386otl.62.2018.12.19.12.37.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Dec 2018 12:37:57 -0800 (PST)
Date:   Wed, 19 Dec 2018 14:37:56 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        hverkuil@xs4all.nl, fischerdouglasc@gmail.com,
        keescook@chromium.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
Subject: Re: [PATCH 5/5] media: dt-bindings: si470x: Document new reset-gpios
 property
Message-ID: <20181219203756.GA29877@bogus>
References: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com>
 <20181205154750.17996-6-pawel.mikolaj.chmiel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181205154750.17996-6-pawel.mikolaj.chmiel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed,  5 Dec 2018 16:47:50 +0100, =?UTF-8?q?Pawe=C5=82=20Chmiel?= wrote:
> Add information about new reset-gpios property to driver documentation
> 
> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> ---
>  Documentation/devicetree/bindings/media/si470x.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
