Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875EEC43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 19:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6372B218C3
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 19:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547235011;
	bh=BpyAFt5946ugiE00tqZo7FW3BnzcyAnkE8EISO8ByH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=XDypdGVmQ5BvJkEJgEicnXjAk12UIG3XkoejbCiGgXAgoRcgFirgHAkAOvXPxDkzb
	 m0IcgZLX1JIYIgjun1fbr0xf+TU+UKrOxCOCgVuh3gkfj1j/Vyl6RADFd6yOBVkYI1
	 TVqoQkNPhcRH/cQIAeC7MaI11FX1a15bbZbSBQ24=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388497AbfAKTaF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 14:30:05 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41143 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731807AbfAKTaE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 14:30:04 -0500
Received: by mail-oi1-f196.google.com with SMTP id j21so13106628oii.8;
        Fri, 11 Jan 2019 11:30:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8c0Cd9SOEjMucxUgr1cK7o0spBsIvwNckk4Oy28C5lI=;
        b=STHvGrhbndwegc5Hx/8McenC8oatCXfpjRyn16FcSOYGUOfM/qRM0QSpvo5gWrD4sX
         /opCwkczwCkPYWKykEW5/yAHvDXC2l4fk3WTuvQ/k5V1tBy419WZigtCPARgNWS7m25S
         Zt1reJ+PF66mAhQ9CwIImgizGG2LDzJp3io88AGV086tleHU/iR3H1PRwgRoxakM5EHd
         jTco3h6ZtsrHEGIgZb2STcYhoE3CY5tk3LRnxHyQTXnEPKumPN5mzXinigK7+8PW7TjV
         nutSWwR+9nX58JReZhGphR/gi4aqez0VKnzLV/Cn7kgtiLYHTkF9Wpmbd5FaI5yZqjjv
         nrEg==
X-Gm-Message-State: AJcUukeSNz9UFP0xBlojSd1FOPThysYGE1826AH1+Wm74RbwBHbjc+C0
        5NAdaYuXsRPzVpLxZhSyng==
X-Google-Smtp-Source: ALg8bN4aD2psTbop+nJFCIp6EGeA7Nih3kgQ7KPHL/VjW6kqRp1Sfq9RC0C0xCae3bHA5zHvpYMDVg==
X-Received: by 2002:aca:f44c:: with SMTP id s73mr10507571oih.102.1547235003963;
        Fri, 11 Jan 2019 11:30:03 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id u65sm31698804oib.5.2019.01.11.11.30.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Jan 2019 11:30:03 -0800 (PST)
Date:   Fri, 11 Jan 2019 13:30:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Yunfei Dong <yunfei.dong@mediatek.com>
Cc:     Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Yunfei Dong <yunfei.dong@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Qianqian Yan <qianqian.yan@mediatek.com>
Subject: Re: [PATCH v2,1/3] media: dt-bindings: media: add 'assigned-clocks'
 to vcodec examples
Message-ID: <20190111193002.GA19308@bogus>
References: <1546571161-11470-1-git-send-email-yunfei.dong@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546571161-11470-1-git-send-email-yunfei.dong@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, 4 Jan 2019 11:05:59 +0800, Yunfei Dong wrote:
> Fix MTK binding document for MT8173 dtsi changed in order
> to use standard CCF interface.
> MT8173 SoC from Mediatek.
> 
> Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
> Signed-off-by: Qianqian Yan <qianqian.yan@mediatek.com>
> ---
> change note:
> v2: modify subject
> ---
>  .../devicetree/bindings/media/mediatek-vcodec.txt   | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
