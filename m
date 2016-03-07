Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33332 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbcCGMqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 07:46:01 -0500
Received: by mail-pf0-f176.google.com with SMTP id 124so80344709pfg.0
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2016 04:46:01 -0800 (PST)
From: Tim Connors <tim.w.connors@gmail.com>
Date: Mon, 7 Mar 2016 23:45:51 +1100 (AEDT)
To: Olli Salonen <olli.salonen@iki.fi>
cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Panic upon DViCO FusionHDTV DVB-T USB (TH7579) insertion
In-Reply-To: <CAAZRmGxts4s1rrNEa6YOCVVTmt7Vv+J=YH_06fe0N-1o=j0B7w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1603072332250.28995@dirac.rather.puzzling.org>
References: <alpine.DEB.2.02.1602272221340.22807@dirac.rather.puzzling.org> <56D1CEC2.7010308@iki.fi> <CAAZRmGxts4s1rrNEa6YOCVVTmt7Vv+J=YH_06fe0N-1o=j0B7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Upgraded kernel to debian linux-image-4.4.0-1-amd64 (was a debian
prerelease 4.4.0-trunk-amd64), compiled in new media_build.git with this
patch:

diff --git a/drivers/media/usb/dvb-usb/cxusb.c
b/drivers/media/usb/dvb-usb/cxusb.c
index 24a457d9d803..def6d21d1445 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1501,18 +1501,18 @@
        struct i2c_client *client;

        /* remove I2C client for tuner */
-       client = st->i2c_client_tuner;
+/*     client = st->i2c_client_tuner;
        if (client) {
                module_put(client->dev.driver->owner);
                i2c_unregister_device(client);
-       }
+       } */

        /* remove I2C client for demodulator */
-       client = st->i2c_client_demod;
+/*     client = st->i2c_client_demod;
        if (client) {
                module_put(client->dev.driver->owner);
                i2c_unregister_device(client);
-       }
+       } */

        dvb_usb_device_exit(intf);
 }

but still get this oops when plugging in the device:

