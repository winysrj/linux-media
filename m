Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750C6C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 15:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E8972173C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 15:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uAUEDvrL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfAGP3H (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 10:29:07 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45538 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729901AbfAGP3H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 10:29:07 -0500
Received: by mail-lf1-f67.google.com with SMTP id b20so542503lfa.12;
        Mon, 07 Jan 2019 07:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p6kEmkcA5eq6xte4+zfVBW1rB9nisSAlEjj7MbE6/pI=;
        b=uAUEDvrL04s6GW8PWf6+iTjjPnzuxmxvpQkGL27fDRAtkOpdx4O1sMHvq+k4eIXfNh
         YhsDn1DDMLwsbbFWUwNuBTExtxzulvY779A3ycXZ9nQY7RTiriGj1oEc/wwTEJoibbyO
         1CJpuDoqTf8trw3IOvZkd8yhskJCtUYn4NWpDYrF0HpUfMm9XAnwWgsdmVFkhHLuBeMU
         e/2KQDPBi/B0MGOFJ2cTjRnD9QqqL9YUZykw2dV/X6uPOBTOvcC1ho4cg4kBf7lJsRW1
         uYY4Xf04X+A5Wkt1DiVSNEPVz1CtN4/itDL/8nq+WqPPrI22BMlx2iCwLVAc6l2a/RKq
         ax3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p6kEmkcA5eq6xte4+zfVBW1rB9nisSAlEjj7MbE6/pI=;
        b=lye1VFfgZ1n+0tENhqNo5j8K+ElpAp0bVl8IcJ49EohpNszJs6kn4PtIFViN/g7eWc
         EmCeXyJyVNckP1kvZ9siTYyP9qAsX1pZwI65AzY5kelhZsePJHCnl/048nSWBTcE90aJ
         /lCG7uzuqra+z1ThRbClbZowRZcWor3hu57qyH3fG8cD9ON7zVE2AjJbBqd1NpJ2Zuu1
         wbflql7IHgoj0aB938v8VMdhcnRX6VCyggGjIGNGzUZeSNETU9zsuInDxQgd+rh9mZq5
         4L+wdyd35oC2V5NcoLW/oOrnnR6UwyZKeDL9V7z9nu0xoYHw1d4LqUbxJdgZLtiugh/V
         kB1A==
X-Gm-Message-State: AA+aEWYbFvSsDGXrvGIaWOqkc4P89B2s7e3k7qU6UA5CLCdKYQYozteQ
        XSV5uNycoMHXTkrErS53l1E=
X-Google-Smtp-Source: AFSGD/UWPbH6yo9Bo7pTxIAu1EGbvPCDNeX1BqMBmvd1Qsw1X1NBKKufCzzHZvjOLdDD0e6HzSWKYw==
X-Received: by 2002:a19:5e5d:: with SMTP id z29mr30003456lfi.105.1546874944909;
        Mon, 07 Jan 2019 07:29:04 -0800 (PST)
Received: from acerlaptop.localnet ([2a02:a315:5445:5300:5926:4a2c:fc61:3ce3])
        by smtp.gmail.com with ESMTPSA id s20sm12436235lfb.51.2019.01.07.07.29.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 07:29:04 -0800 (PST)
From:   =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH] media: s5p-mfc: fix incorrect bus assignment in virtual child device
Date:   Mon, 07 Jan 2019 16:29:02 +0100
Message-ID: <2051667.E519KkqpxJ@acerlaptop>
In-Reply-To: <20190107120414.30622-1-m.szyprowski@samsung.com>
References: <CGME20190107120420eucas1p179b227d5ff0e040540ed9f48573e6e73@eucas1p1.samsung.com> <20190107120414.30622-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dnia poniedzia=C5=82ek, 7 stycznia 2019 13:04:14 CET Marek Szyprowski pisze:
> Virtual MFC codec's child devices must not be assigned to platform bus,
> because they are allocated as raw 'struct device' and don't have the
> corresponding 'platform' part. This fixes NULL pointer access revealed
> recently by commit a66d972465d1 ("devres: Align data[] to
> ARCH_KMALLOC_MINALIGN").
>=20
> Reported-by: Pawe=C5=82 Chmiel <pawel.mikolaj.chmiel@gmail.com>
> Fixes: c79667dd93b0 ("media: s5p-mfc: replace custom reserved memory hand=
ling code with generic one")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/pla=
tform/s5p-mfc/s5p_mfc.c
> index 927a1235408d..ca11f8a7569d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1089,7 +1089,6 @@ static struct device *s5p_mfc_alloc_memdev(struct d=
evice *dev,
>  	device_initialize(child);
>  	dev_set_name(child, "%s:%s", dev_name(dev), name);
>  	child->parent =3D dev;
> -	child->bus =3D dev->bus;
>  	child->coherent_dma_mask =3D dev->coherent_dma_mask;
>  	child->dma_mask =3D dev->dma_mask;
>  	child->release =3D s5p_mfc_memdev_release;
>=20

Checked on Samsung Galaxy S and not it's not crashing anymore. Thanks for p=
atch.
Tested-by: Pawe=C5=82 Chmiel <pawel.mikolaj.chmiel@gmail.com>



