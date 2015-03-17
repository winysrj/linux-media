Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35410 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbCQBxl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 21:53:41 -0400
Received: by wgdm6 with SMTP id m6so53888576wgd.2
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2015 18:53:40 -0700 (PDT)
Date: Tue, 17 Mar 2015 09:53:40 +0800
From: "=?utf-8?B?TmliYmxlIE1heA==?=" <nibble.max@gmail.com>
To: "=?utf-8?B?T2xlIEVybnN0?=" <olebowle@gmx.com>
Cc: "=?utf-8?B?b2xsaS5zYWxvbmVu?=" <olli.salonen@iki.fi>,
	"=?utf-8?B?QW50dGkgUGFsb3NhYXJp?=" <crope@iki.fi>,
	"=?utf-8?B?bGludXgtbWVkaWE=?=" <linux-media@vger.kernel.org>
References: <5504920C.7080806@gmx.com>,
 <55055E66.6040600@gmx.com>,
 <550563B2.9010306@iki.fi>
Subject: =?utf-8?B?UmU6IFJlOiBjeDIzODg1OiBEVkJTa3kgUzk1MiBkdmJfcmVnaXN0ZXIgZmFpbGVkIGVyciA9IC0yMg==?=
Message-ID: <201503170953368436904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

what is the "chip_id" debug output from m88ts2022 module?

I think you maybe hold the old S952 card.
Its satellite tuner is M88TS2020, not M88TS2022.

Best Regards,
Max
On 2015-03-15 19:07:07, Ole Ernst <olebowle@gmx.com> wrote:
>Hi Antti,
>
>thanks for your quick response! Based on lsmod and modinfo I do have
>m88ts2022.
>
>$ lsmod | grep m88
>m88ts2022              16898  0
>regmap_i2c             12783  1 m88ts2022
>m88ds3103              21452  0
>i2c_mux                12534  1 m88ds3103
>dvb_core              102038  4 cx23885,altera_ci,m88ds3103,videobuf2_dvb
>i2c_core               50240  13
>drm,i2c_i801,cx23885,cx25840,m88ts2022,i2c_mux,regmap_i2c,nvidia,v4l2_common,tveeprom,m88ds3103,tda18271,videodev
>
>$ modinfo m88ts2022
>filename:
>/lib/modules/3.19.1-1-ARCH/kernel/drivers/media/tuners/m88ts2022.ko.gz
>license:        GPL
>author:         Antti Palosaari <crope@iki.fi>
>description:    Montage M88TS2022 silicon tuner driver
>alias:          i2c:m88ts2022
>depends:        i2c-core,regmap-i2c
>intree:         Y
>vermagic:       3.19.1-1-ARCH SMP preempt mod_unload modversions
>
>Thanks,
>Ole
>
>Am 15.03.2015 um 11:49 schrieb Antti Palosaari:
>> You don't have m88ts2022 driver installed.
>> 
>> Antti
>> 
>> On 03/15/2015 12:26 PM, Ole Ernst wrote:
>>> Hi,
>>>
>>> I added some printk in cx23885-dvb.c and the problem is in
>>> i2c_new_device:
>>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/media/pci/cx23885/cx23885-dvb.c?id=refs/tags/v3.19.1#n1935
>>>
>>>
>>> The returned client_tuner is not NULL, but client_tuner->dev.driver is.
>>> Hence it will goto frontend_detach, which will then return -EINVAL. Any
>>> idea why client_tuner->dev.driver is NULL?
>>>
>>> Thanks,
>>> Ole
>>>
>>> Am 14.03.2015 um 20:54 schrieb Ole Ernst:
>>>> Hi,
>>>>
>>>> using linux-3.19.1-1 (Archlinux) I get the following output while
>>>> booting without the media-build-tree provided by DVBSky:
>>>>
>>>> cx23885 driver version 0.0.4 loaded
>>>> cx23885 0000:04:00.0: enabling device (0000 -> 0002)
>>>> CORE cx23885[0]: subsystem: 4254:0952, board: DVBSky S952
>>>> [card=50,autodetected]
>>>> cx25840 3-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
>>>> cx25840 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
>>>> cx23885_dvb_register() allocating 1 frontend(s)
>>>> cx23885[0]: cx23885 based dvb card
>>>> i2c i2c-2: m88ds3103_attach: chip_id=70
>>>> i2c i2c-2: Added multiplexed i2c bus 4
>>>> cx23885_dvb_register() dvb_register failed err = -22
>>>> cx23885_dev_setup() Failed to register dvb adapters on VID_B
>>>> cx23885_dvb_register() allocating 1 frontend(s)
>>>> cx23885[0]: cx23885 based dvb card
>>>> i2c i2c-1: m88ds3103_attach: chip_id=70
>>>> i2c i2c-1: Added multiplexed i2c bus 4
>>>> cx23885_dvb_register() dvb_register failed err = -22
>>>> cx23885_dev_setup() Failed to register dvb on VID_C
>>>> cx23885_dev_checkrevision() Hardware revision = 0xa5
>>>> cx23885[0]/0: found at 0000:04:00.0, rev: 4, irq: 17, latency: 0, mmio:
>>>> 0xf7200000
>>>>
>>>> Obviously there are no device in /dev/dvb. Using the media-build-tree
>>>> works just fine though. The following firmware files are installed in
>>>> /usr/lib/firmware:
>>>> dvb-demod-m88ds3103.fw
>>>> dvb-demod-m88rs6000.fw
>>>> dvb-demod-si2168-a20-01.fw
>>>> dvb-demod-si2168-a30-01.fw
>>>> dvb-demod-si2168-b40-01.fw
>>>> dvb-fe-ds300x.fw
>>>> dvb-fe-ds3103.fw
>>>> dvb-fe-rs6000.fw
>>>> dvb-tuner-si2158-a20-01.fw
>>>>
>>>> Output of lspci -vvvnn:
>>>> https://gist.githubusercontent.com/olebowle/6a4108363a9d1f7dd033/raw/lscpi
>>>>
>>>>
>>>> I also set the module parameters debug, i2c_debug, irq_debug and
>>>> irq_debug in cx23885.
>>>> The output is pretty verbose and can be found here:
>>>> https://gist.githubusercontent.com/olebowle/6a4108363a9d1f7dd033/raw/debug.log
>>>>
>>>>
>>>> Thanks,
>>>> Ole
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>> 

