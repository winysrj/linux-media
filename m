Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:45742 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab1IWMEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 08:04:16 -0400
Date: Fri, 23 Sep 2011 14:04:04 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: cx231xx: DMA problem on ARM
Message-ID: <20110923140404.5816c056@skate>
In-Reply-To: <20110922172929.16df967f@skate>
References: <20110921135604.64363a2e@skate>
	<CAGoCfiyFbHcZO-Rz2VFr249NprqvhQhcSPBLHRj_Txs9gimYqA@mail.gmail.com>
	<20110922164508.395c2900@skate>
	<CAGoCfiy_RVbgq+3WTsC=ZrJsOfDYEWUov6meOU8=ShACBM7J2g@mail.gmail.com>
	<20110922172929.16df967f@skate>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Devin,

Le Thu, 22 Sep 2011 17:29:29 +0200,
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> a écrit :

> I guess you're talking about 44ecf1df9493e6684cd1bb34abb107a0ffe1078a,
> which ensures a 10ms msleep call. We don't have this patch, but as with
> CONFIG_HZ=100, msleep() calls are anyway rounded up to 10ms, so I'm not
> sure this patch will have a huge impact. But we will try.
> 
> Then, there is also de99d5328c6d54694471da28711a05adec708c3b, but it
> doesn't seem to be related to our problem. But we will also try with
> that one.

So, we have now tried with Linux 3.0 and the following additional
patches:

 * 992299e84a4891275ea5924e30b66ce39a701e5e (Fix regression
   introduced which broke the Hauppauge USBLive 2)
 * 44ecf1df9493e6684cd1bb34abb107a0ffe1078a (cx231xx: Fix power ramping
   issue)
 * de99d5328c6d54694471da28711a05adec708c3b (cx231xx: Provide
   signal lock status in G_INPUT)
 * the DMA fix

And still the result is the same: we get a first frame, and then
nothing more, and we have a large number of error messages in the
kernel logs.

[   18.833587] cx231xx v4l2 driver loaded.
[   18.833831] cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 5 interfaces
[   18.833862] cx231xx #0: registering interface 1
[   18.854492] cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size = 0
[   19.185943] cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size = 0
[   19.405700] cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
[   19.692993] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[   20.238159] cx25840 4-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0)
[   20.333740] cx25840 4-0044:  Firmware download size changed to 16 bytes max length
[   21.783569] smsc95xx 1-2.1:1.0: eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
[   22.921936] cx25840 4-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
[   22.960815] cx231xx #0: cx231xx #0: v4l2 driver version 0.0.1
[   22.989715] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[   23.042663] cx231xx #0: video_mux : 0
[   23.042694] cx231xx #0: do_mode_ctrl_overrides : 0xb000
[   23.043548] cx231xx #0: do_mode_ctrl_overrides NTSC
[   23.056213] cx231xx #0: cx231xx #0/0: registered device video0 [v4l2]
[   23.061035] cx231xx #0: cx231xx #0/0: registered device vbi0
[   23.061065] cx231xx #0: V4L2 device registered as video0 and vbi0
[   23.061096] cx231xx #0: EndPoint Addr 0x84, Alternate settings: 5
[   23.061096] cx231xx #0: Alternate setting 0, max size= 512
[   23.061126] cx231xx #0: Alternate setting 1, max size= 184
[   23.061126] cx231xx #0: Alternate setting 2, max size= 728
[   23.061157] cx231xx #0: Alternate setting 3, max size= 2892
[   23.061157] cx231xx #0: Alternate setting 4, max size= 1800
[   23.061187] cx231xx #0: EndPoint Addr 0x85, Alternate settings: 2
[   23.061187] cx231xx #0: Alternate setting 0, max size= 512
[   23.061218] cx231xx #0: Alternate setting 1, max size= 512
[   23.061218] cx231xx #0: EndPoint Addr 0x86, Alternate settings: 2
[   23.061248] cx231xx #0: Alternate setting 0, max size= 512
[   23.061248] cx231xx #0: Alternate setting 1, max size= 576
[   23.067108] usbcore: registered new interface driver cx231xx
[   23.360412] cx231xx #0:  setPowerMode::mode = 48, No Change req.
[   23.365905] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[   23.367156] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[   23.872253] cx231xx #0: cx231xx-audio.c: probing for cx231xx non standard usbaudio
[   23.875762] cx231xx #0: EndPoint Addr 0x83, Alternate settings: 3
[   23.875793] cx231xx #0: Alternate setting 0, max size= 512
[   23.875793] cx231xx #0: Alternate setting 1, max size= 28
[   23.875823] cx231xx #0: Alternate setting 2, max size= 52
[   23.875823] cx231xx: Cx231xx Audio Extension initialized
[   24.794891] lp: driver loaded but no devices found
[   24.880157] ppdev: user-space parallel port driver
[   30.872589] eth0: no IPv6 routers present
[  183.789154] omap_device: omap-mcbsp.2: new worst case activate latency 0: 30517
[  183.829803] omap_device: omap-mcbsp.2: new worst case deactivate latency 0: 30517
[  184.355712] omap_device: omap-mcbsp.2: new worst case deactivate latency 0: 61035
[  186.400878] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
[  186.401855] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
[  186.404571] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
[  186.405578] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
[  186.408050] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
[  186.409332] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
[  186.412109] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
[  186.414306] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
[  186.416961] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
[  186.418060] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
[  186.427520] cx231xx #0: cx231xx_start_stream():: ep_mask = 4
[  186.498504] cx231xx #0: cx231xx_init_audio_isoc: Starting ISO AUDIO transfers
[  194.358123] cx231xx #0: cx231xx_stop_stream():: ep_mask = 4
[  393.839813] cx231xx #0:  setPowerMode::mode = 48, No Change req.
[  393.842834] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[  393.844024] cx231xx #0:  setPowerMode::mode = 48, No Change req.
[  394.126953] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[  394.133605] cx231xx #0: cx231xx_initialize_stream_xfer: set video registers
[  394.134094] cx231xx #0: cx231xx_start_stream():: ep_mask = 8
[  559.661468] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  559.665985] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  559.721374] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[  559.731079] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)
[  942.321258] cx231xx #0:  setPowerMode::mode = 48, No Change req.
[  942.325469] cx231xx #0: cannot change alt number to 3 (error=-71)
[  942.414031] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  942.418243] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  942.426574] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  942.436218] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  942.440032] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[  942.486846] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)
[  954.314727] cx231xx #0:  setPowerMode::mode = 48, No Change req.
[  954.319030] cx231xx #0: cannot change alt number to 3 (error=-71)
[  954.333618] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  954.337860] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  954.342315] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  954.348052] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  955.153045] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[  955.162963] cx231xx #0: cx231xx_initialize_stream_xfer: set video registers
[  955.172302] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  955.176788] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  977.247924] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  977.252502] cx231xx #0: UsbInterface::sendCommand, failed with status --71
[  977.329895] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[  977.339508] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)

We will try to increase PWR_SLEEP_INTERVAL even further (up to 50
msec), but if you have other ideas to try, we would definitely be
interested. For the record, the same driver works just fine on x86,
those problems are seen on an OMAP3 based ARM platform.

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