Mar  7 23:17:02 fs kernel: [ 1244.944047] usb 1-4: new high-speed USB device number 7 using ehci-pci
Mar  7 23:17:03 fs kernel: [ 1245.076521] usb 1-4: New USB device found, idVendor=0fe9, idProduct=db10
Mar  7 23:17:03 fs kernel: [ 1245.076532] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Mar  7 23:17:03 fs laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Mar  7 23:17:03 fs laptop-mode: laptop-mode-tools is disabled in config file. Exiting
Mar  7 23:17:03 fs kernel: [ 1245.130250] media: Linux media interface: v0.10
Mar  7 23:17:03 fs kernel: [ 1245.135455] WARNING: You are using an experimental version of the media stack.
Mar  7 23:17:03 fs kernel: [ 1245.135455] #011As the driver is backported to an older kernel, it doesn't offer
Mar  7 23:17:03 fs kernel: [ 1245.135455] #011enough quality for its usage in production.
Mar  7 23:17:03 fs kernel: [ 1245.135455] #011Use it with care.
Mar  7 23:17:03 fs kernel: [ 1245.135455] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
Mar  7 23:17:03 fs kernel: [ 1245.135455] #011de08b5a8be0df1eb7c796b0fe6b30cf1d03d14a6 [media] v4l: exynos4-is: Drop unneeded check when setting up fimc-lite links
Mar  7 23:17:03 fs kernel: [ 1245.135455] #01102650ebd2d306b661e6ad000e7981c7d8544f8f6 [media] v4l: vsp1: Check if an entity is a subdev with the right function
Mar  7 23:17:03 fs kernel: [ 1245.135455] #0110a82edd011f5cd3de1eded8fe1d78cef370b2083 [media] hide unused functions for !MEDIA_CONTROLLER
Mar  7 23:17:03 fs kernel: [ 1245.143211] WARNING: You are using an experimental version of the media stack.
Mar  7 23:17:03 fs kernel: [ 1245.143211] #011As the driver is backported to an older kernel, it doesn't offer
Mar  7 23:17:03 fs kernel: [ 1245.143211] #011enough quality for its usage in production.
Mar  7 23:17:03 fs kernel: [ 1245.143211] #011Use it with care.
Mar  7 23:17:03 fs kernel: [ 1245.143211] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
Mar  7 23:17:03 fs kernel: [ 1245.143211] #011de08b5a8be0df1eb7c796b0fe6b30cf1d03d14a6 [media] v4l: exynos4-is: Drop unneeded check when setting up fimc-lite links
Mar  7 23:17:03 fs kernel: [ 1245.143211] #01102650ebd2d306b661e6ad000e7981c7d8544f8f6 [media] v4l: vsp1: Check if an entity is a subdev with the right function
Mar  7 23:17:03 fs kernel: [ 1245.143211] #0110a82edd011f5cd3de1eded8fe1d78cef370b2083 [media] hide unused functions for !MEDIA_CONTROLLER
Mar  7 23:17:03 fs kernel: [ 1245.153266] dvb-usb: found a 'DViCO FusionHDTV DVB-T USB (TH7579)' in cold state, will try to load a firmware
Mar  7 23:17:03 fs kernel: [ 1245.154688] usb 1-4: firmware: direct-loading firmware dvb-usb-bluebird-01.fw
Mar  7 23:17:03 fs kernel: [ 1245.154706] dvb-usb: downloading firmware from file 'dvb-usb-bluebird-01.fw'
Mar  7 23:17:03 fs kernel: [ 1245.218962] usbcore: registered new interface driver dvb_usb_cxusb
Mar  7 23:17:03 fs laptop-mode: Warning: Configuration file /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
Mar  7 23:17:03 fs laptop-mode: laptop-mode-tools is disabled in config file. Exiting
Mar  7 23:17:03 fs kernel: [ 1245.250660] usb 1-4: USB disconnect, device number 7
Mar  7 23:17:03 fs kernel: [ 1245.250727] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
Mar  7 23:17:04 fs CRON[13170]: pam_unix(cron:session): session closed for user root
Mar  7 23:17:05 fs kernel: [ 1247.036080] usb 1-4: new high-speed USB device number 8 using ehci-pci
Mar  7 23:17:05 fs kernel: [ 1247.169608] usb 1-4: New USB device found, idVendor=0fe9, idProduct=db11
Mar  7 23:17:05 fs kernel: [ 1247.169622] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Mar  7 23:17:05 fs kernel: [ 1247.169631] usb 1-4: Product: Bluebird
Mar  7 23:17:05 fs kernel: [ 1247.169640] usb 1-4: Manufacturer: Dvico
Mar  7 23:17:05 fs kernel: [ 1247.170411] dvb-usb: found a 'DViCO FusionHDTV DVB-T USB (TH7579)' in warm state.
Mar  7 23:17:05 fs kernel: [ 1247.170745] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Mar  7 23:17:05 fs kernel: [ 1247.181694] DVB: registering new adapter (DViCO FusionHDTV DVB-T USB (TH7579))
Mar  7 23:17:05 fs kernel: [ 1247.181715] usb 1-4: media controller created
Mar  7 23:17:05 fs kernel: [ 1247.182217] BUG: unable to handle kernel NULL pointer dereference at           (null)
Mar  7 23:17:05 fs kernel: [ 1247.182514] IP: [<ffffffff81303976>] __list_add+0x16/0xb0
Mar  7 23:17:05 fs kernel: [ 1247.182715] PGD ab930067 PUD abb21067 PMD 0
Mar  7 23:17:05 fs kernel: [ 1247.182925] Oops: 0000 [#1] SMP
Mar  7 23:17:05 fs kernel: [ 1247.183088] Modules linked in: dvb_usb_cxusb(O) dib0070(O) dvb_usb(O) dvb_core(O) rc_core(O) media(O) nf_conntrack_netlink nf_conntrack xt_multiport iptable_filter ip_tables x_tables nfnetlink_log nfnetlink fuse cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep rfcomm bluetooth rfkill autofs4 uinput rpcsec_gss_krb5 nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc raid1 cpufreq_stats loop md_mod zfs(PO) coretemp zunicode(PO) zcommon(PO) pcspkr znvpair(PO) serio_raw i2c_i801 evdev snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device pl2303 usbserial spl(O) zavl(PO) amdkfd radeon snd_hda_intel ttm snd_hda_codec drm_kms_helper snd_hda_core snd_hwdep snd_pcm_oss snd_mixer_oss ich7_gpio(O) drm snd_pcm i2c_algo_bit snd_timer snd shpchp soundcore 8250_fintek button acpi_cpufreq tpm_tis tpm processor ext4 crc16 mbcache jbd2 dm_mod it87 hwmon_vid ata_generic sg sd_mod hid_generic uas usbhid usb_storage hid ahci pata_jmicron libahci libata scsi_mod e1000
Mar  7 23:17:05 fs kernel: e ptp uhci_hcd pps_core ehci_pci ehci_hcd usbcore usb_common fan fjes thermal
Mar  7 23:17:05 fs kernel: [ 1247.184425] CPU: 0 PID: 134 Comm: kworker/0:2 Tainted: P           O    4.4.0-1-amd64 #1 Debian 4.4.2-3
Mar  7 23:17:05 fs kernel: [ 1247.184425] Hardware name: OEM OEM/Pineview-ICH9, BIOS 6.00 PG 11/17/2010
Mar  7 23:17:05 fs kernel: [ 1247.184425] Workqueue: usb_hub_wq hub_event [usbcore]
Mar  7 23:17:05 fs kernel: [ 1247.184425] task: ffff88003635f1c0 ti: ffff88003627c000 task.ti: ffff88003627c000
Mar  7 23:17:05 fs kernel: [ 1247.184425] RIP: 0010:[<ffffffff81303976>]  [<ffffffff81303976>] __list_add+0x16/0xb0
Mar  7 23:17:05 fs kernel: [ 1247.184425] RSP: 0018:ffff88003627f6e8  EFLAGS: 00010246
Mar  7 23:17:05 fs kernel: [ 1247.184425] RAX: 0000000000000001 RBX: ffff88007bd38010 RCX: 0000000000000000
Mar  7 23:17:05 fs kernel: [ 1247.184425] RDX: ffff88013903d440 RSI: 0000000000000000 RDI: ffff88007bd38010
Mar  7 23:17:05 fs kernel: [ 1247.184425] RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffffffffffff
Mar  7 23:17:05 fs kernel: [ 1247.184425] R10: 0000000000000000 R11: ffff88003610c36e R12: ffff88013903d440
Mar  7 23:17:05 fs kernel: [ 1247.184425] R13: 0000000000000000 R14: ffffffffa098d740 R15: ffff88007bd38000
Mar  7 23:17:05 fs kernel: [ 1247.184425] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Mar  7 23:17:05 fs kernel: [ 1247.184425] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar  7 23:17:05 fs kernel: [ 1247.184425] CR2: 0000000000000000 CR3: 00000000ab841000 CR4: 00000000000006f0
Mar  7 23:17:05 fs kernel: [ 1247.184425] Stack:
Mar  7 23:17:05 fs kernel: [ 1247.184425]  ffff88013903d000 ffff88007bd38000 ffff88013903d490 ffffffffa09536c8
Mar  7 23:17:05 fs kernel: [ 1247.184425]  ffff88007bd38000 ffff88013903d000 ffffffffa0951100 00000000fd03d7a9
Mar  7 23:17:05 fs kernel: [ 1247.184425]  ffff88003610c36d ffff88003610c36f ffff88003627f810 000000000000000f
Mar  7 23:17:05 fs kernel: [ 1247.184425] Call Trace:
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa09536c8>] ? media_gobj_create+0xa8/0xd0 [media]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa0951100>] ? media_device_register_entity+0xd0/0x220 [media]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff812f30dd>] ? vsnprintf+0x39d/0x590
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff812f65f6>] ? kvasprintf+0x76/0xa0
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff812f666e>] ? kasprintf+0x4e/0x70
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa097b67c>] ? dvb_create_tsout_entity+0x12c/0x150 [dvb_core]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa097bb45>] ? dvb_register_device+0x425/0x630 [dvb_core]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa097d226>] ? dvb_dmxdev_init+0xf6/0x140 [dvb_core]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa09a5903>] ? dvb_usb_adapter_dvb_init+0x1b3/0x2a0 [dvb_usb]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa09a4a6e>] ? dvb_usb_device_init+0x4ce/0x760 [dvb_usb]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa09b2155>] ? cxusb_probe+0xb5/0x200 [dvb_usb_cxusb]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa0038c03>] ? usb_probe_interface+0x1b3/0x300 [usbcore]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140dbc2>] ? driver_probe_device+0x212/0x480
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140deb0>] ? __driver_attach+0x80/0x80
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140b8c2>] ? bus_for_each_drv+0x62/0xb0
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140d8c8>] ? __device_attach+0xd8/0x160
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140cbc7>] ? bus_probe_device+0x87/0xa0
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140a8e5>] ? device_add+0x3f5/0x660
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa0036c2b>] ? usb_set_configuration+0x51b/0x8f0 [usbcore]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa0040fa8>] ? generic_probe+0x28/0x80 [usbcore]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140dbc2>] ? driver_probe_device+0x212/0x480
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140deb0>] ? __driver_attach+0x80/0x80
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140b8c2>] ? bus_for_each_drv+0x62/0xb0
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140d8c8>] ? __device_attach+0xd8/0x160
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140cbc7>] ? bus_probe_device+0x87/0xa0
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8140a8e5>] ? device_add+0x3f5/0x660
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa002c545>] ? usb_new_device+0x265/0x490 [usbcore]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffffa002e6e3>] ? hub_event+0xfb3/0x14f0 [usbcore]
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8108d84f>] ? process_one_work+0x19f/0x3d0
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8108dacd>] ? worker_thread+0x4d/0x450
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8108da80>] ? process_one_work+0x3d0/0x3d0
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff8109385d>] ? kthread+0xcd/0xf0
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff81093790>] ? kthread_create_on_node+0x190/0x190
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff81589c0f>] ? ret_from_fork+0x3f/0x70
Mar  7 23:17:05 fs kernel: [ 1247.184425]  [<ffffffff81093790>] ? kthread_create_on_node+0x190/0x190
Mar  7 23:17:05 fs kernel: [ 1247.184425] Code: ff ff e8 ee 27 d7 ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 41 54 55 49 89 d4 53 4c 8b 42 08 48 89 fb 48 89 f5 49 39 f0 75 28 <4c> 8b 45 00 4d 39 c4 75 46 48 39 dd 74 61 49 39 dc 74 5c 49 89
Mar  7 23:17:05 fs kernel: [ 1247.184425] RIP  [<ffffffff81303976>] __list_add+0x16/0xb0
Mar  7 23:17:05 fs kernel: [ 1247.184425]  RSP <ffff88003627f6e8>
Mar  7 23:17:05 fs kernel: [ 1247.184425] CR2: 0000000000000000
Mar  7 23:17:05 fs kernel: [ 1247.184425] ---[ end trace b95825a975e95544 ]---
Mar  7 23:17:05 fs kernel: [ 1247.427089] BUG: unable to handle kernel paging request at ffffffffffffffd8


