Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42679 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbaAFVaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 16:30:55 -0500
Received: by mail-vc0-f178.google.com with SMTP id lh4so9501300vcb.9
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 13:30:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABMudhTYJnKx45EPt2T4F73woQO5mkDwpY4y8TjnaJY3SSBAWw@mail.gmail.com>
References: <CABMudhTYJnKx45EPt2T4F73woQO5mkDwpY4y8TjnaJY3SSBAWw@mail.gmail.com>
Date: Mon, 6 Jan 2014 19:30:54 -0200
Message-ID: <CAOMZO5ABFuYidfFcqXK0ENj190dkU=GrE7X2Ss5WpRJ1B5-edQ@mail.gmail.com>
Subject: Re: How to enable "CONFIG_V4L2_MEM2MEM_DEV"
From: Fabio Estevam <festevam@gmail.com>
To: m silverstri <michael.j.silverstri@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 6, 2014 at 7:22 PM, m silverstri
<michael.j.silverstri@gmail.com> wrote:
> I have added 'CONFIG_V4L2_MEM2MEM_DEV=y'  to my 'imx_v6_v7_defconfig'
> and do a "make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabi-
> imx_v6_v7_defconfig", I don't see CONFIG_V4L2_MEM2MEM_DEV being set to
> 'y' in .config that was automatically generated.
>
> I think I am making changes to the right 'imx_v6_v7_defconfig' file
> since when i add
> 'CONFIG_V4L_TEST_DRIVERS=y' to 'imx_v6_v7_defconfig', I see
> 'CONFIG_V4L_TEST_DRIVERS=y' in .config when I do "make ARCH=arm
> CROSS_COMPILE=/usr/bin/arm-linux-gnueabi- imx_v6_v7_defconfig"
>
> I am not sure why CONFIG_V4L2_MEM2MEM_DEV is not being set when I put
> 'CONFIG_V4L2_MEM2MEM_DEV=y'

Can you try the latest 3.13-rc7?

I just tried it here:

make imx_v6_v7_defconfig

Then I inspect the generated .config and CONFIG_V4L2_MEM2MEM_DEV=y

Regards,

Fabio Estevam
