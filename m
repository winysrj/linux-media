Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F77FC67839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 02:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1567B20839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 02:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544582043;
	bh=VqdqhXX54KuYfbFLfq0DS4hqlUZETNzHP8HHHkDXhkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xVbxqdVhLW971g26QVWF3a6pWE+H21l45A8ROQFrxP11TlKg+xzgKVhe9I72zKI95
	 ptuv8iRw8tdf8HuoxDA2L4W1sUFETnwiXMS2Udx+5AEQZEewDP9XAijiE+9O9qqUIw
	 jZiWJ1HhEBgz1hqPGE1nKiCZnHMIERkURBWnHdbA=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1567B20839
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbeLLCd5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 21:33:57 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33975 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbeLLCd5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 21:33:57 -0500
Received: by mail-oi1-f195.google.com with SMTP id h25so13867606oig.1;
        Tue, 11 Dec 2018 18:33:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9hQxpSJGUHcHaTjiGWXZ6kTkt2yNEbevsOId/dKgcb8=;
        b=sbDx+zNT/ki5VqvGjB51D64nj1L93gFi4Rx7Yw8CD6v+spv9EAo1vPkc/yEf8JM8kz
         rqhUipE1Tfgyd7QsuMmtVAPAC6cS4A88PZBK6OD6dxZJ2XLejF4JdjbNLIs1IwLvtH/C
         XXUbxrMvF0NrNI1mRSmsQOaTCDbcLQy8OnnIk0CXD7KU2l9Z4eyFFgO6KdwmExLcWExR
         XdA3USFXjTvrIoy7gUtJI+9b8bn/h0OS2Lk8yDUZ+we0vieNKoXuES+xY2jzpuJ8wRDt
         oBocMnbJYlo0X5LoLgALPuMwtMjzNwAOV3DUkuCvDi8mTxm/lZLYWajtQanFXKYn2cpF
         Drcg==
X-Gm-Message-State: AA+aEWa68JAjo/KZppx9wXq5PBc6M30mit2ikYvsMcZ1fv/5i2bp1GnG
        D/tLwRuEvPjvBieW6Qca0w==
X-Google-Smtp-Source: AFSGD/Vuk7UYOiVgN4AyuPuZ+BiDamViqRblq7y66LleVIlxCS6PFGp2AhlzCkZw3Z2lJddg9WnP7g==
X-Received: by 2002:aca:5c05:: with SMTP id q5mr192476oib.146.1544582036686;
        Tue, 11 Dec 2018 18:33:56 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id e6sm7135003otp.68.2018.12.11.18.33.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Dec 2018 18:33:56 -0800 (PST)
Date:   Tue, 11 Dec 2018 20:33:55 -0600
From:   Rob Herring <robh@kernel.org>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] media: dt-bindings: media: sun6i: Separate H3
 compatible from A31
Message-ID: <20181212023355.GA7324@bogus>
References: <20181130075849.16941-1-wens@csie.org>
 <20181130075849.16941-2-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130075849.16941-2-wens@csie.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, 30 Nov 2018 15:58:44 +0800, Chen-Yu Tsai wrote:
> The CSI controller found on the H3 (and H5) is a reduced version of the
> one found on the A31. It only has 1 channel, instead of 4 channels for
> time-multiplexed BT.656. Since the H3 is a reduced version, it cannot
> "fallback" to a compatible that implements more features than it
> supports.
> 
> Split out the H3 compatible as a separate entry, with no fallback.
> 
> Fixes: b7eadaa3a02a ("media: dt-bindings: media: sun6i: Add A31 and H3
> 		      compatibles")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  Documentation/devicetree/bindings/media/sun6i-csi.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
