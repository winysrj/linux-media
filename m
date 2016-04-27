Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52207 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbcD0TFh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 15:05:37 -0400
Date: Wed, 27 Apr 2016 21:05:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?=
	<ivo.g.dimitrov.75@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>, sakari.ailus@iki.fi,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160427190528.GA32434@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <572048AC.7050700@gmail.com>
 <572062EF.7060502@gmail.com>
 <20160427164256.GA8156@earth>
 <1461777170.18568.2.camel@Nokia-N900>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461777170.18568.2.camel@Nokia-N900>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > On Wed, Apr 27, 2016 at 09:57:51AM +0300, Ivaylo Dimitrov wrote:
> > > > > https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/log/?h=n900-camera-ivo
> > > > 
> > > > Ok, going to diff with my tree to see what I have missed to send in
> > > > the patchset
> > > 
> > > Now, that's getting weird.
> > 
> > [...]
> > The zImage + initrd works with the steps you described below. I
> 
> Great!
> 
> > received a completly black image, but at least there are interrupts
> > and yavta is happy (=> it does not hang).
> >
> 
> The black image is because by default exposure and gain are set to 0 :). 
> Use yavta to set the appropriate controls. You can
> also enable test patterns from there.

Uff.. .there's a lot of controls to play with ;-).

So I did this...

while true; do ./yavta --capture=1 --skip 0 --format UYVY --size
656x488 /dev/video6 --file=/tmp/delme# && cat /tmp/delme000001 >
/dev/fb0; done

...and kernel certainly did not like that. After a while:

