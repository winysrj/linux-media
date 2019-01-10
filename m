Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35442C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 20:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E869220665
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 20:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbfAJUpF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 15:45:05 -0500
Received: from mout2.freenet.de ([195.4.92.92]:46002 "EHLO mout2.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729533AbfAJUpF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 15:45:05 -0500
Received: from [195.4.92.165] (helo=mjail2.freenet.de)
        by mout2.freenet.de with esmtpa (ID moeses@freenet.de) (port 25) (Exim 4.90_1 #2)
        id 1ghhCI-0005Un-Gh
        for linux-media@vger.kernel.org; Thu, 10 Jan 2019 21:45:02 +0100
Received: from [::1] (port=35758 helo=mjail2.freenet.de)
        by mjail2.freenet.de with esmtpa (ID moeses@freenet.de) (Exim 4.90_1 #2)
        id 1ghhCI-0000Ag-Fx
        for linux-media@vger.kernel.org; Thu, 10 Jan 2019 21:45:02 +0100
Received: from sub3.freenet.de ([195.4.92.122]:58658)
        by mjail2.freenet.de with esmtpa (ID moeses@freenet.de) (Exim 4.90_1 #2)
        id 1ghh9o-0007CK-6y
        for linux-media@vger.kernel.org; Thu, 10 Jan 2019 21:42:28 +0100
Received: from ip5b426acc.dynamic.kabel-deutschland.de ([91.66.106.204]:57296 helo=[192.168.120.100])
        by sub3.freenet.de with esmtpsa (ID moeses@freenet.de) (TLSv1.2:ECDHE-RSA-CHACHA20-POLY1305:256) (port 465) (Exim 4.90_1 #2)
        id 1ghh9o-0001D6-3v
        for linux-media@vger.kernel.org; Thu, 10 Jan 2019 21:42:28 +0100
To:     linux-media@vger.kernel.org
From:   "F.M." <moeses@freenet.de>
Subject: "dmxdev: DVB (dvb_dmxdev_filter_start): could not set feed" with two
 DVB sticks
Message-ID: <2108c9fd-8d03-db50-a258-cea08e49867e@freenet.de>
Date:   Thu, 10 Jan 2019 21:42:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
X-Originated-At: 91.66.106.204!57296
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi folks,

I’m trying to set up two DVB-adapters, one receiving a cable and the 
other a terrestrial signal. In the tests involved are the following 
adapters:

1.    TechnoTrend TVStick CT2-4400 (bus ID 0b48:3014)
2.    Hauppauge WinTV SoloHD (bus ID 2040:8268)

The system runs Debian buster with kernel 4.19.

dmesg output:
[Di Jan  8 12:45:41 2019] em28xx 1-4:1.0: New device HCW soloHD @ 480 
Mbps (2040:8268, interface 0, class 0)
[Di Jan  8 12:45:41 2019] em28xx 1-4:1.0: DVB interface 0 found: bulk
[Di Jan  8 12:45:41 2019] em28xx 1-4:1.0: chip ID is em28178
[Di Jan  8 12:45:41 2019] usb 1-3: dvb_usb_v2: found a 'TechnoTrend 
TVStick CT2-4400' in warm state
[Di Jan  8 12:45:41 2019] usb 1-3: dvb_usb_v2: will pass the complete 
MPEG2 transport stream to the software demuxer
[Di Jan  8 12:45:41 2019] dvbdev: DVB: registering new adapter 
(TechnoTrend TVStick CT2-4400)
[Di Jan  8 12:45:41 2019] usb 1-3: dvb_usb_v2: MAC address: 
bc:ea:2b:44:0f:89
[Di Jan  8 12:45:41 2019] i2c i2c-6: Added multiplexed i2c bus 7
[Di Jan  8 12:45:41 2019] si2168 6-0064: Silicon Labs Si2168-B40 
successfully identified
[Di Jan  8 12:45:41 2019] si2168 6-0064: firmware version: B 4.0.2
[Di Jan  8 12:45:41 2019] si2157 7-0060: Silicon Labs 
Si2147/2148/2157/2158 successfully attached
[Di Jan  8 12:45:41 2019] usb 1-3: DVB: registering adapter 0 frontend 0 
(Silicon Labs Si2168)...
[Di Jan  8 12:45:41 2019] usb 1-3: dvb_usb_v2: 'TechnoTrend TVStick 
CT2-4400' successfully initialized and connected
[Di Jan  8 12:45:41 2019] usbcore: registered new interface driver 
dvb_usb_dvbsky
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0: EEPROM ID = 26 00 01 00, 
EEPROM hash = 0xccc2c180
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0: EEPROM info:
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0:    microcode start address = 
0x0004, boot configuration = 0x01
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0:    AC97 audio (5 sample rates)
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0:    500mA max power
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0:    Table at offset 0x27, 
strings=0x0e6a, 0x1888, 0x087e
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0: Identified as PCTV tripleStick 
(292e) (card=94)
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0: dvb set to bulk mode.
[Di Jan  8 12:45:43 2019] usbcore: registered new interface driver em28xx
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0: Binding DVB extension
[Di Jan  8 12:45:43 2019] i2c i2c-9: Added multiplexed i2c bus 10
[Di Jan  8 12:45:43 2019] si2168 9-0064: Silicon Labs Si2168-B40 
successfully identified
[Di Jan  8 12:45:43 2019] si2168 9-0064: firmware version: B 4.0.2
[Di Jan  8 12:45:43 2019] si2157 10-0060: Silicon Labs 
Si2147/2148/2157/2158 successfully attached
[Di Jan  8 12:45:43 2019] dvbdev: DVB: registering new adapter (1-4:1.0)
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0: DVB: registering adapter 1 
frontend 0 (Silicon Labs Si2168)...
[Di Jan  8 12:45:43 2019] em28xx 1-4:1.0: DVB extension successfully 
initialized
[Di Jan  8 12:45:43 2019] em28xx: Registered (Em28xx dvb Extension) 
extension
[Di Jan  8 12:45:45 2019] e1000e: enp0s25 NIC Link is Up 1000 Mbps Full 
Duplex, Flow Control: Rx/Tx
[Di Jan  8 12:45:45 2019] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s25: link 
becomes ready
[Di Jan  8 12:45:45 2019] si2168 6-0064: firmware: direct-loading 
firmware dvb-demod-si2168-b40-01.fw
[Di Jan  8 12:45:45 2019] si2168 6-0064: downloading firmware from file 
'dvb-demod-si2168-b40-01.fw'
[Di Jan  8 12:45:46 2019] si2168 6-0064: firmware version: B 4.0.11
[Di Jan  8 12:45:46 2019] si2157 7-0060: found a 'Silicon Labs Si2157-A30'
[Di Jan  8 12:45:46 2019] si2157 7-0060: firmware version: 3.0.5
[Di Jan  8 12:45:46 2019] si2168 9-0064: firmware: direct-loading 
firmware dvb-demod-si2168-b40-01.fw
[Di Jan  8 12:45:46 2019] si2168 9-0064: downloading firmware from file 
'dvb-demod-si2168-b40-01.fw'
[Di Jan  8 12:45:46 2019] si2168 9-0064: firmware version: B 4.0.11
[Di Jan  8 12:45:46 2019] si2157 10-0060: found a 'Silicon Labs Si2157-A30'
[Di Jan  8 12:45:46 2019] si2157 10-0060: firmware version: 3.0.5
[Di Jan  8 12:46:46 2019] dmxdev: DVB (dvb_dmxdev_filter_start): could 
not set feed
[Di Jan  8 12:46:46 2019] dvb_demux: dvb_demux_feed_del: feed not in 
list (type=1 state=0 pid=ffff)

Both adapters work fine individually but together the two last lines 
occur and VDR only receives a signal on one of them while the other 
gives "no data" message. When i.e. I add the first tuner later I get 
such messages in the journal:

Jan 08 12:36:08 mypc kernel:  device_create_groups_vargs+0xd1/0xf0
Jan 08 12:36:08 mypc kernel:  device_create+0x49/0x60
Jan 08 12:36:08 mypc kernel:  ? _cond_resched+0x15/0x30
Jan 08 12:36:08 mypc kernel:  ? kmem_cache_alloc_trace+0x155/0x1d0
Jan 08 12:36:08 mypc kernel:  dvb_register_device+0x229/0x2c0 [dvb_core]
Jan 08 12:36:08 mypc kernel:  dvb_usbv2_probe+0x54d/0x10d0 [dvb_usb_v2]
Jan 08 12:36:08 mypc kernel:  ? __pm_runtime_set_status+0x247/0x260
Jan 08 12:36:08 mypc kernel:  usb_probe_interface+0xe4/0x2f0 [usbcore]
Jan 08 12:36:08 mypc kernel:  really_probe+0x235/0x3a0
Jan 08 12:36:08 mypc kernel:  driver_probe_device+0xb3/0xf0
Jan 08 12:36:08 mypc kernel:  __driver_attach+0xdd/0x110
Jan 08 12:36:08 mypc kernel:  ? driver_probe_device+0xf0/0xf0
Jan 08 12:36:08 mypc kernel:  bus_for_each_dev+0x76/0xc0
Jan 08 12:36:08 mypc kernel:  ? klist_add_tail+0x3b/0x70
Jan 08 12:36:08 mypc kernel:  bus_add_driver+0x152/0x230
Jan 08 12:36:08 mypc kernel:  driver_register+0x6b/0xb0
Jan 08 12:36:08 mypc kernel:  usb_register_driver+0x7a/0x130 [usbcore]
Jan 08 12:36:08 mypc kernel:  ? 0xffffffffc09e5000
Jan 08 12:36:08 mypc kernel:  do_one_initcall+0x46/0x1c3
Jan 08 12:36:08 mypc kernel:  ? free_unref_page_commit+0x91/0x100
Jan 08 12:36:08 mypc kernel:  ? _cond_resched+0x15/0x30
Jan 08 12:36:08 mypc kernel:  ? kmem_cache_alloc_trace+0x155/0x1d0
Jan 08 12:36:08 mypc kernel:  do_init_module+0x5a/0x210
Jan 08 12:36:08 mypc kernel:  load_module+0x215c/0x2380
Jan 08 12:36:08 mypc kernel:  ? __do_sys_finit_module+0xad/0x110
Jan 08 12:36:08 mypc kernel:  __do_sys_finit_module+0xad/0x110
Jan 08 12:36:08 mypc kernel:  do_syscall_64+0x53/0x100
Jan 08 12:36:08 mypc kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
Jan 08 12:36:08 mypc kernel: RIP: 0033:0x7f3029f62309
Jan 08 12:36:08 mypc kernel: Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 
0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 
8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
Jan 08 12:36:08 mypc kernel: RSP: 002b:00007ffefc69b4c8 EFLAGS: 00000246 
ORIG_RAX: 0000000000000139
Jan 08 12:36:08 mypc kernel: RAX: ffffffffffffffda RBX: 0000555d0528bde0 
RCX: 00007f3029f62309
Jan 08 12:36:08 mypc kernel: RDX: 0000000000000000 RSI: 0000555d0528ebd0 
RDI: 0000000000000006
Jan 08 12:36:08 mypc kernel: RBP: 0000555d0528ebd0 R08: 0000000000000000 
R09: 0000000000000000
Jan 08 12:36:08 mypc kernel: R10: 0000000000000006 R11: 0000000000000246 
R12: 0000000000000000
Jan 08 12:36:08 mypc kernel: R13: 0000555d0528be60 R14: 0000000000040000 
R15: 0000555d0528bde0
Jan 08 12:36:08 mypc kernel: kobject_add_internal failed for dvb with 
-EEXIST, don't try to register things with the same name in the same 
directory.
Jan 08 12:36:08 mypc kernel: dvbdev: dvb_register_device: failed to 
create device dvb0.net0 (-17)
Jan 08 12:36:08 mypc kernel: usb 1-3: dvb_usb_v2: dvb_net_init() failed=-17
Jan 08 12:36:08 mypc kernel: dvb_usb_dvbsky: probe of 1-3:1.0 failed 
with error -17

As I thought that the different modules (dvb_usb_dvbsky and em28xx) are 
the cause I ordered a new device which use the same chips:

3. DVBSky T330 (bus ID 0572:0320).

The error messages still show up:

[Mi Jan  9 21:59:48 2019] usb 1-3: dvb_usb_v2: found a 'DVBSky T330' in 
warm state
[Mi Jan  9 21:59:48 2019] usb 1-3: dvb_usb_v2: will pass the complete 
MPEG2 transport stream to the software demuxer
[Mi Jan  9 21:59:48 2019] dvbdev: DVB: registering new adapter (DVBSky T330)
[Mi Jan  9 21:59:48 2019] usb 1-3: dvb_usb_v2: MAC address: 
00:cc:10:a5:33:0c
[Mi Jan  9 21:59:48 2019] i2c i2c-6: Added multiplexed i2c bus 7
[Mi Jan  9 21:59:48 2019] si2168 6-0064: Silicon Labs Si2168-B40 
successfully identified
[Mi Jan  9 21:59:48 2019] si2168 6-0064: firmware version: B 4.0.2
[Mi Jan  9 21:59:48 2019] media: Linux media interface: v0.10
[Mi Jan  9 21:59:48 2019] si2157 7-0060: Silicon Labs 
Si2147/2148/2157/2158 successfully attached
[Mi Jan  9 21:59:48 2019] usb 1-3: DVB: registering adapter 0 frontend 0 
(Silicon Labs Si2168)...
[Mi Jan  9 21:59:48 2019] usb 1-3: dvb_usb_v2: 'DVBSky T330' 
successfully initialized and connected
[Mi Jan  9 21:59:48 2019] usb 1-4: dvb_usb_v2: found a 'TechnoTrend 
TVStick CT2-4400' in warm state
[Mi Jan  9 21:59:48 2019] usb 1-4: dvb_usb_v2: will pass the complete 
MPEG2 transport stream to the software demuxer
[Mi Jan  9 21:59:48 2019] dvbdev: DVB: registering new adapter 
(TechnoTrend TVStick CT2-4400)
[Mi Jan  9 21:59:48 2019] usb 1-4: dvb_usb_v2: MAC address: 
bc:ea:2b:44:0f:89
[Mi Jan  9 21:59:48 2019] i2c i2c-8: Added multiplexed i2c bus 9
[Mi Jan  9 21:59:48 2019] si2168 8-0064: Silicon Labs Si2168-B40 
successfully identified
[Mi Jan  9 21:59:48 2019] si2168 8-0064: firmware version: B 4.0.2
[Mi Jan  9 21:59:48 2019] si2157 9-0060: Silicon Labs 
Si2147/2148/2157/2158 successfully attached
[Mi Jan  9 21:59:48 2019] usb 1-4: DVB: registering adapter 1 frontend 0 
(Silicon Labs Si2168)...
[Mi Jan  9 21:59:48 2019] usb 1-4: dvb_usb_v2: 'TechnoTrend TVStick 
CT2-4400' successfully initialized and connected
[Mi Jan  9 21:59:48 2019] usbcore: registered new interface driver 
dvb_usb_dvbsky
[Mi Jan  9 22:00:03 2019] si2168 6-0064: firmware: direct-loading 
firmware dvb-demod-si2168-b40-01.fw
[Mi Jan  9 22:00:03 2019] si2168 6-0064: downloading firmware from file 
'dvb-demod-si2168-b40-01.fw'
[Mi Jan  9 22:00:03 2019] si2168 6-0064: firmware version: B 4.0.11
[Mi Jan  9 22:00:03 2019] si2157 7-0060: found a 'Silicon Labs Si2157-A30'
[Mi Jan  9 22:00:04 2019] si2157 7-0060: firmware version: 3.0.5
[Mi Jan  9 22:00:04 2019] si2168 8-0064: firmware: direct-loading 
firmware dvb-demod-si2168-b40-01.fw
[Mi Jan  9 22:00:04 2019] si2168 8-0064: downloading firmware from file 
'dvb-demod-si2168-b40-01.fw'
[Mi Jan  9 22:00:04 2019] si2168 8-0064: firmware version: B 4.0.11
[Mi Jan  9 22:00:04 2019] si2157 9-0060: found a 'Silicon Labs Si2157-A30'
[Mi Jan  9 22:00:04 2019] si2157 9-0060: firmware version: 3.0.5
[Mi Jan  9 22:00:04 2019] fuse init (API version 7.28)
[Mi Jan  9 22:01:01 2019] dmxdev: DVB (dvb_dmxdev_filter_start): could 
not set feed
[Mi Jan  9 22:01:01 2019] dvb_demux: dvb_demux_feed_del: feed not in 
list (type=1 state=0 pid=ffff)

Now I'd like to know if this is an driver limitation or is there 
anything I could set up differently in order to make it work (except for 
disabling the remotes I didn't set any parameters than standard).

Regards, Frank


