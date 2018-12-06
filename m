Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180BBC04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 11:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7E0020850
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 11:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="KgSuak+z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7E0020850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbeLFLNq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 06:13:46 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:53783 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729200AbeLFLNp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 06:13:45 -0500
Received: by mail-it1-f194.google.com with SMTP id g85so717603ita.3
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2018 03:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vj32qMVVqi6/ofzNPokT7fWYP1x6Tmk73xihbhtsudQ=;
        b=KgSuak+zZgxr7hdXV1+3diY6BhdW5gsTRaxv+gsfhbKvDkOiYfEYQOyIQzl8buSXRy
         UE8rXZtvTA+T0Dj2BneSITTCCGRV9KOUHrzgIkA1gBIc/Tdm4tTnGKRxU86JdRx86Kyn
         gxMhKl7Kl1xHKZ/wWQ1eOVgJwNCAbhmQmmwgM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vj32qMVVqi6/ofzNPokT7fWYP1x6Tmk73xihbhtsudQ=;
        b=E7b4XKD93Gp8WnNAt0LqiDTqlvsQO0zW09TZzWBRDE9viardRn35w3QcgjR904+z3D
         bb/lW1kXHWkfzI1j6io9ffvUxIKkwuRP1AlOzk+2BI8xK5PLXzCP2tIsDEQV7PTULI0B
         8a/9nQ3cKzLq9t3tTqLuht1gt9DC1zeB/6/o591zyKta3kQaxXhtOU2TUs1yjygpW3qU
         3xIOBjpYMlIhdBkws2VmtuEixdOPnwwKbwcck9BF7GxXRP6Wpl8On6cCtR+1+/yZfZgn
         yxr+odussUIpse9rGksoJDJEGL2AiCeHArZ2jk+bSH8VORRJXMvuTHTKD7D3myJd/+AG
         J5pw==
X-Gm-Message-State: AA+aEWaaJ4zvnaObrSSvYtVTAtDkP9tvXO9rhFP1EayhsdKo8BifoEAX
        EfL8YUXJGAWyJruPqAE8+p2VGdwSReuLWZkPyjcl+8dIQAY=
X-Google-Smtp-Source: AFSGD/UbozYhj6vuPIK1+h81UN1S1mC9snecLkVi502yTqbuUoxEhdW+jH8hMe4nWVSGcSOrqCWf4bqyyzewScHfs0I=
X-Received: by 2002:a24:4f07:: with SMTP id c7mr1364648itb.107.1544094824912;
 Thu, 06 Dec 2018 03:13:44 -0800 (PST)
MIME-Version: 1.0
References: <20181203100747.16442-1-jagan@amarulasolutions.com>
 <20181203100747.16442-6-jagan@amarulasolutions.com> <CAGb2v6441wV7PM6q=vF2cpJtP9BGdYjQQqNU54rqELNJ5YcmdQ@mail.gmail.com>
