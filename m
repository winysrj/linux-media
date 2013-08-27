Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3H0JJ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 05:09:56 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7R99tWF021451
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 05:09:56 -0400
Received: from shalem.localdomain (vpn1-5-180.ams2.redhat.com [10.36.5.180])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7R99rAl028709
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 05:09:55 -0400
Message-ID: <521C6CE1.9010106@redhat.com>
Date: Tue, 27 Aug 2013 11:09:53 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Potential deadlock in bttv + msp3400 in 3.11
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I just noticed the following in my logs after upgrading my distro
to Fedora 20 (alpha) which comes with 3.11-rc6 with lockdep enabled:

Aug 27 10:41:54 shalem kernel: [    6.564261] Linux video capture interface: v2.00
Aug 27 10:41:54 shalem kernel: [    6.606711] bttv: driver version 0.9.19 loaded
Aug 27 10:41:54 shalem kernel: [    6.606714] bttv: using 8 buffers with 2080k (520 pages) each for capture
Aug 27 10:41:54 shalem kernel: [    6.614843] bttv: Bt8xx card found (0)
Aug 27 10:41:54 shalem kernel: [    6.617700] bttv: 0: Bt878 (rev 2) at 0000:03:07.0, irq: 20, latency: 32, mmio: 0xd0001000
Aug 27 10:41:54 shalem kernel: [    6.617735] bttv: 0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
Aug 27 10:41:54 shalem kernel: [    6.617737] bttv: 0: using: Hauppauge (bt878) [card=10,autodetected]
Aug 27 10:41:54 shalem kernel: [    6.620723] bttv: 0: Hauppauge/Voodoo msp34xx: reset line init [5]
Aug 27 10:41:54 shalem kernel: [    6.660240] tveeprom 8-0050: Hauppauge model 61334, rev B2  , serial# 3211125
Aug 27 10:41:54 shalem kernel: [    6.660243] tveeprom 8-0050: tuner model is Philips FM1216 (idx 21, type 5)
Aug 27 10:41:54 shalem kernel: [    6.660245] tveeprom 8-0050: TV standards PAL(B/G) (eeprom 0x04)
Aug 27 10:41:54 shalem kernel: [    6.660246] tveeprom 8-0050: audio processor is MSP3415 (idx 6)
Aug 27 10:41:54 shalem kernel: [    6.660247] tveeprom 8-0050: has radio
Aug 27 10:41:54 shalem kernel: [    6.660248] bttv: 0: Hauppauge eeprom indicates model#61334
Aug 27 10:41:54 shalem kernel: [    6.660250] bttv: 0: tuner type=5
Aug 27 10:41:54 shalem kernel: [    6.696498] msp3400 8-0040: MSP3410D-B4 found @ 0x80 (bt878 #0 [sw])
Aug 27 10:41:54 shalem kernel: [    6.696501] msp3400 8-0040: msp3400 supports nicam, mode is autodetect
Aug 27 10:41:54 shalem kernel: [    6.715961] e1000e 0000:00:19.0 eth0: registered PHC clock
Aug 27 10:41:54 shalem kernel: [    6.715965] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:19:99:63:fb:4e
Aug 27 10:41:54 shalem kernel: [    6.715967] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
Aug 27 10:41:54 shalem kernel: [    6.716000] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
Aug 27 10:41:54 shalem kernel: [    6.716457] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Aug 27 10:41:54 shalem kernel: [    6.717600] e1000e 0000:02:00.0: Disabling ASPM L0s L1
Aug 27 10:41:54 shalem kernel: [    6.720731] e1000e 0000:02:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
Aug 27 10:41:54 shalem kernel: [    6.738248] tuner 8-0061: Tuner -1 found with type(s) Radio TV.
Aug 27 10:41:54 shalem kernel: [    6.744170] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
Aug 27 10:41:54 shalem kernel: [    6.760132] tuner-simple 8-0061: creating new instance
Aug 27 10:41:54 shalem kernel: [    6.760135] tuner-simple 8-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
Aug 27 10:41:54 shalem kernel: [    6.763428]
Aug 27 10:41:54 shalem kernel: [    6.763430] ======================================================
Aug 27 10:41:54 shalem kernel: [    6.763431] [ INFO: possible circular locking dependency detected ]
Aug 27 10:41:54 shalem kernel: [    6.763432] 3.11.0-0.rc6.git4.1.fc20.x86_64 #1 Not tainted
Aug 27 10:41:54 shalem kernel: [    6.763433] -------------------------------------------------------
Aug 27 10:41:54 shalem kernel: [    6.763434] systemd-udevd/385 is trying to acquire lock:
Aug 27 10:41:54 shalem kernel: [    6.763436]  (msp3400_driver:799:(hdl)->_lock){+.+.+.}, at: [<ffffffffa02ed685>] find_ref_lock+0x25/0x60 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763444]
Aug 27 10:41:54 shalem kernel: [    6.763444] but task is already holding lock:
Aug 27 10:41:54 shalem kernel: [    6.763445]  (bttv_driver:4064:(hdl)->_lock){+.+...}, at: [<ffffffffa02ee75d>] v4l2_ctrl_handler_setup+0x3d/0x130 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763451]
Aug 27 10:41:54 shalem kernel: [    6.763451] which lock already depends on the new lock.
Aug 27 10:41:54 shalem kernel: [    6.763451]
Aug 27 10:41:54 shalem kernel: [    6.763452]
Aug 27 10:41:54 shalem kernel: [    6.763452] the existing dependency chain (in reverse order) is:
Aug 27 10:41:54 shalem kernel: [    6.763453]
Aug 27 10:41:54 shalem kernel: [    6.763453] -> #1 (bttv_driver:4064:(hdl)->_lock){+.+...}:
Aug 27 10:41:54 shalem kernel: [    6.763456]        [<ffffffff810e9422>] lock_acquire+0xa2/0x1f0
Aug 27 10:41:54 shalem kernel: [    6.763460]        [<ffffffff81727457>] mutex_lock_nested+0x87/0x3e0
Aug 27 10:41:54 shalem kernel: [    6.763463]        [<ffffffffa02ed685>] find_ref_lock+0x25/0x60 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763466]        [<ffffffffa02efee6>] handler_new_ref+0x46/0x1e0 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763469]        [<ffffffffa02f0a57>] v4l2_ctrl_add_handler+0xb7/0xf0 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763473]        [<ffffffffa02ea426>] v4l2_device_register_subdev+0xb6/0x160 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763476]        [<ffffffffa02b0a10>] v4l2_i2c_new_subdev_board+0xa0/0x100 [v4l2_common]
Aug 27 10:41:54 shalem kernel: [    6.763479]        [<ffffffffa02b0ada>] v4l2_i2c_new_subdev+0x6a/0x90 [v4l2_common]
Aug 27 10:41:54 shalem kernel: [    6.763481]        [<ffffffffa0329510>] bttv_init_card2+0x1490/0x1930 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763487]        [<ffffffffa0326545>] bttv_probe+0x7a5/0xd60 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763492]        [<ffffffff813a2b0e>] local_pci_probe+0x3e/0x70
Aug 27 10:41:54 shalem kernel: [    6.763494]        [<ffffffff813a3df1>] pci_device_probe+0x111/0x120
Aug 27 10:41:54 shalem kernel: [    6.763496]        [<ffffffff81487db7>] driver_probe_device+0x87/0x390
Aug 27 10:41:54 shalem kernel: [    6.763500]        [<ffffffff81488193>] __driver_attach+0x93/0xa0
Aug 27 10:41:54 shalem kernel: [    6.763502]        [<ffffffff81485bfb>] bus_for_each_dev+0x6b/0xb0
Aug 27 10:41:54 shalem kernel: [    6.763505]        [<ffffffff814877de>] driver_attach+0x1e/0x20
Aug 27 10:41:54 shalem kernel: [    6.763507]        [<ffffffff81487368>] bus_add_driver+0x1f8/0x2b0
Aug 27 10:41:54 shalem kernel: [    6.763509]        [<ffffffff81488814>] driver_register+0x74/0x150
Aug 27 10:41:54 shalem kernel: [    6.763511]        [<ffffffff813a2990>] __pci_register_driver+0x60/0x70
Aug 27 10:41:54 shalem kernel: [    6.763512]        [<ffffffffa03440cf>] bttv_init_module+0xcf/0xe9 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763516]        [<ffffffff810020fa>] do_one_initcall+0xfa/0x1b0
Aug 27 10:41:54 shalem kernel: [    6.763519]        [<ffffffff810f763f>] load_module+0x1c6f/0x27f0
Aug 27 10:41:54 shalem kernel: [    6.763522]        [<ffffffff810f8356>] SyS_finit_module+0x86/0xb0
Aug 27 10:41:54 shalem kernel: [    6.763524]        [<ffffffff81736719>] system_call_fastpath+0x16/0x1b
Aug 27 10:41:54 shalem kernel: [    6.763527]
Aug 27 10:41:54 shalem kernel: [    6.763527] -> #0 (msp3400_driver:799:(hdl)->_lock){+.+.+.}:
Aug 27 10:41:54 shalem kernel: [    6.763529]        [<ffffffff810e88c4>] __lock_acquire+0x17b4/0x1b20
Aug 27 10:41:54 shalem kernel: [    6.763531]        [<ffffffff810e9422>] lock_acquire+0xa2/0x1f0
Aug 27 10:41:54 shalem kernel: [    6.763533]        [<ffffffff81727457>] mutex_lock_nested+0x87/0x3e0
Aug 27 10:41:54 shalem kernel: [    6.763534]        [<ffffffffa02ed685>] find_ref_lock+0x25/0x60 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763538]        [<ffffffffa02ed6ce>] v4l2_ctrl_find+0xe/0x30 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763541]        [<ffffffffa03251fd>] audio_mute+0x3d/0xb0 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763545]        [<ffffffffa032540b>] bttv_s_ctrl+0x19b/0x430 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763549]        [<ffffffffa02ee80e>] v4l2_ctrl_handler_setup+0xee/0x130 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763552]        [<ffffffffa032658b>] bttv_probe+0x7eb/0xd60 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763556]        [<ffffffff813a2b0e>] local_pci_probe+0x3e/0x70
Aug 27 10:41:54 shalem kernel: [    6.763558]        [<ffffffff813a3df1>] pci_device_probe+0x111/0x120
Aug 27 10:41:54 shalem kernel: [    6.763559]        [<ffffffff81487db7>] driver_probe_device+0x87/0x390
Aug 27 10:41:54 shalem kernel: [    6.763562]        [<ffffffff81488193>] __driver_attach+0x93/0xa0
Aug 27 10:41:54 shalem kernel: [    6.763564]        [<ffffffff81485bfb>] bus_for_each_dev+0x6b/0xb0
Aug 27 10:41:54 shalem kernel: [    6.763566]        [<ffffffff814877de>] driver_attach+0x1e/0x20
Aug 27 10:41:54 shalem kernel: [    6.763568]        [<ffffffff81487368>] bus_add_driver+0x1f8/0x2b0
Aug 27 10:41:54 shalem kernel: [    6.763570]        [<ffffffff81488814>] driver_register+0x74/0x150
Aug 27 10:41:54 shalem kernel: [    6.763572]        [<ffffffff813a2990>] __pci_register_driver+0x60/0x70
Aug 27 10:41:54 shalem kernel: [    6.763573]        [<ffffffffa03440cf>] bttv_init_module+0xcf/0xe9 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763577]        [<ffffffff810020fa>] do_one_initcall+0xfa/0x1b0
Aug 27 10:41:54 shalem kernel: [    6.763579]        [<ffffffff810f763f>] load_module+0x1c6f/0x27f0
Aug 27 10:41:54 shalem kernel: [    6.763581]        [<ffffffff810f8356>] SyS_finit_module+0x86/0xb0
Aug 27 10:41:54 shalem kernel: [    6.763583]        [<ffffffff81736719>] system_call_fastpath+0x16/0x1b
Aug 27 10:41:54 shalem kernel: [    6.763585]
Aug 27 10:41:54 shalem kernel: [    6.763585] other info that might help us debug this:
Aug 27 10:41:54 shalem kernel: [    6.763585]
Aug 27 10:41:54 shalem kernel: [    6.763586]  Possible unsafe locking scenario:
Aug 27 10:41:54 shalem kernel: [    6.763586]
Aug 27 10:41:54 shalem kernel: [    6.763587]        CPU0                    CPU1
Aug 27 10:41:54 shalem kernel: [    6.763588]        ----                    ----
Aug 27 10:41:54 shalem kernel: [    6.763589]   lock(bttv_driver:4064:(hdl)->_lock);
Aug 27 10:41:54 shalem kernel: [    6.763591]                                lock(msp3400_driver:799:(hdl)->_lock);
Aug 27 10:41:54 shalem kernel: [    6.763592]                                lock(bttv_driver:4064:(hdl)->_lock);
Aug 27 10:41:54 shalem kernel: [    6.763594]   lock(msp3400_driver:799:(hdl)->_lock);
Aug 27 10:41:54 shalem kernel: [    6.763595]
Aug 27 10:41:54 shalem kernel: [    6.763595]  *** DEADLOCK ***
Aug 27 10:41:54 shalem kernel: [    6.763595]
Aug 27 10:41:54 shalem kernel: [    6.763597] 3 locks held by systemd-udevd/385:
Aug 27 10:41:54 shalem kernel: [    6.763597]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff8148814b>] __driver_attach+0x4b/0xa0
Aug 27 10:41:54 shalem kernel: [    6.763601]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff81488159>] __driver_attach+0x59/0xa0
Aug 27 10:41:54 shalem kernel: [    6.763605]  #2:  (bttv_driver:4064:(hdl)->_lock){+.+...}, at: [<ffffffffa02ee75d>] v4l2_ctrl_handler_setup+0x3d/0x130 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763610]
Aug 27 10:41:54 shalem kernel: [    6.763610] stack backtrace:
Aug 27 10:41:54 shalem kernel: [    6.763612] CPU: 1 PID: 385 Comm: systemd-udevd Not tainted 3.11.0-0.rc6.git4.1.fc20.x86_64 #1
Aug 27 10:41:54 shalem kernel: [    6.763613] Hardware name: FUJITSU D3071-S1/D3071-S1, BIOS V4.6.4.0 R1.12.0 for D3071-S1x 09/20/2012
Aug 27 10:41:54 shalem kernel: [    6.763614]  ffffffff825de5e0 ffff880123487870 ffffffff81723846 ffffffff825de5e0
Aug 27 10:41:54 shalem kernel: [    6.763618]  ffff8801234878b0 ffffffff8171f447 ffff880123487900 ffff880124cb9fc0
Aug 27 10:41:54 shalem kernel: [    6.763620]  ffff880124cb9700 0000000000000003 0000000000000003 ffff880124cb9fc0
Aug 27 10:41:54 shalem kernel: [    6.763622] Call Trace:
Aug 27 10:41:54 shalem kernel: [    6.763625]  [<ffffffff81723846>] dump_stack+0x54/0x74
Aug 27 10:41:54 shalem kernel: [    6.763628]  [<ffffffff8171f447>] print_circular_bug+0x201/0x20f
Aug 27 10:41:54 shalem kernel: [    6.763631]  [<ffffffff810e88c4>] __lock_acquire+0x17b4/0x1b20
Aug 27 10:41:54 shalem kernel: [    6.763633]  [<ffffffff810e9422>] lock_acquire+0xa2/0x1f0
Aug 27 10:41:54 shalem kernel: [    6.763636]  [<ffffffffa02ed685>] ? find_ref_lock+0x25/0x60 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763638]  [<ffffffff81727457>] mutex_lock_nested+0x87/0x3e0
Aug 27 10:41:54 shalem kernel: [    6.763642]  [<ffffffffa02ed685>] ? find_ref_lock+0x25/0x60 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763645]  [<ffffffffa02ed685>] ? find_ref_lock+0x25/0x60 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763648]  [<ffffffffa02ed685>] find_ref_lock+0x25/0x60 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763651]  [<ffffffffa02ed6ce>] v4l2_ctrl_find+0xe/0x30 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763655]  [<ffffffffa03251fd>] audio_mute+0x3d/0xb0 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763659]  [<ffffffffa032540b>] bttv_s_ctrl+0x19b/0x430 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763662]  [<ffffffffa02ee80e>] v4l2_ctrl_handler_setup+0xee/0x130 [videodev]
Aug 27 10:41:54 shalem kernel: [    6.763666]  [<ffffffffa032658b>] bttv_probe+0x7eb/0xd60 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763668]  [<ffffffff813a2b0e>] local_pci_probe+0x3e/0x70
Aug 27 10:41:54 shalem kernel: [    6.763670]  [<ffffffff813a3df1>] pci_device_probe+0x111/0x120
Aug 27 10:41:54 shalem kernel: [    6.763673]  [<ffffffff81487db7>] driver_probe_device+0x87/0x390
Aug 27 10:41:54 shalem kernel: [    6.763676]  [<ffffffff81488193>] __driver_attach+0x93/0xa0
Aug 27 10:41:54 shalem kernel: [    6.763678]  [<ffffffff81488100>] ? __device_attach+0x40/0x40
Aug 27 10:41:54 shalem kernel: [    6.763680]  [<ffffffff81485bfb>] bus_for_each_dev+0x6b/0xb0
Aug 27 10:41:54 shalem kernel: [    6.763683]  [<ffffffff814877de>] driver_attach+0x1e/0x20
Aug 27 10:41:54 shalem kernel: [    6.763685]  [<ffffffff81487368>] bus_add_driver+0x1f8/0x2b0
Aug 27 10:41:54 shalem kernel: [    6.763688]  [<ffffffffa0344000>] ? 0xffffffffa0343fff
Aug 27 10:41:54 shalem kernel: [    6.763689]  [<ffffffff81488814>] driver_register+0x74/0x150
Aug 27 10:41:54 shalem kernel: [    6.763691]  [<ffffffffa0344000>] ? 0xffffffffa0343fff
Aug 27 10:41:54 shalem kernel: [    6.763693]  [<ffffffff813a2990>] __pci_register_driver+0x60/0x70
Aug 27 10:41:54 shalem kernel: [    6.763697]  [<ffffffffa03440cf>] bttv_init_module+0xcf/0xe9 [bttv]
Aug 27 10:41:54 shalem kernel: [    6.763699]  [<ffffffff810020fa>] do_one_initcall+0xfa/0x1b0
Aug 27 10:41:54 shalem kernel: [    6.763702]  [<ffffffff8105cb93>] ? set_memory_nx+0x43/0x50
Aug 27 10:41:54 shalem kernel: [    6.763705]  [<ffffffff810f763f>] load_module+0x1c6f/0x27f0
Aug 27 10:41:54 shalem kernel: [    6.763707]  [<ffffffff810f2e20>] ? store_uevent+0x40/0x40
Aug 27 10:41:54 shalem kernel: [    6.763710]  [<ffffffff810f8356>] SyS_finit_module+0x86/0xb0
Aug 27 10:41:54 shalem kernel: [    6.763712]  [<ffffffff81736719>] system_call_fastpath+0x16/0x1b
Aug 27 10:41:54 shalem kernel: [    6.770783] bttv: 0: Setting PLL: 28636363 => 35468950 (needs up to 100ms)
Aug 27 10:41:54 shalem kernel: [    6.792575] usbcore: registered new interface driver snd-usb-audio
Aug 27 10:41:54 shalem kernel: [    6.792722] bttv: PLL set ok
Aug 27 10:41:54 shalem kernel: [    6.792840] hda_codec: CX20642: BIOS auto-probing.
Aug 27 10:41:54 shalem kernel: [    6.797749] bttv: 0: registered device video0
Aug 27 10:41:54 shalem kernel: [    6.802138] bttv: 0: registered device vbi0
Aug 27 10:41:54 shalem kernel: [    6.805430] bttv: 0: registered device radio0

I've not investigated this myself, -ENOTIME.

Regards,

Hans
