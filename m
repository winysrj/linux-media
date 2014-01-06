Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:56611 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbaAFVW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 16:22:26 -0500
Received: by mail-ob0-f169.google.com with SMTP id wm4so19106616obc.28
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 13:22:26 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 6 Jan 2014 13:22:25 -0800
Message-ID: <CABMudhTYJnKx45EPt2T4F73woQO5mkDwpY4y8TjnaJY3SSBAWw@mail.gmail.com>
Subject: How to enable "CONFIG_V4L2_MEM2MEM_DEV"
From: m silverstri <michael.j.silverstri@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have added 'CONFIG_V4L2_MEM2MEM_DEV=y'  to my 'imx_v6_v7_defconfig'
and do a "make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabi-
imx_v6_v7_defconfig", I don't see CONFIG_V4L2_MEM2MEM_DEV being set to
'y' in .config that was automatically generated.

I think I am making changes to the right 'imx_v6_v7_defconfig' file
since when i add
'CONFIG_V4L_TEST_DRIVERS=y' to 'imx_v6_v7_defconfig', I see
'CONFIG_V4L_TEST_DRIVERS=y' in .config when I do "make ARCH=arm
CROSS_COMPILE=/usr/bin/arm-linux-gnueabi- imx_v6_v7_defconfig"

I am not sure why CONFIG_V4L2_MEM2MEM_DEV is not being set when I put
'CONFIG_V4L2_MEM2MEM_DEV=y'

And from the  Kconfig, V4L2_MEM2MEM_DEV only depends on VIDEOBUF2_CORE
# Used by drivers that need v4l2-mem2mem.ko
config V4L2_MEM2MEM_DEV
        tristate
        depends on VIDEOBUF2_CORE

and I have CONFIG_VIDEOBUF2_CORE=y


Thank you.
