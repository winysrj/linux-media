Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m32FKMJt027841
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 11:20:22 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m32FKC0t026285
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 11:20:12 -0400
Received: by yw-out-2324.google.com with SMTP id 3so289239ywj.81
	for <video4linux-list@redhat.com>; Wed, 02 Apr 2008 08:20:02 -0700 (PDT)
Message-ID: <1dea8a6d0804020820n460fed06ie947b86c39ea7afb@mail.gmail.com>
Date: Wed, 2 Apr 2008 23:20:01 +0800
From: "Ben Caldwell" <benny.caldwell@gmail.com>
To: "Thomas Schuering" <linux-dvb@ts4.de>
In-Reply-To: <20080402124620.GA25986@ts4.de>
MIME-Version: 1.0
References: <33ABD80B75296D43A316BFF5B0B52F5F0EEB1F@SRV-QS-MAIL5.lands.nsw>
	<1dea8a6d0804010841h34f027e7lb4b5342fe45afbb7@mail.gmail.com>
	<37219a840804011319h6fa0d69elbf95b308236e2179@mail.gmail.com>
	<20080402124620.GA25986@ts4.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: alan@redhat.com, LInux DVB <linux-dvb@linuxtv.org>,
	Nicholas Magers <Nicholas.Magers@lands.nsw.gov.au>,
	Michael Krufky <mkrufky@linuxtv.org>, video4linux-list@redhat.com
Subject: Re: [linux-dvb] Dvico Dual 4 card not working.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, Apr 2, 2008 at 8:46 PM, Thomas Schuering <linux-dvb@ts4.de> wrote:


> Then the process 'kdvb-fe-0' eats up 100% CPU-time,
> the keyboard is dead. The machine hangs.
>

Hi Mike,

I have the same problem as Thomas.

I applied your patch and recompiled. My machine starts up and finds the
cards ok. From the system log at this point:

*xc2028 1-0061: Loading 3 firmware images from xc3028-dvico-au-01.fw, type:
DViCO DualDig4/Nano2 (Australia), ver 2.7

*This is better than the current mercurial tip which leaves call traces in
the log just from finding the card, so you've definitely fixed something
there.*

*The problem comes when I start up my mythtv backend which accesses the
card, it failed and this was in the log:
*
BUG: soft lockup - CPU#0 stuck for 11s! [kdvb-fe-0:3131]
CPU 0:
Modules linked in: coretemp hwmon rfcomm l2cap bluetooth autofs4 sunrpc
nf_conntrack_ipv4 ipt_REJECT iptable_filter ip_tables nf_conntrack_ipv6
xt_state nf_conntrack xt_tcpudp ip6t_ipv6header ip6t_REJECT ip6table_filter
ip6_tables x_tables cpufreq_ondemand acpi_cpufreq dm_mirror dm_multipath
dm_mod ipv6 tuner_xc2028(U) zl10353(U) snd_hda_intel snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq dvb_usb_cxusb(U) snd_seq_device
snd_pcm_oss arc4 snd_mixer_oss ecb blkcipher snd_pcm dvb_usb(U) nvidia(P)(U)
dvb_core(U) ath5k firewire_ohci firewire_core snd_timer snd_page_alloc
mac80211 snd_hwdep snd parport_pc parport crc_itu_t lirc_mod_mce(U) cfg80211
lirc_dev(U) iTCO_wdt iTCO_vendor_support serio_raw i2c_i801 pcspkr e1000
soundcore i2c_core sg sr_mod cdrom button pata_marvell ahci libata sd_mod
scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 3131, comm: kdvb-fe-0 Tainted: P        2.6.24.3-50.fc8 #1
RIP: 0010:[<ffffffff81269781>]  [<ffffffff81269781>] _spin_lock+0x7/0xf
RSP: 0018:ffff81002a0bbb78  EFLAGS: 00000286
RAX: 00000000ffffffff RBX: ffff81003e58d748 RCX: ffff81002a0bbc7f
RDX: ffff81002a0bbfd8 RSI: 0000000000000122 RDI: ffff81003e58d74c
RBP: ffffffff8102bea6 R08: 0000000000000001 R09: 0000000000000000
R10: ffff81002a0bbc20 R11: 0000000000000002 R12: ffffffff8138ffd0
R13: ffffffff8104922a R14: ffff81002a0bbb20 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff813cb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000003b1889afa0 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff81268872>] __mutex_lock_interruptible_slowpath+0x1d/0xc7
 [<ffffffff81082cf5>] zone_statistics+0x3f/0x60
 [<ffffffff88a72ae9>] :dvb_usb:dvb_usb_generic_rw+0x6c/0x228
 [<ffffffff88ab81b2>] :dvb_usb_cxusb:cxusb_ctrl_msg+0x88/0x96
 [<ffffffff8101b582>] smp_call_function_mask+0x66/0x78
 [<ffffffff88ab8330>] :dvb_usb_cxusb:cxusb_bluebird_gpio_rw+0x39/0x72
 [<ffffffff88ab8e36>] :dvb_usb_cxusb:cxusb_bluebird_gpio_pulse+0x41/0x4f
 [<ffffffff88ab918e>]
:dvb_usb_cxusb:dvico_bluebird_xc2028_callback+0x3f/0x91
 [<ffffffff88b4f794>] :tuner_xc2028:generic_set_freq+0x89e/0x156a
 [<ffffffff88b4942c>] :zl10353:zl10353_single_write+0x4d/0x75
 [<ffffffff88b49a0f>] :zl10353:zl10353_set_parameters+0x3b9/0x45c
 [<ffffffff8103f3c0>] try_to_del_timer_sync+0x51/0x5a
 [<ffffffff881ee84d>] :dvb_core:dvb_frontend_swzigzag_autotune+0x189/0x1b1
 [<ffffffff881ef0db>] :dvb_core:dvb_frontend_swzigzag+0x1b8/0x21c
 [<ffffffff810492a4>] finish_wait+0x32/0x5d
 [<ffffffff881eff22>] :dvb_core:dvb_frontend_thread+0x28f/0x351
 [<ffffffff81049221>] autoremove_wake_function+0x0/0x2e
 [<ffffffff881efc93>] :dvb_core:dvb_frontend_thread+0x0/0x351
 [<ffffffff810490f2>] kthread+0x47/0x75
 [<ffffffff8100cca8>] child_rip+0xa/0x12
 [<ffffffff8101ced7>] lapic_next_event+0x0/0xa
 [<ffffffff810490ab>] kthread+0x0/0x75
 [<ffffffff8100cc9e>] child_rip+0x0/0x12

*Hope that helps,

Ben
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