[ 3468.118774] ---[ end trace 70aa4a6442fc6916 ]---
[ 3468.137084] Address Hole seen by CAM  at address 0
[ 3468.137084] ------------[ cut here ]------------
[ 3468.137084] WARNING: CPU: 0 PID: 4974 at
drivers/bus/omap_l3_smx.c:166 omap3_l3_app_irq+0xdc/0x124
[ 3468.137207] Modules linked in: smiapp smiapp_pll ipv6
isp1704_charger omap3_isp videobuf2_v4l2 videobuf2_dma_contig
videobuf2_memops videobuf2_core et8ek8 smiaregs lis3lv02d_i2c
lis3lv02d input_polldev ti_soc_thermal arc4 wl1251_spi wl1251 crc7
mac80211 cfg80211 omap_ssi hsi bq2415x_charger si4713
bq27xxx_battery_i2c bq27xxx_battery leds_lp5523 leds_lp55xx_common
adp1653 v4l2_common tsl2563 smc91x mii rtc_twl twl4030_vibra
ff_memless twl4030_wdt tsc2005 tsc200x_core omap_sham omap_wdt
gpio_keys rx51_battery video_bus_switch videodev media
[ 3468.137207] CPU: 0 PID: 4974 Comm: init Tainted: G        W
4.6.0-rc4+ #1
[ 3468.137207] Hardware name: Nokia RX-51 board
[ 3468.137237] [<c010bc18>] (unwind_backtrace) from [<c0109f38>]
(show_stack+0x10/0x14)
[ 3468.137237] [<c0109f38>] (show_stack) from [<c01262dc>]
(__warn+0xcc/0xf8)
[ 3468.137268] [<c01262dc>] (__warn) from [<c0126324>]
(warn_slowpath_null+0x1c/0x20)
[ 3468.137298] [<c0126324>] (warn_slowpath_null) from [<c0331c6c>]
(omap3_l3_app_irq+0xdc/0x124)
[ 3468.137298] [<c0331c6c>] (omap3_l3_app_irq) from [<c01545bc>]
(handle_irq_event_percpu+0x34/0x138)
[ 3468.137329] [<c01545bc>] (handle_irq_event_percpu) from
[<c015471c>] (handle_irq_event+0x5c/0x88)
[ 3468.137329] [<c015471c>] (handle_irq_event) from [<c015768c>]
(handle_level_irq+0xcc/0x130)
[ 3468.137359] [<c015768c>] (handle_level_irq) from [<c0153f9c>]
(generic_handle_irq+0x18/0x28)
[ 3468.137359] [<c0153f9c>] (generic_handle_irq) from [<c01540bc>]
(__handle_domain_irq+0x84/0xa8)
[ 3468.137390] [<c01540bc>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.137390] [<c054da14>] (__irq_svc) from [<c0129044>]
(__do_softirq+0x5c/0x208)
[ 3468.137420] [<c0129044>] (__do_softirq) from [<c0129448>]
(irq_exit+0x80/0xe4)
[ 3468.137451] [<c0129448>] (irq_exit) from [<c01540c0>]
(__handle_domain_irq+0x88/0xa8)
[ 3468.137451] [<c01540c0>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.137481] [<c054da14>] (__irq_svc) from [<c0152d50>]
(console_unlock+0x3f4/0x4fc)
[ 3468.137481] [<c0152d50>] (console_unlock) from [<c038e2d4>]
(do_con_write.part.10+0x1d80/0x1dac)
[ 3468.137512] [<c038e2d4>] (do_con_write.part.10) from [<c038e374>]
(con_write+0x30/0x48)
[ 3468.137512] [<c038e374>] (con_write) from [<c037a014>]
(do_output_char+0x9c/0x1e4)
[ 3468.137542] [<c037a014>] (do_output_char) from [<c037b1d4>]
(n_tty_write+0x2ac/0x430)
[ 3468.137573] [<c037b1d4>] (n_tty_write) from [<c03775ec>]
(tty_write+0x1b0/0x240)
[ 3468.137573] [<c03775ec>] (tty_write) from [<c01db128>]
(__vfs_write+0x2c/0xd4)
[ 3468.137603] [<c01db128>] (__vfs_write) from [<c01dc710>]
(vfs_write+0xa0/0x18c)
[ 3468.137603] [<c01dc710>] (vfs_write) from [<c01dc9f4>]
(SyS_write+0x3c/0x78)
[ 3468.137603] [<c01dc9f4>] (SyS_write) from [<c0107160>]
(ret_fast_syscall+0x0/0x3c)
[ 3468.137634] ---[ end trace 70aa4a6442fc6917 ]---
[ 3468.144317] omap3isp 480bc000.isp: CCP2 err:8010817
[ 3468.144317] Address Hole seen by CAM  at address b00
[ 3468.144317] ------------[ cut here ]------------
[ 3468.144348] WARNING: CPU: 0 PID: 4973 at
drivers/bus/omap_l3_smx.c:166 omap3_l3_app_irq+0xdc/0x124
[ 3468.144439] Modules linked in: smiapp smiapp_pll ipv6
isp1704_charger omap3_isp videobuf2_v4l2 videobuf2_dma_contig
videobuf2_memops videobuf2_core et8ek8 smiaregs lis3lv02d_i2c
lis3lv02d input_polldev ti_soc_thermal arc4 wl1251_spi wl1251 crc7
mac80211 cfg80211 omap_ssi hsi bq2415x_charger si4713
bq27xxx_battery_i2c bq27xxx_battery leds_lp5523 leds_lp55xx_common
adp1653 v4l2_common tsl2563 smc91x mii rtc_twl twl4030_vibra
ff_memless twl4030_wdt tsc2005 tsc200x_core omap_sham omap_wdt
gpio_keys rx51_battery video_bus_switch videodev media
[ 3468.144439] CPU: 0 PID: 4973 Comm: yavta Tainted: G        W
4.6.0-rc4+ #1
[ 3468.144470] Hardware name: Nokia RX-51 board
[ 3468.144470] [<c010bc18>] (unwind_backtrace) from [<c0109f38>]
(show_stack+0x10/0x14)
[ 3468.144500] [<c0109f38>] (show_stack) from [<c01262dc>]
(__warn+0xcc/0xf8)
[ 3468.144500] [<c01262dc>] (__warn) from [<c0126324>]
(warn_slowpath_null+0x1c/0x20)
[ 3468.144531] [<c0126324>] (warn_slowpath_null) from [<c0331c6c>]
(omap3_l3_app_irq+0xdc/0x124)
[ 3468.144561] [<c0331c6c>] (omap3_l3_app_irq) from [<c01545bc>]
(handle_irq_event_percpu+0x34/0x138)
[ 3468.144561] [<c01545bc>] (handle_irq_event_percpu) from
[<c015471c>] (handle_irq_event+0x5c/0x88)
[ 3468.144592] [<c015471c>] (handle_irq_event) from [<c015768c>]
(handle_level_irq+0xcc/0x130)
[ 3468.144592] [<c015768c>] (handle_level_irq) from [<c0153f9c>]
(generic_handle_irq+0x18/0x28)
[ 3468.144622] [<c0153f9c>] (generic_handle_irq) from [<c01540bc>]
(__handle_domain_irq+0x84/0xa8)
[ 3468.144622] [<c01540bc>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.144714] [<c054da14>] (__irq_svc) from [<bf20e9dc>]
(omap3isp_ccdc_busy+0xc/0x14 [omap3_isp])
[ 3468.144866] [<bf20e9dc>] (omap3isp_ccdc_busy [omap3_isp]) from
[<bf205a9c>] (isp_pipeline_wait_ccdc+0x54/0x60 [omap3_isp])
[ 3468.144989] [<bf205a9c>] (isp_pipeline_wait_ccdc [omap3_isp]) from
[<bf205058>] (isp_pipeline_wait+0x28/0x4c [omap3_isp])
[ 3468.145111] [<bf205058>] (isp_pipeline_wait [omap3_isp]) from
[<bf2056d8>] (isp_pipeline_disable+0x154/0x224 [omap3_isp])
[ 3468.145233] [<bf2056d8>] (isp_pipeline_disable [omap3_isp]) from
[<bf2065a0>] (omap3isp_pipeline_set_stream+0x14/0x2c [omap3_isp])
[ 3468.145355] [<bf2065a0>] (omap3isp_pipeline_set_stream [omap3_isp])
from [<bf2092d0>] (isp_video_streamoff+0xcc/0x124 [omap3_isp])
[ 3468.145477] [<bf2092d0>] (isp_video_streamoff [omap3_isp]) from
[<bf209354>] (isp_video_release+0x2c/0x78 [omap3_isp])
[ 3468.145690] [<bf209354>] (isp_video_release [omap3_isp]) from
[<bf00d300>] (v4l2_release+0x30/0x6c [videodev])
[ 3468.145812] [<bf00d300>] (v4l2_release [videodev]) from
[<c01dd35c>] (__fput+0xd4/0x1f0)
[ 3468.145843] [<c01dd35c>] (__fput) from [<c013e030>]
(task_work_run+0x74/0x88)
[ 3468.145843] [<c013e030>] (task_work_run) from [<c01283c8>]
(do_exit+0x3e8/0x920)
[ 3468.145874] [<c01283c8>] (do_exit) from [<c0128a50>]
(do_group_exit+0xb8/0xfc)
[ 3468.145874] [<c0128a50>] (do_group_exit) from [<c013274c>]
(get_signal+0x604/0x680)
[ 3468.145904] [<c013274c>] (get_signal) from [<c010de54>]
(do_signal+0x84/0x5d0)
[ 3468.145935] [<c010de54>] (do_signal) from [<c0109958>]
(do_work_pending+0x48/0xb8)
[ 3468.145935] [<c0109958>] (do_work_pending) from [<c01071b4>]
(slow_work_pending+0xc/0x20)
[ 3468.145935] ---[ end trace 70aa4a6442fc6918 ]---
[ 3468.167877] Address Hole seen by CAM  at address 0
[ 3468.167877] ------------[ cut here ]------------
[ 3468.167907] WARNING: CPU: 0 PID: 4973 at
drivers/bus/omap_l3_smx.c:166 omap3_l3_app_irq+0xdc/0x124
[ 3468.167999] Modules linked in: smiapp smiapp_pll ipv6
isp1704_charger omap3_isp videobuf2_v4l2 videobuf2_dma_contig
videobuf2_memops videobuf2_core et8ek8 smiaregs lis3lv02d_i2c
lis3lv02d input_polldev ti_soc_thermal arc4 wl1251_spi wl1251 crc7
mac80211 cfg80211 omap_ssi hsi bq2415x_charger si4713
bq27xxx_battery_i2c bq27xxx_battery leds_lp5523 leds_lp55xx_common
adp1653 v4l2_common tsl2563 smc91x mii rtc_twl twl4030_vibra
ff_memless twl4030_wdt tsc2005 tsc200x_core omap_sham omap_wdt
gpio_keys rx51_battery video_bus_switch videodev media
[ 3468.167999] CPU: 0 PID: 4973 Comm: yavta Tainted: G        W
4.6.0-rc4+ #1
[ 3468.168029] Hardware name: Nokia RX-51 board
[ 3468.168029] [<c010bc18>] (unwind_backtrace) from [<c0109f38>]
(show_stack+0x10/0x14)
[ 3468.168060] [<c0109f38>] (show_stack) from [<c01262dc>]
(__warn+0xcc/0xf8)
[ 3468.168090] [<c01262dc>] (__warn) from [<c0126324>]
(warn_slowpath_null+0x1c/0x20)
[ 3468.168090] [<c0126324>] (warn_slowpath_null) from [<c0331c6c>]
(omap3_l3_app_irq+0xdc/0x124)
[ 3468.168121] [<c0331c6c>] (omap3_l3_app_irq) from [<c01545bc>]
(handle_irq_event_percpu+0x34/0x138)
[ 3468.168121] [<c01545bc>] (handle_irq_event_percpu) from
[<c015471c>] (handle_irq_event+0x5c/0x88)
[ 3468.168151] [<c015471c>] (handle_irq_event) from [<c015768c>]
(handle_level_irq+0xcc/0x130)
[ 3468.168182] [<c015768c>] (handle_level_irq) from [<c0153f9c>]
(generic_handle_irq+0x18/0x28)
[ 3468.168182] [<c0153f9c>] (generic_handle_irq) from [<c01540bc>]
(__handle_domain_irq+0x84/0xa8)
[ 3468.168212] [<c01540bc>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.168273] [<c054da14>] (__irq_svc) from [<bf21530c>]
(hist_busy+0xc/0x14 [omap3_isp])
[ 3468.168426] [<bf21530c>] (hist_busy [omap3_isp]) from [<bf213dc4>]
(omap3isp_stat_pcr_busy+0x10/0x14 [omap3_isp])
[ 3468.168548] [<bf213dc4>] (omap3isp_stat_pcr_busy [omap3_isp]) from
[<bf214198>] (omap3isp_stat_busy+0xc/0x2c [omap3_isp])
[ 3468.168670] [<bf214198>] (omap3isp_stat_busy [omap3_isp]) from
[<bf205a88>] (isp_pipeline_wait_ccdc+0x40/0x60 [omap3_isp])
[ 3468.168792] [<bf205a88>] (isp_pipeline_wait_ccdc [omap3_isp]) from
[<bf205058>] (isp_pipeline_wait+0x28/0x4c [omap3_isp])
[ 3468.168914] [<bf205058>] (isp_pipeline_wait [omap3_isp]) from
[<bf2056d8>] (isp_pipeline_disable+0x154/0x224 [omap3_isp])
[ 3468.169036] [<bf2056d8>] (isp_pipeline_disable [omap3_isp]) from
[<bf2065a0>] (omap3isp_pipeline_set_stream+0x14/0x2c [omap3_isp])
[ 3468.169158] [<bf2065a0>] (omap3isp_pipeline_set_stream [omap3_isp])
from [<bf2092d0>] (isp_video_streamoff+0xcc/0x124 [omap3_isp])
[ 3468.169281] [<bf2092d0>] (isp_video_streamoff [omap3_isp]) from
[<bf209354>] (isp_video_release+0x2c/0x78 [omap3_isp])
[ 3468.169494] [<bf209354>] (isp_video_release [omap3_isp]) from
[<bf00d300>] (v4l2_release+0x30/0x6c [videodev])
[ 3468.169616] [<bf00d300>] (v4l2_release [videodev]) from
[<c01dd35c>] (__fput+0xd4/0x1f0)
[ 3468.169616] [<c01dd35c>] (__fput) from [<c013e030>]
(task_work_run+0x74/0x88)
[ 3468.169647] [<c013e030>] (task_work_run) from [<c01283c8>]
(do_exit+0x3e8/0x920)
[ 3468.169647] [<c01283c8>] (do_exit) from [<c0128a50>]
(do_group_exit+0xb8/0xfc)
[ 3468.169677] [<c0128a50>] (do_group_exit) from [<c013274c>]
(get_signal+0x604/0x680)
[ 3468.169708] [<c013274c>] (get_signal) from [<c010de54>]
(do_signal+0x84/0x5d0)
[ 3468.169708] [<c010de54>] (do_signal) from [<c0109958>]
(do_work_pending+0x48/0xb8)
[ 3468.169738] [<c0109958>] (do_work_pending) from [<c01071b4>]
(slow_work_pending+0xc/0x20)
[ 3468.169738] ---[ end trace 70aa4a6442fc6919 ]---
[ 3468.188049] omap3isp 480bc000.isp: CCP2 err:8010817
[ 3468.188110] Address Hole seen by CAM  at address b00
[ 3468.188110] ------------[ cut here ]------------
[ 3468.188140] WARNING: CPU: 0 PID: 4974 at
drivers/bus/omap_l3_smx.c:166 omap3_l3_app_irq+0xdc/0x124
[ 3468.188232] Modules linked in: smiapp smiapp_pll ipv6
isp1704_charger omap3_isp videobuf2_v4l2 videobuf2_dma_contig
videobuf2_memops videobuf2_core et8ek8 smiaregs lis3lv02d_i2c
lis3lv02d input_polldev ti_soc_thermal arc4 wl1251_spi wl1251 crc7
mac80211 cfg80211 omap_ssi hsi bq2415x_charger si4713
bq27xxx_battery_i2c bq27xxx_battery leds_lp5523 leds_lp55xx_common
adp1653 v4l2_common tsl2563 smc91x mii rtc_twl twl4030_vibra
ff_memless twl4030_wdt tsc2005 tsc200x_core omap_sham omap_wdt
gpio_keys rx51_battery video_bus_switch videodev media
[ 3468.188232] CPU: 0 PID: 4974 Comm: init Tainted: G        W
4.6.0-rc4+ #1
[ 3468.188232] Hardware name: Nokia RX-51 board
[ 3468.188262] [<c010bc18>] (unwind_backtrace) from [<c0109f38>]
(show_stack+0x10/0x14)
[ 3468.188293] [<c0109f38>] (show_stack) from [<c01262dc>]
(__warn+0xcc/0xf8)
[ 3468.188293] [<c01262dc>] (__warn) from [<c0126324>]
(warn_slowpath_null+0x1c/0x20)
[ 3468.188323] [<c0126324>] (warn_slowpath_null) from [<c0331c6c>]
(omap3_l3_app_irq+0xdc/0x124)
[ 3468.188323] [<c0331c6c>] (omap3_l3_app_irq) from [<c01545bc>]
(handle_irq_event_percpu+0x34/0x138)
[ 3468.188354] [<c01545bc>] (handle_irq_event_percpu) from
[<c015471c>] (handle_irq_event+0x5c/0x88)
[ 3468.188385] [<c015471c>] (handle_irq_event) from [<c015768c>]
(handle_level_irq+0xcc/0x130)
[ 3468.188385] [<c015768c>] (handle_level_irq) from [<c0153f9c>]
(generic_handle_irq+0x18/0x28)
[ 3468.188415] [<c0153f9c>] (generic_handle_irq) from [<c01540bc>]
(__handle_domain_irq+0x84/0xa8)
[ 3468.188415] [<c01540bc>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.188446] [<c054da14>] (__irq_svc) from [<c0129044>]
(__do_softirq+0x5c/0x208)
[ 3468.188446] [<c0129044>] (__do_softirq) from [<c0129448>]
(irq_exit+0x80/0xe4)
[ 3468.188476] [<c0129448>] (irq_exit) from [<c01540c0>]
(__handle_domain_irq+0x88/0xa8)
[ 3468.188476] [<c01540c0>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.188507] [<c054da14>] (__irq_svc) from [<c0152d50>]
(console_unlock+0x3f4/0x4fc)
[ 3468.188537] [<c0152d50>] (console_unlock) from [<c038e2d4>]
(do_con_write.part.10+0x1d80/0x1dac)
[ 3468.188537] [<c038e2d4>] (do_con_write.part.10) from [<c038e374>]
(con_write+0x30/0x48)
[ 3468.188568] [<c038e374>] (con_write) from [<c037a014>]
(do_output_char+0x9c/0x1e4)
[ 3468.188598] [<c037a014>] (do_output_char) from [<c037b1d4>]
(n_tty_write+0x2ac/0x430)
[ 3468.188598] [<c037b1d4>] (n_tty_write) from [<c03775ec>]
(tty_write+0x1b0/0x240)
[ 3468.188629] [<c03775ec>] (tty_write) from [<c01db128>]
(__vfs_write+0x2c/0xd4)
[ 3468.188629] [<c01db128>] (__vfs_write) from [<c01dc710>]
(vfs_write+0xa0/0x18c)
[ 3468.188659] [<c01dc710>] (vfs_write) from [<c01dc9f4>]
(SyS_write+0x3c/0x78)
[ 3468.188659] [<c01dc9f4>] (SyS_write) from [<c0107160>]
(ret_fast_syscall+0x0/0x3c)
[ 3468.188659] ---[ end trace 70aa4a6442fc691a ]---
[ 3468.200592] Address Hole seen by CAM  at address 0
[ 3468.200592] ------------[ cut here ]------------
[ 3468.200592] WARNING: CPU: 0 PID: 4973 at
drivers/bus/omap_l3_smx.c:166 omap3_l3_app_irq+0xdc/0x124
[ 3468.200683] Modules linked in: smiapp smiapp_pll ipv6
isp1704_charger omap3_isp videobuf2_v4l2 videobuf2_dma_contig
videobuf2_memops videobuf2_core et8ek8 smiaregs lis3lv02d_i2c
lis3lv02d input_polldev ti_soc_thermal arc4 wl1251_spi wl1251 crc7
mac80211 cfg80211 omap_ssi hsi bq2415x_charger si4713
bq27xxx_battery_i2c bq27xxx_battery leds_lp5523 leds_lp55xx_common
adp1653 v4l2_common tsl2563 smc91x mii rtc_twl twl4030_vibra
ff_memless twl4030_wdt tsc2005 tsc200x_core omap_sham omap_wdt
gpio_keys rx51_battery video_bus_switch videodev media
[ 3468.200714] CPU: 0 PID: 4973 Comm: yavta Tainted: G        W
4.6.0-rc4+ #1
[ 3468.200714] Hardware name: Nokia RX-51 board
[ 3468.200744] [<c010bc18>] (unwind_backtrace) from [<c0109f38>]
(show_stack+0x10/0x14)
[ 3468.200744] [<c0109f38>] (show_stack) from [<c01262dc>]
(__warn+0xcc/0xf8)
[ 3468.200775] [<c01262dc>] (__warn) from [<c0126324>]
(warn_slowpath_null+0x1c/0x20)
[ 3468.200775] [<c0126324>] (warn_slowpath_null) from [<c0331c6c>]
(omap3_l3_app_irq+0xdc/0x124)
[ 3468.200805] [<c0331c6c>] (omap3_l3_app_irq) from [<c01545bc>]
(handle_irq_event_percpu+0x34/0x138)
[ 3468.200836] [<c01545bc>] (handle_irq_event_percpu) from
[<c015471c>] (handle_irq_event+0x5c/0x88)
[ 3468.200836] [<c015471c>] (handle_irq_event) from [<c015768c>]
(handle_level_irq+0xcc/0x130)
[ 3468.200866] [<c015768c>] (handle_level_irq) from [<c0153f9c>]
(generic_handle_irq+0x18/0x28)
[ 3468.200866] [<c0153f9c>] (generic_handle_irq) from [<c01540bc>]
(__handle_domain_irq+0x84/0xa8)
[ 3468.200897] [<c01540bc>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.200988] [<c054da14>] (__irq_svc) from [<bf2141b4>]
(omap3isp_stat_busy+0x28/0x2c [omap3_isp])
[ 3468.201110] [<bf2141b4>] (omap3isp_stat_busy [omap3_isp]) from
[<bf205a88>] (isp_pipeline_wait_ccdc+0x40/0x60 [omap3_isp])
[ 3468.201232] [<bf205a88>] (isp_pipeline_wait_ccdc [omap3_isp]) from
[<bf205058>] (isp_pipeline_wait+0x28/0x4c [omap3_isp])
[ 3468.201354] [<bf205058>] (isp_pipeline_wait [omap3_isp]) from
[<bf2056d8>] (isp_pipeline_disable+0x154/0x224 [omap3_isp])
[ 3468.201477] [<bf2056d8>] (isp_pipeline_disable [omap3_isp]) from
[<bf2065a0>] (omap3isp_pipeline_set_stream+0x14/0x2c [omap3_isp])
[ 3468.201599] [<bf2065a0>] (omap3isp_pipeline_set_stream [omap3_isp])
from [<bf2092d0>] (isp_video_streamoff+0xcc/0x124 [omap3_isp])
[ 3468.201721] [<bf2092d0>] (isp_video_streamoff [omap3_isp]) from
[<bf209354>] (isp_video_release+0x2c/0x78 [omap3_isp])
[ 3468.201934] [<bf209354>] (isp_video_release [omap3_isp]) from
[<bf00d300>] (v4l2_release+0x30/0x6c [videodev])
[ 3468.202056] [<bf00d300>] (v4l2_release [videodev]) from
[<c01dd35c>] (__fput+0xd4/0x1f0)
[ 3468.202056] [<c01dd35c>] (__fput) from [<c013e030>]
(task_work_run+0x74/0x88)
[ 3468.202087] [<c013e030>] (task_work_run) from [<c01283c8>]
(do_exit+0x3e8/0x920)
[ 3468.202117] [<c01283c8>] (do_exit) from [<c0128a50>]
(do_group_exit+0xb8/0xfc)
[ 3468.202117] [<c0128a50>] (do_group_exit) from [<c013274c>]
(get_signal+0x604/0x680)
[ 3468.202148] [<c013274c>] (get_signal) from [<c010de54>]
(do_signal+0x84/0x5d0)
[ 3468.202148] [<c010de54>] (do_signal) from [<c0109958>]
(do_work_pending+0x48/0xb8)
[ 3468.202178] [<c0109958>] (do_work_pending) from [<c01071b4>]
(slow_work_pending+0xc/0x20)
[ 3468.202178] ---[ end trace 70aa4a6442fc691b ]---
[ 3468.218109] omap3isp 480bc000.isp: CCP2 err:8010817
[ 3468.218109] Address Hole seen by CAM  at address b00
[ 3468.218109] ------------[ cut here ]------------
[ 3468.218139] WARNING: CPU: 0 PID: 4974 at
drivers/bus/omap_l3_smx.c:166 omap3_l3_app_irq+0xdc/0x124
[ 3468.218231] Modules linked in: smiapp smiapp_pll ipv6
isp1704_charger omap3_isp videobuf2_v4l2 videobuf2_dma_contig
videobuf2_memops videobuf2_core et8ek8 smiaregs lis3lv02d_i2c
lis3lv02d input_polldev ti_soc_thermal arc4 wl1251_spi wl1251 crc7
mac80211 cfg80211 omap_ssi hsi bq2415x_charger si4713
bq27xxx_battery_i2c bq27xxx_battery leds_lp5523 leds_lp55xx_common
adp1653 v4l2_common tsl2563 smc91x mii rtc_twl twl4030_vibra
ff_memless twl4030_wdt tsc2005 tsc200x_core omap_sham omap_wdt
gpio_keys rx51_battery video_bus_switch videodev media
[ 3468.218231] CPU: 0 PID: 4974 Comm: init Tainted: G        W
4.6.0-rc4+ #1
[ 3468.218231] Hardware name: Nokia RX-51 board
[ 3468.218261] [<c010bc18>] (unwind_backtrace) from [<c0109f38>]
(show_stack+0x10/0x14)
[ 3468.218292] [<c0109f38>] (show_stack) from [<c01262dc>]
(__warn+0xcc/0xf8)
[ 3468.218292] [<c01262dc>] (__warn) from [<c0126324>]
(warn_slowpath_null+0x1c/0x20)
[ 3468.218322] [<c0126324>] (warn_slowpath_null) from [<c0331c6c>]
(omap3_l3_app_irq+0xdc/0x124)
[ 3468.218353] [<c0331c6c>] (omap3_l3_app_irq) from [<c01545bc>]
(handle_irq_event_percpu+0x34/0x138)
[ 3468.218353] [<c01545bc>] (handle_irq_event_percpu) from
[<c015471c>] (handle_irq_event+0x5c/0x88)
[ 3468.218383] [<c015471c>] (handle_irq_event) from [<c015768c>]
(handle_level_irq+0xcc/0x130)
[ 3468.218383] [<c015768c>] (handle_level_irq) from [<c0153f9c>]
(generic_handle_irq+0x18/0x28)
[ 3468.218414] [<c0153f9c>] (generic_handle_irq) from [<c01540bc>]
(__handle_domain_irq+0x84/0xa8)
[ 3468.218414] [<c01540bc>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.218444] [<c054da14>] (__irq_svc) from [<c0152d50>]
(console_unlock+0x3f4/0x4fc)
[ 3468.218475] [<c0152d50>] (console_unlock) from [<c038e2d4>]
(do_con_write.part.10+0x1d80/0x1dac)
[ 3468.218475] [<c038e2d4>] (do_con_write.part.10) from [<c038e374>]
(con_write+0x30/0x48)
[ 3468.218505] [<c038e374>] (con_write) from [<c037a014>]
(do_output_char+0x9c/0x1e4)
[ 3468.218536] [<c037a014>] (do_output_char) from [<c037b1d4>]
(n_tty_write+0x2ac/0x430)
[ 3468.218536] [<c037b1d4>] (n_tty_write) from [<c03775ec>]
(tty_write+0x1b0/0x240)
[ 3468.218566] [<c03775ec>] (tty_write) from [<c01db128>]
(__vfs_write+0x2c/0xd4)
[ 3468.218566] [<c01db128>] (__vfs_write) from [<c01dc710>]
(vfs_write+0xa0/0x18c)
[ 3468.218566] [<c01dc710>] (vfs_write) from [<c01dc9f4>]
(SyS_write+0x3c/0x78)
[ 3468.218597] [<c01dc9f4>] (SyS_write) from [<c0107160>]
(ret_fast_syscall+0x0/0x3c)
[ 3468.218597] ---[ end trace 70aa4a6442fc691c ]---
[ 3468.233276] Address Hole seen by CAM  at address 0
[ 3468.233276] ------------[ cut here ]------------
[ 3468.233306] WARNING: CPU: 0 PID: 4973 at
drivers/bus/omap_l3_smx.c:166 omap3_l3_app_irq+0xdc/0x124
[ 3468.233398] Modules linked in: smiapp smiapp_pll ipv6
isp1704_charger omap3_isp videobuf2_v4l2 videobuf2_dma_contig
videobuf2_memops videobuf2_core et8ek8 smiaregs lis3lv02d_i2c
lis3lv02d input_polldev ti_soc_thermal arc4 wl1251_spi wl1251 crc7
mac80211 cfg80211 omap_ssi hsi bq2415x_charger si4713
bq27xxx_battery_i2c bq27xxx_battery leds_lp5523 leds_lp55xx_common
adp1653 v4l2_common tsl2563 smc91x mii rtc_twl twl4030_vibra
ff_memless twl4030_wdt tsc2005 tsc200x_core omap_sham omap_wdt
gpio_keys rx51_battery video_bus_switch videodev media
[ 3468.233398] CPU: 0 PID: 4973 Comm: yavta Tainted: G        W
4.6.0-rc4+ #1
[ 3468.233398] Hardware name: Nokia RX-51 board
[ 3468.233428] [<c010bc18>] (unwind_backtrace) from [<c0109f38>]
(show_stack+0x10/0x14)
[ 3468.233459] [<c0109f38>] (show_stack) from [<c01262dc>]
(__warn+0xcc/0xf8)
[ 3468.233459] [<c01262dc>] (__warn) from [<c0126324>]
(warn_slowpath_null+0x1c/0x20)
[ 3468.233489] [<c0126324>] (warn_slowpath_null) from [<c0331c6c>]
(omap3_l3_app_irq+0xdc/0x124)
[ 3468.233520] [<c0331c6c>] (omap3_l3_app_irq) from [<c01545bc>]
(handle_irq_event_percpu+0x34/0x138)
[ 3468.233520] [<c01545bc>] (handle_irq_event_percpu) from
[<c015471c>] (handle_irq_event+0x5c/0x88)
[ 3468.233551] [<c015471c>] (handle_irq_event) from [<c015768c>]
(handle_level_irq+0xcc/0x130)
[ 3468.233551] [<c015768c>] (handle_level_irq) from [<c0153f9c>]
(generic_handle_irq+0x18/0x28)
[ 3468.233581] [<c0153f9c>] (generic_handle_irq) from [<c01540bc>]
(__handle_domain_irq+0x84/0xa8)
[ 3468.233581] [<c01540bc>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.233673] [<c054da14>] (__irq_svc) from [<bf20e9dc>]
(omap3isp_ccdc_busy+0xc/0x14 [omap3_isp])
[ 3468.233795] [<bf20e9dc>] (omap3isp_ccdc_busy [omap3_isp]) from
[<bf205a9c>] (isp_pipeline_wait_ccdc+0x54/0x60 [omap3_isp])
[ 3468.233917] [<bf205a9c>] (isp_pipeline_wait_ccdc [omap3_isp]) from
[<bf205058>] (isp_pipeline_wait+0x28/0x4c [omap3_isp])
[ 3468.234039] [<bf205058>] (isp_pipeline_wait [omap3_isp]) from
[<bf2056d8>] (isp_pipeline_disable+0x154/0x224 [omap3_isp])
[ 3468.234191] [<bf2056d8>] (isp_pipeline_disable [omap3_isp]) from
[<bf2065a0>] (omap3isp_pipeline_set_stream+0x14/0x2c [omap3_isp])
[ 3468.234313] [<bf2065a0>] (omap3isp_pipeline_set_stream [omap3_isp])
from [<bf2092d0>] (isp_video_streamoff+0xcc/0x124 [omap3_isp])
[ 3468.234436] [<bf2092d0>] (isp_video_streamoff [omap3_isp]) from
[<bf209354>] (isp_video_release+0x2c/0x78 [omap3_isp])
[ 3468.234619] [<bf209354>] (isp_video_release [omap3_isp]) from
[<bf00d300>] (v4l2_release+0x30/0x6c [videodev])
[ 3468.234771] [<bf00d300>] (v4l2_release [videodev]) from
[<c01dd35c>] (__fput+0xd4/0x1f0)
[ 3468.234771] [<c01dd35c>] (__fput) from [<c013e030>]
(task_work_run+0x74/0x88)
[ 3468.234802] [<c013e030>] (task_work_run) from [<c01283c8>]
(do_exit+0x3e8/0x920)
[ 3468.234802] [<c01283c8>] (do_exit) from [<c0128a50>]
(do_group_exit+0xb8/0xfc)
[ 3468.234832] [<c0128a50>] (do_group_exit) from [<c013274c>]
(get_signal+0x604/0x680)
[ 3468.234832] [<c013274c>] (get_signal) from [<c010de54>]
(do_signal+0x84/0x5d0)
[ 3468.234863] [<c010de54>] (do_signal) from [<c0109958>]
(do_work_pending+0x48/0xb8)
[ 3468.234893] [<c0109958>] (do_work_pending) from [<c01071b4>]
(slow_work_pending+0xc/0x20)
[ 3468.234893] ---[ end trace 70aa4a6442fc691d ]---
[ 3468.238891] omap3isp 480bc000.isp: Unable to stop OMAP3 ISP CCDC
[ 3468.238922] Address Hole seen by CAM  at address b00
[ 3468.238922] ------------[ cut here ]------------
[ 3468.238952] WARNING: CPU: 0 PID: 4973 at
drivers/bus/omap_l3_smx.c:166 omap3_l3_app_irq+0xdc/0x124
[ 3468.239044] Modules linked in: smiapp smiapp_pll ipv6
isp1704_charger omap3_isp videobuf2_v4l2 videobuf2_dma_contig
videobuf2_memops videobuf2_core et8ek8 smiaregs lis3lv02d_i2c
lis3lv02d input_polldev ti_soc_thermal arc4 wl1251_spi wl1251 crc7
mac80211 cfg80211 omap_ssi hsi bq2415x_charger si4713
bq27xxx_battery_i2c bq27xxx_battery leds_lp5523 leds_lp55xx_common
adp1653 v4l2_common tsl2563 smc91x mii rtc_twl twl4030_vibra
ff_memless twl4030_wdt tsc2005 tsc200x_core omap_sham omap_wdt
gpio_keys rx51_battery video_bus_switch videodev media
[ 3468.239044] CPU: 0 PID: 4973 Comm: yavta Tainted: G        W
4.6.0-rc4+ #1
[ 3468.239044] Hardware name: Nokia RX-51 board
[ 3468.239074] [<c010bc18>] (unwind_backtrace) from [<c0109f38>]
(show_stack+0x10/0x14)
[ 3468.239105] [<c0109f38>] (show_stack) from [<c01262dc>]
(__warn+0xcc/0xf8)
[ 3468.239105] [<c01262dc>] (__warn) from [<c0126324>]
(warn_slowpath_null+0x1c/0x20)
[ 3468.239135] [<c0126324>] (warn_slowpath_null) from [<c0331c6c>]
(omap3_l3_app_irq+0xdc/0x124)
[ 3468.239166] [<c0331c6c>] (omap3_l3_app_irq) from [<c01545bc>]
(handle_irq_event_percpu+0x34/0x138)
[ 3468.239166] [<c01545bc>] (handle_irq_event_percpu) from
[<c015471c>] (handle_irq_event+0x5c/0x88)
[ 3468.239196] [<c015471c>] (handle_irq_event) from [<c015768c>]
(handle_level_irq+0xcc/0x130)
[ 3468.239196] [<c015768c>] (handle_level_irq) from [<c0153f9c>]
(generic_handle_irq+0x18/0x28)
[ 3468.239227] [<c0153f9c>] (generic_handle_irq) from [<c01540bc>]
(__handle_domain_irq+0x84/0xa8)
[ 3468.239227] [<c01540bc>] (__handle_domain_irq) from [<c054da14>]
(__irq_svc+0x54/0x90)
[ 3468.239257] [<c054da14>] (__irq_svc) from [<c0372430>]
(regulator_disable+0x8/0x5c)
[ 3468.239349] [<c0372430>] (regulator_disable) from [<bf20a120>]
(ccp2_if_enable+0xf4/0xfc [omap3_isp])
[ 3468.239471] [<bf20a120>] (ccp2_if_enable [omap3_isp]) from
[<bf20a948>] (ccp2_s_stream+0x44c/0x4b0 [omap3_isp])
[ 3468.239593] [<bf20a948>] (ccp2_s_stream [omap3_isp]) from
[<bf205688>] (isp_pipeline_disable+0x104/0x224 [omap3_isp])
[ 3468.239746] [<bf205688>] (isp_pipeline_disable [omap3_isp]) from
[<bf2065a0>] (omap3isp_pipeline_set_stream+0x14/0x2c [omap3_isp])
[ 3468.239868] [<bf2065a0>] (omap3isp_pipeline_set_stream [omap3_isp])
from [<bf2092d0>] (isp_video_streamoff+0xcc/0x124 [omap3_isp])
[ 3468.239990] [<bf2092d0>] (isp_video_streamoff [omap3_isp]) from
[<bf209354>] (isp_video_release+0x2c/0x78 [omap3_isp])
[ 3468.240173] [<bf209354>] (isp_video_release [omap3_isp]) from
[<bf00d300>] (v4l2_release+0x30/0x6c [videodev])
[ 3468.240295] [<bf00d300>] (v4l2_release [videodev]) from
[<c01dd35c>] (__fput+0xd4/0x1f0)
[ 3468.240325] [<c01dd35c>] (__fput) from [<c013e030>]
(task_work_run+0x74/0x88)
[ 3468.240325] [<c013e030>] (task_work_run) from [<c01283c8>]
(do_exit+0x3e8/0x920)
[ 3468.240356] [<c01283c8>] (do_exit) from [<c0128a50>]
(do_group_exit+0xb8/0xfc)
[ 3468.240356] [<c0128a50>] (do_group_exit) from [<c013274c>]
(get_signal+0x604/0x680)
[ 3468.240386] [<c013274c>] (get_signal) from [<c010de54>]
(do_signal+0x84/0x5d0)
[ 3468.240417] [<c010de54>] (do_signal) from [<c0109958>]
(do_work_pending+0x48/0xb8)
[ 3468.240417] [<c0109958>] (do_work_pending) from [<c01071b4>]
(slow_work_pending+0xc/0x20)
[ 3468.240417] ---[ end trace 70aa4a6442fc691e ]---

But it seems to produce _something_ so I guess its a improvement :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
