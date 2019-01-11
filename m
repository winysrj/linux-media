Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE049C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 13:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 666BC2084C
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 13:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547212326;
	bh=fmdBIve6t3CNr6TewQOZhMSBMAQNaKBLXKLk8DDyIDE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=2JuD7nqH1z72k0zbB+ZxwPanyOVOKDR0KM20B4Xo35Cid3lOn1lnKkDy0NzrBpvJT
	 dRepL52bJ+waxFctU4+TykbjYgOkZT3y8LP7ZH8ApfbKb7LBaMUUvdQI3VCfzN0fhh
	 3lbmdpcHVVcLf+d0Y3HAUz8/D/eDAeBXR2VoQjrE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbfAKNMF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 08:12:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:47216 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfAKNMF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 08:12:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fmdBIve6t3CNr6TewQOZhMSBMAQNaKBLXKLk8DDyIDE=; b=fMVFa7RSBKJUmPNLgYH27BI3qY
        acTyMIYzrmOy4HHW2yp+SiDZYH4n9l3bhYo/LaZaFewY6NdtU0XVXLDbkmFvIJWRFyYAwRk0Q6muU
        pPJaPzHBOeMpRRbONBfVTrDr9BbDFmMHNFXya33faoO9gh5tc6CZjOHPhiDswzhR1mADxyLLtIm2V
        4yxfdg9bSInUnHFBpMHzol8H5Rz5Rdg1vZkTfHgrf1YDihy7qNs1Z79j7lSW9f9uxClCHF+tYM/9x
        GyHNOfmTMM0Zzh1cRw9vMNgCIns51Gl2BF03DW93UccbFpSQZeXBbgsit5WDRdmEugYhcZPU9K3g6
        tMz5AbZw==;
