Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75A2C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 13:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9191520844
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 13:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PqPb5PtP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfBENkI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 08:40:08 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38578 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbfBENkI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 08:40:08 -0500
Received: by mail-pl1-f194.google.com with SMTP id e5so1503589plb.5;
        Tue, 05 Feb 2019 05:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9tOa516GafoOkBpVFLzvXJxv4VQq7VRilgzb6o0Aoy8=;
        b=PqPb5PtPrp9t97QB5R77Rh0Wd+CYiOPjsYjp7KovTfKjBdtqozJX71RJtdyXCsblbp
         TrzPQywQeD3Oqrc3KAKPAIpYrhS3wJtvRIWW0N93VXOTBPO1u+7c492u/3qKe0Lhe3VB
         l/3vEdBSZeb2alK6x0PVG/K8wGdbCfAAquQVFNd/TDpY92TMqPYD2Gv8XSY3oB3wR7lY
         qURMnY1Lm50zfxBVJN6ckz4agooX93SSfs4v9EIQhpyjxYZTqr8SYMX3U5mETKnTHQqm
         cTVFaPL5YybAZPiRgSfkSdDgcynBPmScSaO0TRg/f1rlflv4jJo4U4kjdGhkDtMaBbP0
         6ChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9tOa516GafoOkBpVFLzvXJxv4VQq7VRilgzb6o0Aoy8=;
        b=cw3rIvf4pxzz1Nh945fUT9ggQRneTXI031oBAm24qtc9oyT9ujFQcBQ5GUHCNUEl65
         i1Kp4pqxMVm7tVWsd4VBzLDPCvF8fRi3rSaONQnpBPcVjZNiiaXDnkr3aMYZSrr6aBMG
         DwgpXNWruF69OTZ7m4WROoBNx9NhIcJoZUjwnZnPlOAu5Pu4ww00GVdUhAKOrsam06IS
         /oY6ia4rMoGCaA2WQWbYCF9p5JUPAb058abqaszhksswz2iTHFidNJBNe86LELHtw/nt
         RBGWjyBaDcA/kPc2cT/T2jLJl9eaEnrzuM9c8Ids/gDdfYm8osGUxQG/TydAPZTqFtmi
         rEnw==
X-Gm-Message-State: AHQUAua8I3K1pbm414n7fznVF57jc6H4kioqyuSyEgNpED25MLGCSEeM
        FhVqSXRgDHw55eR4wNCXD1JtLlkgTr7sOzit1z0=
X-Google-Smtp-Source: AHgI3IYIxd/CWp8eEFyD1OpvGqkReh12UGCNJ2+ds7aKITMxG+tZzIbmPIllUt1kX1NqUpzKGHFp0OEa/kYAfsyLTzA=
X-Received: by 2002:a17:902:887:: with SMTP id 7mr5166828pll.164.1549374007663;
 Tue, 05 Feb 2019 05:40:07 -0800 (PST)
MIME-Version: 1.0
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com> <20190204090521.5ngcycuvccvfrpqb@valkosipuli.retiisi.org.uk>
In-Reply-To: <20190204090521.5ngcycuvccvfrpqb@valkosipuli.retiisi.org.uk>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Tue, 5 Feb 2019 22:39:56 +0900
Message-ID: <CAC5umyhhfxFiPnS6Kj-m-VgcEt8p6BOSBF=T_TdozNHCCkbPSw@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] media: mt9m001: switch soc_mt9m001 to a standard
 subdev sensor driver
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marco Felsch <m.felsch@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B42=E6=9C=884=E6=97=A5(=E6=9C=88) 18:06 Sakari Ailus <sakari.ail=
us@iki.fi>:
>
> Hi Mita-san,
>
> On Tue, Jan 08, 2019 at 11:51:37PM +0900, Akinobu Mita wrote:
> > This patchset converts soc_camera mt9m001 driver to a standard subdev
> > sensor driver.
> >
> > * v2
> > - Update binding doc suggested by Rob Herring.
> > - Fix MODULE_LICENSE() masmatch.
> > - Sort headers alphabetically.
> > - Add new label for error handling in s_stream() callback.
> > - Replace pm_runtime_get_noresume() + pm_runtime_put_sync() with a
> >   single pm_runtime_idle() call in probe() function.
> > - Change the argument of mt9m001_power_o{n,ff} to struct device, and
> >   use them for runtime PM callbacks directly.
> > - Remove redundant Kconfig dependency
> > - Preserve subdev flags set by v4l2_i2c_subdev_init().
> > - Set initial try format with default configuration instead of
> >   current one.
>
> While this set improved the original mt9m001 driver a lot, it did not add=
 a
> MAINTAINERS entry for it. The same applies to the mt9m111 driver.
>
> Could you provide the MAINTAINERS entries for the two drivers, please?

As long as I have those two sensors, I can review and test the patches.
So I would like to add the following MAINTAINERS entries.

MT9M001 CAMERA SENSOR
M:      Sakari Ailus <sakari.ailus@linux.intel.com>
R:      Akinobu Mita <akinobu.mita@gmail.com>
L:      linux-media@vger.kernel.org
T:      git git://linuxtv.org/media_tree.git
S:      Maintained
F:      Documentation/devicetree/bindings/media/i2c/mt9m001.txt
F:      drivers/media/i2c/mt9m001.c

MT9M111 CAMERA SENSOR
M:      Sakari Ailus <sakari.ailus@linux.intel.com>
R:      Akinobu Mita <akinobu.mita@gmail.com>
L:      linux-media@vger.kernel.org
T:      git git://linuxtv.org/media_tree.git
S:      Maintained
F:      Documentation/devicetree/bindings/media/i2c/mt9m111.txt
F:      drivers/media/i2c/mt9m111.c
