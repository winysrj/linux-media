Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,URIBL_RHS_DOB,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FBCC04EBF
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 21:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D94E20850
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 21:47:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D94E20850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbeLDVrh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 16:47:37 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35255 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbeLDVrh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 16:47:37 -0500
Received: by mail-oi1-f195.google.com with SMTP id v6so15703527oif.2;
        Tue, 04 Dec 2018 13:47:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h4IfCXMBhmfDml/xc3p3lpzvdTs3Mo2ee3ruNM29h5I=;
        b=nazxe/C/CXw8BUo+RSie13X63HoiDF7w2jM9gNvTTDGq7gSAFrmvUxD00XKGY6mTCW
         lktgFnt/njTPVDx1MrUOW4/e7Z8QKqIFQY08VGxkmv7raNiEdA8FIIcB4awMd6+lU5pX
         4729mX5KH62rwPvRMmZlKlMviFRovW2RdwQf1F9CRvh9SsuTqdflYO/UNZJ+RSqbs3b2
         /MXcpckw00z7LqeFMHgqCR6HDWTf3gReCABYVVlqt9Aaj3KNxvByZmeOt8FpCNl2Deeo
         6uVw/APxyvCZSimy3bttfTAYoZ9qhTgdQlFZMsgQICvmZjM0FhaCC2DYo+TrDQeKGYQY
         +5PA==
X-Gm-Message-State: AA+aEWYLk5VaYV3C6zZ0yPRU+nU/E2+DUkjhRxAGC2gNnrHFWTwb3QkO
        MVyp7zcd8yg8YnZeziOcyA==
X-Google-Smtp-Source: AFSGD/Vg6ShvAjfY/VQ25n/XOjRR/3J2ssxWm80K8x5Ckr0APduYY0hD2SecbtSEiYDw+yWKayl1zQ==
X-Received: by 2002:aca:f306:: with SMTP id r6mr14195069oih.230.1543960055384;
        Tue, 04 Dec 2018 13:47:35 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t8sm7316697otp.69.2018.12.04.13.47.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Dec 2018 13:47:34 -0800 (PST)
Date:   Tue, 4 Dec 2018 15:47:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH 11/15] dt-bindings: media: cedrus: Add compatibles for
 the A64 and H5
Message-ID: <20181204214733.GA14148@bogus>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
 <20181115145013.3378-12-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115145013.3378-12-paul.kocialkowski@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 15 Nov 2018 15:50:09 +0100, Paul Kocialkowski wrote:
> This introduces two new compatibles for the cedrus driver, for the
> A64 and H5 platforms.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  Documentation/devicetree/bindings/media/cedrus.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
