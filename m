Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA547C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8857204FD
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:30:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8857204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mess.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbeLJMak (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:30:40 -0500
Received: from gofer.mess.org ([88.97.38.141]:37923 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbeLJMak (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 07:30:40 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 38AD96010E; Mon, 10 Dec 2018 12:30:38 +0000 (GMT)
Date:   Mon, 10 Dec 2018 12:30:38 +0000
From:   Sean Young <sean@mess.org>
To:     David Howe <howe.david@gmail.com>
Cc:     linux-media@vger.kernel.org
Subject: Re: bug report cxusb oops
Message-ID: <20181210123037.ppyjgzs2dm7m2kst@gofer.mess.org>
References: <3a51448a-3412-f348-d594-5cd4ec84294e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a51448a-3412-f348-d594-5cd4ec84294e@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Mon, Dec 10, 2018 at 10:51:33AM +1100, David Howe wrote:
> hi
> 
> using the experimental version of the media stack and i get this
> 
> [   80.606898] dvb-usb: found a 'DViCO FusionHDTV DVB-T NANO2 w/o firmware'
> in cold state, will try to load a firmware
> [   80.620010] dvb-usb: downloading firmware from file
> 'dvb-usb-bluebird-02.fw'
> [   80.656195] usbcore: registered new interface driver dvb_usb_cxusb
> [   80.688792] usb 3-1: USB disconnect, device number 2
> [   80.688826] BUG: unable to handle kernel paging request at
> 0000000000002db8
> [   80.688830] PGD 0 P4D 0
> [   80.688834] Oops: 0000 [#1] PREEMPT SMP PTI
> [   80.688838] CPU: 2 PID: 26 Comm: kworker/2:0 Tainted: G           OE    
> 4.18.0-10-lowlatency #11-Ubuntu
> [   80.688840] Hardware name: Hewlett-Packard HP EliteBook 8460p/161C, BIOS
> 68SCF Ver. F.67 02/13/2018
> [   80.688846] Workqueue: usb_hub_wq hub_event
> [   80.688852] RIP: 0010:cxusb_disconnect+0x18/0x70 [dvb_usb_cxusb]

I'm not entirely sure how it got to cxusb_disconnect() without calling
usb_set_intfdata(). I would have expected a "found a '%s' in warm state."
message.

Which kernel version are you running? Are building media_build or just the
latest media_tree -- if so, what commit?

Does this issue happen every time you boot/connect the usb dvb device?


Thanks
Sean

> [   80.688853] Code: 85 c0 75 e7 31 c0 48 c7 02 00 00 00 00 5d c3 0f 1f 00
> 66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 fc 53 48 8b 87 c8 00 00 00 <4c>
> 8b a8 b8 2d 00 00 49 8b 5d 10 48 85 db 74 18 48 8b 83 a8 00 00
> [   80.688885] RSP: 0018:ffffa44f00d97b68 EFLAGS: 00010246
> [   80.688888] RAX: 0000000000000000 RBX: ffff98db2dad3030 RCX:
> 0000000000000000
> [   80.688890] RDX: 0000000000000000 RSI: ffff98db2dad3000 RDI:
> ffff98db2dad3000
> [   80.688891] RBP: ffffa44f00d97b80 R08: 0000000000000000 R09:
> ffffffff95335b00
> [   80.688893] R10: ffff98db2ef01660 R11: 0000000000000001 R12:
> ffff98db2dad3000
> [   80.688895] R13: ffffffffc10530a8 R14: ffff98db307d7000 R15:
> ffff98db307d70a0
> [   80.688898] FS:  0000000000000000(0000) GS:ffff98db3dc80000(0000)
> knlGS:0000000000000000
> [   80.688900] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   80.688902] CR2: 0000000000002db8 CR3: 000000010ae0a001 CR4:
> 00000000000606e0
> [   80.688904] Call Trace:
> [   80.688911]  usb_unbind_interface+0x7a/0x280
> [   80.688916]  device_release_driver_internal+0x18c/0x260
> [   80.688919]  device_release_driver+0x12/0x20
> [   80.688922]  bus_remove_device+0xec/0x160
> [   80.688925]  device_del+0x13b/0x350
> [   80.688928]  ? __dev_printk+0x44/0x70
> [   80.688932]  usb_disable_device+0x9f/0x270
> [   80.688935]  usb_disconnect+0xca/0x2c0
> [   80.688938]  hub_port_connect+0x85/0xa70
> [   80.688941]  port_event+0x45b/0x6d0
> [   80.688945]  hub_event+0x14f/0x3b0
> [   80.688951]  process_one_work+0x208/0x3f0
> [   80.688954]  worker_thread+0x34/0x3f0
> [   80.688958]  kthread+0x120/0x140
> [   80.688961]  ? rescuer_thread+0x390/0x390
> [   80.688964]  ? kthread_create_worker_on_cpu+0x70/0x70
> [   80.688967]  ret_from_fork+0x35/0x40
> [   80.688970] Modules linked in: dvb_usb_cxusb(OE) dib0070(OE) dvb_usb(OE)
> dvb_core(OE) rc_core(OE) rfcomm rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd
> grace fscache ccm bnep snd_hda_codec_hdmi snd_hda_codec_idt hp_wmi
> snd_hda_codec_generic snd_hda_intel snd_hda_codec arc4 sparse_keymap iwldvm
> mac80211 intel_rapl x86_pkg_temp_thermal intel_powerclamp uvcvideo(OE)
> videobuf2_vmalloc(OE) videobuf2_memops(OE) videobuf2_v4l2(OE) coretemp
> wmi_bmof videobuf2_common(OE) videodev(OE) snd_hda_core snd_hwdep media(OE)
> kvm irqbypass crct10dif_pclmul crc32_pclmul btusb ghash_clmulni_intel btrtl
> iwlwifi pcbc snd_pcm aesni_intel joydev btbcm input_leds snd_seq_midi
> snd_seq_midi_event btintel aes_x86_64 crypto_simd cryptd bluetooth
> glue_helper intel_cstate i915 ecdh_generic intel_rapl_perf hp_accel
> drm_kms_helper drm
> [   80.689018]  lis3lv02d snd_rawmidi serio_raw mei_me i2c_algo_bit
> fb_sys_fops syscopyarea sysfillrect cfg80211 wmi tpm_infineon snd_seq
> snd_seq_device snd_timer mei sysimgblt input_polldev snd soundcore video
> mac_hid sch_fq_codel cuse parport_pc ppdev lp parport sunrpc ip_tables
> x_tables autofs4 gpio_ich ahci psmouse libahci lpc_ich firewire_ohci
> sdhci_pci e1000e firewire_core cqhci sdhci crc_itu_t
> [   80.689047] CR2: 0000000000002db8
> [   80.689050] ---[ end trace b4ada9b289256086 ]---
> [   80.689054] RIP: 0010:cxusb_disconnect+0x18/0x70 [dvb_usb_cxusb]
> [   80.689056] Code: 85 c0 75 e7 31 c0 48 c7 02 00 00 00 00 5d c3 0f 1f 00
> 66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 fc 53 48 8b 87 c8 00 00 00 <4c>
> 8b a8 b8 2d 00 00 49 8b 5d 10 48 85 db 74 18 48 8b 83 a8 00 00
> [   80.689090] RSP: 0018:ffffa44f00d97b68 EFLAGS: 00010246
> [   80.689092] RAX: 0000000000000000 RBX: ffff98db2dad3030 RCX:
> 0000000000000000
> [   80.689093] RDX: 0000000000000000 RSI: ffff98db2dad3000 RDI:
> ffff98db2dad3000
> [   80.689095] RBP: ffffa44f00d97b80 R08: 0000000000000000 R09:
> ffffffff95335b00
> [   80.689097] R10: ffff98db2ef01660 R11: 0000000000000001 R12:
> ffff98db2dad3000
> [   80.689098] R13: ffffffffc10530a8 R14: ffff98db307d7000 R15:
> ffff98db307d70a0
> [   80.689101] FS:  0000000000000000(0000) GS:ffff98db3dc80000(0000)
> knlGS:0000000000000000
> [   80.689103] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   80.689105] CR2: 0000000000002db8 CR3: 000000010ae0a001 CR4:
> 00000000000606e0
