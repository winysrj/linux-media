Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3879BC07E85
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 23:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8FEE2082F
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 23:51:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q2cPh5Rb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8FEE2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbeLIXvk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 18:51:40 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42043 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbeLIXvj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 18:51:39 -0500
Received: by mail-pf1-f193.google.com with SMTP id 64so4466640pfr.9
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2018 15:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=+pP6s+9ZdRWIzF2a/r/DpDdYIhSGFlKCOA9URMf6wGc=;
        b=Q2cPh5RbLR3uzEE7t9TxoVlbV+MzHkiPe2wHlK/RkPOPeYZJNdtNsCpItODqpmBJJW
         T3unlN52UB0wrA6rujHYLjOKYGFTugl00AyrgipWleSQLAbiZ9q8ditdLC/XvK/qZwW8
         cvhfY1Y28jCWHF463krbUnGImtAxZjbaMVCc+J4/RoiyU7p0bWsUS/lwJjN4gQv7hGZh
         og0ZkV1Pp57rWD9Ui7k7QBBJFO2lB/5IZVeB3L4y0kia/tswnFKf8rLDz0+zLXfOh1/a
         hOh1Qz7IW4LIvoJMg+sTIvKofX0/exO91+JDhGmFWNHuDD39oP+AaVYtoAXO2P8FONQs
         HPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=+pP6s+9ZdRWIzF2a/r/DpDdYIhSGFlKCOA9URMf6wGc=;
        b=nHALUau/O1XsMrNbQxA+2dge2B01a+vDHHmfGD/WApzcXL4UrzoBTCoT3wCIQqlnz0
         7cWWs20mWePkZwOZLyvesrl641ki03luSotJEWUlLEE/jF/tpHo8uH+L0/uPx+yjgSDb
         2sRJqxgvepMNW4EdaMoRxBnzJriX8M+ohZ9ktz+yWUcXAxw5ZHsxU0TQO73Il6BNXYkt
         FPSCR/XOAC7deDa8Wf2dHoJuLRdnkWZQcUSLTRRPr10hhu18ua4FNe8bGnpilVQiGinq
         pr3XaXVMVq7od+xiNctLyhTMgFR2CJoC6h1eA5spfg6U+++XHu755fZBMdOwmsWbssHX
         cXSA==
X-Gm-Message-State: AA+aEWZ5a5I8IoZafkm42Ctlwjo7oNb2g9nPS8e04CIx2uEE+qEFiDww
        WrTbdzcED54ocxIlix/YUSt1bS8l
X-Google-Smtp-Source: AFSGD/WG5AorhofT7spJrBsrhdRLys/80R0hAm+nkixDjEsr+8PGFNiR4+nZpxSOaFk3oKBvbHB9jA==
X-Received: by 2002:a63:f1f:: with SMTP id e31mr8966433pgl.274.1544399498203;
        Sun, 09 Dec 2018 15:51:38 -0800 (PST)
Received: from [192.168.10.24] (ppp121-45-203-217.bras1.cbr1.internode.on.net. [121.45.203.217])
        by smtp.gmail.com with ESMTPSA id k15sm16101556pfb.147.2018.12.09.15.51.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Dec 2018 15:51:37 -0800 (PST)
To:     linux-media@vger.kernel.org
From:   David Howe <howe.david@gmail.com>
Subject: bug report cxusb oops
Message-ID: <3a51448a-3412-f348-d594-5cd4ec84294e@gmail.com>
Date:   Mon, 10 Dec 2018 10:51:33 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

hi

using the experimental version of the media stack and i get this

