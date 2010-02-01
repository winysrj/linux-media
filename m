Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65520 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0BAGik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 01:38:40 -0500
Received: by bwz27 with SMTP id 27so2743406bwz.21
        for <linux-media@vger.kernel.org>; Sun, 31 Jan 2010 22:38:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1a297b361001311449i15222c8bmca41e74c28999c08@mail.gmail.com>
References: <f509f3091001311233s4991ac2bn9c0a527f57501dae@mail.gmail.com>
	 <1a297b361001311449i15222c8bmca41e74c28999c08@mail.gmail.com>
Date: Mon, 1 Feb 2010 07:38:38 +0100
Message-ID: <f509f3091001312238w12656ee5gc6dfabad51da4116@mail.gmail.com>
Subject: Re: Twinhan dtv 3030 mantis dvb-t
From: Niklas Claesson <nicke.claesson@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for the quick answer!
I downloaded http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.bz2 and did:

make release VER=`uname -r`
make
sudo make install

I had to disable "firedtv" as well, but that is another (ubuntu
related) known issue.

Unfortunately it's not working and I get the same errors. Is there any
way to verify that I'm using the latest driver? Are there any
dependencies I'm not aware of?

/var/log/messages:
Feb  1 00:43:30 niklas-desktop kernel: [   10.513329] *pde = 00000000
Feb  1 00:43:30 niklas-desktop kernel: [   10.513338] Modules linked
in: snd_hda_codec_analog arc4 ecb mantis(+) mantis_core ir_common
ir_core tda665x lnbp21 mb86a16 stb6100 tda10021 tda10023 zl10353
stb0899 stv0299 dvb_core rtl8187 mac80211 led_class eeprom_93cx6
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq iptable_filter cfg80211 lp parport
snd_timer snd_seq_device ip_tables x_tables lirc_imon lirc_dev btusb
usblp asus_atk0110 nvidia(P) snd soundcore snd_page_alloc ohci1394
skge ieee1394 usbhid sky2 intel_agp agpgart
Feb  1 00:43:30 niklas-desktop kernel: [   10.513386]
Feb  1 00:43:30 niklas-desktop kernel: [   10.513390] Pid: 861, comm:
modprobe Tainted: P           (2.6.31-17-generic #54-Ubuntu) System
Product Name
Feb  1 00:43:30 niklas-desktop kernel: [   10.513393] EIP:
0060:[<f84e9480>] EFLAGS: 00010292 CPU: 0
Feb  1 00:43:30 niklas-desktop kernel: [   10.513400] EIP is at
dvb_unregister_frontend+0x10/0xe0 [dvb_core]
Feb  1 00:43:30 niklas-desktop kernel: [   10.513402] EAX: 00000000
EBX: f616b000 ECX: f6391d40 EDX: 00000000
Feb  1 00:43:30 niklas-desktop kernel: [   10.513405] ESI: 00000000
EDI: f616b1fc EBP: f61abdec ESP: f61abdc8
Feb  1 00:43:30 niklas-desktop kernel: [   10.513407]  DS: 007b ES:
007b FS: 00d8 GS: 00e0 SS: 0068
Feb  1 00:43:30 niklas-desktop kernel: [   10.513413]  f61abdec
f84ee01e f616b000 00000000 f616b1fc f61abdec f616b000 f616b000
Feb  1 00:43:30 niklas-desktop kernel: [   10.513420] <0> ffffffff
f61abe2c f859b4dc f70fc858 f859fb90 f616b000 00000000 f616b470
Feb  1 00:43:30 niklas-desktop kernel: [   10.513427] <0> f616b048
f616b464 f616b458 f85af4e0 f616b3fc f616b1ac f616b000 00000000
Feb  1 00:43:30 niklas-desktop kernel: [   10.513444]  [<f84ee01e>] ?
dvb_net_release+0x1e/0xb0 [dvb_core]
Feb  1 00:43:30 niklas-desktop kernel: [   10.513452]  [<f859b4dc>] ?
mantis_dvb_init+0x398/0x3de [mantis_core]
Feb  1 00:43:30 niklas-desktop kernel: [   10.513457]  [<f85ac606>] ?
mantis_pci_probe+0x1d7/0x2f8 [mantis]
Feb  1 00:43:30 niklas-desktop kernel: [   10.513464]  [<c03285ae>] ?
local_pci_probe+0xe/0x10
Feb  1 00:43:30 niklas-desktop kernel: [   10.513468]  [<c0329330>] ?
pci_device_probe+0x60/0x80
Feb  1 00:43:30 niklas-desktop kernel: [   10.513474]  [<c03a2e30>] ?
really_probe+0x50/0x140
Feb  1 00:43:30 niklas-desktop kernel: [   10.513479]  [<c0570cea>] ?
_spin_lock_irqsave+0x2a/0x40
Feb  1 00:43:30 niklas-desktop kernel: [   10.513483]  [<c03a2f39>] ?
driver_probe_device+0x19/0x20
Feb  1 00:43:30 niklas-desktop kernel: [   10.513486]  [<c03a2fb9>] ?
__driver_attach+0x79/0x80
Feb  1 00:43:30 niklas-desktop kernel: [   10.513490]  [<c03a2488>] ?
bus_for_each_dev+0x48/0x70
Feb  1 00:43:30 niklas-desktop kernel: [   10.513493]  [<c03a2cf9>] ?
driver_attach+0x19/0x20
Feb  1 00:43:30 niklas-desktop kernel: [   10.513497]  [<c03a2f40>] ?
__driver_attach+0x0/0x80
Feb  1 00:43:30 niklas-desktop kernel: [   10.513501]  [<c03a26df>] ?
bus_add_driver+0xbf/0x2a0
Feb  1 00:43:30 niklas-desktop kernel: [   10.513504]  [<c0329270>] ?
pci_device_remove+0x0/0x40
Feb  1 00:43:30 niklas-desktop kernel: [   10.513508]  [<c03a3245>] ?
driver_register+0x65/0x120
Feb  1 00:43:30 niklas-desktop kernel: [   10.513511]  [<c0329550>] ?
__pci_register_driver+0x40/0xb0
Feb  1 00:43:30 niklas-desktop kernel: [   10.513516]  [<f85ac42d>] ?
mantis_init+0x17/0x19 [mantis]
Feb  1 00:43:30 niklas-desktop kernel: [   10.513519]  [<c010112c>] ?
do_one_initcall+0x2c/0x190
Feb  1 00:43:30 niklas-desktop kernel: [   10.513523]  [<f85ac416>] ?
mantis_init+0x0/0x19 [mantis]
Feb  1 00:43:30 niklas-desktop kernel: [   10.513528]  [<c0173711>] ?
sys_init_module+0xb1/0x1f0
Feb  1 00:43:30 niklas-desktop kernel: [   10.513532]  [<c010336c>] ?
syscall_call+0x7/0xb
Feb  1 00:43:30 niklas-desktop kernel: [   10.513612] ---[ end trace
fbdc5992aad42451 ]---

lspci:
05:02.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
PCI Bridge Controller [Ver 1.0] (rev 01)
	Subsystem: Twinhan Technology Co. Ltd Device 0024
	Flags: bus master, medium devsel, latency 64, IRQ 23
	Memory at dfeff000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis

Med vänliga hälsningar
Niklas Claesson



2010/1/31 Manu Abraham <abraham.manu@gmail.com>:
> Hi,
>
> The mantis driver has been merged. So you can as well try out the
> latest changes from http://linuxtv.org/hg/v4l-dvb as well.
>
> Regards,
> Manu
>
