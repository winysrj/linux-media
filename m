Return-Path: <SRS0=Cdzf=R3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B8CC43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 21:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966BA213F2
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 21:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553462022;
	bh=x2HIzQhIvkoBb8RYQnIvE8p4jSra0N+iO6KX8myIoyQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=y+/u7+B7VEYQsdgrTAVbA0yHQ7rusR5OqnBRDC7glO4Sg14LDUzDOXj3fj3T+4hCN
	 vlf6q1HdS3Gp6h4Ajwg6njC1/i3edZOl0o8tgA54IwhIEDHeTMIW23nIDM9PezbXU9
	 CGYjcXSIzjqsVHKLrHrywJe1FlUxhPc3rhh4YW/o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfCXVNh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 17:13:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbfCXVNh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 17:13:37 -0400
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0DD02173C;
        Sun, 24 Mar 2019 21:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553462016;
        bh=x2HIzQhIvkoBb8RYQnIvE8p4jSra0N+iO6KX8myIoyQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GyJ7YS+nckQbbO6vuDYBbT9h+m5eb8aF94LlQuaWwvvxWrSobNCQ1qAw94oTWyHSf
         qbT+PFBPNosgBk+i0RKhomBAUDRDiBXX1ad4U0rqR1+3ldfMtZ0w/epebdRd0ld7q7
         h18Fgkw7mHNQTYBJrXiuZ9Js4H/36+mVP3SoZQu8=
Received: by mail-qk1-f178.google.com with SMTP id w20so4182902qka.7;
        Sun, 24 Mar 2019 14:13:35 -0700 (PDT)
X-Gm-Message-State: APjAAAUfkBFOl7gAtdDVuAn9FvYp9tlTcZs9HjN1RxpaCLNJuuS4xUa6
        8fhgW9lUT8KWU8Mtn4s463753SIOEI0oK5saVA==
X-Google-Smtp-Source: APXvYqzg4h+Cu3YIlg3bnpzwOR4M2QBbH8N22dFEfqkViTZFrn4+elyYizpdenA0DznNAIAg8dqUxN/mwt5MyXgilNE=
X-Received: by 2002:a37:4a12:: with SMTP id x18mr16186408qka.184.1553462015134;
 Sun, 24 Mar 2019 14:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.2aba8cbd95630d87f927465cc2beb881936c83d9.1553010938.git-series.maxime.ripard@bootlin.com>
 <8b1291b572695e4baa67c144dd6deee0563b7586.1553010938.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <8b1291b572695e4baa67c144dd6deee0563b7586.1553010938.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Sun, 24 Mar 2019 16:13:23 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKiCZrf0BVwN-q6a2SgZVco3iKhm8qeoeJr_wrSwCFUzQ@mail.gmail.com>
Message-ID: <CAL_JsqKiCZrf0BVwN-q6a2SgZVco3iKhm8qeoeJr_wrSwCFUzQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] dt-bindings: media: Add Allwinner A10 CSI binding
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 19, 2019 at 10:56 AM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> The Allwinner A10 CMOS Sensor Interface is a camera capture interface also
> used in later (A10s, A13, A20, R8 and GR8) SoCs.
>
> On some SoCs, like the A10, there's multiple instances of that controller,
> with one instance supporting more channels and having an ISP.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 94 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
