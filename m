Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46601 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbaCOQeT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 12:34:19 -0400
Message-ID: <53248108.4040601@iki.fi>
Date: Sat, 15 Mar 2014 18:34:16 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [linuxtv-media:master 471/499] e4000.c:undefined reference to
 `v4l2_ctrl_handler_free'
References: <53244504.diJFy1Wfww202OA7%fengguang.wu@intel.com>
In-Reply-To: <53244504.diJFy1Wfww202OA7%fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
I am not sure how this should be resolved. E4000 has already depends to 
VIDEO_V4L2. Should VIDEO_V4L2 selected in config MEDIA_SUBDRV_AUTOSELECT ?

regards
Antti


On 15.03.2014 14:18, kbuild test robot wrote:
> tree:   git://linuxtv.org/media_tree.git master
> head:   ed97a6fe5308e5982d118a25f0697b791af5ec50
> commit: adaa616ffb697f00db9b4ccb638c5e9e719dbb7f [471/499] [media] e4000: implement controls via v4l2 control framework
> config: i386-randconfig-j4-03151459 (attached as .config)
>
> All error/warnings:
>
> warning: (DVB_USB_RTL28XXU) selects MEDIA_TUNER_E4000 which has unmet direct dependencies ((MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT) && MEDIA_SUPPORT && I2C && VIDEO_V4L2)
>     drivers/built-in.o: In function `e4000_remove':
>>> e4000.c:(.text+0x541015): undefined reference to `v4l2_ctrl_handler_free'
>     drivers/built-in.o: In function `e4000_probe':
>>> e4000.c:(.text+0x54219e): undefined reference to `v4l2_ctrl_handler_init_class'
>>> e4000.c:(.text+0x5421ce): undefined reference to `v4l2_ctrl_new_std'
>>> e4000.c:(.text+0x542204): undefined reference to `v4l2_ctrl_new_std'
>>> e4000.c:(.text+0x542223): undefined reference to `v4l2_ctrl_auto_cluster'
>>> e4000.c:(.text+0x542253): undefined reference to `v4l2_ctrl_new_std'
>>> e4000.c:(.text+0x542289): undefined reference to `v4l2_ctrl_new_std'
>>> e4000.c:(.text+0x5422a8): undefined reference to `v4l2_ctrl_auto_cluster'
>>> e4000.c:(.text+0x5422d8): undefined reference to `v4l2_ctrl_new_std'
>>> e4000.c:(.text+0x54230e): undefined reference to `v4l2_ctrl_new_std'
>>> e4000.c:(.text+0x54232d): undefined reference to `v4l2_ctrl_auto_cluster'
>>> e4000.c:(.text+0x54235d): undefined reference to `v4l2_ctrl_new_std'
>>> e4000.c:(.text+0x542393): undefined reference to `v4l2_ctrl_new_std'
>>> e4000.c:(.text+0x5423b2): undefined reference to `v4l2_ctrl_auto_cluster'
>>> e4000.c:(.text+0x5423d8): undefined reference to `v4l2_ctrl_handler_free'
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
>


-- 
http://palosaari.fi/