Hope I haven't miscompiled or something stupid.

On Tue, 1 Mar 2016, Olli Salonen wrote:

> Well, that theory is easy to test if you have the device:
>
> Just comment out these lines (that only are applicable to Mygica T230
> anyhow) from the function cxusb_disconnect:
>
>         /* remove I2C client for tuner */
>         client = st->i2c_client_tuner;
>         if (client) {
>                 module_put(client->dev.driver->owner);
>                 i2c_unregister_device(client);
>         }
>
>         /* remove I2C client for demodulator */
>         client = st->i2c_client_demod;
>         if (client) {
>                 module_put(client->dev.driver->owner);
>                 i2c_unregister_device(client);
>         }
>
> Not an expert on the internals of dvb-usb, but in what kind of
> situation the state would not be available?
>
> Cheers,
> -olli
>
>
>
> On 27 February 2016 at 18:28, Antti Palosaari <crope@iki.fi> wrote:
> > I think it is because of your device disconnects itself from the usb bus
> > after the firmware download (and then reconnects with different usb id) and
> > disconnect callback refers to data that does not exist at the moment (driver
> > state).
> >
> > Olli could you take a look about it.
> >
> > regards
> > Antti
> >
> >
> > On 02/27/2016 01:26 PM, Tim Connors wrote:
> >>
> >> I've submitted bug https://bugzilla.kernel.org/show_bug.cgi?id=112861
> >>
> >> cxusb last worked for me in debian's 3.16.0-0.bpo.4-amd64, failed in 4.3
> >> and 4.4.  Oops and then panic within a second of plugging in the usb cable
> >> (or at bootup).  My other usb tuner is working flawlessly.
> >>
> >> https://bugzilla.redhat.com/show_bug.cgi?id=1175001
> >> might be a similar bug, and I tried reverting the patch here (since George
> >> talks about a new oops in the same timeframe):
> >> https://bugzilla.redhat.com/show_bug.cgi?id=1154454
> >> but with no luck.
> >>
> >>
> >> What should I do next?
> >>
> >>
> >> Feb 15 00:09:54 fs kernel: [11927.112039] usb 1-3.2: new high-speed USB
> >> device number 9 using ehci-pci
> >> Feb 15 00:09:54 fs kernel: [11927.220430] usb 1-3.2: New USB device found,
> >> idVendor=0fe9, idProduct=db10
> >> Feb 15 00:09:54 fs kernel: [11927.220440] usb 1-3.2: New USB device
> >> strings: Mfr=0, Product=0, SerialNumber=0
> >> Feb 15 00:09:54 fs laptop-mode: Warning: Configuration file
> >> /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
> >> Feb 15 00:09:54 fs laptop-mode: laptop-mode-tools is disabled in config
> >> file. Exiting
> >> Feb 15 00:09:54 fs kernel: [11927.254648] dvb-usb: found a 'DViCO
> >> FusionHDTV DVB-T USB (TH7579)' in cold state, will try to load a firmware
> >> Feb 15 00:09:54 fs kernel: [11927.254740] usb 1-3.2: firmware:
> >> direct-loading firmware dvb-usb-bluebird-01.fw
> >> Feb 15 00:09:54 fs kernel: [11927.254749] dvb-usb: downloading firmware
> >> from file 'dvb-usb-bluebird-01.fw'
> >> Feb 15 00:09:54 fs kernel: [11927.318141] usbcore: registered new
> >> interface driver dvb_usb_cxusb
> >> Feb 15 00:09:54 fs laptop-mode: Warning: Configuration file
> >> /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
> >> Feb 15 00:09:54 fs laptop-mode: laptop-mode-tools is disabled in config
> >> file. Exiting
> >> Feb 15 00:09:54 fs kernel: [11927.397296] usb 1-3.2: USB disconnect,
> >> device number 9
> >> Feb 15 00:09:54 fs kernel: [11927.397407] BUG: unable to handle kernel
> >> paging request at 0000000000002830
> >> Feb 15 00:09:54 fs kernel: [11927.397656] IP: [<ffffffffa0d350a3>]
> >> cxusb_disconnect+0x13/0x70 [dvb_usb_cxusb]
> >> Feb 15 00:09:54 fs kernel: [11927.397907] PGD a1537067 PUD b003f067 PMD 0
> >> Feb 15 00:09:54 fs kernel: [11927.398096] Oops: 0000 [#1] SMP
> >> Feb 15 00:09:54 fs kernel: [11927.398247] Modules linked in:
> >> dvb_usb_cxusb(O) rc_dib0700_rc5(O) tuner_xc2028(O) dib7000p(O)
> >> dvb_usb_dib0700(O) dib9000(O) dib7000m(O) dib0090(O) dib0070(O) dib3000mc(O)
> >> dibx000_common(O) dvb_usb(O) dvb_core(O) rc_core(O) media(O) nfsv4
> >> dns_resolver nf_conntrack_netlink nf_conntrack xt_multiport iptable_filter
> >> ip_tables x_tables nfnetlink_log nfnetlink fuse cpufreq_powersave
> >> cpufreq_userspace cpufreq_conservative bnep rfcomm bluetooth rfkill autofs4
> >> uinput rpcsec_gss_krb5 nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace
> >> fscache sunrpc raid1 cpufreq_stats loop md_mod coretemp pcspkr serio_raw
> >> evdev i2c_i801 pl2303 usbserial zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO)
> >> snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device spl(O) zavl(PO)
> >> amdkfd radeon snd_hda_intel ttm drm_kms_helper snd_hda_codec ich7_gpio(O)
> >> snd_hda_core snd_hwdep snd_pcm_oss drm snd_mixer_oss i2c_algo_bit snd_pcm
> >> snd_timer snd soundcore shpchp 8250_fintek button acpi!
> >
> > _c!
> >>
> >>   pufreq tpm_tis tpm processor ext4
> >> Feb 15 00:09:54 fs kernel: crc16 mbcache jbd2 dm_mod it87 hwmon_vid
> >> ata_generic hid_generic usbhid hid uas usb_storage sg sd_mod ahci
> >> pata_jmicron libahci libata e1000e scsi_mod uhci_hcd ehci_pci ehci_hcd ptp
> >> pps_core usbcore usb_common thermal fan [last unloaded: dib0090]
> >> Feb 15 00:09:54 fs kernel: [11927.401277] CPU: 0 PID: 8965 Comm:
> >> kworker/0:0 Tainted: P           O    4.4.0-trunk-amd64 #1 Debian 4.4-1~exp1
> >> Feb 15 00:09:54 fs kernel: [11927.401277] Hardware name: OEM
> >> OEM/Pineview-ICH9, BIOS 6.00 PG 11/17/2010
> >> Feb 15 00:09:54 fs kernel: [11927.401277] Workqueue: usb_hub_wq hub_event
> >> [usbcore]
> >> Feb 15 00:09:54 fs kernel: [11927.401277] task: ffff880036172740 ti:
> >> ffff8801112f8000 task.ti: ffff8801112f8000
> >> Feb 15 00:09:54 fs kernel: [11927.401277] RIP: 0010:[<ffffffffa0d350a3>]
> >> [<ffffffffa0d350a3>] cxusb_disconnect+0x13/0x70 [dvb_usb_cxusb]
> >> Feb 15 00:09:54 fs kernel: [11927.401277] RSP: 0018:ffff8801112fbbd8
> >> EFLAGS: 00010246
> >> Feb 15 00:09:54 fs kernel: [11927.401277] RAX: 0000000000000000 RBX:
> >> ffff88007f057030 RCX: 0000000000000000
> >> Feb 15 00:09:54 fs kernel: [11927.401277] RDX: 0000000000000000 RSI:
> >> ffff88007f057000 RDI: ffff88007f057000
> >> Feb 15 00:09:54 fs kernel: [11927.401277] RBP: ffff88007f057000 R08:
> >> 0000000000000000 R09: 0000000000000000
> >> Feb 15 00:09:54 fs kernel: [11927.401277] R10: 000000000000001a R11:
> >> 0000000000000070 R12: ffffffffa0051380
> >> Feb 15 00:09:54 fs kernel: [11927.401277] R13: ffffffffa0d390a8 R14:
> >> ffff8800b90a8090 R15: ffff8800b90a8000
> >> Feb 15 00:09:54 fs kernel: [11927.401277] FS:  0000000000000000(0000)
> >> GS:ffff88013fc00000(0000) knlGS:0000000000000000
> >> Feb 15 00:09:54 fs kernel: [11927.401277] CS:  0010 DS: 0000 ES: 0000 CR0:
> >> 000000008005003b
> >> Feb 15 00:09:54 fs kernel: [11927.401277] CR2: 0000000000002830 CR3:
> >> 00000000b001b000 CR4: 00000000000006f0
> >> Feb 15 00:09:54 fs kernel: [11927.401277] Stack:
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  ffff88007f057030
> >> ffff88007f057000 ffffffffa0051380 ffffffffa003c429
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  ffff8800b90a8000
> >> 0000000000000000 ffff8800b90a8090 ffff88007f0570e0
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  ffff88007f057030
> >> ffffffffa0d390a8 ffffffffa0051380 ffff88007f057040
> >> Feb 15 00:09:54 fs kernel: [11927.401277] Call Trace:
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa003c429>] ?
> >> usb_unbind_interface+0x79/0x250 [usbcore]
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff81408fea>] ?
> >> __device_release_driver+0x9a/0x140
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff814090ae>] ?
> >> device_release_driver+0x1e/0x30
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff81408739>] ?
> >> bus_remove_device+0xf9/0x170
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff81404bb7>] ?
> >> device_del+0x127/0x250
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff814057fc>] ?
> >> _dev_info+0x6c/0x90
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa0039dce>] ?
> >> usb_disable_device+0x7e/0x260 [usbcore]
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa002fc30>] ?
> >> usb_disconnect+0x90/0x280 [usbcore]
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa002bc24>] ?
> >> set_port_feature+0x44/0x50 [usbcore]
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa0031e5d>] ?
> >> hub_event+0x75d/0x14e0 [usbcore]
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff8108d79f>] ?
> >> process_one_work+0x19f/0x3d0
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff8108da1d>] ?
> >> worker_thread+0x4d/0x450
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff8108d9d0>] ?
> >> process_one_work+0x3d0/0x3d0
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff810937ad>] ?
> >> kthread+0xcd/0xf0
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff810936e0>] ?
> >> kthread_create_on_node+0x190/0x190
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff81583dcf>] ?
> >> ret_from_fork+0x3f/0x70
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff810936e0>] ?
> >> kthread_create_on_node+0x190/0x190
> >> Feb 15 00:09:54 fs kernel: [11927.401277] Code: c7 02 00 00 00 00 31 c0 c3
> >> 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 48 89
> >> fd 53 48 8b 87 d0 00 00 00 <4c> 8b a0 30 28 00 00 49 8b 5c 24 10 48 85 db 74
> >> 18 48 8b 83 b0
> >> Feb 15 00:09:54 fs kernel: [11927.401277] RIP  [<ffffffffa0d350a3>]
> >> cxusb_disconnect+0x13/0x70 [dvb_usb_cxusb]
> >> Feb 15 00:09:54 fs kernel: [11927.401277]  RSP <ffff8801112fbbd8>
> >> Feb 15 00:09:54 fs kernel: [11927.401277] CR2: 0000000000002830
> >> Feb 15 00:09:54 fs kernel: [11927.401277] ---[ end trace d6393009544ed355
> >> ]---
> >> Feb 15 00:09:54 fs kernel: [11927.527370] BUG: unable to handle kernel
> >> paging request at ffffffffffffffd8
> >>
> >
> > --
> > http://palosaari.fi/
>
>

-- 
Tim Connors
