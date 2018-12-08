Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700DEC64EB1
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A2DA2083D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="K3dOzOhJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A2DA2083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbeLHRHX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:07:23 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:52699 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbeLHRHT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:07:19 -0500
Received: by mail-wm1-f48.google.com with SMTP id r11-v6so7073312wmb.2
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2018 09:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yxYRRpCF74Ms1Snmk+74VUqKHf7uHCQGnyg34xMkG5U=;
        b=K3dOzOhJxrtM+T6vVpvmsfwcfK+TAMDLrsnGNOTR1uFBBwJbjGJiN5gYI9nKfqh6d1
         VcWbweIuggIFql9Jr228Ut5mHB0EdgSXvspuL15M2/GCuMxPGLl7ON6n7aA0bdIXYCeU
         qq/6FFl5beAWBrOlxw3AXOjfDZN1zj0+zm38Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yxYRRpCF74Ms1Snmk+74VUqKHf7uHCQGnyg34xMkG5U=;
        b=Zmrwzsk/c4VMTguQqdOV9Z4ZdMkRfek9wthCNNtRLHocHG3Z74RclJhHy7/ZcGLpPF
         NbYfjRMGvl09OuxEgjg5n9pUP/+iUifo2zUrqV16ASrKS7EADULLMHawL2f9lUI6WSqO
         x3/zxwKR9A/nQ40lzN0lFJPqBdc6uIDucLAWmH+U6zKun+PX4bg7aG7USkuRdIMmvqnv
         9/7kK2nMMiyEkNy2yYI0BRiEcq++BO0k+qMeeVHctPf4RarBUF75j4etaBoO5IL/BisV
         U9flXavgbnddC6LBeN8HNqoIndPqPzxtc52xzpj6M4OAw8A5Qz2mSU/9dVrr8y2zatId
         UG5A==
X-Gm-Message-State: AA+aEWZm4ByqbDabfkZWNNX+sjrPYZep+Igyze2RPLN9Vl3Fz16sUq6Q
        mtttxM5HiM5jEBkqYVC48S3a3spoYwYu7G80Up3UVVsBn60=
X-Google-Smtp-Source: AFSGD/WnyDh/avSDZlWeO/kRe1jWwUAFo9V6ZYucxdfaR+9XvT/reW+QteX7C5wKCaLQ+pq3WUI3Wj+Z8z4j7sQ2u8c=
X-Received: by 2002:a1c:b456:: with SMTP id d83mr5906249wmf.115.1544288836919;
 Sat, 08 Dec 2018 09:07:16 -0800 (PST)
MIME-Version: 1.0
References: <CAMty3ZAa2_o87YJ=1iak-o-rfZjoYz7PKXM9uGrbHsh6JLOCWw@mail.gmail.com>
 <850c2502-217c-a9f0-b433-0cd26d0419fd@xs4all.nl> <CAOf5uwkirwRPk3=w1fONLrOpwNqGiJbhh6okDmOTWyKWvW+U1w@mail.gmail.com>
In-Reply-To: <CAOf5uwkirwRPk3=w1fONLrOpwNqGiJbhh6okDmOTWyKWvW+U1w@mail.gmail.com>
From:   Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date:   Sat, 8 Dec 2018 18:07:04 +0100
Message-ID: <CAOf5uw=d6D4FGZp8iWKdA1+77ZQtkNZwbJStmO+L-NtW4gqfaA@mail.gmail.com>
Subject: Re: Configure video PAL decoder into media pipeline
To:     hverkuil@xs4all.nl
Cc:     Jagan Teki <jagan@amarulasolutions.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi

Down you have my tentative of connection

I need to hack a bit to have tuner registered. I'm using imx-media

