Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:54003 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaAFXzX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 18:55:23 -0500
Received: by mail-ve0-f175.google.com with SMTP id jx11so9531855veb.20
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 15:55:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABMudhRhgwL01ey5Av6wxUkNjKNiuFVfcS4tPS0Oj6umALGjxA@mail.gmail.com>
References: <CABMudhTYJnKx45EPt2T4F73woQO5mkDwpY4y8TjnaJY3SSBAWw@mail.gmail.com>
	<CAOMZO5ABFuYidfFcqXK0ENj190dkU=GrE7X2Ss5WpRJ1B5-edQ@mail.gmail.com>
	<CABMudhRhgwL01ey5Av6wxUkNjKNiuFVfcS4tPS0Oj6umALGjxA@mail.gmail.com>
Date: Mon, 6 Jan 2014 21:55:22 -0200
Message-ID: <CAOMZO5C=fS=z_2k7acKtXDZ8e2_e=bQxK8pmczJpj0ZEwMn5TA@mail.gmail.com>
Subject: Re: How to enable "CONFIG_V4L2_MEM2MEM_DEV"
From: Fabio Estevam <festevam@gmail.com>
To: m silverstri <michael.j.silverstri@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 6, 2014 at 9:42 PM, m silverstri
<michael.j.silverstri@gmail.com> wrote:
> Thanks.  I try the latest (I clone linux from
> https://github.com/torvalds/linux) and do 'make ARCH=arm
> CROSS_COMPILE=/usr/bin/arm-linux-gnueabi- imx_v6_v7_defconfig' again,
> I see
>
> " CONFIG_V4L2_MEM2MEM_DEV=y" in the generated .config.
>
> But when I try to add 'CONFIG_VIDEO_SAMSUNG_S5P_JPEG=y' to
> imx_v6_v7_defconfig and re'make, I don't see
> CONFIG_VIDEO_SAMSUNG_S5P_JPEG=y in the generated .config.

CONFIG_VIDEO_SAMSUNG_S5P_JPEG is to be used with Samsung SoC, not with
Freescale i.mx family.

Regards,

Fabio Estevam
