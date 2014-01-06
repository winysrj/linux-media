Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:34632 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294AbaAFXmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 18:42:49 -0500
Received: by mail-oa0-f45.google.com with SMTP id g12so4283191oah.18
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 15:42:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5ABFuYidfFcqXK0ENj190dkU=GrE7X2Ss5WpRJ1B5-edQ@mail.gmail.com>
References: <CABMudhTYJnKx45EPt2T4F73woQO5mkDwpY4y8TjnaJY3SSBAWw@mail.gmail.com>
	<CAOMZO5ABFuYidfFcqXK0ENj190dkU=GrE7X2Ss5WpRJ1B5-edQ@mail.gmail.com>
Date: Mon, 6 Jan 2014 15:42:48 -0800
Message-ID: <CABMudhRhgwL01ey5Av6wxUkNjKNiuFVfcS4tPS0Oj6umALGjxA@mail.gmail.com>
Subject: Re: How to enable "CONFIG_V4L2_MEM2MEM_DEV"
From: m silverstri <michael.j.silverstri@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks.  I try the latest (I clone linux from
https://github.com/torvalds/linux) and do 'make ARCH=arm
CROSS_COMPILE=/usr/bin/arm-linux-gnueabi- imx_v6_v7_defconfig' again,
I see

" CONFIG_V4L2_MEM2MEM_DEV=y" in the generated .config.

But when I try to add 'CONFIG_VIDEO_SAMSUNG_S5P_JPEG=y' to
imx_v6_v7_defconfig and re'make, I don't see
CONFIG_VIDEO_SAMSUNG_S5P_JPEG=y in the generated .config.

I have looked up Kconfig and find out the dependency is:

config VIDEO_SAMSUNG_S5P_JPEG
tristate "Samsung S5P/Exynos4 JPEG codec driver"
depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
select VIDEOBUF2_DMA_CONTIG
select V4L2_MEM2MEM_DEV
---help---
 This is a v4l2 driver for Samsung S5P and EXYNOS4 JPEG codec

I have checked that both VIDEO_DEV && VIDEO_V4L2 are set, except
PLAT_S5P. I am not sure how to set 'PLAT_S5P'.

I appreciate if I can get help on this.

Thank you.


On Mon, Jan 6, 2014 at 1:30 PM, Fabio Estevam <festevam@gmail.com> wrote:
> On Mon, Jan 6, 2014 at 7:22 PM, m silverstri
> <michael.j.silverstri@gmail.com> wrote:
>> I have added 'CONFIG_V4L2_MEM2MEM_DEV=y'  to my 'imx_v6_v7_defconfig'
>> and do a "make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabi-
>> imx_v6_v7_defconfig", I don't see CONFIG_V4L2_MEM2MEM_DEV being set to
>> 'y' in .config that was automatically generated.
>>
>> I think I am making changes to the right 'imx_v6_v7_defconfig' file
>> since when i add
>> 'CONFIG_V4L_TEST_DRIVERS=y' to 'imx_v6_v7_defconfig', I see
>> 'CONFIG_V4L_TEST_DRIVERS=y' in .config when I do "make ARCH=arm
>> CROSS_COMPILE=/usr/bin/arm-linux-gnueabi- imx_v6_v7_defconfig"
>>
>> I am not sure why CONFIG_V4L2_MEM2MEM_DEV is not being set when I put
>> 'CONFIG_V4L2_MEM2MEM_DEV=y'
>
> Can you try the latest 3.13-rc7?
>
> I just tried it here:
>
> make imx_v6_v7_defconfig
>
> Then I inspect the generated .config and CONFIG_V4L2_MEM2MEM_DEV=y
>
> Regards,
>
> Fabio Estevam