On Sat, Dec 8, 2018 at 12:48 PM Michael Nazzareno Trimarchi
<michael@amarulasolutions.com> wrote:
>
> Hi
>
> On Fri, Dec 7, 2018 at 1:11 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > On 12/07/2018 12:51 PM, Jagan Teki wrote:
> > > Hi,
> > >
> > > We have some unconventional setup for parallel CSI design where analog
> > > input data is converted into to digital composite using PAL decoder
> > > and it feed to adv7180, camera sensor.
> > >
> > > Analog input =>  Video PAL Decoder => ADV7180 => IPU-CSI0
> >
> > Just PAL? No NTSC support?
> >
> For now does not matter. I have registere the TUNER that support it
> but seems that media-ctl is not suppose to work with the MEDIA_ENT_F_TUNER
>
> Is this correct?
>
> > >
> > > The PAL decoder is I2C based, tda9885 chip. We setup it up via dt
> > > bindings and the chip is
> > > detected fine.
> > >
> > > But we need to know, is this to be part of media control subdev
> > > pipeline? so-that we can configure pads, links like what we do on
> > > conventional pipeline  or it should not to be part of media pipeline?
> >
> > Yes, I would say it should be part of the pipeline.
> >
>
> Ok I have created a draft patch to add the adv some new endpoint but
> is sufficient to declare tuner type in media control?
>
> Michael
>
> > >
> > > Please advise for best possible way to fit this into the design.
> > >
> > > Another observation is since the IPU has more than one sink, source
> > > pads, we source or sink the other components on the pipeline but look
> > > like the same thing seems not possible with adv7180 since if has only
> > > one pad. If it has only one pad sourcing to adv7180 from tda9885 seems
> > > not possible, If I'm not mistaken.
> >
> > Correct, in all cases where the adv7180 is used it is directly connected
> > to the video input connector on a board.
> >
> > So to support this the adv7180 driver should be modified to add an input pad
> > so you can connect the decoder. It will be needed at some point anyway once
> > we add support for connector entities.
> >
> > Regards,
> >
> >         Hans
> >
> > >
> > > I tried to look for similar design in mainline, but I couldn't find
> > > it. is there any design similar to this in mainline?
> > >
> > > Please let us know if anyone has any suggestions on this.
> > >

[    3.379129] imx-media: ipu1_vdic:2 -> ipu1_ic_prp:0
[    3.384262] imx-media: ipu2_vdic:2 -> ipu2_ic_prp:0
[    3.389217] imx-media: ipu1_ic_prp:1 -> ipu1_ic_prpenc:0
[    3.394616] imx-media: ipu1_ic_prp:2 -> ipu1_ic_prpvf:0
[    3.399867] imx-media: ipu2_ic_prp:1 -> ipu2_ic_prpenc:0
[    3.405289] imx-media: ipu2_ic_prp:2 -> ipu2_ic_prpvf:0
[    3.410552] imx-media: ipu1_csi0:1 -> ipu1_ic_prp:0
[    3.415502] imx-media: ipu1_csi0:1 -> ipu1_vdic:0
[    3.420305] imx-media: ipu1_csi0_mux:5 -> ipu1_csi0:0
[    3.425427] imx-media: ipu1_csi1:1 -> ipu1_ic_prp:0
[    3.430328] imx-media: ipu1_csi1:1 -> ipu1_vdic:0
[    3.435142] imx-media: ipu1_csi1_mux:5 -> ipu1_csi1:0
[    3.440321] imx-media: adv7180 2-0020:1 -> ipu1_csi0_mux:4

with
       tuner: tuner@43 {
                compatible = "tuner";
                reg = <0x43>;
                pinctrl-names = "default";
                pinctrl-0 = <&pinctrl_tuner>;

                ports {
                        #address-cells = <1>;
                        #size-cells = <0>;
                        port@1 {
                                reg = <1>;

                                tuner_in: endpoint {
                                        remote-endpoint = <&tuner_out>;
                                };
                        };
                };
        };

        adv7180: camera@20 {
                compatible = "adi,adv7180";
                reg = <0x20>;
                pinctrl-names = "default";
                pinctrl-0 = <&pinctrl_adv7180>;
                powerdown-gpios = <&gpio3 20 GPIO_ACTIVE_LOW>; /* PDEC_PWRDN */

                ports {
                        #address-cells = <1>;
                        #size-cells = <0>;

                        port@1 {
                                reg = <1>;

                                adv7180_to_ipu1_csi0_mux: endpoint {
                                        remote-endpoint =
<&ipu1_csi0_mux_from_parallel_sensor>;
                                        bus-width = <8>;
                                };
                        };

                        port@0 {
                                reg = <0>;

                                tuner_out: endpoint {
                                        remote-endpoint = <&tuner_in>;
                                };
                        };
                };
        };

Any help is appreciate

Michael

> > > Jagan.
> > >
> >
>
>
> --
