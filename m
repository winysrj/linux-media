Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEF9C10F03
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 13:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F0D2133D
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 13:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1LaOvWI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfCSNiM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:38:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46661 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfCSNiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 09:38:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id a22so13839404pgg.13
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 06:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WLET6+1d+gAHmLTIbxdxe6xq83qyuPNTlBFndOpjzQ0=;
        b=W1LaOvWIluaU+iuXVMw8mH+wl20cMkakXR8eAkoL/OM+Y+Cgs4mHFnZqt17pE9pR6k
         KMgT58nEdsD7PI7pGYshMQIdpSjOPKwzhSaRPm6W9D19QDlblRNB7x2DI0Ldy+VaQCf2
         qnbSMIPsozGcb9pjS3ixLcfCT4UyDItxhxwBpkl0RLB5XAfi5fHMTDMm7nH3cLJ5Keo6
         eiYoxYMdQWbGaATwQIdFdelgVRCjRx30S/4Tdhf0TtJ6tyy/EkR5j0ixsb22jsXwsV8N
         6X0cGdX+si1UUxR88FcV9REmArkKX7RKC+J6/RuSk18iVIPqpHlJmUNCBl0sbDYOeWl6
         ubZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WLET6+1d+gAHmLTIbxdxe6xq83qyuPNTlBFndOpjzQ0=;
        b=j0fpourOdRyPit4MftU4JxpyzXRFzClmdwENYStCloDmGHhrhz5XpsvrIvTf8rhFpT
         Yw9d+ipUbvx1I2iDMEbzZ6woicYvOIh1A+hkiUQamNPJDmtwUhT8gJLHDlfilYDaBN8G
         5hB+nH3fTKaw6DQHOMlbHVkuc/LqqybZeqZBikHBvG6XRvij003TQKQ/RwRWe7mUQYqf
         wBUWYbLycNKKUFmg/XJGu0J6rpbcCkVgPIuKosTaNydUE+9W1I4J8R5wdiKdW/gR+ooR
         4saecS/dXr1uyNS3dHhJ4eDqog/rDYf8pvezPcKXkZ3T0WgdXnDHnqlJEfQnsjPV1ngB
         tyrw==
X-Gm-Message-State: APjAAAUREC4jV5ELmLCE7ITO8wG+TekuDSAQw2hLGi35Fz8KmDKd3mO4
        J7NjZx/0o85JBxO9Zb2shtZlLnmJVKAkSKXaCZ8=
X-Google-Smtp-Source: APXvYqwUNqBy6avKpP93ML2SXgd8nK/xuJTiXDaBjr3GO0J9MOSjVLkKFEv8Otz3Lsc5uowluA25QrFvdz3IPip2byo=
X-Received: by 2002:a63:5c59:: with SMTP id n25mr12990334pgm.432.1553002691406;
 Tue, 19 Mar 2019 06:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
 <559a9073a3d42de6737f75a1fb6a6e53451a6a28.camel@v3.sk> <20190313210535.fl54xfjhui7dl7bb@kekkonen.localdomain>
 <1900bcf1-a5b7-b4b3-d275-03117e6c87ef@microchip.com>
In-Reply-To: <1900bcf1-a5b7-b4b3-d275-03117e6c87ef@microchip.com>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Tue, 19 Mar 2019 22:38:00 +0900
Message-ID: <CAC5umyhjXbP9cUnGHew6wsHMDadUKfFo0MGnMWS6D0f=QsdPGg@mail.gmail.com>
Subject: Re: [PATCH 0/2] media: ov7670: fix regressions caused by "hook
 s_power onto v4l2 core"
To:     Eugen Hristev <Eugen.Hristev@microchip.com>
Cc:     Lubomir Rintel <lkundrak@v3.sk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B43=E6=9C=8819=E6=97=A5(=E7=81=AB) 18:14 <Eugen.Hristev@microchi=
p.com>:
>
>
>
> On 13.03.2019 23:05, Sakari Ailus wrote:
>
> > On Tue, Mar 12, 2019 at 06:16:08PM +0100, Lubomir Rintel wrote:
> >> On Tue, 2019-03-12 at 00:36 +0900, Akinobu Mita wrote:
> >>> This patchset fixes the problems introduced by recent change to ov767=
0.
> >>>
> >>> Akinobu Mita (2):
> >>>    media: ov7670: restore default settings after power-up
> >>>    media: ov7670: don't access registers when the device is powered o=
ff
> >>>
> >>>   drivers/media/i2c/ov7670.c | 32 +++++++++++++++++++++++++++-----
> >>>   1 file changed, 27 insertions(+), 5 deletions(-)
> >>>
> >>> Cc: Lubomir Rintel <lkundrak@v3.sk>
> >>> Cc: Jonathan Corbet <corbet@lwn.net>
> >>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> >>
> >> For the both patches in the set:
> >>
> >> Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>
> >> Tested-by: Lubomir Rintel <lkundrak@v3.sk>
> >
> > Thanks, guys!
> >
>
> Hi Akinobu,
>
> I am having issues with this sensor, and your patches do not fix them
> for me ( maybe they are not supposed to )
>
> My issues are like this: once I set a format and start streaming, if I
> stop streaming and reconfigure the format , for example YUYV after RAW,
> or RGB565 after RAW and viceversa, the sensor looks to have completely
> messed up settings: images obtained are very bad.
> This did not happen for me with older kernel version (4.14 stable for
> example).
> I can help with testing patches if you need.

I'd suggest identifying which commit introduced your problem.
