Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC868C282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 11:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B90218D2
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 11:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvuZdKlN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfBILyv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 06:54:51 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33708 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfBILyv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 06:54:51 -0500
Received: by mail-pg1-f194.google.com with SMTP id z11so2772361pgu.0
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2019 03:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AAoCPlYjj+WlN2qxV8iOGhhxlSacyK9WT019zuWZkvY=;
        b=GvuZdKlNULZKFxeYSchcnYooXJDLqGcxhTZ0m1v6kWrF+bNcdhL7SzaZ+HXupkgYBI
         RwbzxmVZgGwcPFqj7OvUEV4d05vLg4i5rfS2tzNQvX8ovmhwMp3kJCUo0zhvDl8iUT8y
         U1SV8j/52lOwJNgjo0pmmITQ2PTejAn+UtLsQ1bMweEXJuCAHCCssTzTXrgLPCf0I5fa
         1BBxY97k8N8vzm5YpyXZIu2Ki+YW9zo2om5LN1Q+HDvWgnLxw43mqNytpjgZeoScMClF
         W86M0SGvXeeCFskV3BF+VODOkf9KX4LPSgXQu+5IXtf86A3vaNTM19slp9MrQMLVhLze
         CIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AAoCPlYjj+WlN2qxV8iOGhhxlSacyK9WT019zuWZkvY=;
        b=s7TvzflC/aR+niA9mDLnSLUEd7tjTcTKrx6t9fQ9q+c1RwZtzO2MDtRAr0r6c1S3sU
         nKH6MSbM37373KZ7DjcR6e+XcuwDE4ErFsm7T5oqbGPpVI84uPDLm26NTH8BqbyQfE2N
         vYOEv4t+B5MiO5oKyrvuWqT6wWZxx9lvrprp03rzZyK41q7wplLjNpz5YC2cZaFbP1Y4
         A6sZCuLIJhloJRsrZGu4txpjnPPFrSMxH35KdPSIoXYhyolRkEgNw6izZSgHYkBWhS3m
         z32Ha8A5lR9cqNM4ET0Dd/LLONrwem6d9vj8eTgWHVkPnpfhQOT89zUiImqaYViW95nr
         2Ecw==
X-Gm-Message-State: AHQUAuaj0Io8RnU7hVW42xAFI6gAlqGsQv6PEHR//WpDJsmeq14d4g0H
        9g6zaKJK0iZZUpWboh0ySqGQqVWKIWjQqixlpgk=
X-Google-Smtp-Source: AHgI3IZSiQwGAKiEw2EAQgfsS+T6w2M7prR9SLtb0MoVJ4zJU6A/P4ijoXAqyfFCnIL1cJMZUCBm0hUM+jFDnglwkZ0=
X-Received: by 2002:a62:3305:: with SMTP id z5mr27653773pfz.112.1549713290701;
 Sat, 09 Feb 2019 03:54:50 -0800 (PST)
MIME-Version: 1.0
References: <1549637565-32096-3-git-send-email-akinobu.mita@gmail.com> <201902090047.fTZ02W0h%fengguang.wu@intel.com>
In-Reply-To: <201902090047.fTZ02W0h%fengguang.wu@intel.com>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Sat, 9 Feb 2019 20:54:39 +0900
Message-ID: <CAC5umyixA-YYOou5OZLSuVDbnSqmckup8=oVWUXw56JVd_nFVg@mail.gmail.com>
Subject: Re: [PATCH 2/4] media: mt9m111: add VIDEO_V4L2_SUBDEV_API dependency
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, linux-media@vger.kernel.org,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B42=E6=9C=889=E6=97=A5(=E5=9C=9F) 1:20 kbuild test robot <lkp@in=
tel.com>:
>
> Hi Akinobu,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on next-20190208]
> [cannot apply to v5.0-rc4]
> [if your patch is applied to the wrong git tree, please drop us a note to=
 help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Akinobu-Mita/media-i2c-t=
weak-Kconfig-dependencies/20190208-233718
> base:   git://linuxtv.org/media_tree.git master
> config: i386-randconfig-x019-201905 (attached as .config)

Ah, SOC_CAMERA_MT9M111 implicitly selects VIDEO_MT9M111 and in this case,
VIDEO_V4L2_SUBDEV_API is not required.

This build error can be fixed by removing SOC_CAMERA_MT9M111 from
drivers/media/i2c/soc_camera/Kconfig.
