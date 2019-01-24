Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E11C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2024218A2
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfAXKP7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:15:59 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40908 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbfAXKP7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 05:15:59 -0500
Received: by mail-ed1-f66.google.com with SMTP id g22so4106996edr.7;
        Thu, 24 Jan 2019 02:15:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IMeU3UY2XAM0kzq1Z8Gn2QEdtJTiaE/AbGjYG0aznDQ=;
        b=g3GuyGgFxTH3OHAZ5YyZ3KECk4ziJDUC8xipy8ioDN2xseodDJv1ubwFLWdsZwX1DJ
         3SqvApAp94JMdO0dGJavxBGo4B164JAGq4VBAblvurMbkexdqLxCaM2kXowhVn8wgiwb
         QP/JW/3WhAT+M0Z1pS9+u4nQ6xAtaZtgMy+hnzc9V6GQCyQU49AoXQeiGZG5D8Ddcy/4
         9c0qrlZO24w/wBesK+Cubw6v08zPTNYd1q9rLJxyZLOoSnaDJQuZJnSpqa6s976D80zO
         xojXPFFCsfB+4iJPNIT/oK+ASYNcgpL9YokyJ41Cq6vN8mpujMSXr4853lChOcZy2bAD
         y28Q==
X-Gm-Message-State: AJcUukfhWccgz8gUqHQDBL8sQgdh4BeuqKfbv7U5YiGc+W99MIyH9TYz
        3LntHQtQdeuKi61MgHYRCpIalhryTZw=
X-Google-Smtp-Source: ALg8bN7D6yOxv6XEnFkyAhvFbUojFSTYhpcKes38+HcSbHbrbukVpAbJzK5A/Ay1AHIX5Gtzjw2C7Q==
X-Received: by 2002:a17:906:4b19:: with SMTP id y25-v6mr5480984eju.89.1548324957127;
        Thu, 24 Jan 2019 02:15:57 -0800 (PST)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id m14sm12091905edc.27.2019.01.24.02.15.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 02:15:56 -0800 (PST)
Received: by mail-wm1-f51.google.com with SMTP id d15so2479713wmb.3;
        Thu, 24 Jan 2019 02:15:56 -0800 (PST)
X-Received: by 2002:a1c:578e:: with SMTP id l136mr1933083wmb.124.1548324956114;
 Thu, 24 Jan 2019 02:15:56 -0800 (PST)
MIME-Version: 1.0
References: <20181130075849.16941-1-wens@csie.org> <20181130075849.16941-4-wens@csie.org>
 <CAMty3ZBFVStHNbYaBxT+Rmy6+g4jtm0cFKk8BL5BDid3c5VW-Q@mail.gmail.com>
In-Reply-To: <CAMty3ZBFVStHNbYaBxT+Rmy6+g4jtm0cFKk8BL5BDid3c5VW-Q@mail.gmail.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Thu, 24 Jan 2019 18:15:43 +0800
X-Gmail-Original-Message-ID: <CAGb2v67oLffVXYAHHcHEo6_rNddqpFwCGq2DzgFW_zkfbpf12g@mail.gmail.com>
Message-ID: <CAGb2v67oLffVXYAHHcHEo6_rNddqpFwCGq2DzgFW_zkfbpf12g@mail.gmail.com>
Subject: Re: [PATCH 3/6] ARM: dts: sunxi: h3/h5: Drop A31 fallback compatible
 for CSI controller
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Jagan Teki <jagan@amarulasolutions.com>,
        Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 3, 2018 at 5:44 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
>
> On Fri, Nov 30, 2018 at 1:29 PM Chen-Yu Tsai <wens@csie.org> wrote:
> >
> > The CSI controller found on the H3 (and H5) is a reduced version of the
> > one found on the A31. It only has 1 channel, instead of 4 channels for
> > time-multiplexed BT.656. Since the H3 is a reduced version, it cannot
> > "fallback" to a compatible that implements more features than it
> > supports.
> >
> > Drop the A31 fallback compatible.
> >
> > Fixes: f89120b6f554 ("ARM: dts: sun8i: Add the H3/H5 CSI controller")
> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > ---
>
> Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>

Merged for 5.1, as the accompanying driver changes were also merged for 5.1

ChenYu
