Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9BCC37123
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 21:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE2820861
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 21:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="x+GM4W58"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfAUVBl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 16:01:41 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:55288 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfAUVBl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 16:01:41 -0500
Received: by mail-wm1-f42.google.com with SMTP id a62so12147653wmh.4
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 13:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=IuWA2h0mlDCsFxTY1/ztSRPKIhqwKU3D/mBBI3HU4y8=;
        b=x+GM4W58C1FEUCnqX2YtKddO8JFpkLvyeE+EzpH/eiNyBHU5TkiBvR9qERVlnjMDV9
         KuoJE1FNzOd1V4FSzzcAVspmlNdIasgFcapvp8icnv3dOeUlC7jODTJVNfZdxFui2UY2
         BJ0B1ZDK3J6TgR9QQ6qfSYAozWGv9FYbnPIUsojDAUND0gSvFEqU/7YipR2netWj8NtX
         hnggbJAPscBn5G2KE0nroWc+gvflfipwiBV66X2KmtRmQ0DXqaQmIHRzr7ef5PCM8Gi2
         18eIlNeOqnfCOx4uRnTliEoglwarNUZwDSX1vjUuFdS9vGS76CieroyD1lhLx1Em+YtR
         rrqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IuWA2h0mlDCsFxTY1/ztSRPKIhqwKU3D/mBBI3HU4y8=;
        b=NXIal6CUb/5laW4PjRre0I7zkao0MXVkonMGreNRMCVbTl7+ObGOhfKOPkw7iRPaWk
         Ct6Pp9z+A9+5YYJ2Y1LGifYLp2D5RWpEuH36WqmfKQ5XQ5OUniAH0PSBpsnjVtYmCwMw
         sU4NM7BC00u5uqRno69omjtXpjmVdZyypVdYIIXVSOWpC7weMnPFY7zegZ9BP0hqHEai
         xnxGrGBonej4yyTD+9uWa6jzt/Cy1y8at1VRr3u8AF8u0fH75/Xqh0xtIJoTzmi2VVcC
         FlFqOWNlFkSy6nY1LckzP7g+fYAb0DokKx3UXa34o9SWW3G2wXUpxwETAD+E4/ehn7Wd
         Qwog==
X-Gm-Message-State: AJcUukfcpA5RuKKR0YGs6zK5Ak4YANuHen+d6IUabNZG/S2yYjxMHLyY
        znvEnPYSV0YrXamtHEBMmPOqCuqdVoWp8EHDqzXiMZUw
X-Google-Smtp-Source: ALg8bN5rDgo0SCR/PnZ9fkyATvuSxhez9rr1t6co7tqx8ikOs4EZlhvlcCKNTjYHA9KL69jWipLyEkUZPN6n8nHrA7k=
X-Received: by 2002:a1c:8b09:: with SMTP id n9mr912447wmd.38.1548104498724;
 Mon, 21 Jan 2019 13:01:38 -0800 (PST)
MIME-Version: 1.0
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 21 Jan 2019 13:01:27 -0800
Message-ID: <CAJ+vNU0mMRA1jQmROMBB4v9WTnBbanB123nfY0XTY2LFAEMGxg@mail.gmail.com>
Subject: CODA9 (IMX) JPEG support
To:     linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Philipp,

Is there any support for coda9 (imx) JPEG enc/dec support being worked
on in the coda driver? I noticed there is support for coda7 but not
yet coda9.

Best regards,

Tim
