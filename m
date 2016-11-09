Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:36508 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbcKIPhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 10:37:31 -0500
Received: by mail-it0-f53.google.com with SMTP id q124so164242871itd.1
        for <linux-media@vger.kernel.org>; Wed, 09 Nov 2016 07:37:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161109073331.204b53c4@vento.lan>
References: <CAA7C2qjXSkmmCB=zc7Y-Btpwzm_B=_ok0t6qMRuCy+gfrEhcMw@mail.gmail.com>
 <20161108155520.224229d5@vento.lan> <CAA7C2qiY5MddsP4Ghky1PAhYuvTbBUR5QwejM=z8wCMJCwRw7g@mail.gmail.com>
 <20161109073331.204b53c4@vento.lan>
From: VDR User <user.vdr@gmail.com>
Date: Wed, 9 Nov 2016 07:37:30 -0800
Message-ID: <CAA7C2qhK0x9bwHH-Q8ufz3zdOgiPs3c=d27s0BRNfmcv9+T+Gg@mail.gmail.com>
Subject: Re: Question about 2 gp8psk patches I noticed, and possible bug.
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are the results after testing the latest patch:

[33922.643770] usbcore: deregistering interface driver dvb_usb_gp8psk
[33922.643789] gp8psk: unregistering fe0
[33922.643865] gp8psk: detaching fe0
[33922.643868] ------------[ cut here ]------------
[33922.643875] WARNING: CPU: 1 PID: 8895 at kernel/module.c:1108
module_put+0x67/0x80
[33922.643876] Modules linked in: dvb_usb_gp8psk(O-) dvb_usb(O)
dvb_core(O) nvidia_drm(PO) nvidia_modeset(PO) snd_hda_codec_hdmi
snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer
snd soundcore nvidia(PO) [last unloaded: dvb_core]
[33922.643890] CPU: 1 PID: 8895 Comm: rmmod Tainted: P        WC O
4.8.4-build.2 #1
[33922.643891] Hardware name: MSI MS-7309/MS-7309, BIOS V1.12 02/23/2009
[33922.643893]  00000000 c12c15f0 00000000 00000000 c103fc7a c161ecc0
00000001 000022bf
[33922.643897]  c161e50f 00000454 c10a4b87 c10a4b87 00000009 f804fd80
00000000 00000000
[33922.643901]  f3cca000 c103fd43 00000009 00000000 00000000 c10a4b87
f804e6e0 c10a58fa
[33922.643905] Call Trace:
[33922.643909]  [<c12c15f0>] ? dump_stack+0x44/0x64
[33922.643913]  [<c103fc7a>] ? __warn+0xfa/0x120
[33922.643915]  [<c10a4b87>] ? module_put+0x67/0x80
[33922.643917]  [<c10a4b87>] ? module_put+0x67/0x80
[33922.643919]  [<c103fd43>] ? warn_slowpath_null+0x23/0x30
[33922.643921]  [<c10a4b87>] ? module_put+0x67/0x80
[33922.643924]  [<f804e6e0>] ? gp8psk_fe_set_frontend+0x460/0x460
[dvb_usb_gp8psk]
[33922.643927]  [<c10a58fa>] ? symbol_put_addr+0x2a/0x50
[33922.643929]  [<f804d0b9>] ? gp8psk_usb_disconnect+0xb9/0xd0 [dvb_usb_gp8psk]
[33922.643932]  [<c13da272>] ? usb_unbind_interface+0x62/0x250
[33922.643936]  [<c1551f3f>] ? _raw_spin_unlock_irqrestore+0xf/0x30
[33922.643939]  [<c1372ea4>] ? __pm_runtime_idle+0x44/0x70
[33922.643943]  [<c1369a68>] ? __device_release_driver+0x78/0x120
[33922.643945]  [<c136a297>] ? driver_detach+0x87/0x90
[33922.643947]  [<c13695d8>] ? bus_remove_driver+0x38/0x90
[33922.643949]  [<c13d9608>] ? usb_deregister+0x58/0xb0
[33922.643951]  [<c10a5eb0>] ? SyS_delete_module+0x130/0x1f0
[33922.643954]  [<c1036200>] ? __do_page_fault+0x1a0/0x440
[33922.643956]  [<c1000fa5>] ? exit_to_usermode_loop+0x85/0x90
[33922.643958]  [<c10013f0>] ? do_fast_syscall_32+0x80/0x130
[33922.643961]  [<c1552403>] ? sysenter_past_esp+0x40/0x6a
[33922.643962] ---[ end trace a387b7eddb538bfe ]---
[33922.643963] gp8psk: calling dvb_usb_device_exit
[33922.646462] dvb-usb: Genpix SkyWalker-2 DVB-S receiver successfully
deinitialized and disconnected.

$ gdb /usr/src/linux/drivers/media/usb/dvb-usb/dvb-usb-gp8psk.ko
GNU gdb (Debian 7.11.1-2) 7.11.1
...
Reading symbols from
/usr/src/linux/drivers/media/usb/dvb-usb/dvb-usb-gp8psk.ko...done.
(gdb) l *gp8psk_fe_set_frontend+0x460
0x1710 is in gp8psk_fe_release (drivers/media/usb/dvb-usb/gp8psk-fe.c:325).
320     }
321
322     static void gp8psk_fe_release(struct dvb_frontend* fe)
323     {
324             struct gp8psk_fe_state *state = fe->demodulator_priv;
325             kfree(state);
326     }
327
328     static struct dvb_frontend_ops gp8psk_fe_ops;
329
(gdb) l *gp8psk_usb_disconnect+0xb9
0xe9 is in gp8psk_usb_disconnect (drivers/media/usb/dvb-usb/gp8psk.c:432).
427                     for (; i >= 0; i--) {
428                             if (adap->fe_adap[i].fe != NULL) {
429                                     printk("gp8psk: unregistering
fe%d\n", i);
430
dvb_unregister_frontend(adap->fe_adap[i].fe);
431                                     printk("gp8psk: detaching fe%d\n", i);
432
dvb_frontend_detach(adap->fe_adap[i].fe);
433                             }
434                     }
435                     adap->num_frontends_initialized = 0;
436             }

Thanks,
Derek