[   80.606898] dvb-usb: found a 'DViCO FusionHDTV DVB-T NANO2 w/o 
firmware' in cold state, will try to load a firmware
[   80.620010] dvb-usb: downloading firmware from file 
'dvb-usb-bluebird-02.fw'
[   80.656195] usbcore: registered new interface driver dvb_usb_cxusb
[   80.688792] usb 3-1: USB disconnect, device number 2
[   80.688826] BUG: unable to handle kernel paging request at 
0000000000002db8
[   80.688830] PGD 0 P4D 0
[   80.688834] Oops: 0000 [#1] PREEMPT SMP PTI
[   80.688838] CPU: 2 PID: 26 Comm: kworker/2:0 Tainted: G           
OE     4.18.0-10-lowlatency #11-Ubuntu
[   80.688840] Hardware name: Hewlett-Packard HP EliteBook 8460p/161C, 
BIOS 68SCF Ver. F.67 02/13/2018
[   80.688846] Workqueue: usb_hub_wq hub_event
[   80.688852] RIP: 0010:cxusb_disconnect+0x18/0x70 [dvb_usb_cxusb]
[   80.688853] Code: 85 c0 75 e7 31 c0 48 c7 02 00 00 00 00 5d c3 0f 1f 
00 66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 fc 53 48 8b 87 c8 00 00 
00 <4c> 8b a8 b8 2d 00 00 49 8b 5d 10 48 85 db 74 18 48 8b 83 a8 00 00
[   80.688885] RSP: 0018:ffffa44f00d97b68 EFLAGS: 00010246
[   80.688888] RAX: 0000000000000000 RBX: ffff98db2dad3030 RCX: 
0000000000000000
[   80.688890] RDX: 0000000000000000 RSI: ffff98db2dad3000 RDI: 
ffff98db2dad3000
[   80.688891] RBP: ffffa44f00d97b80 R08: 0000000000000000 R09: 
ffffffff95335b00
[   80.688893] R10: ffff98db2ef01660 R11: 0000000000000001 R12: 
ffff98db2dad3000
[   80.688895] R13: ffffffffc10530a8 R14: ffff98db307d7000 R15: 
ffff98db307d70a0
[   80.688898] FS:  0000000000000000(0000) GS:ffff98db3dc80000(0000) 
knlGS:0000000000000000
[   80.688900] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   80.688902] CR2: 0000000000002db8 CR3: 000000010ae0a001 CR4: 
00000000000606e0
[   80.688904] Call Trace:
[   80.688911]  usb_unbind_interface+0x7a/0x280
[   80.688916]  device_release_driver_internal+0x18c/0x260
[   80.688919]  device_release_driver+0x12/0x20
[   80.688922]  bus_remove_device+0xec/0x160
[   80.688925]  device_del+0x13b/0x350
[   80.688928]  ? __dev_printk+0x44/0x70
[   80.688932]  usb_disable_device+0x9f/0x270
[   80.688935]  usb_disconnect+0xca/0x2c0
[   80.688938]  hub_port_connect+0x85/0xa70
[   80.688941]  port_event+0x45b/0x6d0
[   80.688945]  hub_event+0x14f/0x3b0
[   80.688951]  process_one_work+0x208/0x3f0
[   80.688954]  worker_thread+0x34/0x3f0
[   80.688958]  kthread+0x120/0x140
[   80.688961]  ? rescuer_thread+0x390/0x390
[   80.688964]  ? kthread_create_worker_on_cpu+0x70/0x70
[   80.688967]  ret_from_fork+0x35/0x40
[   80.688970] Modules linked in: dvb_usb_cxusb(OE) dib0070(OE) 
dvb_usb(OE) dvb_core(OE) rc_core(OE) rfcomm rpcsec_gss_krb5 auth_rpcgss 
nfsv4 nfs lockd grace fscache ccm bnep snd_hda_codec_hdmi 
snd_hda_codec_idt hp_wmi snd_hda_codec_generic snd_hda_intel 
snd_hda_codec arc4 sparse_keymap iwldvm mac80211 intel_rapl 
x86_pkg_temp_thermal intel_powerclamp uvcvideo(OE) videobuf2_vmalloc(OE) 
videobuf2_memops(OE) videobuf2_v4l2(OE) coretemp wmi_bmof 
videobuf2_common(OE) videodev(OE) snd_hda_core snd_hwdep media(OE) kvm 
irqbypass crct10dif_pclmul crc32_pclmul btusb ghash_clmulni_intel btrtl 
iwlwifi pcbc snd_pcm aesni_intel joydev btbcm input_leds snd_seq_midi 
snd_seq_midi_event btintel aes_x86_64 crypto_simd cryptd bluetooth 
glue_helper intel_cstate i915 ecdh_generic intel_rapl_perf hp_accel 
drm_kms_helper drm
[   80.689018]  lis3lv02d snd_rawmidi serio_raw mei_me i2c_algo_bit 
fb_sys_fops syscopyarea sysfillrect cfg80211 wmi tpm_infineon snd_seq 
snd_seq_device snd_timer mei sysimgblt input_polldev snd soundcore video 
mac_hid sch_fq_codel cuse parport_pc ppdev lp parport sunrpc ip_tables 
x_tables autofs4 gpio_ich ahci psmouse libahci lpc_ich firewire_ohci 
sdhci_pci e1000e firewire_core cqhci sdhci crc_itu_t
[   80.689047] CR2: 0000000000002db8
[   80.689050] ---[ end trace b4ada9b289256086 ]---
[   80.689054] RIP: 0010:cxusb_disconnect+0x18/0x70 [dvb_usb_cxusb]
[   80.689056] Code: 85 c0 75 e7 31 c0 48 c7 02 00 00 00 00 5d c3 0f 1f 
00 66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 fc 53 48 8b 87 c8 00 00 
00 <4c> 8b a8 b8 2d 00 00 49 8b 5d 10 48 85 db 74 18 48 8b 83 a8 00 00
[   80.689090] RSP: 0018:ffffa44f00d97b68 EFLAGS: 00010246
[   80.689092] RAX: 0000000000000000 RBX: ffff98db2dad3030 RCX: 
0000000000000000
[   80.689093] RDX: 0000000000000000 RSI: ffff98db2dad3000 RDI: 
ffff98db2dad3000
[   80.689095] RBP: ffffa44f00d97b80 R08: 0000000000000000 R09: 
ffffffff95335b00
[   80.689097] R10: ffff98db2ef01660 R11: 0000000000000001 R12: 
ffff98db2dad3000
[   80.689098] R13: ffffffffc10530a8 R14: ffff98db307d7000 R15: 
ffff98db307d70a0
[   80.689101] FS:  0000000000000000(0000) GS:ffff98db3dc80000(0000) 
knlGS:0000000000000000
[   80.689103] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   80.689105] CR2: 0000000000002db8 CR3: 000000010ae0a001 CR4: 
00000000000606e0

