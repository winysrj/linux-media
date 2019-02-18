Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F52EC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 18:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31DC4217F5
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550513554;
	bh=ta3N26nGASg3oY0rpAoSat/LeVqm+UM02t8uqjsLqgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=BMgxo085IvDmmVdZym4kGfU7jH8cM62uF8UbDG5HfujZC/Ld+OL8y9t7ZNCr2JuFr
	 xeERF4RLWQ6V+CJLHgAiwDE1EicB4GDwVBLNAj2rdoyb30tiAsuZeoRW4Mlg3f4Sas
	 35Q9C3pJTV0HxXD/3JA32rvcmmikKNyLQplO/rFA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390452AbfBRSMd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 13:12:33 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40158 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390204AbfBRSMc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 13:12:32 -0500
Received: by mail-ot1-f66.google.com with SMTP id s5so29784540oth.7;
        Mon, 18 Feb 2019 10:12:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z/eE4JHArO1RDsFJ6k0J/R14gZjMnOTudavF0ULrl1I=;
        b=b7zz/j6b6rGeolMZCo99murwXHMe8PUD6qE6dYFKXt9Jj0QOUxHXB372WoldhhyQZ4
         yxIFRX8nWWhU6eljP0iBoZvydW4JUHmsk9SosGyzVIEagjuP/KpsNI8QUS8CdHchHVXt
         RbUAQVyXRM0lSwwYiL5ww6gYz/01VkOPZ96GAevrY7AkWMzhQ4EwTfh/RBn3VG5kC9ZO
         W0blTTinpYVkMPFPAd/SHhW3AtMeWv6d9/2I7hte7G9+kDQKU1P4OENF0QmgUriG8p8/
         Q8RhUNa+XirvXRkmB0wzNovgoiW+CheLdiNktVoh/EjO4ZP+q0EgPD5jejSOvVI92QIz
         EbGQ==
X-Gm-Message-State: AHQUAua3kbOMJRP1/fhWcvDJCjqm4ogshFoi+egeZxZ0GT7LriPplYY1
        gRIXh2/zFDZbhTEq5Sjckw==
X-Google-Smtp-Source: AHgI3Ib30mtSvMyS7kJ5ltJw39EqgT2B7+1owlKc/xRhDqtQ2uDJaKCJ9Dij61ay+cINf0YvFGDjxA==
X-Received: by 2002:aca:af90:: with SMTP id y138mr56199oie.35.1550513551683;
        Mon, 18 Feb 2019 10:12:31 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a12sm6226991otl.39.2019.02.18.10.12.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Feb 2019 10:12:31 -0800 (PST)
Date:   Mon, 18 Feb 2019 12:12:30 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Tretter <m.tretter@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, dshah@xilinx.com,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: Re: [PATCH v3 1/3] media: dt-bindings: media: document allegro-dvt
 bindings
Message-ID: <20190218181230.GA13153@bogus>
References: <20190213175124.3695-1-m.tretter@pengutronix.de>
 <20190213175124.3695-2-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213175124.3695-2-m.tretter@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 13 Feb 2019 18:51:22 +0100, Michael Tretter wrote:
> Add device-tree bindings for the Allegro DVT video IP core found on the
> Xilinx ZynqMP EV family.
> 
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> ---
> v2 -> v3:
> - rename node to video-codec
> - drop interrupt-names
> - fix compatible in example
> - add clocks to required properties
> 
> v1 -> v2:
> none
> ---
>  .../devicetree/bindings/media/allegro.txt     | 43 +++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
