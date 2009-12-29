Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:4533 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZL2JWj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 04:22:39 -0500
Message-ID: <4B39C98B.9050107@toaster.net>
Date: Tue, 29 Dec 2009 01:19:07 -0800
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
	bugzilla-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org,
	USB list <linux-usb@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bugme-new] [Bug 14564] New: capture-example sleeping function
 called from invalid context at arch/x86/mm/fault.c
References: <Pine.LNX.4.44L0.0912171011410.3055-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912171011410.3055-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------050402050202090405040601"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050402050202090405040601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Stern wrote:
> The patch doesn't fix anything.  The point was to gather enough 
> information to figure out what's going wrong.  Without the debug 
> messages, there's no information.
>
> Perhaps things will slow down less if you change the new ohci_info() 
> calls in the patch to ohci_dbg().  Or perhaps you can increase the 
> timeout values in capture-example.c.
>
> You should also apply this patch (be sure to enable CONFIG_USB_DEBUG):
>
> 	http://marc.info/?l=linux-usb&m=126056642931083&w=2
>
> It probably won't make any difference, but including it anyway is
> worthwhile.
>
> Alan Stern
>   
The early return in td_free that is in the patch will trap the error.

I changed the debug statements to ohci_dbg and I was able to capture the 
full output with klogd. It is attached.

Sean

--------------050402050202090405040601
Content-Type: text/x-log;
 name="kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel.log"

