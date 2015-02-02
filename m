Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52763 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932872AbbBBT60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 14:58:26 -0500
Date: Mon, 2 Feb 2015 14:58:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Jonas Jonsson <jonas.jonsson@hornstull.net>
cc: USB list <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: HP EC372S (Yuan DVB ExpressCard) crash in 3.18.3
In-Reply-To: <54CF4294.4030905@hornstull.net>
Message-ID: <Pine.LNX.4.44L0.1502021457070.1065-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Feb 2015, Jonas Jonsson wrote:

> Hi,
> 
> I posted a bug on kernel.org 
> (https://bugzilla.kernel.org/show_bug.cgi?id=92301 ) and was asked to 
> sent it to this mail-address.

Since this bug involves the dvb-usb driver, it should also be posted to 
the linux-media mailing list (CC-ed).

Alan Stern

> Jan 29 21:26:51 plattpcn kernel: [   17.322493] input: UVC Camera (05ca:1812) as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/2-4:1.0/input/input10
> Jan 29 21:26:51 plattpcn kernel: [   17.322621] usbcore: registered new interface driver uvcvideo
> Jan 29 21:26:51 plattpcn kernel: [   17.322623] USB Video Class driver (1.1.1)
> Jan 29 21:26:51 plattpcn kernel: [   17.583002] input: HP WMI hotkeys as /devices/virtual/input/input11
> Jan 29 21:26:51 plattpcn kernel: [   18.108106] iwl4965 0000:02:00.0: loaded firmware version 228.61.2.24
> Jan 29 21:26:51 plattpcn kernel: [   18.360154] ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
> Jan 29 21:26:51 plattpcn kernel: [   18.620404] dvb-usb: found a 'Yuan EC372S' in cold state, will try to load a firmware
> Jan 29 21:26:51 plattpcn kernel: [   18.993039] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
> Jan 29 21:26:51 plattpcn kernel: [   19.194634] dib0700: firmware started successfully.
> Jan 29 21:26:51 plattpcn kernel: [   19.695174] dvb-usb: found a 'Yuan EC372S' in warm state.
> Jan 29 21:26:51 plattpcn kernel: [   19.695448] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> Jan 29 21:26:51 plattpcn kernel: [   19.695527] DVB: registering new adapter (Yuan EC372S)
> Jan 29 21:26:51 plattpcn kernel: [   20.090809] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
> Jan 29 21:26:51 plattpcn kernel: [   20.090987] IP: [<ffffffffa057b061>] dib7000p_attach+0x11/0xa0 [dib7000p]
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] PGD 36893067 PUD b95b0067 PMD 0
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] Oops: 0002 [#1] SMP
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] Modules linked in: dib7000p(E) dvb_usb_dib0700(E+) dib7000m(E) arc4(E) dib0090(E) dib0070(E) dib3000mc(E) dibx000_common(E) dvb_usb(E) dvb_core(E) coretemp(E) hp_wmi(E) rc_core(E) sparse_keymap(E) uvcvideo(E) iwl4965(E) videobuf2_vmalloc(E) snd_hda_codec_si3054(E) kvm(E) iwlegacy(E) snd_hda_codec_realtek(E) videobuf2_memops(E) mac80211(E) videobuf2_core(E) snd_hda_codec_generic(E) v4l2_common(E) videodev(E) snd_hda_intel(E) joydev(E) snd_hda_controller(E) serio_raw(E) snd_hda_codec(E) snd_hwdep(E) r852(E) cfg80211(E) snd_pcm(E) sm_common(E) btusb(E) nand(E) snd_seq_midi(E) nand_ecc(E) snd_seq_midi_event(E) bluetooth(E) snd_rawmidi(E) nand_bch(E) snd_seq(E) bch(E) r592(E) snd_seq_device(E) nand_ids(E) snd_timer(E) mtd(E) memstick(E) drm(E) snd(E) soundcore(E) lpc_ich(E) wmi(E) video(E) mac_hid(E) parport_pc(E) ppdev(E) lp(E) parport(E) psmouse(E) ahci(E) libahci(E) firewire_ohci(E) firewire_core(E) sdhci_pci(E) crc_itu_t(E) sdhci(E) r8169(E) mii(E)
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] CPU: 0 PID: 442 Comm: systemd-udevd Tainted: G            E  3.18.3jonas #1
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] Hardware name: Hewlett-Packard HP Pavilion dv9700 Notebook PC    /30CB, BIOS F.59      11/25/2008
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] task: ffff8800b8f68000 ti: ffff8800b9148000 task.ti: ffff8800b9148000
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] RIP: 0010:[<ffffffffa057b061>]  [<ffffffffa057b061>] dib7000p_attach+0x11/0xa0 [dib7000p]
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] RSP: 0018:ffff8800b914ba88  EFLAGS: 00010202
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] RAX: 0000000000000010 RBX: ffff8800ba9d1278 RCX: ffffffffa0581040
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] RDX: ffffffffa0581040 RSI: ffffffffa0581c2b RDI: 0000000000000010
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] RBP: ffff8800b914ba88 R08: ffffffff810e47a0 R09: 00000001802a0029
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] R10: ffffea0002ed9fc0 R11: ffffffff8107cf84 R12: 0000000000000000
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] R13: 0000000000000010 R14: ffff8800ba9d1278 R15: ffff8800ba9d1398
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] FS:  00007fd441492880(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] CR2: 0000000000000080 CR3: 0000000036892000 CR4: 00000000000007f0
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] Stack:
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  ffff8800b914bab8 ffffffffa055adab ffff8800ba9d1278 ffff8800ba9d1278
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  ffff8800ba9d1278 0000000000000000 ffff8800b914baf8 ffffffffa04776b8
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  ffff8800ba9d0000 0000000000000000 ffff8800ba9d1278 ffff8800ba9d0000
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] Call Trace:
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffffa055adab>] stk7700P2_frontend_attach+0x3b/0x1f0 [dvb_usb_dib0700]
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffffa04776b8>] dvb_usb_adapter_frontend_init+0xf8/0x1b0 [dvb_usb]
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffffa047694c>] dvb_usb_device_init+0x45c/0x610 [dvb_usb]
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffffa055731a>] dib0700_probe+0x6a/0x100 [dvb_usb_dib0700]
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff8175deb6>] ? mutex_lock+0x16/0x37
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff8156d12f>] usb_probe_interface+0x1df/0x330
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff814afead>] driver_probe_device+0x12d/0x3e0
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff814b023b>] __driver_attach+0x9b/0xa0
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff814b01a0>] ? __device_attach+0x40/0x40
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff814addc3>] bus_for_each_dev+0x63/0xa0
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff814af88e>] driver_attach+0x1e/0x20
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff814af490>] bus_add_driver+0x180/0x240
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff814b0a24>] driver_register+0x64/0xf0
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff8156b792>] usb_register_driver+0x82/0x160
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffffa04bc000>] ? 0xffffffffa04bc000
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffffa04bc01e>] dib0700_driver_init+0x1e/0x1000 [dvb_usb_dib0700]
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff8119bf42>] ? __vunmap+0xc2/0x110
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff810e9245>] load_module+0x1d35/0x27d0
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff810e4f90>] ? store_uevent+0x40/0x40
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff810e9e56>] SyS_finit_module+0x86/0xb0
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  [<ffffffff817603ed>] system_call_fastpath+0x16/0x1b
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] Code: 8b 87 18 03 00 00 55 48 89 e5 5d 48 05 68 16 00 00 c3 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 85 ff 48 89 f8 48 89 e5 74 7f <48> c7 47 70 90 c9 57 a0 48 c7 47 68 00 ba 57 a0 48 c7 47 30 80
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] RIP  [<ffffffffa057b061>] dib7000p_attach+0x11/0xa0 [dib7000p]
> Jan 29 21:26:51 plattpcn kernel: [   20.091007]  RSP <ffff8800b914ba88>
> Jan 29 21:26:51 plattpcn kernel: [   20.091007] CR2: 0000000000000080
> Jan 29 21:26:51 plattpcn kernel: [   20.102621] ---[ end trace 11794293bad0bfef ]---
> 
> 
> 
> Regards,
> 
> Jonas

