Return-Path: <SRS0=IHcP=PI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CE8C43387
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 16:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3DC82133F
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 16:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUXmrlrt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbeLaQ51 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 31 Dec 2018 11:57:27 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45685 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbeLaQ50 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Dec 2018 11:57:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id g62so13370427pfd.12
        for <linux-media@vger.kernel.org>; Mon, 31 Dec 2018 08:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gXJSJqJIMcHdlfa4Q8TZaXDye2Q8b+2q0218gWqeOkM=;
        b=KUXmrlrtxHPnQ/GXz2nWB/y5NQq/LHB3nnzo8upKyWKnUI/JgBzAw3HpDuHOXuttXg
         O1yGEW+qbLLWm/ECeDausjBANYO5G/zJxRXGIQZf7NSKv0niplhLu666rt+6Z/1LczJX
         AurLAouMqMz+MpUyB/G1CILd7L3M2LAyn3QzcxG28DWSVdrt285LNnvRGCLbxzatx6eu
         75Vb6mQa72IaZzskbSXdC02vYb3vbTrMZ7UZ5ZTAoAKUBwm3eA/0bw45mBRUQgXsb8hs
         AGu5Twc03xWeBOEZl108vm+E0pzqBLVNzu8PyB2YVgpWAj/7xpisW7WD/m3GRa8cs6nl
         vN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gXJSJqJIMcHdlfa4Q8TZaXDye2Q8b+2q0218gWqeOkM=;
        b=dR2KNJ735APFKbyxQpuxm+f+QNHIyrhWUgj0Rza8mNpGgAyRzmgheQ9RoCcLODSUOx
         oprAta3vIszz0fhb7Jf/rkAXd4VincF70kboTisYq2Vt2Uo6OpuXDygsAQzk6QNhXfmh
         KWo7yyAAHe+3N6lH2l0xWv0VDKms5naq5/InQn7xJaBHKSe6Rlsv+qT98ozezOO8WpdQ
         O0s13F9GPm+a8D3pPRD4XpaMCRtEwUm12Y0/nr4w+xpdHuEjMH4V7RYFPikxTn4ihu0+
         VQuYKMxiq81ZkB+h+c/2ptapHPP5x+fLzqEsHatTU3rNAYtZGLA9nK1w9RM/e4VVIwwr
         jgAg==
X-Gm-Message-State: AA+aEWZUgrCbdqSKwXi2f0drLQLt15ytCPZKQPyaEdZEA+naGdIwXIHC
        u2PoX4DH1uBBzo8fx8mfS51+nKF0s2Btph7hvqc=
X-Google-Smtp-Source: AFSGD/WegKQWiGx/rx0AFaXaiMx1KG7k3V1fUUdoJsIr+TRKEnQq5WTSV0OyT1LmvCdI2RqX7kd4bq/CihBWq90AgF0=
X-Received: by 2002:a62:d701:: with SMTP id b1mr37816942pfh.34.1546275444816;
 Mon, 31 Dec 2018 08:57:24 -0800 (PST)
MIME-Version: 1.0
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
 <1546103258-29025-2-git-send-email-akinobu.mita@gmail.com> <20181231103029.4qlr5fd2l3vwyeb7@pengutronix.de>
In-Reply-To: <20181231103029.4qlr5fd2l3vwyeb7@pengutronix.de>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Tue, 1 Jan 2019 01:57:13 +0900
Message-ID: <CAC5umyg7kdLp+t4-vpa1GbEXaxt17B+H8CObOOOzoQ_SETwXLQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] media: mt9m111: fix setting pixclk polarity
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     linux-media@vger.kernel.org,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2018=E5=B9=B412=E6=9C=8831=E6=97=A5(=E6=9C=88) 19:30 Marco Felsch <m.felsch=
@pengutronix.de>:
>
> Hi Akinobu,
>
> On 18-12-30 02:07, Akinobu Mita wrote:
> > Since commit 98480d65c48c ("media: mt9m111: allow to setup pixclk
> > polarity"), the MT9M111_OUTFMT_INV_PIX_CLOCK bit in the output format
> > control 2 register has to be changed depending on the pclk-sample prope=
rty
> > setting.
> >
> > Without this change, the MT9M111_OUTFMT_INV_PIX_CLOCK bit is unchanged.
>
> I don't know what you mean, it will get applied depending on the
> property.
>
> 8<-----------------------------------------------------------------------=
-
> static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
>                               u32 code)
> {
>
>         ...
>
>         /* receiver samples on falling edge, chip-hw default is rising */
>         if (mt9m111->pclk_sample =3D=3D 0)
>                 mask_outfmt2 |=3D MT9M111_OUTFMT_INV_PIX_CLOCK;
>
>         ...
> }
>
> 8<-----------------------------------------------------------------------=
-
>
> Isn't this right?

You are right.  I misread and thought the commit sets the
MT9M111_OUTFMT_INV_PIX_CLOCK bit in 'data_outfmt2' instead of
'mask_outfmt2'.

This patch will be dropped from this series in the next version.

> Can you cc me the other patches too, so I can keep track of it easier?

OK.  I'll do from v2.