Received: from 177.18.27.52.dynamic.adsl.gvt.net.br ([177.18.27.52] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ghwbS-0007ua-KB; Fri, 11 Jan 2019 13:12:03 +0000
Date:   Fri, 11 Jan 2019 11:11:56 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     "F.M." <moeses@freenet.de>
Cc:     linux-media@vger.kernel.org
Subject: Re: "dmxdev: DVB (dvb_dmxdev_filter_start): could not set feed"
 with two DVB sticks
Message-ID: <20190111111156.7ba3bd4a@coco.lan>
In-Reply-To: <2108c9fd-8d03-db50-a258-cea08e49867e@freenet.de>
References: <2108c9fd-8d03-db50-a258-cea08e49867e@freenet.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 10 Jan 2019 21:42:27 +0100
"F.M." <moeses@freenet.de> escreveu:

> Hi folks,
>=20
> I=E2=80=99m trying to set up two DVB-adapters, one receiving a cable and =
the=20
> other a terrestrial signal. In the tests involved are the following=20
> adapters:
>=20
> 1.=C2=A0=C2=A0=C2=A0 TechnoTrend TVStick CT2-4400 (bus ID 0b48:3014)
> 2.=C2=A0=C2=A0=C2=A0 Hauppauge WinTV SoloHD (bus ID 2040:8268)
>=20
> The system runs Debian buster with kernel 4.19.
>=20
> dmesg output:
> [Di Jan=C2=A0 8 12:45:41 2019] em28xx 1-4:1.0: New device HCW soloHD @ 48=
0=20
> Mbps (2040:8268, interface 0, class 0)
> [Di Jan=C2=A0 8 12:45:41 2019] em28xx 1-4:1.0: DVB interface 0 found: bulk
> [Di Jan=C2=A0 8 12:45:41 2019] em28xx 1-4:1.0: chip ID is em28178
> [Di Jan=C2=A0 8 12:45:41 2019] usb 1-3: dvb_usb_v2: found a 'TechnoTrend=
=20
> TVStick CT2-4400' in warm state
> [Di Jan=C2=A0 8 12:45:41 2019] usb 1-3: dvb_usb_v2: will pass the complet=
e=20
> MPEG2 transport stream to the software demuxer
> [Di Jan=C2=A0 8 12:45:41 2019] dvbdev: DVB: registering new adapter=20
> (TechnoTrend TVStick CT2-4400)
> [Di Jan=C2=A0 8 12:45:41 2019] usb 1-3: dvb_usb_v2: MAC address:=20
> bc:ea:2b:44:0f:89
> [Di Jan=C2=A0 8 12:45:41 2019] i2c i2c-6: Added multiplexed i2c bus 7
> [Di Jan=C2=A0 8 12:45:41 2019] si2168 6-0064: Silicon Labs Si2168-B40=20
> successfully identified
> [Di Jan=C2=A0 8 12:45:41 2019] si2168 6-0064: firmware version: B 4.0.2
> [Di Jan=C2=A0 8 12:45:41 2019] si2157 7-0060: Silicon Labs=20
> Si2147/2148/2157/2158 successfully attached
> [Di Jan=C2=A0 8 12:45:41 2019] usb 1-3: DVB: registering adapter 0 fronte=
nd 0=20
> (Silicon Labs Si2168)...
> [Di Jan=C2=A0 8 12:45:41 2019] usb 1-3: dvb_usb_v2: 'TechnoTrend TVStick=
=20
> CT2-4400' successfully initialized and connected
> [Di Jan=C2=A0 8 12:45:41 2019] usbcore: registered new interface driver=20
> dvb_usb_dvbsky
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0: EEPROM ID =3D 26 00 01 00,=
=20
> EEPROM hash =3D 0xccc2c180
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0: EEPROM info:
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0:=C2=A0=C2=A0=C2=A0 microcod=
e start address =3D=20
> 0x0004, boot configuration =3D 0x01
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0:=C2=A0=C2=A0=C2=A0 AC97 aud=
io (5 sample rates)
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0:=C2=A0=C2=A0=C2=A0 500mA ma=
x power
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0:=C2=A0=C2=A0=C2=A0 Table at=
 offset 0x27,=20
> strings=3D0x0e6a, 0x1888, 0x087e
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0: Identified as PCTV tripleS=
tick=20
> (292e) (card=3D94)
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0: dvb set to bulk mode.
> [Di Jan=C2=A0 8 12:45:43 2019] usbcore: registered new interface driver e=
m28xx
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0: Binding DVB extension
> [Di Jan=C2=A0 8 12:45:43 2019] i2c i2c-9: Added multiplexed i2c bus 10
> [Di Jan=C2=A0 8 12:45:43 2019] si2168 9-0064: Silicon Labs Si2168-B40=20
> successfully identified
> [Di Jan=C2=A0 8 12:45:43 2019] si2168 9-0064: firmware version: B 4.0.2
> [Di Jan=C2=A0 8 12:45:43 2019] si2157 10-0060: Silicon Labs=20
> Si2147/2148/2157/2158 successfully attached
> [Di Jan=C2=A0 8 12:45:43 2019] dvbdev: DVB: registering new adapter (1-4:=
1.0)
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0: DVB: registering adapter 1=
=20
> frontend 0 (Silicon Labs Si2168)...
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx 1-4:1.0: DVB extension successfully=
=20
> initialized
> [Di Jan=C2=A0 8 12:45:43 2019] em28xx: Registered (Em28xx dvb Extension)=
=20
> extension
> [Di Jan=C2=A0 8 12:45:45 2019] e1000e: enp0s25 NIC Link is Up 1000 Mbps F=
ull=20
> Duplex, Flow Control: Rx/Tx
> [Di Jan=C2=A0 8 12:45:45 2019] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s25: li=
nk=20
> becomes ready
> [Di Jan=C2=A0 8 12:45:45 2019] si2168 6-0064: firmware: direct-loading=20
> firmware dvb-demod-si2168-b40-01.fw
> [Di Jan=C2=A0 8 12:45:45 2019] si2168 6-0064: downloading firmware from f=
ile=20
> 'dvb-demod-si2168-b40-01.fw'
> [Di Jan=C2=A0 8 12:45:46 2019] si2168 6-0064: firmware version: B 4.0.11
> [Di Jan=C2=A0 8 12:45:46 2019] si2157 7-0060: found a 'Silicon Labs Si215=
7-A30'
> [Di Jan=C2=A0 8 12:45:46 2019] si2157 7-0060: firmware version: 3.0.5
> [Di Jan=C2=A0 8 12:45:46 2019] si2168 9-0064: firmware: direct-loading=20
> firmware dvb-demod-si2168-b40-01.fw
> [Di Jan=C2=A0 8 12:45:46 2019] si2168 9-0064: downloading firmware from f=
ile=20
> 'dvb-demod-si2168-b40-01.fw'
> [Di Jan=C2=A0 8 12:45:46 2019] si2168 9-0064: firmware version: B 4.0.11
> [Di Jan=C2=A0 8 12:45:46 2019] si2157 10-0060: found a 'Silicon Labs Si21=
57-A30'
> [Di Jan=C2=A0 8 12:45:46 2019] si2157 10-0060: firmware version: 3.0.5
> [Di Jan=C2=A0 8 12:46:46 2019] dmxdev: DVB (dvb_dmxdev_filter_start): cou=
ld=20
> not set feed
> [Di Jan=C2=A0 8 12:46:46 2019] dvb_demux: dvb_demux_feed_del: feed not in=
=20
> list (type=3D1 state=3D0 pid=3Dffff)
>=20
> Both adapters work fine individually but together the two last lines=20
> occur and VDR only receives a signal on one of them while the other=20
> gives "no data" message. When i.e. I add the first tuner later I get=20
> such messages in the journal:
>=20
> Jan 08 12:36:08 mypc kernel:=C2=A0 device_create_groups_vargs+0xd1/0xf0
> Jan 08 12:36:08 mypc kernel:=C2=A0 device_create+0x49/0x60
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? _cond_resched+0x15/0x30
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? kmem_cache_alloc_trace+0x155/0x1d0
> Jan 08 12:36:08 mypc kernel:=C2=A0 dvb_register_device+0x229/0x2c0 [dvb_c=
ore]
> Jan 08 12:36:08 mypc kernel:=C2=A0 dvb_usbv2_probe+0x54d/0x10d0 [dvb_usb_=
v2]
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? __pm_runtime_set_status+0x247/0x260
> Jan 08 12:36:08 mypc kernel:=C2=A0 usb_probe_interface+0xe4/0x2f0 [usbcor=
e]
> Jan 08 12:36:08 mypc kernel:=C2=A0 really_probe+0x235/0x3a0
> Jan 08 12:36:08 mypc kernel:=C2=A0 driver_probe_device+0xb3/0xf0
> Jan 08 12:36:08 mypc kernel:=C2=A0 __driver_attach+0xdd/0x110
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? driver_probe_device+0xf0/0xf0
> Jan 08 12:36:08 mypc kernel:=C2=A0 bus_for_each_dev+0x76/0xc0
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? klist_add_tail+0x3b/0x70
> Jan 08 12:36:08 mypc kernel:=C2=A0 bus_add_driver+0x152/0x230
> Jan 08 12:36:08 mypc kernel:=C2=A0 driver_register+0x6b/0xb0
> Jan 08 12:36:08 mypc kernel:=C2=A0 usb_register_driver+0x7a/0x130 [usbcor=
e]
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? 0xffffffffc09e5000
> Jan 08 12:36:08 mypc kernel:=C2=A0 do_one_initcall+0x46/0x1c3
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? free_unref_page_commit+0x91/0x100
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? _cond_resched+0x15/0x30
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? kmem_cache_alloc_trace+0x155/0x1d0
> Jan 08 12:36:08 mypc kernel:=C2=A0 do_init_module+0x5a/0x210
> Jan 08 12:36:08 mypc kernel:=C2=A0 load_module+0x215c/0x2380
> Jan 08 12:36:08 mypc kernel:=C2=A0 ? __do_sys_finit_module+0xad/0x110
> Jan 08 12:36:08 mypc kernel:=C2=A0 __do_sys_finit_module+0xad/0x110
> Jan 08 12:36:08 mypc kernel:=C2=A0 do_syscall_64+0x53/0x100
> Jan 08 12:36:08 mypc kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Jan 08 12:36:08 mypc kernel: RIP: 0033:0x7f3029f62309
> Jan 08 12:36:08 mypc kernel: Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00=20
> 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c=20
> 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> Jan 08 12:36:08 mypc kernel: RSP: 002b:00007ffefc69b4c8 EFLAGS: 00000246=
=20
> ORIG_RAX: 0000000000000139
> Jan 08 12:36:08 mypc kernel: RAX: ffffffffffffffda RBX: 0000555d0528bde0=
=20
> RCX: 00007f3029f62309
> Jan 08 12:36:08 mypc kernel: RDX: 0000000000000000 RSI: 0000555d0528ebd0=
=20
> RDI: 0000000000000006
> Jan 08 12:36:08 mypc kernel: RBP: 0000555d0528ebd0 R08: 0000000000000000=
=20
> R09: 0000000000000000
> Jan 08 12:36:08 mypc kernel: R10: 0000000000000006 R11: 0000000000000246=
=20
> R12: 0000000000000000
> Jan 08 12:36:08 mypc kernel: R13: 0000555d0528be60 R14: 0000000000040000=
=20
> R15: 0000555d0528bde0
> Jan 08 12:36:08 mypc kernel: kobject_add_internal failed for dvb with=20
> -EEXIST, don't try to register things with the same name in the same=20
> directory.
> Jan 08 12:36:08 mypc kernel: dvbdev: dvb_register_device: failed to=20
> create device dvb0.net0 (-17)
> Jan 08 12:36:08 mypc kernel: usb 1-3: dvb_usb_v2: dvb_net_init() failed=
=3D-17
> Jan 08 12:36:08 mypc kernel: dvb_usb_dvbsky: probe of 1-3:1.0 failed=20
> with error -17

Could you please post the full dmesg? What I suspect is that you may
have some trouble with the USB (yet, it should not be crashing).

Perhaps your chipset is not providing enough power via USB for
both devices and the device is getting unregistered and re-registered.

> As I thought that the different modules (dvb_usb_dvbsky and em28xx) are=20
> the cause I ordered a new device which use the same chips:
>=20
> 3. DVBSky T330 (bus ID 0572:0320).
>=20
> The error messages still show up:
>=20
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-3: dvb_usb_v2: found a 'DVBSky T330'=
 in=20
> warm state
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-3: dvb_usb_v2: will pass the complet=
e=20
> MPEG2 transport stream to the software demuxer
> [Mi Jan=C2=A0 9 21:59:48 2019] dvbdev: DVB: registering new adapter (DVBS=
ky T330)
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-3: dvb_usb_v2: MAC address:=20
> 00:cc:10:a5:33:0c
> [Mi Jan=C2=A0 9 21:59:48 2019] i2c i2c-6: Added multiplexed i2c bus 7
> [Mi Jan=C2=A0 9 21:59:48 2019] si2168 6-0064: Silicon Labs Si2168-B40=20
> successfully identified
> [Mi Jan=C2=A0 9 21:59:48 2019] si2168 6-0064: firmware version: B 4.0.2
> [Mi Jan=C2=A0 9 21:59:48 2019] media: Linux media interface: v0.10
> [Mi Jan=C2=A0 9 21:59:48 2019] si2157 7-0060: Silicon Labs=20
> Si2147/2148/2157/2158 successfully attached
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-3: DVB: registering adapter 0 fronte=
nd 0=20
> (Silicon Labs Si2168)...
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-3: dvb_usb_v2: 'DVBSky T330'=20
> successfully initialized and connected
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-4: dvb_usb_v2: found a 'TechnoTrend=
=20
> TVStick CT2-4400' in warm state
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-4: dvb_usb_v2: will pass the complet=
e=20
> MPEG2 transport stream to the software demuxer
> [Mi Jan=C2=A0 9 21:59:48 2019] dvbdev: DVB: registering new adapter=20
> (TechnoTrend TVStick CT2-4400)
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-4: dvb_usb_v2: MAC address:=20
> bc:ea:2b:44:0f:89
> [Mi Jan=C2=A0 9 21:59:48 2019] i2c i2c-8: Added multiplexed i2c bus 9
> [Mi Jan=C2=A0 9 21:59:48 2019] si2168 8-0064: Silicon Labs Si2168-B40=20
> successfully identified
> [Mi Jan=C2=A0 9 21:59:48 2019] si2168 8-0064: firmware version: B 4.0.2
> [Mi Jan=C2=A0 9 21:59:48 2019] si2157 9-0060: Silicon Labs=20
> Si2147/2148/2157/2158 successfully attached
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-4: DVB: registering adapter 1 fronte=
nd 0=20
> (Silicon Labs Si2168)...
> [Mi Jan=C2=A0 9 21:59:48 2019] usb 1-4: dvb_usb_v2: 'TechnoTrend TVStick=
=20
> CT2-4400' successfully initialized and connected
> [Mi Jan=C2=A0 9 21:59:48 2019] usbcore: registered new interface driver=20
> dvb_usb_dvbsky
> [Mi Jan=C2=A0 9 22:00:03 2019] si2168 6-0064: firmware: direct-loading=20
> firmware dvb-demod-si2168-b40-01.fw
> [Mi Jan=C2=A0 9 22:00:03 2019] si2168 6-0064: downloading firmware from f=
ile=20
> 'dvb-demod-si2168-b40-01.fw'
> [Mi Jan=C2=A0 9 22:00:03 2019] si2168 6-0064: firmware version: B 4.0.11
> [Mi Jan=C2=A0 9 22:00:03 2019] si2157 7-0060: found a 'Silicon Labs Si215=
7-A30'
> [Mi Jan=C2=A0 9 22:00:04 2019] si2157 7-0060: firmware version: 3.0.5
> [Mi Jan=C2=A0 9 22:00:04 2019] si2168 8-0064: firmware: direct-loading=20
> firmware dvb-demod-si2168-b40-01.fw
> [Mi Jan=C2=A0 9 22:00:04 2019] si2168 8-0064: downloading firmware from f=
ile=20
> 'dvb-demod-si2168-b40-01.fw'
> [Mi Jan=C2=A0 9 22:00:04 2019] si2168 8-0064: firmware version: B 4.0.11
> [Mi Jan=C2=A0 9 22:00:04 2019] si2157 9-0060: found a 'Silicon Labs Si215=
7-A30'
> [Mi Jan=C2=A0 9 22:00:04 2019] si2157 9-0060: firmware version: 3.0.5
> [Mi Jan=C2=A0 9 22:00:04 2019] fuse init (API version 7.28)
> [Mi Jan=C2=A0 9 22:01:01 2019] dmxdev: DVB (dvb_dmxdev_filter_start): cou=
ld=20
> not set feed
> [Mi Jan=C2=A0 9 22:01:01 2019] dvb_demux: dvb_demux_feed_del: feed not in=
=20
> list (type=3D1 state=3D0 pid=3Dffff)
>=20
> Now I'd like to know if this is an driver limitation or is there=20
> anything I could set up differently in order to make it work (except for=
=20
> disabling the remotes I didn't set any parameters than standard).

There is a limit when multiple USB devices are used, with is the
maximum USB bandwidth. Several systems share a single USB bus with
multiple USB ports. That limits the maximum number of slots that can
be allocated for ISOC traffic, but this affects more analog TV
(with uses uncompressed frames). With em28xx driver, a 640x480
video with 30 frames per second and 16 bits per pixel is enough
to reserve 60% of the maximum allowed number of frames for ISOC on
a USB bus. That produces a ~140 MBps trafic[1]. So, if one wants=20
multiple USB cards, he has to either reduce the resolution or be
sure that the second card is on a separate USB bus.

[1] You may think that this is a way below the 480 Mbps "official"
limit for USB, but the USB spec actually limits the number of
packets per second. So, if a device is not using the maximum
packet size, the limit is a way below the maximum.

With Digital TV, as the the bit rate per a MPEG-TS stream is at
the range of 20 Mbps to 50 Mbps, usually you can have more
USB devices working at the same time [2].

[2] At least on x86_64 machines. I've seen a lot of problems
on arm, due to broken USB hosts/host drivers. The Rasperry Pi
USB host, for example, has problems even with just one device.

Thanks,
Mauro
