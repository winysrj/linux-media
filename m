Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA66C04EB8
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 11:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67B5620868
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 11:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="R7bI+o23"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67B5620868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbeLHLsg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 06:48:36 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:43240 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeLHLsg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 06:48:36 -0500
Received: by mail-wr1-f42.google.com with SMTP id r10so6099165wrs.10
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2018 03:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W9CCf7dNTH1Y7U6PTjl/HQiX3qRW6tBNDCqQCqqnZ6M=;
        b=R7bI+o233jDIv7GjodP+mDjcLtGs6xl1Scy5lx+FK2eZbtjeFYRzubJT7l/rGN5qJy
         i/NMyiwLDeyExa13zngtc+0SCGlWv13Tyx30nl52WhSU4mesMKNtYnjmmune9vfJe23q
         VuPnENUVqozY3ePPso3BqQxTc9X3+8AImz9Ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W9CCf7dNTH1Y7U6PTjl/HQiX3qRW6tBNDCqQCqqnZ6M=;
        b=nslQw6qPNMjMIb3JmtYyrAocjDXsXKm4zi2JGXuYsZTH6qtQOcrjEKFRkzhXMDk16e
         AX1qXB6IYANkWYsRKG/SBhZVb51Bg5hcA35p6DBEtk0eY/m5MyexEvbgo4IaayOUK9Dk
         7iqlevw5jaHeIftfIE5WO/W9vIxw53w/+9Ah1NT/xo10ufWenJ8vG7HUFY1ONZRQ2PRy
         7lpuBnCXQOxs4ULDZJIM50esSOfEMgxcfRDat3zZDIZ9pC8zKBBvtYE98vRDIxjge/fw
         ldL+PvOqbOS+t4gUANT0Apc0PYbVG26CBlQts8OsyhTIwzWntOlE+h4IOELSYrg+nxB9
         Hk2A==
X-Gm-Message-State: AA+aEWadlkcaxugd7qX2fWLogVFQwLp4W901PVJkx/x5yEY8AmgvbFaQ
        reFseGp/ie0hzNvGWCgqrL2bnjvC1cN15SK/mXou6w==
X-Google-Smtp-Source: AFSGD/XYy4c4elmVjqgiVRkp7RQQDn0Q61nfbOIkgwX/76V/JwIbAhaQRtBag3hINS96tzA0egABrBgj5UJZBeKmoeU=
X-Received: by 2002:adf:9422:: with SMTP id 31mr4734372wrq.106.1544269714648;
 Sat, 08 Dec 2018 03:48:34 -0800 (PST)
MIME-Version: 1.0
References: <CAMty3ZAa2_o87YJ=1iak-o-rfZjoYz7PKXM9uGrbHsh6JLOCWw@mail.gmail.com>
 <850c2502-217c-a9f0-b433-0cd26d0419fd@xs4all.nl>
In-Reply-To: <850c2502-217c-a9f0-b433-0cd26d0419fd@xs4all.nl>
From:   Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date:   Sat, 8 Dec 2018 12:48:23 +0100
Message-ID: <CAOf5uwkirwRPk3=w1fONLrOpwNqGiJbhh6okDmOTWyKWvW+U1w@mail.gmail.com>
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

On Fri, Dec 7, 2018 at 1:11 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 12/07/2018 12:51 PM, Jagan Teki wrote:
> > Hi,
> >
> > We have some unconventional setup for parallel CSI design where analog
> > input data is converted into to digital composite using PAL decoder
> > and it feed to adv7180, camera sensor.
> >
> > Analog input =>  Video PAL Decoder => ADV7180 => IPU-CSI0
>
> Just PAL? No NTSC support?
>
For now does not matter. I have registere the TUNER that support it
but seems that media-ctl is not suppose to work with the MEDIA_ENT_F_TUNER

Is this correct?

> >
> > The PAL decoder is I2C based, tda9885 chip. We setup it up via dt
> > bindings and the chip is
> > detected fine.
> >
> > But we need to know, is this to be part of media control subdev
> > pipeline? so-that we can configure pads, links like what we do on
> > conventional pipeline  or it should not to be part of media pipeline?
>
> Yes, I would say it should be part of the pipeline.
>

Ok I have created a draft patch to add the adv some new endpoint but
is sufficient to declare tuner type in media control?

Michael

> >
> > Please advise for best possible way to fit this into the design.
> >
> > Another observation is since the IPU has more than one sink, source
> > pads, we source or sink the other components on the pipeline but look
> > like the same thing seems not possible with adv7180 since if has only
> > one pad. If it has only one pad sourcing to adv7180 from tda9885 seems
> > not possible, If I'm not mistaken.
>
> Correct, in all cases where the adv7180 is used it is directly connected
> to the video input connector on a board.
>
> So to support this the adv7180 driver should be modified to add an input pad
> so you can connect the decoder. It will be needed at some point anyway once
> we add support for connector entities.
>
> Regards,
>
>         Hans
>
> >
> > I tried to look for similar design in mainline, but I couldn't find
> > it. is there any design similar to this in mainline?
> >
> > Please let us know if anyone has any suggestions on this.
> >
> > Jagan.
> >
>


-- 
| Michael Nazzareno Trimarchi                     Amarula Solutions BV |
| COO  -  Founder                                      Cruquiuskade 47 |
| +31(0)851119172                                 Amsterdam 1018 AM NL |
|                  [`as] http://www.amarulasolutions.com               |