klogd 1.5.0, log source = /proc/kmsg started.
Cannot find map file.
Loaded 35125 symbols from 1 module.
s' (c6b31290): kobject_add_internal: parent: 'psmouse', set: '<NULL>'
<7>kobject: 'psmouse' (c6b8ef70): kobject_uevent_env
<7>kobject: 'psmouse' (c6b8ef70): fill_kobj_path: path = '/bus/serio/drivers/psmouse'
<7>kobject: 'input0' (c6b81814): kobject_add_internal: parent: 'input', set: 'devices'
<7>kobject: 'input0' (c6b81814): kobject_uevent_env
<7>kobject: 'input0' (c6b81814): fill_kobj_path: path = '/class/input/input0'
<7>kobject: 'serio0' (c6b7cedc): fill_kobj_path: path = '/devices/platform/i8042/serio0'
<7>kobject: 'pcspkr' (c6b94f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'input1' (c6b14814): kobject_add_internal: parent: 'input', set: 'devices'
<7>kobject: 'input1' (c6b14814): kobject_uevent_env
<7>kobject: 'input1' (c6b14814): fill_kobj_path: path = '/class/input/input1'
<7>kobject: 'pcspkr' (c7230e00): fill_kobj_path: path = '/devices/platform/pcspkr'
<7>kobject: 'input0' (c6b81814): fill_kobj_path: path = '/class/input/input0'
<6>input: AT Translated Set 2 keyboard as /class/input/input0
<7>kobject: 'input1' (c6b14814): fill_kobj_path: path = '/class/input/input1'
<6>input: PC Speaker as /class/input/input1
<7>kobject: 'pcspkr' (c6b94f70): kobject_uevent_env
<7>kobject: 'pcspkr' (c6b94f70): fill_kobj_path: path = '/bus/platform/drivers/pcspkr'
<7>kobject: 'powermate' (c6b92f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'powermate' (c6b92f70): kobject_uevent_env
<7>kobject: 'powermate' (c6b92f70): fill_kobj_path: path = '/bus/usb/drivers/powermate'
<6>usbcore: registered new interface driver powermate
<7>kobject: 'uinput' (c6b86ef8): kobject_add_internal: parent: 'misc', set: 'devices'
<7>kobject: 'uinput' (c6b86ef8): kobject_uevent_env
<7>kobject: 'uinput' (c6b86ef8): fill_kobj_path: path = '/class/misc/uinput'
<7>kobject: '<NULL>' (c6b8b814): kobject_cleanup
<7>kobject: '<NULL>' (c6b8b814): calling ktype release
<7>kobject: 'rtc_cmos' (c6b9ff70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'rtc_cmos' (c6b9ff70): kobject_uevent_env
<7>kobject: 'rtc_cmos' (c6b9ff70): fill_kobj_path: path = '/bus/pnp/drivers/rtc_cmos'
<7>kobject: 'rtc_cmos' (c6ba1f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'rtc0' (c6b82bf8): kobject_add_internal: parent: 'rtc', set: 'devices'
<7>kobject: 'rtc0' (c6b82bf8): kobject_uevent_env
<7>kobject: 'rtc0' (c6b82bf8): fill_kobj_path: path = '/class/rtc/rtc0'
<7>kobject: 'rtc_cmos' (c1474150): fill_kobj_path: path = '/devices/platform/rtc_cmos'
<7>kobject: '<NULL>' (c6b8b814): kobject_cleanup
<7>kobject: '<NULL>' (c6b8b814): calling ktype release
<6>rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
<6>rtc0: alarms up to one day, 114 bytes nvram
<7>kobject: 'rtc_cmos' (c6ba1f70): kobject_uevent_env
<7>kobject: 'rtc_cmos' (c6ba1f70): fill_kobj_path: path = '/bus/platform/drivers/rtc_cmos'
<5>ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/none/1.1.2.2
<6>PPP BSD Compression module registered
<7>kobject: 'mmcblk' (c6442f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'mmcblk' (c6442f70): kobject_uevent_env
<7>kobject: 'mmcblk' (c6442f70): fill_kobj_path: path = '/bus/mmc/drivers/mmcblk'
<7>kobject: 'mmc_test' (c6444f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'mmc_test' (c6444f70): kobject_uevent_env
<7>kobject: 'mmc_test' (c6444f70): fill_kobj_path: path = '/bus/mmc/drivers/mmc_test'
<7>kobject: 'sdio_uart' (c6447f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'sdio_uart' (c6447f70): kobject_uevent_env
<7>kobject: 'sdio_uart' (c6447f70): fill_kobj_path: path = '/bus/sdio/drivers/sdio_uart'
<6>sdhci: Secure Digital Host Controller Interface driver
<6>sdhci: Copyright(c) Pierre Ossman
<7>kobject: 'sdhci-pci' (c6448f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'sdhci-pci' (c6448f70): kobject_uevent_env
<7>kobject: 'sdhci-pci' (c6448f70): fill_kobj_path: path = '/bus/pci/drivers/sdhci-pci'
<6>ricoh-mmc: Ricoh MMC Controller disabling driver
<6>ricoh-mmc: Copyright(c) Philip Langdale
<7>kobject: 'ricoh-mmc' (c6449f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'ricoh-mmc' (c6449f70): kobject_uevent_env
<7>kobject: 'ricoh-mmc' (c6449f70): fill_kobj_path: path = '/bus/pci/drivers/ricoh-mmc'
<6>wbsd: Winbond W83L51xD SD/MMC card interface driver
<6>wbsd: Copyright(c) Pierre Ossman
<7>kobject: 'wbsd' (c644bf70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'wbsd' (c644bf70): kobject_uevent_env
<7>kobject: 'wbsd' (c644bf70): fill_kobj_path: path = '/bus/pnp/drivers/wbsd'
<7>kobject: 'mmc_spi' (c644cf70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'mmc_spi' (c644cf70): kobject_uevent_env
<7>kobject: 'mmc_spi' (c644cf70): fill_kobj_path: path = '/bus/spi/drivers/mmc_spi'
<7>kobject: 'hid' (c6ba0e1c): kobject_add_internal: parent: 'bus', set: 'bus'
<7>kobject: 'hid' (c6ba0e1c): kobject_uevent_env
<7>kobject: 'hid' (c6ba0e1c): fill_kobj_path: path = '/bus/hid'
<7>kobject: 'devices' (c6b646b4): kobject_add_internal: parent: 'hid', set: '<NULL>'
<7>kobject: 'devices' (c6b646b4): kobject_uevent_env
<7>kobject: 'devices' (c6b646b4): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'drivers' (c6b6463c): kobject_add_internal: parent: 'hid', set: '<NULL>'
<7>kobject: 'drivers' (c6b6463c): kobject_uevent_env
<7>kobject: 'drivers' (c6b6463c): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'a4tech' (c644ef70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'a4tech' (c644ef70): kobject_uevent_env
<7>kobject: 'a4tech' (c644ef70): fill_kobj_path: path = '/bus/hid/drivers/a4tech'
<7>kobject: 'apple' (c644ff70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'drivers' (c6b31b28): kobject_add_internal: parent: 'hid_apple', set: '<NULL>'
<7>kobject: 'apple' (c644ff70): kobject_uevent_env
<7>kobject: 'apple' (c644ff70): fill_kobj_path: path = '/bus/hid/drivers/apple'
<7>kobject: 'belkin' (c6450f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'belkin' (c6450f70): kobject_uevent_env
<7>kobject: 'belkin' (c6450f70): fill_kobj_path: path = '/bus/hid/drivers/belkin'
<7>kobject: 'cherry' (c6451f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'cherry' (c6451f70): kobject_uevent_env
<7>kobject: 'cherry' (c6451f70): fill_kobj_path: path = '/bus/hid/drivers/cherry'
<7>kobject: 'chicony' (c6452f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'chicony' (c6452f70): kobject_uevent_env
<7>kobject: 'chicony' (c6452f70): fill_kobj_path: path = '/bus/hid/drivers/chicony'
<7>kobject: 'cypress' (c6453f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'cypress' (c6453f70): kobject_uevent_env
<7>kobject: 'cypress' (c6453f70): fill_kobj_path: path = '/bus/hid/drivers/cypress'
<7>kobject: 'dragonrise' (c6456f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'dragonrise' (c6456f70): kobject_uevent_env
<7>kobject: 'dragonrise' (c6456f70): fill_kobj_path: path = '/bus/hid/drivers/dragonrise'
<7>kobject: 'ezkey' (c6458f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'ezkey' (c6458f70): kobject_uevent_env
<7>kobject: 'ezkey' (c6458f70): fill_kobj_path: path = '/bus/hid/drivers/ezkey'
<7>kobject: 'gyration' (c6459f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'gyration' (c6459f70): kobject_uevent_env
<7>kobject: 'gyration' (c6459f70): fill_kobj_path: path = '/bus/hid/drivers/gyration'
<7>kobject: 'kensington' (c6ba3f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'kensington' (c6ba3f70): kobject_uevent_env
<7>kobject: 'kensington' (c6ba3f70): fill_kobj_path: path = '/bus/hid/drivers/kensington'
<7>kobject: 'kye' (c645cf70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'kye' (c645cf70): kobject_uevent_env
<7>kobject: 'kye' (c645cf70): fill_kobj_path: path = '/bus/hid/drivers/kye'
<7>kobject: 'logitech' (c645df70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'logitech' (c645df70): kobject_uevent_env
<7>kobject: 'logitech' (c645df70): fill_kobj_path: path = '/bus/hid/drivers/logitech'
<7>kobject: 'microsoft' (c645ef70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'microsoft' (c645ef70): kobject_uevent_env
<7>kobject: 'microsoft' (c645ef70): fill_kobj_path: path = '/bus/hid/drivers/microsoft'
<7>kobject: 'monterey' (c645ff70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'monterey' (c645ff70): kobject_uevent_env
<7>kobject: 'monterey' (c645ff70): fill_kobj_path: path = '/bus/hid/drivers/monterey'
<7>kobject: 'ntrig' (c6460f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'ntrig' (c6460f70): kobject_uevent_env
<7>kobject: 'ntrig' (c6460f70): fill_kobj_path: path = '/bus/hid/drivers/ntrig'
<7>kobject: 'pantherlord' (c6461f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'pantherlord' (c6461f70): kobject_uevent_env
<7>kobject: 'pantherlord' (c6461f70): fill_kobj_path: path = '/bus/hid/drivers/pantherlord'
<7>kobject: 'petalynx' (c6454f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'petalynx' (c6454f70): kobject_uevent_env
<7>kobject: 'petalynx' (c6454f70): fill_kobj_path: path = '/bus/hid/drivers/petalynx'
<7>kobject: 'samsung' (c6455f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'samsung' (c6455f70): kobject_uevent_env
<7>kobject: 'samsung' (c6455f70): fill_kobj_path: path = '/bus/hid/drivers/samsung'
<7>kobject: 'smartjoyplus' (c6465f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'smartjoyplus' (c6465f70): kobject_uevent_env
<7>kobject: 'smartjoyplus' (c6465f70): fill_kobj_path: path = '/bus/hid/drivers/smartjoyplus'
<7>kobject: 'sony' (c6466f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'sony' (c6466f70): kobject_uevent_env
<7>kobject: 'sony' (c6466f70): fill_kobj_path: path = '/bus/hid/drivers/sony'
<7>kobject: 'sunplus' (c6467f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'sunplus' (c6467f70): kobject_uevent_env
<7>kobject: 'sunplus' (c6467f70): fill_kobj_path: path = '/bus/hid/drivers/sunplus'
<7>kobject: 'greenasia' (c6468f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'greenasia' (c6468f70): kobject_uevent_env
<7>kobject: 'greenasia' (c6468f70): fill_kobj_path: path = '/bus/hid/drivers/greenasia'
<7>kobject: 'thrustmaster' (c6469f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'thrustmaster' (c6469f70): kobject_uevent_env
<7>kobject: 'thrustmaster' (c6469f70): fill_kobj_path: path = '/bus/hid/drivers/thrustmaster'
<7>kobject: 'topseed' (c646af70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'topseed' (c646af70): kobject_uevent_env
<7>kobject: 'topseed' (c646af70): fill_kobj_path: path = '/bus/hid/drivers/topseed'
<7>kobject: 'zeroplus' (c646bf70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'zeroplus' (c646bf70): kobject_uevent_env
<7>kobject: 'zeroplus' (c646bf70): fill_kobj_path: path = '/bus/hid/drivers/zeroplus'
<7>kobject: 'generic-usb' (c646df70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'drivers' (c6b31a78): kobject_add_internal: parent: 'usbhid', set: '<NULL>'
<7>kobject: 'generic-usb' (c646df70): kobject_uevent_env
<7>kobject: 'generic-usb' (c646df70): fill_kobj_path: path = '/bus/hid/drivers/generic-usb'
<7>kobject: 'hiddev' (c6472f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'hiddev' (c6472f70): kobject_uevent_env
<7>kobject: 'hiddev' (c6472f70): fill_kobj_path: path = '/bus/usb/drivers/hiddev'
<6>usbcore: registered new interface driver hiddev
<7>kobject: 'usbhid' (c6474f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'usbhid' (c6474f70): kobject_uevent_env
<7>kobject: 'usbhid' (c6474f70): fill_kobj_path: path = '/bus/usb/drivers/usbhid'
<6>usbcore: registered new interface driver usbhid
<6>usbhid: v2.6:USB HID core driver
<7>kobject: 'sound' (c644de1c): kobject_add_internal: parent: 'class', set: 'class'
<7>kobject: 'sound' (c644de1c): kobject_uevent_env
<7>kobject: 'sound' (c644de1c): fill_kobj_path: path = '/class/sound'
<6>Advanced Linux Sound Architecture Driver Version 1.0.20.
<7>kobject: 'timer' (c6b9eef8): kobject_add_internal: parent: 'sound', set: 'devices'
<7>kobject: 'timer' (c6b9eef8): kobject_uevent_env
<7>kobject: 'timer' (c6b9eef8): fill_kobj_path: path = '/class/sound/timer'
<7>kobject: 'snd-usb-audio' (c648ef70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'drivers' (c6b31918): kobject_add_internal: parent: 'snd_usb_audio', set: '<NULL>'
<7>kobject: 'snd-usb-audio' (c648ef70): kobject_uevent_env
<7>kobject: 'snd-usb-audio' (c648ef70): fill_kobj_path: path = '/bus/usb/drivers/snd-usb-audio'
<6>usbcore: registered new interface driver snd-usb-audio
<7>kobject: 'snd-usb-usx2y' (c648ff70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'drivers' (c6b318c0): kobject_add_internal: parent: 'snd_usb_usx2y', set: '<NULL>'
<7>kobject: 'snd-usb-usx2y' (c648ff70): kobject_uevent_env
<7>kobject: 'snd-usb-usx2y' (c648ff70): fill_kobj_path: path = '/bus/usb/drivers/snd-usb-usx2y'
<6>usbcore: registered new interface driver snd-usb-usx2y
<7>kobject: 'snd-usb-caiaq' (c6490f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'drivers' (c6b31868): kobject_add_internal: parent: 'snd_usb_caiaq', set: '<NULL>'
<7>kobject: 'snd-usb-caiaq' (c6490f70): kobject_uevent_env
<7>kobject: 'snd-usb-caiaq' (c6490f70): fill_kobj_path: path = '/bus/usb/drivers/snd-usb-caiaq'
<6>usbcore: registered new interface driver snd-usb-caiaq
<7>kobject: 'soc-audio' (c6492f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>kobject: 'soc-audio' (c6492f70): kobject_uevent_env
<7>kobject: 'soc-audio' (c6492f70): fill_kobj_path: path = '/bus/platform/drivers/soc-audio'
<6>ALSA device list:
<6>  No soundcards found.
<6>TCP cubic registered
<6>Initializing XFRM netlink socket
<6>NET: Registered protocol family 17
<6>RPC: Registered udp transport module.
<6>RPC: Registered tcp transport module.
<6>lib80211: common routines for IEEE802.11 drivers
<7>lib80211_crypt: registered algorithm 'NULL'
<7>kobject: 'cpu_dma_latency' (c64b5ef8): kobject_add_internal: parent: 'misc', set: 'devices'
<7>kobject: 'cpu_dma_latency' (c64b5ef8): kobject_uevent_env
<7>kobject: 'cpu_dma_latency' (c64b5ef8): fill_kobj_path: path = '/class/misc/cpu_dma_latency'
<7>kobject: 'network_latency' (c64baef8): kobject_add_internal: parent: 'misc', set: 'devices'
<7>kobject: 'network_latency' (c64baef8): kobject_uevent_env
<7>kobject: 'network_latency' (c64baef8): fill_kobj_path: path = '/class/misc/network_latency'
<7>kobject: 'network_throughput' (c64c0ef8): kobject_add_internal: parent: 'misc', set: 'devices'
<7>kobject: 'network_throughput' (c64c0ef8): kobject_uevent_env
<7>kobject: 'network_throughput' (c64c0ef8): fill_kobj_path: path = '/class/misc/network_throughput'
<6>rtc_cmos rtc_cmos: setting system clock to 2009-12-29 17:12:12 UTC (1262106732)
<7>kobject: 'memmap' (c6b6418c): kobject_add_internal: parent: 'firmware', set: '<NULL>'
<7>kobject: 'memmap' (c6b6418c): kobject_uevent_env
<7>kobject: 'memmap' (c6b6418c): kobject_uevent_env: attempted to send uevent without kset!
<7>kobject: '0' (c1d1298c): kobject_add_internal: parent: 'memmap', set: 'memmap'
<7>kobject: '1' (c1d129cc): kobject_add_internal: parent: 'memmap', set: 'memmap'
<7>kobject: '2' (c1d12a0c): kobject_add_internal: parent: 'memmap', set: 'memmap'
<7>kobject: '3' (c1d12a4c): kobject_add_internal: parent: 'memmap', set: 'memmap'
<7>kobject: '4' (c1d12a8c): kobject_add_internal: parent: 'memmap', set: 'memmap'
<6>kjournald starting.  Commit interval 5 seconds
<6>EXT3-fs: mounted filesystem with writeback data mode.
<4>VFS: Mounted root (ext3 filesystem) readonly on device 22:2.
<6>debug: unmapping init memory c15ed000..c1627000
<6>Write protecting the kernel text: 2964k
<6>Write protecting the kernel read-only data: 1556k
<4>klogd used greatest stack depth: 5668 bytes left
<6>eth0: link up, 10Mbps, half-duplex, lpa 0x0000
<7>kobject: 'vcs2' (c6522ef8): kobject_add_internal: parent: 'vc', set: 'devices'
<7>kobject: 'vcs2' (c6522ef8): kobject_uevent_env
<7>kobject: 'vcs2' (c6522ef8): fill_kobj_path: path = '/class/vc/vcs2'
<7>kobject: 'vcsa2' (c64c3ef8): kobject_add_internal: parent: 'vc', set: 'devices'
<7>kobject: 'vcsa2' (c64c3ef8): kobject_uevent_env
<7>kobject: 'vcsa2' (c64c3ef8): fill_kobj_path: path = '/class/vc/vcsa2'
<7>hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>ehci_hcd 0000:00:0b.1: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
<7>hub 2-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
<7>hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
<7>ehci_hcd 0000:00:0b.1: port 2 full speed --> companion
<7>ehci_hcd 0000:00:0b.1: GetStatus port 2 status 003001 POWER OWNER sig=se0 CONNECT
<7>hub 2-0:1.0: port 2 not reset yet, waiting 50ms
<7>ehci_hcd 0000:00:0b.1: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
<7>kobject: '2-2' (c66c0c5c): kobject_cleanup
<7>kobject: '2-2' (c66c0c5c): calling ktype release
<7>kobject: '2-2': free name
<7>hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>ohci_hcd 0000:00:0b.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
<7>hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
<7>hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
<7>ohci_hcd 0000:00:0b.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
<6>usb 4-2: new full speed USB device using ohci_hcd and address 2
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>usb 4-2: ep0 maxpacket = 8
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>usb 4-2: default language 0x0409
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>usb 4-2: udev 2, busnum 4, minor = 385
<6>usb 4-2: New USB device found, idVendor=093a, idProduct=2460
<6>usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>usb 4-2: Product: CIF Single Chip     
<6>usb 4-2: Manufacturer: Pixart Imaging Inc. 
<7>kobject: '4-2' (c66c0c5c): kobject_add_internal: parent: 'usb4', set: 'devices'
<7>kobject: '4-2' (c66c0c5c): kobject_uevent_env
<7>kobject: '4-2' (c66c0c5c): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2'
<7>usb 4-2: uevent
<7>usb 4-2: usb_probe_device
<6>usb 4-2: configuration #1 chosen from 1 choice
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>usb 4-2: adding 4-2:1.0 (config #1, interface 0)
<7>kobject: '4-2:1.0' (c66cae14): kobject_add_internal: parent: '4-2', set: 'devices'
<7>kobject: '4-2:1.0' (c66cae14): kobject_uevent_env
<7>kobject: '4-2:1.0' (c66cae14): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2/4-2:1.0'
<7>usb 4-2:1.0: uevent
<7>usbserial_generic 4-2:1.0: usb_probe_interface
<7>usbserial_generic 4-2:1.0: usb_probe_interface - got id
<7>kobject: 'ep_81' (c651af00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_81' (c651af00): kobject_uevent_env
<7>kobject: 'ep_81' (c651af00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c66cef00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_02' (c66cef00): kobject_uevent_env
<7>kobject: 'ep_02' (c66cef00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c66d0f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_83' (c66d0f00): kobject_uevent_env
<7>kobject: 'ep_83' (c66d0f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c66d4f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_04' (c66d4f00): kobject_uevent_env
<7>kobject: 'ep_04' (c66d4f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c66d6f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_85' (c66d6f00): kobject_uevent_env
<7>kobject: 'ep_85' (c66d6f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c66d8f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_06' (c66d8f00): kobject_uevent_env
<7>kobject: 'ep_06' (c66d8f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'usbdev4.2' (c66dbef8): kobject_add_internal: parent: 'usb_device', set: 'devices'
<7>kobject: 'usbdev4.2' (c66dbef8): kobject_uevent_env
<7>kobject: 'usbdev4.2' (c66dbef8): fill_kobj_path: path = '/class/usb_device/usbdev4.2'
<7>kobject: '4-2' (c66c0c5c): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2'
<7>drivers/usb/core/inode.c: creating file '002'
<7>kobject: 'ep_00' (c66ddf00): kobject_add_internal: parent: '4-2', set: 'devices'
<7>kobject: 'ep_00' (c66ddf00): kobject_uevent_env
<7>kobject: 'ep_00' (c66ddf00): kobject_uevent_env: filter function caused the event to drop!
<7>hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>kobject: 'gspca_pac207' (c8815588): kobject_add_internal: parent: 'module', set: 'module'
<4>gspca_pac207: Unknown symbol gspca_frame_add
<4>gspca_pac207: Unknown symbol gspca_debug
<4>gspca_pac207: Unknown symbol gspca_disconnect
<4>gspca_pac207: Unknown symbol gspca_auto_gain_n_exposure
<4>gspca_pac207: Unknown symbol gspca_dev_probe
<7>kobject: 'gspca_pac207' (c8815588): kobject_cleanup
<7>kobject: 'gspca_pac207' (c8815588): does not have a release() function, it is broken and must be fixed.
<7>kobject: 'gspca_pac207': free name
<7>kobject: 'v4l1_compat' (c8850d68): kobject_add_internal: parent: 'module', set: 'module'
<7>kobject: 'holders' (c64c44f8): kobject_add_internal: parent: 'v4l1_compat', set: '<NULL>'
<7>kobject: 'v4l1_compat' (c8850d68): kobject_uevent_env
<7>kobject: 'v4l1_compat' (c8850d68): fill_kobj_path: path = '/module/v4l1_compat'
<7>kobject: 'videodev' (c8867d28): kobject_add_internal: parent: 'module', set: 'module'
<7>kobject: 'holders' (c64c4c88): kobject_add_internal: parent: 'videodev', set: '<NULL>'
<7>kobject: 'videodev' (c8867d28): kobject_uevent_env
<7>kobject: 'videodev' (c8867d28): fill_kobj_path: path = '/module/videodev'
<6>Linux video capture interface: v2.00
<7>kobject: 'video4linux' (c66fce1c): kobject_add_internal: parent: 'class', set: 'class'
<7>kobject: 'video4linux' (c66fce1c): kobject_uevent_env
<7>kobject: 'video4linux' (c66fce1c): fill_kobj_path: path = '/class/video4linux'
<7>kobject: 'gspca_main' (c8877848): kobject_add_internal: parent: 'module', set: 'module'
<7>kobject: 'holders' (c64c4b28): kobject_add_internal: parent: 'gspca_main', set: '<NULL>'
<7>kobject: 'gspca_main' (c8877848): kobject_uevent_env
<7>kobject: 'gspca_main' (c8877848): fill_kobj_path: path = '/module/gspca_main'
<6>gspca: main v2.7.0 registered
<7>kobject: 'gspca_pac207' (c887e588): kobject_add_internal: parent: 'module', set: 'module'
<7>kobject: 'holders' (c66e0658): kobject_add_internal: parent: 'gspca_pac207', set: '<NULL>'
<7>kobject: 'gspca_pac207' (c887e588): kobject_uevent_env
<7>kobject: 'gspca_pac207' (c887e588): fill_kobj_path: path = '/module/gspca_pac207'
<7>kobject: 'pac207' (c6ba4f70): kobject_add_internal: parent: 'drivers', set: 'drivers'
<7>pac207 4-2:1.0: usb_probe_interface
<7>pac207 4-2:1.0: usb_probe_interface - got id
<6>gspca: probing 093a:2460
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<6>pac207: Pixart Sensor ID 0x27 Chips ID 0x09
<6>pac207: Pixart PAC207BCA Image Processor and Control Chip detected (vid/pid 0x093A:0x2460)
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>kobject: 'video0' (c665f7fc): kobject_add_internal: parent: 'video4linux', set: 'devices'
<7>kobject: 'video0' (c665f7fc): kobject_uevent_env
<7>kobject: 'video0' (c665f7fc): fill_kobj_path: path = '/class/video4linux/video0'
<7>kobject: '4-2:1.0' (c66cae14): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2/4-2:1.0'
<6>gspca: /dev/video0 created
<7>kobject: 'drivers' (c66e0188): kobject_add_internal: parent: 'gspca_pac207', set: '<NULL>'
<7>kobject: 'pac207' (c6ba4f70): kobject_uevent_env
<7>kobject: 'pac207' (c6ba4f70): fill_kobj_path: path = '/bus/usb/drivers/pac207'
<6>usbcore: registered new interface driver pac207
<6>pac207: registered
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>kobject: 'ep_81' (c651af00): kobject_uevent_env
<7>kobject: 'ep_81' (c651af00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_81' (c651af00): kobject_cleanup
<7>kobject: 'ep_81' (c651af00): calling ktype release
<7>kobject: 'ep_81': free name
<7>kobject: 'ep_02' (c66cef00): kobject_uevent_env
<7>kobject: 'ep_02' (c66cef00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c66cef00): kobject_cleanup
<7>kobject: 'ep_02' (c66cef00): calling ktype release
<7>kobject: 'ep_02': free name
<7>kobject: 'ep_83' (c66d0f00): kobject_uevent_env
<7>kobject: 'ep_83' (c66d0f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c66d0f00): kobject_cleanup
<7>kobject: 'ep_83' (c66d0f00): calling ktype release
<7>kobject: 'ep_83': free name
<7>kobject: 'ep_04' (c66d4f00): kobject_uevent_env
<7>kobject: 'ep_04' (c66d4f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c66d4f00): kobject_cleanup
<7>kobject: 'ep_04' (c66d4f00): calling ktype release
<7>kobject: 'ep_04': free name
<7>kobject: 'ep_85' (c66d6f00): kobject_uevent_env
<7>kobject: 'ep_85' (c66d6f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c66d6f00): kobject_cleanup
<7>kobject: 'ep_85' (c66d6f00): calling ktype release
<7>kobject: 'ep_85': free name
<7>kobject: 'ep_06' (c66d8f00): kobject_uevent_env
<7>kobject: 'ep_06' (c66d8f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c66d8f00): kobject_cleanup
<7>kobject: 'ep_06' (c66d8f00): calling ktype release
<7>kobject: 'ep_06': free name
<7>kobject: 'ep_81' (c66d8f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_81' (c66d8f00): kobject_uevent_env
<7>kobject: 'ep_81' (c66d8f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c66d6f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_02' (c66d6f00): kobject_uevent_env
<7>kobject: 'ep_02' (c66d6f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c66d4f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_83' (c66d4f00): kobject_uevent_env
<7>kobject: 'ep_83' (c66d4f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c66d0f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_04' (c66d0f00): kobject_uevent_env
<7>kobject: 'ep_04' (c66d0f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c66cef00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_85' (c66cef00): kobject_uevent_env
<7>kobject: 'ep_85' (c66cef00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c651af00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_06' (c651af00): kobject_uevent_env
<7>kobject: 'ep_06' (c651af00): kobject_uevent_env: filter function caused the event to drop!
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1000
<7>ohci_hcd 0000:00:0b.0: td free c66c10c0
<7>ohci_hcd 0000:00:0b.0: td free c667>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c67>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:5: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0::00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85:00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.000:00:0b.0: td alloc for 2 ep85: c66c1a00
p85: c66c1940
<7>ohci_hcd 0000:000:00:0b.0: td ai_hcd 0000:00:0b.0: td free c6787ree c6787b40
<7>ree c6787bc0
<7>ohci_hcd 0000:00:0b.0: td free c6787c00
<7>ohci_hcd 0000:00:ree c66c1cc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1c80
<7>ohci_hcd 0000:00:0b.0: td free c66c1c40
<7>ohci_hcd 0000:00:0b.0: td free c66c1c00
<7>ohci_hcd 0000:00:0b.0: td free c66c1bc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1b80
<7>ohci_hcd 0000:00:0b.0: td free c66c1b40
<7>ohci_hcd 0000:00:0b.0: td free c66c1b00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ac0
<7>ohci_hcd 000ree c6787500
<7>ohci_hcd 0000:00:0b.0: td free c67874c0
<7>ohci_hcd 0000:00:0b.0: td free c6787480
<7>ohci_hcd 0000:00:0b.0: td free c6787440
<7>ohci_hcd 0000:00:0b.0: td free c6787400
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0ree c6787c80
<7>ohci_hcd 0000:00:0b.0: td free c6787c40
<7>ohci_hcd 0000:00:0b.0: td free c6787c00
<7>ohci_hcd 0000:00:0b.0: td free c6787bc0
<7>ohci_hcd 0000:00:0b.0: td free c6787b80
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a:00:0b.0:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67878c0:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.000:00:0b.0: td alloc for 2 p85: c6787780
<7>ohci_hcd 0000:000:00:0b.0: td alloc for 2 ep85: 7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c1a7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0:7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td : c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040:00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>o:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0::00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>o:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td allo00:00:0b.0: td allocp85: c6787780
<7>ohci_hcd 0000:000:00:0b.0: td alloc for 2 ep85:7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c1a407>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0:7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: t7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td : c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0::00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td al:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohc7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.07>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>o: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0::00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0:00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0::00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: 00:00:0b.0: td alloc for 2p85: c6787900
<7>ohci_hcd 0000:000:00:0b.0: td alloc for 2 ep85:7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:007>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td al:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_hcd 0000:00:0b:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0:00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0:00:00:0b.0: td alloc forp85: c6787180
<7>ohci_hcd 0000:000:007>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 07>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td free c6787640
<7>ohci_hcd 0000:00:0b.0: td free c6787600
<7>ohci_hcd 0000:00:0b.0: td f7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free :00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1:00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td00:00:0b.0: td alloc for 2p85: c66c1940
<7>ohci_hcd 0000:000:00:0b.0: td alloc for 2 ep85:7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free 7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 0000:00:0b.0: t7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td fr7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free c6787dc0
<7>ohci_hcd 0000:00:0b.0: td free c6787d80
<7>ohci_hcd 0000:00:0b.0: td : c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:000:00:0b.0: td alloc for 2 ep857>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c67877>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td 7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td free c6787640
<7>ohci_hcd 0000:00:0b.0: td free c6787600
<7>ohci_hcd 0000:00:0b.0:: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: t:00:0b.0: 00:00:0b.0: td allocp85: c6787f40
<7>ohci_hcd 0000:000:00:0b.0: td alloc for 2 ep85:7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c67877>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td fre7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td free c6787640
<7>ohci_hcd 0000:00:0b.0: td free c6787600
<7>ohci_hcd 0000:00:0b.0: td : c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: t:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>o:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_hcd 0000:00:0b.0: :00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 007>ohci_hcd 0007>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td f7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 0000:00:0b.0: : c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0::00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: t:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_hcd 0000:00:0b.0: t00:00:0b.0: td alloc fop85: c66c1ec0
<7>ohci_hcd 0000:000:00:0b.0: td alloc for 2 ep85: 7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free c6787dc0
<7>ohci_hcd 0000:00:0b.0: td free 7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td fre:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: :00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td :00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00::00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.00:00:0b.0: td alloc for 2 p85: c6787900
<7>ohci_hcd 0000:00:00:0b.0: td alloc for 2 ep85:7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td free c6787640
<7>ohci_hcd 0000:00:0b.0: td free c678767>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free c6787dc0
<7>ohci_hcd 0000:00:0b.0: td free c6787d80
<7>ohci_hcd 0000:00:0b.0: td fr7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>o c6787040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1cc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1c80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1c40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1c00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1bc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1b80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c66c1740
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd 0000:00:0b.0: td free c6787400
<7>ohci_hcd 0000:00:0b.0: td free c6787440
<7>ohci_hcd 0000:00:0b.0: td free c6787480
<7>ohci_hcd 0000:00:0b.0: td free c67874c0
<7>ohci_hcd 0000:00:0b.0: td free c6787500
<7>ohci_hcd 0000:00:0b.0: td free c6787540
<7>ohci_hcd 0000:00:0b.0: td free c6787580
<7>ohci_hcd 0000:00:0b.0: td free c67875c0
<7>ohci_hcd 0000:00:0b.0: td free c6787600
<7>ohci_hcd 0000:00:0b.0: td free c6787640
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787600
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67875c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787580
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787540
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787500
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67874c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787480
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787440
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787400
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67873c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd 0000:00:0b.0: td free c66c1840
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
<7>ohci_hcd 0000:00:0b.0: td free c6787b80
<7>ohci_hcd 0000:00:0b.0: td free c6787bc0
<7>ohci_hcd 0000:00:0b.0: td free c6787c00
<7>ohci_hcd 0000:00:0b.0: td free c6787c40
<7>ohci_hcd 0000:00:0b.0: td free c6787c80
<7>ohci_hcd 0000:00:0b.0: td free c6787cc0
<7>ohci_hcd 0000:00:0b.0: td free c6787d00
<7>ohci_hcd 0000:00:0b.0: td free c6787d40
<7>ohci_hcd 0000:00:0b.0: td free c6787d80
<7>ohci_hcd 0000:00:0b.0: td free c6787dc0
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787d40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787d00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787cc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787c80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787c40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787c00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787bc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1840
<7>hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>ohci_hcd 0000:00:0b.0: GetStatus roothub.portstatus [1] = 0x00030100 PESC CSC PPS
<7>hub 4-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
<6>usb 4-2: USB disconnect, address 2
<7>usb 4-2: unregistering device
<7>usb 4-2: usb_disable_device nuking all URBs
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: shutdown urb c6784bf0 ep5in-iso
<7>ohci_hcd 0000:00:0b.0: shutdown urb c6785bf0 ep5in-iso
<7>ohci_hcd 0000:00:0b.0: shutdown urb c6691bf0 ep5in-iso
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1d80
<7>ohci_hcd 0000:00:0b.0: td free c66c1d40
<7>ohci_hcd 0000:00:0b.0: td free c66c1d00
<7>ohci_hcd 0000:00:0b.0: td free c66c1cc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1c80
<7>ohci_hcd 0000:00:0b.0: td free c66c1c40
<7>ohci_hcd 0000:00:0b.0: td free c66c1c00
<7>ohci_hcd 0000:00:0b.0: td free c66c1bc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1b80
<7>ohci_hcd 0000:00:0b.0: td free c66c1b40
<7>ohci_hcd 0000:00:0b.0: td free c66c1b00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ac0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a80
<7>ohci_hcd 0000:00:0b.0: td free c66c1a40
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td free c6787640
<7>ohci_hcd 0000:00:0b.0: td free c6787600
<7>ohci_hcd 0000:00:0b.0: td free c67875c0
<7>ohci_hcd 0000:00:0b.0: td free c6787580
<7>ohci_hcd 0000:00:0b.0: td free c6787540
<7>ohci_hcd 0000:00:0b.0: td free c6787500
<7>ohci_hcd 0000:00:0b.0: td free c67874c0
<7>ohci_hcd 0000:00:0b.0: td free c6787480
<7>ohci_hcd 0000:00:0b.0: td free c6787440
<7>ohci_hcd 0000:00:0b.0: td free c6787400
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1740
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free c6787dc0
<7>ohci_hcd 0000:00:0b.0: td free c6787d80
<7>ohci_hcd 0000:00:0b.0: td free c6787d40
<7>ohci_hcd 0000:00:0b.0: td free c6787d00
<7>ohci_hcd 0000:00:0b.0: td free c6787cc0
<7>ohci_hcd 0000:00:0b.0: td free c6787c80
<7>ohci_hcd 0000:00:0b.0: td free c6787c40
<7>ohci_hcd 0000:00:0b.0: td free c6787c00
<7>ohci_hcd 0000:00:0b.0: td free c6787bc0
<7>ohci_hcd 0000:00:0b.0: td free c6787b80
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1840
<7>usb 4-2: unregistering interface 4-2:1.0
<7>kobject: 'ep_81' (c66d8f00): kobject_uevent_env
<7>kobject: 'ep_81' (c66d8f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_81' (c66d8f00): kobject_cleanup
<7>kobject: 'ep_81' (c66d8f00): calling ktype release
<7>kobject: 'ep_81': free name
<7>kobject: 'ep_02' (c66d6f00): kobject_uevent_env
<7>kobject: 'ep_02' (c66d6f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c66d6f00): kobject_cleanup
<7>kobject: 'ep_02' (c66d6f00): calling ktype release
<7>kobject: 'ep_02': free name
<7>kobject: 'ep_83' (c66d4f00): kobject_uevent_env
<7>kobject: 'ep_83' (c66d4f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c66d4f00): kobject_cleanup
<7>kobject: 'ep_83' (c66d4f00): calling ktype release
<7>kobject: 'ep_83': free name
<7>kobject: 'ep_04' (c66d0f00): kobject_uevent_env
<7>kobject: 'ep_04' (c66d0f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c66d0f00): kobject_cleanup
<7>kobject: 'ep_04' (c66d0f00): calling ktype release
<7>kobject: 'ep_04': free name
<7>kobject: 'ep_85' (c66cef00): kobject_uevent_env
<7>kobject: 'ep_85' (c66cef00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c66cef00): kobject_cleanup
<7>kobject: 'ep_85' (c66cef00): calling ktype release
<7>kobject: 'ep_85': free name
<7>kobject: 'ep_06' (c651af00): kobject_uevent_env
<7>kobject: 'ep_06' (c651af00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c651af00): kobject_cleanup
<7>kobject: 'ep_06' (c651af00): calling ktype release
<7>kobject: 'ep_06': free name
<6>gspca: /dev/video0 disconnect
<7>kobject: 'video0' (c665f7fc): kobject_uevent_env
<7>kobject: 'video0' (c665f7fc): fill_kobj_path: path = '/class/video4linux/video0'
<7>kobject: '4-2:1.0' (c66cae14): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2/4-2:1.0'
<7>kobject: 'video0' (c665f7fc): kobject_cleanup
<7>kobject: 'video0' (c665f7fc): calling ktype release
<7>kobject: '<NULL>' (c66e0130): kobject_cleanup
<7>kobject: '<NULL>' (c66e0130): calling ktype release
<6>gspca: /dev/video0 released
<7>kobject: 'video0': free name
<7>kobject: '4-2:1.0' (c66cae14): kobject_uevent_env
<7>kobject: '4-2:1.0' (c66cae14): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2/4-2:1.0'
<7>usb 4-2:1.0: uevent
<7>kobject: '4-2:1.0' (c66cae14): kobject_cleanup
<7>kobject: '4-2:1.0' (c66cae14): calling ktype release
<7>kobject: '4-2:1.0': free name
<7>kobject: 'ep_00' (c66ddf00): kobject_uevent_env
<7>kobject: 'ep_00' (c66ddf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_00' (c66ddf00): kobject_cleanup
<7>kobject: 'ep_00' (c66ddf00): calling ktype release
<7>kobject: 'ep_00': free name
<7>kobject: 'usbdev4.2' (c66dbef8): kobject_uevent_env
<7>kobject: 'usbdev4.2' (c66dbef8): fill_kobj_path: path = '/class/usb_device/usbdev4.2'
<7>kobject: '4-2' (c66c0c5c): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2'
<7>kobject: 'usbdev4.2' (c66dbef8): kobject_cleanup
<7>kobject: 'usbdev4.2' (c66dbef8): calling ktype release
<7>kobject: 'usbdev4.2': free name
<7>kobject: '4-2' (c66c0c5c): kobject_uevent_env
<7>kobject: '4-2' (c66c0c5c): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2'
<7>usb 4-2: uevent
<7>kobject: '4-2' (c66c0c5c): kobject_cleanup
<7>kobject: '4-2' (c66c0c5c): calling ktype release
<7>kobject: '4-2': free name
<4>capture-example used greatest stack depth: 5256 bytes left
<7>hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
<7>hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>ehci_hcd 0000:00:0b.1: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
<7>hub 2-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
<7>hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
<7>ehci_hcd 0000:00:0b.1: port 2 full speed --> companion
<7>ehci_hcd 0000:00:0b.1: GetStatus port 2 status 003001 POWER OWNER sig=se0 CONNECT
<7>hub 2-0:1.0: port 2 not reset yet, waiting 50ms
<7>ehci_hcd 0000:00:0b.1: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
<7>kobject: '2-2' (c66b2c5c): kobject_cleanup
<7>kobject: '2-2' (c66b2c5c): calling ktype release
<7>kobject: '2-2': free name
<7>hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>ohci_hcd 0000:00:0b.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
<7>hub 4-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
<7>hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
<7>ohci_hcd 0000:00:0b.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
<6>usb 4-2: new full speed USB device using ohci_hcd and address 3
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>usb 4-2: ep0 maxpacket = 8
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>usb 4-2: default language 0x0409
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>usb 4-2: udev 3, busnum 4, minor = 386
<6>usb 4-2: New USB device found, idVendor=093a, idProduct=2460
<6>usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>usb 4-2: Product: CIF Single Chip     
<6>usb 4-2: Manufacturer: Pixart Imaging Inc. 
<7>kobject: '4-2' (c66b2c5c): kobject_add_internal: parent: 'usb4', set: 'devices'
<7>kobject: '4-2' (c66b2c5c): kobject_uevent_env
<7>kobject: '4-2' (c66b2c5c): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2'
<7>usb 4-2: uevent
<7>usb 4-2: usb_probe_device
<6>usb 4-2: configuration #1 chosen from 1 choice
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>usb 4-2: adding 4-2:1.0 (config #1, interface 0)
<7>kobject: '4-2:1.0' (c66e5e14): kobject_add_internal: parent: '4-2', set: 'devices'
<7>kobject: '4-2:1.0' (c66e5e14): kobject_uevent_env
<7>kobject: '4-2:1.0' (c66e5e14): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2/4-2:1.0'
<7>usb 4-2:1.0: uevent
<7>usbserial_generic 4-2:1.0: usb_probe_interface
<7>usbserial_generic 4-2:1.0: usb_probe_interface - got id
<7>pac207 4-2:1.0: usb_probe_interface
<7>pac207 4-2:1.0: usb_probe_interface - got id
<6>gspca: probing 093a:2460
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<6>pac207: Pixart Sensor ID 0x27 Chips ID 0x09
<6>pac207: Pixart PAC207BCA Image Processor and Control Chip detected (vid/pid 0x093A:0x2460)
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>kobject: 'video0' (c65d77fc): kobject_add_internal: parent: 'video4linux', set: 'devices'
<7>kobject: 'video0' (c65d77fc): kobject_uevent_env
<7>kobject: 'video0' (c65d77fc): fill_kobj_path: path = '/class/video4linux/video0'
<7>kobject: '4-2:1.0' (c66e5e14): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2/4-2:1.0'
<6>gspca: /dev/video0 created
<7>kobject: 'ep_81' (c668ff00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_81' (c668ff00): kobject_uevent_env
<7>kobject: 'ep_81' (c668ff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c6686f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_02' (c6686f00): kobject_uevent_env
<7>kobject: 'ep_02' (c6686f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c6695f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_83' (c6695f00): kobject_uevent_env
<7>kobject: 'ep_83' (c6695f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c66faf00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_04' (c66faf00): kobject_uevent_env
<7>kobject: 'ep_04' (c66faf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c66dff00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_85' (c66dff00): kobject_uevent_env
<7>kobject: 'ep_85' (c66dff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c66aaf00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_06' (c66aaf00): kobject_uevent_env
<7>kobject: 'ep_06' (c66aaf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'usbdev4.3' (c6559ef8): kobject_add_internal: parent: 'usb_device', set: 'devices'
<7>kobject: 'usbdev4.3' (c6559ef8): kobject_uevent_env
<7>kobject: 'usbdev4.3' (c6559ef8): fill_kobj_path: path = '/class/usb_device/usbdev4.3'
<7>kobject: '4-2' (c66b2c5c): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2'
<7>drivers/usb/core/inode.c: creating file '003'
<7>kobject: 'ep_00' (c678bf00): kobject_add_internal: parent: '4-2', set: 'devices'
<7>kobject: 'ep_00' (c678bf00): kobject_uevent_env
<7>kobject: 'ep_00' (c678bf00): kobject_uevent_env: filter function caused the event to drop!
<7>hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>kobject: 'ep_81' (c668ff00): kobject_uevent_env
<7>kobject: 'ep_81' (c668ff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_81' (c668ff00): kobject_cleanup
<7>kobject: 'ep_81' (c668ff00): calling ktype release
<7>kobject: 'ep_81': free name
<7>kobject: 'ep_02' (c6686f00): kobject_uevent_env
<7>kobject: 'ep_02' (c6686f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c6686f00): kobject_cleanup
<7>kobject: 'ep_02' (c6686f00): calling ktype release
<7>kobject: 'ep_02': free name
<7>kobject: 'ep_83' (c6695f00): kobject_uevent_env
<7>kobject: 'ep_83' (c6695f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c6695f00): kobject_cleanup
<7>kobject: 'ep_83' (c6695f00): calling ktype release
<7>kobject: 'ep_83': free name
<7>kobject: 'ep_04' (c66faf00): kobject_uevent_env
<7>kobject: 'ep_04' (c66faf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c66faf00): kobject_cleanup
<7>kobject: 'ep_04' (c66faf00): calling ktype release
<7>kobject: 'ep_04': free name
<7>kobject: 'ep_85' (c66dff00): kobject_uevent_env
<7>kobject: 'ep_85' (c66dff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c66dff00): kobject_cleanup
<7>kobject: 'ep_85' (c66dff00): calling ktype release
<7>kobject: 'ep_85': free name
<7>kobject: 'ep_06' (c66aaf00): kobject_uevent_env
<7>kobject: 'ep_06' (c66aaf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c66aaf00): kobject_cleanup
<7>kobject: 'ep_06' (c66aaf00): calling ktype release
<7>kobject: 'ep_06': free name
<7>kobject: 'ep_81' (c66aaf00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_81' (c66aaf00): kobject_uevent_env
<7>kobject: 'ep_81' (c66aaf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c66dff00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_02' (c66dff00): kobject_uevent_env
<7>kobject: 'ep_02' (c66dff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c66faf00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_83' (c66faf00): kobject_uevent_env
<7>kobject: 'ep_83' (c66faf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c6695f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_04' (c6695f00): kobject_uevent_env
<7>kobject: 'ep_04' (c6695f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c6686f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_85' (c6686f00): kobject_uevent_env
<7>kobject: 'ep_85' (c6686f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c668ff00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_06' (c668ff00): kobject_uevent_env
<7>kobject: 'ep_06' (c668ff00): kobject_uevent_env: filter function caused the event to drop!
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c67879d 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:007>ohci_hcd 0000:00:0b.0: td free c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_hcd 000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f80
<7>ohci00:00:0b.0: td alloc for 2 ep85: c67879c0
<700:00:0b.0: td alloc for 2 ep85 i_hcd 0000:00:0ree c66c1b00
<7>ohci_hcd 0000:ree c66c1b80
<7>ohci_hcd 0000:00:0b.0: td free c66c1bc0
<7>ohci_hcd 0000:00:0b.0: tree c6787d40
<7>ohci_hcd 0000:00:0b.0: td free c6787d00
<7>ohci_hcd 0000:00:0b.0: td free c6787cc0
<7>ohci_hcd 0000:00:0b.0: td free c6787c80
<7>ohci_hcd 0000:00:0b.0: td free c6787c40
<7>ohci_hcd 0000:00:0b.0: td free c6787c00
<7>ohci_hcd 0000:00:0b.0: td free c6787bc0
<7>ohci_hcd 0000:00:0b.0: td free c6787b80
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
ree c67875c0
<7>ohci_hcd 0000:00:0b.0: td free c6787580
<7>ohci_hcd 0000:00:0b.0: td free c6787540
<7>ohci_hcd 0000:00:0b.0: td free c6787500
<7>ohci_hcd 0000:00:0b.0: td free c67874c0
<7>ohci_hcd 0000:00:0b.0: td free c6787480
<7>ohci_hcd 0000:00:0b.0: td free c6787440
<7>ohci_hcd 0000:00:0b.0: td free c6787400
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c678734ree c66c1cc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1c80
<7>ohci_hcd 0000:00:0b.0: td free c66c1c40
<7>ohci_hcd 0000:00:0b.0: td free c66c1c00
<7>ohci_hcd 0000:00:0b.0: td free c66c1bc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1b80
<7>ohci_hcd 0000:00:0b.0: td free c66c1b40
<7>ohci_hcd 0000:00:0b.0: td free c66c1b00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ac0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a80
<7>ohci_hcd 0000:00:0b.0: td free c66c1a40
<: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a4 c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>oh00:00:0b.0: td alloc for 2 p85: c66c1f00
<700:00:0b.0: td alloc for 2 ep857>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c1a40
<7>ohci_hcd 0000:00:0b.0: td free c66c1a80
<7>ohci_hcd 0000:00:0b7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 07>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f80
<7>ohci_:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep87>ohci_hcd 0000:00:0b.0: td free c6787180
<7>oh7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0007>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f80
<7>ohci_hcd 00:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 e:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for p85: c6787080
<00:00:0b.0: td alloc for 2 ep857>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc07>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td al:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: :00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 00:00:0b.0: td alloc for 2 ep85: c66c1940
<00:00:0b.0: td alloc for 2 ep857>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c677>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 07>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd 00: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85::00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_h00:00:0b.0: td alloc for 2p85: c6787240
00:00:0b.0: td alloc for 2 ep857>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
<7>ohci_hcd 00: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for :00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0:00:00:0b.0: td alloc fp85: c6787240
00:00:0b.0: td alloc for 2 ep857>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e407>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>oh: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 00:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohc:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep8:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_h:00:0b.0: td7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0007>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_h7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 00: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000::00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohc:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_hcd 00:00:0b.0: td alloc for 2 p85: c66c1f00
<00:00:0b.0: td alloc for 2 ep857>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c67873c7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc f:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd00:00:0b.0: td alloc for 2 epp85: c6787840
00:00:0b.0: td alloc for 2 ep85:7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohc7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:007>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 00: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td f:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 e:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 00:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd00:00:0b.0: td alloc for 2p85: c6787080
<00:00:0b.0: td alloc for 2 ep85:7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1d7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
<7>ohci_hcd 00007>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:007>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c1a40
<7>ohci_hcd 0000:00:0b.0: td free c66c1a80
<7>ohci_hc: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 e:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 07>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_h: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for :00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep8:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>o:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_hcd 0:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep8:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c6787380
<7>oh7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_h7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd 0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f80
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_hcd00:00:0b.0: td alloc for 2p85: c6787240
<00:00:0b.0: td alloc for 2 ep85:7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td f:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f80
<7>ohci_hcd 000:00:0b.0: td alloc for 2 p85: c67879c0
<00:00:0b.0: td alloc for 2 ep857>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c1a40
<7>ohci_hcd 0000:07>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 00007>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:07>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 00: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: :00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_hcd 00:00:0b.0: td alloc for 2 p85: c66c1f00
<00:00:0b.0: td alloc for 2 ep857>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c67>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c1a40
<7>ohci_hcd 0000:00:0b.0: td free c66c1a80
<7>ohci_hcd 07>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:07>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hc7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd td free c66c18c0
<7>ohci_hcdi_hcd 0000:00:0b.0: td free c6ree c66c1b00
<7>ohci_hcd 0000:00:00:0b.0: td alloc for 2 ep85: c66c1d40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d00
<7>oh7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td fre c6787a40
<70: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67873c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787400
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787440
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787480
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67874c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787500
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787540
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787580
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67875c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787600
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1d80
<7>ohci_hcd 0000:00:0b.0: td free c66c1d40
<7>ohci_hcd 0000:00:0b.0: td free c66c1d00
<7>ohci_hcd 0000:00:0b.0: td free c66c1cc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1c80
<7>ohci_hcd 0000:00:0b.0: td free c66c1c40
<7>ohci_hcd 0000:00:0b.0: td free c66c1c00
<7>ohci_hcd 0000:00:0b.0: td free c66c1bc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1b80
<7>ohci_hcd 0000:00:0b.0: td free c66c1b40
<7>ohci_hcd 0000:00:0b.0: td free c66c1b00
<7>ohci_hcd 0000:00:0b.0: td free c66c1ac0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a80
<7>ohci_hcd 0000:00:0b.0: td free c66c1a40
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1b80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1bc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1c00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1c40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1c80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1cc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
<7>ohci_hcd 0000:00:0b.0: td free c6787b80
<7>ohci_hcd 0000:00:0b.0: td free c6787bc0
<7>ohci_hcd 0000:00:0b.0: td free c6787c00
<7>ohci_hcd 0000:00:0b.0: td free c6787c40
<7>ohci_hcd 0000:00:0b.0: td free c6787c80
<7>ohci_hcd 0000:00:0b.0: td free c6787cc0
<7>ohci_hcd 0000:00:0b.0: td free c6787d00
<7>ohci_hcd 0000:00:0b.0: td free c6787d40
<7>ohci_hcd 0000:00:0b.0: td free c6787d80
<7>ohci_hcd 0000:00:0b.0: td free c6787dc0
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787d40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787d00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787cc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787c80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787c40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787c00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787bc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c17c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c16c0
<7>ohci_hcd 0000:00:0b.0: td free c66c17c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1840
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd 0000:00:0b.0: td free c6787400
<7>ohci_hcd 0000:00:0b.0: td free c6787440
<7>ohci_hcd 0000:00:0b.0: td free c6787480
<7>ohci_hcd 0000:00:0b.0: td free c67874c0
<7>ohci_hcd 0000:00:0b.0: td free c6787500
<7>ohci_hcd 0000:00:0b.0: td free c6787540
<7>ohci_hcd 0000:00:0b.0: td free c6787580
<7>ohci_hcd 0000:00:0b.0: td free c67875c0
<7>ohci_hcd 0000:00:0b.0: td free c6787600
<7>ohci_hcd 0000:00:0b.0: td free c6787640
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free c6787dc0
<7>ohci_hcd 0000:00:0b.0: td free c6787d80
<7>ohci_hcd 0000:00:0b.0: td free c6787d40
<7>ohci_hcd 0000:00:0b.0: td free c6787d00
<7>ohci_hcd 0000:00:0b.0: td free c6787cc0
<7>ohci_hcd 0000:00:0b.0: td free c6787c80
<7>ohci_hcd 0000:00:0b.0: td free c6787c40
<7>ohci_hcd 0000:00:0b.0: td free c6787c00
<7>ohci_hcd 0000:00:0b.0: td free c6787bc0
<7>ohci_hcd 0000:00:0b.0: td free c6787b80
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c66c1740
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c1a40
<7>ohci_hcd 0000:00:0b.0: td free c66c1a80
<7>ohci_hcd 0000:00:0b.0: td free c66c1ac0
<7>ohci_hcd 0000:00:0b.0: td free c66c1b00
<7>ohci_hcd 0000:00:0b.0: td free c66c1b40
<7>ohci_hcd 0000:00:0b.0: td free c66c1b80
<7>ohci_hcd 0000:00:0b.0: td free c66c1bc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1c00
<7>ohci_hcd 0000:00:0b.0: td free c66c1c40
<7>ohci_hcd 0000:00:0b.0: td free c66c1c80
<7>ohci_hcd 0000:00:0b.0: td free c66c1cc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1d00
<7>ohci_hcd 0000:00:0b.0: td free c66c1d40
<7>ohci_hcd 0000:00:0b.0: td free c66c1d80
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>kobject: 'ep_81' (c66aaf00): kobject_uevent_env
<7>kobject: 'ep_81' (c66aaf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_81' (c66aaf00): kobject_cleanup
<7>kobject: 'ep_81' (c66aaf00): calling ktype release
<7>kobject: 'ep_81': free name
<7>kobject: 'ep_02' (c66dff00): kobject_uevent_env
<7>kobject: 'ep_02' (c66dff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c66dff00): kobject_cleanup
<7>kobject: 'ep_02' (c66dff00): calling ktype release
<7>kobject: 'ep_02': free name
<7>kobject: 'ep_83' (c66faf00): kobject_uevent_env
<7>kobject: 'ep_83' (c66faf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c66faf00): kobject_cleanup
<7>kobject: 'ep_83' (c66faf00): calling ktype release
<7>kobject: 'ep_83': free name
<7>kobject: 'ep_04' (c6695f00): kobject_uevent_env
<7>kobject: 'ep_04' (c6695f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c6695f00): kobject_cleanup
<7>kobject: 'ep_04' (c6695f00): calling ktype release
<7>kobject: 'ep_04': free name
<7>kobject: 'ep_85' (c6686f00): kobject_uevent_env
<7>kobject: 'ep_85' (c6686f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c6686f00): kobject_cleanup
<7>kobject: 'ep_85' (c6686f00): calling ktype release
<7>kobject: 'ep_85': free name
<7>kobject: 'ep_06' (c668ff00): kobject_uevent_env
<7>kobject: 'ep_06' (c668ff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c668ff00): kobject_cleanup
<7>kobject: 'ep_06' (c668ff00): calling ktype release
<7>kobject: 'ep_06': free name
<7>ohci_hcd 0000:00:0b.0: td free c66c1800
<7>kobject: 'ep_81' (c668ff00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_81' (c668ff00): kobject_uevent_env
<7>kobject: 'ep_81' (c668ff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c6686f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_02' (c6686f00): kobject_uevent_env
<7>kobject: 'ep_02' (c6686f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c6695f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_83' (c6695f00): kobject_uevent_env
<7>kobject: 'ep_83' (c6695f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c66faf00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_04' (c66faf00): kobject_uevent_env
<7>kobject: 'ep_04' (c66faf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c66dff00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_85' (c66dff00): kobject_uevent_env
<7>kobject: 'ep_85' (c66dff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c66aaf00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_06' (c66aaf00): kobject_uevent_env
<7>kobject: 'ep_06' (c66aaf00): kobject_uevent_env: filter function caused the event to drop!
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>kobject: 'ep_81' (c668ff00): kobject_uevent_env
<7>kobject: 'ep_81' (c668ff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_81' (c668ff00): kobject_cleanup
<7>kobject: 'ep_81' (c668ff00): calling ktype release
<7>kobject: 'ep_81': free name
<7>kobject: 'ep_02' (c6686f00): kobject_uevent_env
<7>kobject: 'ep_02' (c6686f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c6686f00): kobject_cleanup
<7>kobject: 'ep_02' (c6686f00): calling ktype release
<7>kobject: 'ep_02': free name
<7>kobject: 'ep_83' (c6695f00): kobject_uevent_env
<7>kobject: 'ep_83' (c6695f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c6695f00): kobject_cleanup
<7>kobject: 'ep_83' (c6695f00): calling ktype release
<7>kobject: 'ep_83': free name
<7>kobject: 'ep_04' (c66faf00): kobject_uevent_env
<7>kobject: 'ep_04' (c66faf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c66faf00): kobject_cleanup
<7>kobject: 'ep_04' (c66faf00): calling ktype release
<7>kobject: 'ep_04': free name
<7>kobject: 'ep_85' (c66dff00): kobject_uevent_env
<7>kobject: 'ep_85' (c66dff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c66dff00): kobject_cleanup
<7>kobject: 'ep_85' (c66dff00): calling ktype release
<7>kobject: 'ep_85': free name
<7>kobject: 'ep_06' (c66aaf00): kobject_uevent_env
<7>kobject: 'ep_06' (c66aaf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c66aaf00): kobject_cleanup
<7>kobject: 'ep_06' (c66aaf00): calling ktype release
<7>kobject: 'ep_06': free name
<7>kobject: 'ep_81' (c66aaf00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_81' (c66aaf00): kobject_uevent_env
<7>kobject: 'ep_81' (c66aaf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c66dff00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_02' (c66dff00): kobject_uevent_env
<7>kobject: 'ep_02' (c66dff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c66faf00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_83' (c66faf00): kobject_uevent_env
<7>kobject: 'ep_83' (c66faf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c6695f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_04' (c6695f00): kobject_uevent_env
<7>kobject: 'ep_04' (c6695f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c6686f00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_85' (c6686f00): kobject_uevent_env
<7>kobject: 'ep_85' (c6686f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c668ff00): kobject_add_internal: parent: '4-2:1.0', set: 'devices'
<7>kobject: 'ep_06' (c668ff00): kobject_uevent_env
<7>kobject: 'ep_06' (c668ff00): kobject_uevent_env: filter function caused the event to drop!
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787980
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd d 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787880
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep0: c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0 ep85: c6787140
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6::00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc :00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>oh:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep8:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: :00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd 0:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for :00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00::00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc fo:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd 000:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td allo:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>oh:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc f:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00::00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td al:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc :00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohc:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c678710:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 e:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc :00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for :00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohc:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85::00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for :00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohc:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>oh:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd 000:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc :00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 e:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc f:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000::00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for :00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00::00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td allo:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>oh:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>oh:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>oh:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd 0000:00:0:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000::00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohc:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep8:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hc:00:0b.0: td alloc for 2 ep85: c67876c0
<:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_h:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd :00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohc:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 :00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>o ep85: c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c66c1780free c66c1a40
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c1or 2 ep85: c66c1040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1880
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c18c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c19c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1b80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1bc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1c00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1c40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1c80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1cc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free c6787dc0
<7>ohci_hcd 0000:00:0b.0: td free c6787d80
<7>ohci_hcd 0000:00:0b.0: td free c6787d40
<7>ohci_hcd 0000:00:0b.0: td free c6787d00
<7>ohci_hcd 0000:00:0b.0: td free c6787cc0
<7>ohci_hcd 0000:00:0b.0: td free c6787c80
<7>ohci_hcd 0000:00:0b.0: td free c6787c40
<7>ohci_hcd 0000:00:0b.0: td free c6787c00
<7>ohci_hcd 0000:00:0b.0: td free c6787bc0
<7>ohci_hcd 0000:00:0b.0: td free c6787b80
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787940
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787980
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67879c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787a80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ac0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787b80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787bc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787c00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787c40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787c80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787cc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787d00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787d40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787d80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787dc0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787e80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787ec0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f00
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f40
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787f80
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787080
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67870c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787100
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787140
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787900
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd 0000:00:0b.0: td free c6787400
<7>ohci_hcd 0000:00:0b.0: td free c6787440
<7>ohci_hcd 0000:00:0b.0: td free c6787480
<7>ohci_hcd 0000:00:0b.0: td free c67874c0
<7>ohci_hcd 0000:00:0b.0: td free c6787500
<7>ohci_hcd 0000:00:0b.0: td free c6787540
<7>ohci_hcd 0000:00:0b.0: td free c6787580
<7>ohci_hcd 0000:00:0b.0: td free c67875c0
<7>ohci_hcd 0000:00:0b.0: td free c6787600
<7>ohci_hcd 0000:00:0b.0: td free c6787640
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787040
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787000
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787840
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787800
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67877c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787780
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787740
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787700
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67876c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787680
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787640
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787600
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67875c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787580
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787540
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787500
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67874c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787480
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787440
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787400
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67873c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787380
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787340
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787300
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67872c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787280
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787240
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787200
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67871c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c6787180
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c67878c0
<7>ohci_hcd 0000:00:0b.0: td alloc for 2 ep85: c66c1780
<7>hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>ohci_hcd 0000:00:0b.0: GetStatus roothub.portstatus [1] = 0x00030100 PESC CSC PPS
<7>hub 4-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
<6>usb 4-2: USB disconnect, address 3
<7>usb 4-2: unregistering device
<7>usb 4-2: usb_disable_device nuking all URBs
<7>ohci_hcd 0000:00:0b.0: td free c6787880
<7>ohci_hcd 0000:00:0b.0: shutdown urb c6731bf0 ep5in-iso
<7>ohci_hcd 0000:00:0b.0: shutdown urb c672fbf0 ep5in-iso
<7>ohci_hcd 0000:00:0b.0: shutdown urb c6730bf0 ep5in-iso
<7>ohci_hcd 0000:00:0b.0: td free c66c1840
<7>ohci_hcd 0000:00:0b.0: td free c66c1040
<7>ohci_hcd 0000:00:0b.0: td free c66c1740
<7>ohci_hcd 0000:00:0b.0: td free c66c1880
<7>ohci_hcd 0000:00:0b.0: td free c66c18c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1900
<7>ohci_hcd 0000:00:0b.0: td free c66c1940
<7>ohci_hcd 0000:00:0b.0: td free c66c1980
<7>ohci_hcd 0000:00:0b.0: td free c66c19c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1a00
<7>ohci_hcd 0000:00:0b.0: td free c66c1a40
<7>ohci_hcd 0000:00:0b.0: td free c66c1a80
<7>ohci_hcd 0000:00:0b.0: td free c66c1ac0
<7>ohci_hcd 0000:00:0b.0: td free c66c1b00
<7>ohci_hcd 0000:00:0b.0: td free c66c1b40
<7>ohci_hcd 0000:00:0b.0: td free c66c1b80
<7>ohci_hcd 0000:00:0b.0: td free c66c1bc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1c00
<7>ohci_hcd 0000:00:0b.0: td free c66c1c40
<7>ohci_hcd 0000:00:0b.0: td free c66c1c80
<7>ohci_hcd 0000:00:0b.0: td free c66c1cc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1d00
<7>ohci_hcd 0000:00:0b.0: td free c66c1d40
<7>ohci_hcd 0000:00:0b.0: td free c66c1d80
<7>ohci_hcd 0000:00:0b.0: td free c66c1dc0
<7>ohci_hcd 0000:00:0b.0: td free c66c1e00
<7>ohci_hcd 0000:00:0b.0: td free c66c1e40
<7>ohci_hcd 0000:00:0b.0: td free c66c1e80
<7>ohci_hcd 0000:00:0b.0: td free c66c1ec0
<7>ohci_hcd 0000:00:0b.0: td free c66c1f00
<7>ohci_hcd 0000:00:0b.0: td free c66c1f40
<7>ohci_hcd 0000:00:0b.0: td free c66c1f80
<7>ohci_hcd 0000:00:0b.0: td free c66c1700
<7>ohci_hcd 0000:00:0b.0: td free c6787940
<7>ohci_hcd 0000:00:0b.0: td free c6787980
<7>ohci_hcd 0000:00:0b.0: td free c67879c0
<7>ohci_hcd 0000:00:0b.0: td free c6787a00
<7>ohci_hcd 0000:00:0b.0: td free c6787a40
<7>ohci_hcd 0000:00:0b.0: td free c6787a80
<7>ohci_hcd 0000:00:0b.0: td free c6787ac0
<7>ohci_hcd 0000:00:0b.0: td free c6787b00
<7>ohci_hcd 0000:00:0b.0: td free c6787b40
<7>ohci_hcd 0000:00:0b.0: td free c6787b80
<7>ohci_hcd 0000:00:0b.0: td free c6787bc0
<7>ohci_hcd 0000:00:0b.0: td free c6787c00
<7>ohci_hcd 0000:00:0b.0: td free c6787c40
<7>ohci_hcd 0000:00:0b.0: td free c6787c80
<7>ohci_hcd 0000:00:0b.0: td free c6787cc0
<7>ohci_hcd 0000:00:0b.0: td free c6787d00
<7>ohci_hcd 0000:00:0b.0: td free c6787d40
<7>ohci_hcd 0000:00:0b.0: td free c6787d80
<7>ohci_hcd 0000:00:0b.0: td free c6787dc0
<7>ohci_hcd 0000:00:0b.0: td free c6787e00
<7>ohci_hcd 0000:00:0b.0: td free c6787e40
<7>ohci_hcd 0000:00:0b.0: td free c6787e80
<7>ohci_hcd 0000:00:0b.0: td free c6787ec0
<7>ohci_hcd 0000:00:0b.0: td free c6787f00
<7>ohci_hcd 0000:00:0b.0: td free c6787f40
<7>ohci_hcd 0000:00:0b.0: td free c6787f80
<7>ohci_hcd 0000:00:0b.0: td free c6787080
<7>ohci_hcd 0000:00:0b.0: td free c67870c0
<7>ohci_hcd 0000:00:0b.0: td free c6787100
<7>ohci_hcd 0000:00:0b.0: td free c6787140
<7>ohci_hcd 0000:00:0b.0: td free c6787900
<7>ohci_hcd 0000:00:0b.0: td free c66c1800
<7>ohci_hcd 0000:00:0b.0: td free c6787040
<7>ohci_hcd 0000:00:0b.0: td free c6787000
<7>ohci_hcd 0000:00:0b.0: td free c6787840
<7>ohci_hcd 0000:00:0b.0: td free c6787800
<7>ohci_hcd 0000:00:0b.0: td free c67877c0
<7>ohci_hcd 0000:00:0b.0: td free c6787780
<7>ohci_hcd 0000:00:0b.0: td free c6787740
<7>ohci_hcd 0000:00:0b.0: td free c6787700
<7>ohci_hcd 0000:00:0b.0: td free c67876c0
<7>ohci_hcd 0000:00:0b.0: td free c6787680
<7>ohci_hcd 0000:00:0b.0: td free c6787640
<7>ohci_hcd 0000:00:0b.0: td free c6787600
<7>ohci_hcd 0000:00:0b.0: td free c67875c0
<7>ohci_hcd 0000:00:0b.0: td free c6787580
<7>ohci_hcd 0000:00:0b.0: td free c6787540
<7>ohci_hcd 0000:00:0b.0: td free c6787500
<7>ohci_hcd 0000:00:0b.0: td free c67874c0
<7>ohci_hcd 0000:00:0b.0: td free c6787480
<7>ohci_hcd 0000:00:0b.0: td free c6787440
<7>ohci_hcd 0000:00:0b.0: td free c6787400
<7>ohci_hcd 0000:00:0b.0: td free c67873c0
<7>ohci_hcd 0000:00:0b.0: td free c6787380
<7>ohci_hcd 0000:00:0b.0: td free c6787340
<7>ohci_hcd 0000:00:0b.0: td free c6787300
<7>ohci_hcd 0000:00:0b.0: td free c67872c0
<7>ohci_hcd 0000:00:0b.0: td free c6787280
<7>ohci_hcd 0000:00:0b.0: td free c6787240
<7>ohci_hcd 0000:00:0b.0: td free c6787200
<7>ohci_hcd 0000:00:0b.0: td free c67871c0
<7>ohci_hcd 0000:00:0b.0: td free c6787180
<7>ohci_hcd 0000:00:0b.0: td free c67878c0
<7>ohci_hcd 0000:00:0b.0: td free c66c1780
<7>ohci_hcd 0000:00:0b.0: poisoned hash at c678779c
<7>usb 4-2: unregistering interface 4-2:1.0
<7>kobject: 'ep_81' (c66aaf00): kobject_uevent_env
<7>kobject: 'ep_81' (c66aaf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_81' (c66aaf00): kobject_cleanup
<7>kobject: 'ep_81' (c66aaf00): calling ktype release
<7>kobject: 'ep_81': free name
<7>kobject: 'ep_02' (c66dff00): kobject_uevent_env
<7>kobject: 'ep_02' (c66dff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_02' (c66dff00): kobject_cleanup
<7>kobject: 'ep_02' (c66dff00): calling ktype release
<7>kobject: 'ep_02': free name
<7>kobject: 'ep_83' (c66faf00): kobject_uevent_env
<7>kobject: 'ep_83' (c66faf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_83' (c66faf00): kobject_cleanup
<7>kobject: 'ep_83' (c66faf00): calling ktype release
<7>kobject: 'ep_83': free name
<7>kobject: 'ep_04' (c6695f00): kobject_uevent_env
<7>kobject: 'ep_04' (c6695f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_04' (c6695f00): kobject_cleanup
<7>kobject: 'ep_04' (c6695f00): calling ktype release
<7>kobject: 'ep_04': free name
<7>kobject: 'ep_85' (c6686f00): kobject_uevent_env
<7>kobject: 'ep_85' (c6686f00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_85' (c6686f00): kobject_cleanup
<7>kobject: 'ep_85' (c6686f00): calling ktype release
<7>kobject: 'ep_85': free name
<7>kobject: 'ep_06' (c668ff00): kobject_uevent_env
<7>kobject: 'ep_06' (c668ff00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_06' (c668ff00): kobject_cleanup
<7>kobject: 'ep_06' (c668ff00): calling ktype release
<7>kobject: 'ep_06': free name
<6>gspca: /dev/video0 disconnect
<7>kobject: 'video0' (c65d77fc): kobject_uevent_env
<7>kobject: 'video0' (c65d77fc): fill_kobj_path: path = '/class/video4linux/video0'
<7>kobject: '4-2:1.0' (c66e5e14): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2/4-2:1.0'
<7>kobject: 'video0' (c65d77fc): kobject_cleanup
<7>kobject: 'video0' (c65d77fc): calling ktype release
<7>kobject: '<NULL>' (c64c4fa0): kobject_cleanup
<7>kobject: '<NULL>' (c64c4fa0): calling ktype release
<6>gspca: /dev/video0 released
<7>kobject: 'video0': free name
<7>kobject: '4-2:1.0' (c66e5e14): kobject_uevent_env
<7>kobject: '4-2:1.0' (c66e5e14): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2/4-2:1.0'
<7>usb 4-2:1.0: uevent
<7>kobject: '4-2:1.0' (c66e5e14): kobject_cleanup
<7>kobject: '4-2:1.0' (c66e5e14): calling ktype release
<7>kobject: '4-2:1.0': free name
<7>kobject: 'ep_00' (c678bf00): kobject_uevent_env
<7>kobject: 'ep_00' (c678bf00): kobject_uevent_env: filter function caused the event to drop!
<7>kobject: 'ep_00' (c678bf00): kobject_cleanup
<7>kobject: 'ep_00' (c678bf00): calling ktype release
<7>kobject: 'ep_00': free name
<7>kobject: 'usbdev4.3' (c6559ef8): kobject_uevent_env
<7>kobject: 'usbdev4.3' (c6559ef8): fill_kobj_path: path = '/class/usb_device/usbdev4.3'
<7>kobject: '4-2' (c66b2c5c): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2'
<7>kobject: 'usbdev4.3' (c6559ef8): kobject_cleanup
<7>kobject: 'usbdev4.3' (c6559ef8): calling ktype release
<7>kobject: 'usbdev4.3': free name
<7>kobject: '4-2' (c66b2c5c): kobject_uevent_env
<7>kobject: '4-2' (c66b2c5c): fill_kobj_path: path = '/devices/pci0000:00/0000:00:0b.0/usb4/4-2'
<7>usb 4-2: uevent
<7>kobject: '4-2' (c66b2c5c): kobject_cleanup
<7>kobject: '4-2' (c66b2c5c): calling ktype release
<7>kobject: '4-2': free name
<7>hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100

--------------050402050202090405040601--