In-Reply-To: <CAGb2v6441wV7PM6q=vF2cpJtP9BGdYjQQqNU54rqELNJ5YcmdQ@mail.gmail.com>
From:   Jagan Teki <jagan@amarulasolutions.com>
Date:   Thu, 6 Dec 2018 16:43:33 +0530
Message-ID: <CAMty3ZBBcum5CF1xQ_ePNUkcMoBPXngbiwf2V7hWHrH7-k3xuQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] arm64: dts: allwinner: a64-amarula-relic: Add OV5640
 camera node
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 3, 2018 at 3:55 PM Chen-Yu Tsai <wens@csie.org> wrote:
>
> On Mon, Dec 3, 2018 at 6:08 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
> >
> > Amarula A64-Relic board by default bound with OV5640 camera,
> > so add support for it with below pin information.
> >
> > - PE13, PE12 via i2c-gpio bitbanging
> > - CLK_CSI_MCLK as external clock
> > - PE1 as external clock pin muxing
> > - DLDO3 as vcc-csi supply
> > - DLDO3 as AVDD supply
> > - ALDO1 as DOVDD supply
> > - ELDO3 as DVDD supply
> > - PE14 gpio for reset pin
> > - PE15 gpio for powerdown pin
> >
> > Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
> > ---
> >  .../allwinner/sun50i-a64-amarula-relic.dts    | 54 +++++++++++++++++++
> >  arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi |  5 ++
> >  2 files changed, 59 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-amarula-relic.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-amarula-relic.dts
> > index 6cb2b7f0c817..9ac6d773188b 100644
> > --- a/arch/arm64/boot/dts/allwinner/sun50i-a64-amarula-relic.dts
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-amarula-relic.dts
> > @@ -22,6 +22,41 @@
> >                 stdout-path = "serial0:115200n8";
> >         };
> >
> > +       i2c-csi {
> > +               compatible = "i2c-gpio";
> > +               sda-gpios = <&pio 4 13 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
> > +               scl-gpios = <&pio 4 12 (GPIO_ACTIVE_HIGH|GPIO_OPEN_DRAIN)>;
>
> FYI our hardware doesn't do open drain.

True, but the kernel is enforcing it seems, from the change from [1].
does that mean Linux use open drain even though hardware doens't have?
or did I miss anything?

[    3.659235] gpio-141 (sda): enforced open drain please flag it
properly in DT/ACPI DSDT/board file
[    3.679954] gpio-140 (scl): enforced open drain please flag it
properly in DT/ACPI DSDT/board file
[    3.814878] i2c-gpio i2c-csi: using lines 141 (SDA) and 140 (SCL)

>
> > +               i2c-gpio,delay-us = <5>;
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +
> > +               ov5640: camera@3c {
> > +                       compatible = "ovti,ov5640";
> > +                       reg = <0x3c>;
> > +                       pinctrl-names = "default";
> > +                       pinctrl-0 = <&csi_mclk_pin>;
> > +                       clocks = <&ccu CLK_CSI_MCLK>;
> > +                       clock-names = "xclk";
> > +
> > +                       AVDD-supply = <&reg_dldo3>;
> > +                       DOVDD-supply = <&reg_aldo1>;
>
> DOVDD is the supply for I/O. You say it is ALDO1 here.
>
> > +                       DVDD-supply = <&reg_eldo3>;
> > +                       reset-gpios = <&pio 4 14 GPIO_ACTIVE_LOW>; /* CSI-RST-R: PE14 */
> > +                       powerdown-gpios = <&pio 4 15 GPIO_ACTIVE_HIGH>; /* CSI-STBY-R: PE15 */
> > +
> > +                       port {
> > +                               ov5640_ep: endpoint {
> > +                                       remote-endpoint = <&csi_ep>;
> > +                                       bus-width = <8>;
> > +                                       hsync-active = <1>; /* Active high */
> > +                                       vsync-active = <0>; /* Active low */
> > +                                       data-active = <1>;  /* Active high */
> > +                                       pclk-sample = <1>;  /* Rising */
> > +                               };
> > +                       };
> > +               };
> > +       };
> > +
> >         wifi_pwrseq: wifi-pwrseq {
> >                 compatible = "mmc-pwrseq-simple";
> >                 clocks = <&rtc 1>;
> > @@ -30,6 +65,25 @@
> >         };
> >  };
> >
> > +&csi {
> > +       vcc-csi-supply = <&reg_dldo3>;
>
> But here you say the SoC-side pins are driven from DLDO3.
>
> This is a somewhat odd mismatch.
>
> Regardless, the ov5640 driver enables all three regulators at probe time.
> Shouldn't that be enough to get the I2C bus working? The pin voltage
> supply does not belong here.

It is working w/o supplying PE group, but I think that may be reason
of supplying similar regulator via DOVDD on sensor side. But we need
to make sure the pin-group must be powered right like DSI, HDMI? if
yes may be we do something via power-domain driver like other SoC's
does or do we have any other option.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/gpio/gpiolib.c?id=f926dfc112bc6cf41d7068ee5e3f261e13a5bec8
