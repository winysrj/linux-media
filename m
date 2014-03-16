Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4353 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaCPMKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Mar 2014 08:10:32 -0400
Message-ID: <5325949C.7060907@xs4all.nl>
Date: Sun, 16 Mar 2014 13:10:04 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [linuxtv-media:master 471/499] e4000.c:undefined reference to
 `v4l2_ctrl_handler_free'
References: <53244504.diJFy1Wfww202OA7%fengguang.wu@intel.com> <53248108.4040601@iki.fi> <20140315212603.369388f1@samsung.com>
In-Reply-To: <20140315212603.369388f1@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2014 01:26 AM, Mauro Carvalho Chehab wrote:
> Em Sat, 15 Mar 2014 18:34:16 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
> 
>> Mauro,
>> I am not sure how this should be resolved. E4000 has already depends to 
>> VIDEO_V4L2. Should VIDEO_V4L2 selected in config MEDIA_SUBDRV_AUTOSELECT ?
> 
> The problem is likely with the Kconfig at the dvb driver. You should
> remember that select doesn't recursively select the dependencies.
> 
> So, you should either make the v4l2 control framework optional at
> e4000 or to make VB_USB_RTL28XXU to either depend or select
> V4L2 core.
> 
> There's also a third option: add stubs for the v4l2_ctrl_* functions
> at the *.h file. This way, if V4L2 is not compiled, the functions
> won't do anything. Perhaps this is the most elegant solution.
> 
> Hans,
> any comments?

I am hesitant to go in that direction, at least for now. At the moment this is
a one-off (right?), so keep it in e4000 or rtl28xxu. When we get more of these
dependencies, then I'd like to get a better understanding where things are heading
with this.

It's always easier to make such decisions if you have a few more use-cases.

Regards,

	Hans

> 
> Regards,
> Mauro
> 
> 
>>
>> regards
>> Antti
>>
>>
>> On 15.03.2014 14:18, kbuild test robot wrote:
>>> tree:   git://linuxtv.org/media_tree.git master
>>> head:   ed97a6fe5308e5982d118a25f0697b791af5ec50
>>> commit: adaa616ffb697f00db9b4ccb638c5e9e719dbb7f [471/499] [media] e4000: implement controls via v4l2 control framework
>>> config: i386-randconfig-j4-03151459 (attached as .config)
>>>
>>> All error/warnings:
>>>
>>> warning: (DVB_USB_RTL28XXU) selects MEDIA_TUNER_E4000 which has unmet direct dependencies ((MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT) && MEDIA_SUPPORT && I2C && VIDEO_V4L2)
>>>     drivers/built-in.o: In function `e4000_remove':
>>>>> e4000.c:(.text+0x541015): undefined reference to `v4l2_ctrl_handler_free'
>>>     drivers/built-in.o: In function `e4000_probe':
>>>>> e4000.c:(.text+0x54219e): undefined reference to `v4l2_ctrl_handler_init_class'
>>>>> e4000.c:(.text+0x5421ce): undefined reference to `v4l2_ctrl_new_std'
>>>>> e4000.c:(.text+0x542204): undefined reference to `v4l2_ctrl_new_std'
>>>>> e4000.c:(.text+0x542223): undefined reference to `v4l2_ctrl_auto_cluster'
>>>>> e4000.c:(.text+0x542253): undefined reference to `v4l2_ctrl_new_std'
>>>>> e4000.c:(.text+0x542289): undefined reference to `v4l2_ctrl_new_std'
>>>>> e4000.c:(.text+0x5422a8): undefined reference to `v4l2_ctrl_auto_cluster'
>>>>> e4000.c:(.text+0x5422d8): undefined reference to `v4l2_ctrl_new_std'
>>>>> e4000.c:(.text+0x54230e): undefined reference to `v4l2_ctrl_new_std'
>>>>> e4000.c:(.text+0x54232d): undefined reference to `v4l2_ctrl_auto_cluster'
>>>>> e4000.c:(.text+0x54235d): undefined reference to `v4l2_ctrl_new_std'
>>>>> e4000.c:(.text+0x542393): undefined reference to `v4l2_ctrl_new_std'
>>>>> e4000.c:(.text+0x5423b2): undefined reference to `v4l2_ctrl_auto_cluster'
>>>>> e4000.c:(.text+0x5423d8): undefined reference to `v4l2_ctrl_handler_free'
>>>
>>> ---
>>> 0-DAY kernel build testing backend              Open Source Technology Center
>>> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
>>>
>>
>>
> 
> 

