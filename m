Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:24506 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbaCPA0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 20:26:09 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2I00FYR6JKIR20@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 15 Mar 2014 20:26:08 -0400 (EDT)
Date: Sat, 15 Mar 2014 21:26:03 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [linuxtv-media:master 471/499] e4000.c:undefined reference to
 `v4l2_ctrl_handler_free'
Message-id: <20140315212603.369388f1@samsung.com>
In-reply-to: <53248108.4040601@iki.fi>
References: <53244504.diJFy1Wfww202OA7%fengguang.wu@intel.com>
 <53248108.4040601@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Mar 2014 18:34:16 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Mauro,
> I am not sure how this should be resolved. E4000 has already depends to 
> VIDEO_V4L2. Should VIDEO_V4L2 selected in config MEDIA_SUBDRV_AUTOSELECT ?

The problem is likely with the Kconfig at the dvb driver. You should
remember that select doesn't recursively select the dependencies.

So, you should either make the v4l2 control framework optional at
e4000 or to make VB_USB_RTL28XXU to either depend or select
V4L2 core.

There's also a third option: add stubs for the v4l2_ctrl_* functions
at the *.h file. This way, if V4L2 is not compiled, the functions
won't do anything. Perhaps this is the most elegant solution.

Hans,
any comments?

Regards,
Mauro


> 
> regards
> Antti
> 
> 
> On 15.03.2014 14:18, kbuild test robot wrote:
> > tree:   git://linuxtv.org/media_tree.git master
> > head:   ed97a6fe5308e5982d118a25f0697b791af5ec50
> > commit: adaa616ffb697f00db9b4ccb638c5e9e719dbb7f [471/499] [media] e4000: implement controls via v4l2 control framework
> > config: i386-randconfig-j4-03151459 (attached as .config)
> >
> > All error/warnings:
> >
> > warning: (DVB_USB_RTL28XXU) selects MEDIA_TUNER_E4000 which has unmet direct dependencies ((MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT) && MEDIA_SUPPORT && I2C && VIDEO_V4L2)
> >     drivers/built-in.o: In function `e4000_remove':
> >>> e4000.c:(.text+0x541015): undefined reference to `v4l2_ctrl_handler_free'
> >     drivers/built-in.o: In function `e4000_probe':
> >>> e4000.c:(.text+0x54219e): undefined reference to `v4l2_ctrl_handler_init_class'
> >>> e4000.c:(.text+0x5421ce): undefined reference to `v4l2_ctrl_new_std'
> >>> e4000.c:(.text+0x542204): undefined reference to `v4l2_ctrl_new_std'
> >>> e4000.c:(.text+0x542223): undefined reference to `v4l2_ctrl_auto_cluster'
> >>> e4000.c:(.text+0x542253): undefined reference to `v4l2_ctrl_new_std'
> >>> e4000.c:(.text+0x542289): undefined reference to `v4l2_ctrl_new_std'
> >>> e4000.c:(.text+0x5422a8): undefined reference to `v4l2_ctrl_auto_cluster'
> >>> e4000.c:(.text+0x5422d8): undefined reference to `v4l2_ctrl_new_std'
> >>> e4000.c:(.text+0x54230e): undefined reference to `v4l2_ctrl_new_std'
> >>> e4000.c:(.text+0x54232d): undefined reference to `v4l2_ctrl_auto_cluster'
> >>> e4000.c:(.text+0x54235d): undefined reference to `v4l2_ctrl_new_std'
> >>> e4000.c:(.text+0x542393): undefined reference to `v4l2_ctrl_new_std'
> >>> e4000.c:(.text+0x5423b2): undefined reference to `v4l2_ctrl_auto_cluster'
> >>> e4000.c:(.text+0x5423d8): undefined reference to `v4l2_ctrl_handler_free'
> >
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> >
> 
> 


-- 

Regards,
Mauro
