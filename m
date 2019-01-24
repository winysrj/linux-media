Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D995EC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B37AD218AE
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfAXKRO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:17:14 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35159 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfAXKRM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 05:17:12 -0500
Received: by mail-ed1-f68.google.com with SMTP id x30so4136314edx.2;
        Thu, 24 Jan 2019 02:17:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QrS7sDgTK/p6WIKMEMFfTtaoUcPIzsYu3/wEQPiXjgs=;
        b=rsg4igA5p/LkdOq/N2qon/FhK7iQ4bgSODHLPXOoiqPACMM/nY0MQdNBQ0KwYTULTb
         Sz0/s8JuN1qbAm2HVIKzVB5Ar8inXyw4rp+nCactNfcvdoQafHVDo9tcDp9DYVbavKmZ
         SHE6hJ5hSOXgvewtdqAqDvOonhDQ+Gxf5AAZX0zpQYA/0POzZyylhxseJdMVsrVEeySM
         1yk98fIsX1dsfXSe1SVM88WnU15sFD1R2JLg1/kBzT3o8EEBu9dvp3j8KUHh0VJClONE
         fDj/bFHsSLdSoZbglIuGkz+A7ltYwHkUf35Ibt7GKjS8Yz7XyH6xzKhPuwLR0dRWIrMC
         GTsA==
X-Gm-Message-State: AJcUukfwjF4PZNSvujp47zMxDroTV2NPbavngDKzd6aRJ7WKwgJT4mTa
        vra/gW/Gy12+ND4uf0B8JdgigFCxZ8s=
X-Google-Smtp-Source: ALg8bN4gYyQfrmtnrdOy/sheqBEAUJBqJ6oIZTXqexkrvyCTk2U+e19kNts4hDS2gehbTdq7xM0o3w==
X-Received: by 2002:a50:f284:: with SMTP id f4mr6033658edm.77.1548325029698;
        Thu, 24 Jan 2019 02:17:09 -0800 (PST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id g2sm10928959edh.15.2019.01.24.02.17.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 02:17:09 -0800 (PST)
Received: by mail-wr1-f46.google.com with SMTP id q18so5794963wrx.9;
        Thu, 24 Jan 2019 02:17:08 -0800 (PST)
X-Received: by 2002:adf:a1d2:: with SMTP id v18mr6254579wrv.87.1548325028586;
 Thu, 24 Jan 2019 02:17:08 -0800 (PST)
MIME-Version: 1.0
References: <20181130075849.16941-1-wens@csie.org> <20181130075849.16941-5-wens@csie.org>
 <CAMty3ZB6p8Uv7abMC8jDHHYwdAeuBen2GPjOhN=wEL7+=DDt3g@mail.gmail.com>
In-Reply-To: <CAMty3ZB6p8Uv7abMC8jDHHYwdAeuBen2GPjOhN=wEL7+=DDt3g@mail.gmail.com>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Thu, 24 Jan 2019 18:16:55 +0800
X-Gmail-Original-Message-ID: <CAGb2v67nAGC0xwgtq+_mYv_ZRmhBQsPdLbbJ6thfKDNY456sYg@mail.gmail.com>
Message-ID: <CAGb2v67nAGC0xwgtq+_mYv_ZRmhBQsPdLbbJ6thfKDNY456sYg@mail.gmail.com>
Subject: Re: [PATCH 4/6] ARM: dts: sunxi: h3-h5: Add pinmux setting for CSI
 MCLK on PE1
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
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

On Mon, Dec 3, 2018 at 5:46 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
>
> On Fri, Nov 30, 2018 at 1:28 PM Chen-Yu Tsai <wens@csie.org> wrote:
> >
> > Some camera modules have the SoC feeding a master clock to the sensor
> > instead of having a standalone crystal. This clock signal is generated
> > from the clock control unit and output from the CSI MCLK function of
> > pin PE1.
> >
> > Add a pinmux setting for it for camera sensors to reference.
> >
> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > ---
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

Not merging this one, as there are no boards in tree that directly use this.

ChenYu
