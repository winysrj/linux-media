Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37898 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbcCAVyM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2016 16:54:12 -0500
Subject: Re: Panic upon DViCO FusionHDTV DVB-T USB (TH7579) insertion
To: Olli Salonen <olli.salonen@iki.fi>
References: <alpine.DEB.2.02.1602272221340.22807@dirac.rather.puzzling.org>
 <56D1CEC2.7010308@iki.fi>
 <CAAZRmGxts4s1rrNEa6YOCVVTmt7Vv+J=YH_06fe0N-1o=j0B7w@mail.gmail.com>
Cc: Tim Connors <reportbug@rather.puzzling.org>,
	linux-media <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56D60F7F.3090302@iki.fi>
Date: Tue, 1 Mar 2016 23:54:07 +0200
MIME-Version: 1.0
In-Reply-To: <CAAZRmGxts4s1rrNEa6YOCVVTmt7Vv+J=YH_06fe0N-1o=j0B7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You could test it pretty easily too. The trick it so hack driver to 
upload TH7579 firmware for your Mygica. Mygica likely downloads firmware 
from the eeprom before enumerated to usb bus - thus no firmware upload 
from the driver point of view normally.

Antti


On 03/01/2016 10:16 PM, Olli Salonen wrote:
> Well, that theory is easy to test if you have the device:
>
> Just comment out these lines (that only are applicable to Mygica T230
> anyhow) from the function cxusb_disconnect:
>
>          /* remove I2C client for tuner */
>          client = st->i2c_client_tuner;
>          if (client) {
>                  module_put(client->dev.driver->owner);
>                  i2c_unregister_device(client);
>          }
>
>          /* remove I2C client for demodulator */
>          client = st->i2c_client_demod;
>          if (client) {
>                  module_put(client->dev.driver->owner);
>                  i2c_unregister_device(client);
>          }
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
>> I think it is because of your device disconnects itself from the usb bus
>> after the firmware download (and then reconnects with different usb id) and
>> disconnect callback refers to data that does not exist at the moment (driver
>> state).
>>
>> Olli could you take a look about it.
>>
>> regards
>> Antti
>>
>>
>> On 02/27/2016 01:26 PM, Tim Connors wrote:
>>>
>>> I've submitted bug https://bugzilla.kernel.org/show_bug.cgi?id=112861
>>>
>>> cxusb last worked for me in debian's 3.16.0-0.bpo.4-amd64, failed in 4.3
>>> and 4.4.  Oops and then panic within a second of plugging in the usb cable
>>> (or at bootup).  My other usb tuner is working flawlessly.
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=1175001
>>> might be a similar bug, and I tried reverting the patch here (since George
>>> talks about a new oops in the same timeframe):
>>> https://bugzilla.redhat.com/show_bug.cgi?id=1154454
>>> but with no luck.
>>>
>>>
>>> What should I do next?
>>>
>>>
>>> Feb 15 00:09:54 fs kernel: [11927.112039] usb 1-3.2: new high-speed USB
>>> device number 9 using ehci-pci
>>> Feb 15 00:09:54 fs kernel: [11927.220430] usb 1-3.2: New USB device found,
>>> idVendor=0fe9, idProduct=db10
>>> Feb 15 00:09:54 fs kernel: [11927.220440] usb 1-3.2: New USB device
>>> strings: Mfr=0, Product=0, SerialNumber=0
>>> Feb 15 00:09:54 fs laptop-mode: Warning: Configuration file
>>> /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
>>> Feb 15 00:09:54 fs laptop-mode: laptop-mode-tools is disabled in config
>>> file. Exiting
>>> Feb 15 00:09:54 fs kernel: [11927.254648] dvb-usb: found a 'DViCO
>>> FusionHDTV DVB-T USB (TH7579)' in cold state, will try to load a firmware
>>> Feb 15 00:09:54 fs kernel: [11927.254740] usb 1-3.2: firmware:
>>> direct-loading firmware dvb-usb-bluebird-01.fw
>>> Feb 15 00:09:54 fs kernel: [11927.254749] dvb-usb: downloading firmware
>>> from file 'dvb-usb-bluebird-01.fw'
>>> Feb 15 00:09:54 fs kernel: [11927.318141] usbcore: registered new
>>> interface driver dvb_usb_cxusb
>>> Feb 15 00:09:54 fs laptop-mode: Warning: Configuration file
>>> /etc/laptop-mode/conf.d/board-specific/*.conf is not readable, skipping.
>>> Feb 15 00:09:54 fs laptop-mode: laptop-mode-tools is disabled in config
>>> file. Exiting
>>> Feb 15 00:09:54 fs kernel: [11927.397296] usb 1-3.2: USB disconnect,
>>> device number 9
>>> Feb 15 00:09:54 fs kernel: [11927.397407] BUG: unable to handle kernel
>>> paging request at 0000000000002830
>>> Feb 15 00:09:54 fs kernel: [11927.397656] IP: [<ffffffffa0d350a3>]
>>> cxusb_disconnect+0x13/0x70 [dvb_usb_cxusb]
>>> Feb 15 00:09:54 fs kernel: [11927.397907] PGD a1537067 PUD b003f067 PMD 0
>>> Feb 15 00:09:54 fs kernel: [11927.398096] Oops: 0000 [#1] SMP
>>> Feb 15 00:09:54 fs kernel: [11927.398247] Modules linked in:
>>> dvb_usb_cxusb(O) rc_dib0700_rc5(O) tuner_xc2028(O) dib7000p(O)
>>> dvb_usb_dib0700(O) dib9000(O) dib7000m(O) dib0090(O) dib0070(O) dib3000mc(O)
>>> dibx000_common(O) dvb_usb(O) dvb_core(O) rc_core(O) media(O) nfsv4
>>> dns_resolver nf_conntrack_netlink nf_conntrack xt_multiport iptable_filter
>>> ip_tables x_tables nfnetlink_log nfnetlink fuse cpufreq_powersave
>>> cpufreq_userspace cpufreq_conservative bnep rfcomm bluetooth rfkill autofs4
>>> uinput rpcsec_gss_krb5 nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace
>>> fscache sunrpc raid1 cpufreq_stats loop md_mod coretemp pcspkr serio_raw
>>> evdev i2c_i801 pl2303 usbserial zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO)
>>> snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device spl(O) zavl(PO)
>>> amdkfd radeon snd_hda_intel ttm drm_kms_helper snd_hda_codec ich7_gpio(O)
>>> snd_hda_core snd_hwdep snd_pcm_oss drm snd_mixer_oss i2c_algo_bit snd_pcm
>>> snd_timer snd soundcore shpchp 8250_fintek button acpi!
>>
>> _c!
>>>
>>>    pufreq tpm_tis tpm processor ext4
>>> Feb 15 00:09:54 fs kernel: crc16 mbcache jbd2 dm_mod it87 hwmon_vid
>>> ata_generic hid_generic usbhid hid uas usb_storage sg sd_mod ahci
>>> pata_jmicron libahci libata e1000e scsi_mod uhci_hcd ehci_pci ehci_hcd ptp
>>> pps_core usbcore usb_common thermal fan [last unloaded: dib0090]
>>> Feb 15 00:09:54 fs kernel: [11927.401277] CPU: 0 PID: 8965 Comm:
>>> kworker/0:0 Tainted: P           O    4.4.0-trunk-amd64 #1 Debian 4.4-1~exp1
>>> Feb 15 00:09:54 fs kernel: [11927.401277] Hardware name: OEM
>>> OEM/Pineview-ICH9, BIOS 6.00 PG 11/17/2010
>>> Feb 15 00:09:54 fs kernel: [11927.401277] Workqueue: usb_hub_wq hub_event
>>> [usbcore]
>>> Feb 15 00:09:54 fs kernel: [11927.401277] task: ffff880036172740 ti:
>>> ffff8801112f8000 task.ti: ffff8801112f8000
>>> Feb 15 00:09:54 fs kernel: [11927.401277] RIP: 0010:[<ffffffffa0d350a3>]
>>> [<ffffffffa0d350a3>] cxusb_disconnect+0x13/0x70 [dvb_usb_cxusb]
>>> Feb 15 00:09:54 fs kernel: [11927.401277] RSP: 0018:ffff8801112fbbd8
>>> EFLAGS: 00010246
>>> Feb 15 00:09:54 fs kernel: [11927.401277] RAX: 0000000000000000 RBX:
>>> ffff88007f057030 RCX: 0000000000000000
>>> Feb 15 00:09:54 fs kernel: [11927.401277] RDX: 0000000000000000 RSI:
>>> ffff88007f057000 RDI: ffff88007f057000
>>> Feb 15 00:09:54 fs kernel: [11927.401277] RBP: ffff88007f057000 R08:
>>> 0000000000000000 R09: 0000000000000000
>>> Feb 15 00:09:54 fs kernel: [11927.401277] R10: 000000000000001a R11:
>>> 0000000000000070 R12: ffffffffa0051380
>>> Feb 15 00:09:54 fs kernel: [11927.401277] R13: ffffffffa0d390a8 R14:
>>> ffff8800b90a8090 R15: ffff8800b90a8000
>>> Feb 15 00:09:54 fs kernel: [11927.401277] FS:  0000000000000000(0000)
>>> GS:ffff88013fc00000(0000) knlGS:0000000000000000
>>> Feb 15 00:09:54 fs kernel: [11927.401277] CS:  0010 DS: 0000 ES: 0000 CR0:
>>> 000000008005003b
>>> Feb 15 00:09:54 fs kernel: [11927.401277] CR2: 0000000000002830 CR3:
>>> 00000000b001b000 CR4: 00000000000006f0
>>> Feb 15 00:09:54 fs kernel: [11927.401277] Stack:
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  ffff88007f057030
>>> ffff88007f057000 ffffffffa0051380 ffffffffa003c429
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  ffff8800b90a8000
>>> 0000000000000000 ffff8800b90a8090 ffff88007f0570e0
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  ffff88007f057030
>>> ffffffffa0d390a8 ffffffffa0051380 ffff88007f057040
>>> Feb 15 00:09:54 fs kernel: [11927.401277] Call Trace:
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa003c429>] ?
>>> usb_unbind_interface+0x79/0x250 [usbcore]
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff81408fea>] ?
>>> __device_release_driver+0x9a/0x140
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff814090ae>] ?
>>> device_release_driver+0x1e/0x30
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff81408739>] ?
>>> bus_remove_device+0xf9/0x170
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff81404bb7>] ?
>>> device_del+0x127/0x250
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff814057fc>] ?
>>> _dev_info+0x6c/0x90
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa0039dce>] ?
>>> usb_disable_device+0x7e/0x260 [usbcore]
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa002fc30>] ?
>>> usb_disconnect+0x90/0x280 [usbcore]
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa002bc24>] ?
>>> set_port_feature+0x44/0x50 [usbcore]
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffffa0031e5d>] ?
>>> hub_event+0x75d/0x14e0 [usbcore]
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff8108d79f>] ?
>>> process_one_work+0x19f/0x3d0
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff8108da1d>] ?
>>> worker_thread+0x4d/0x450
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff8108d9d0>] ?
>>> process_one_work+0x3d0/0x3d0
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff810937ad>] ?
>>> kthread+0xcd/0xf0
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff810936e0>] ?
>>> kthread_create_on_node+0x190/0x190
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff81583dcf>] ?
>>> ret_from_fork+0x3f/0x70
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  [<ffffffff810936e0>] ?
>>> kthread_create_on_node+0x190/0x190
>>> Feb 15 00:09:54 fs kernel: [11927.401277] Code: c7 02 00 00 00 00 31 c0 c3
>>> 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 48 89
>>> fd 53 48 8b 87 d0 00 00 00 <4c> 8b a0 30 28 00 00 49 8b 5c 24 10 48 85 db 74
>>> 18 48 8b 83 b0
>>> Feb 15 00:09:54 fs kernel: [11927.401277] RIP  [<ffffffffa0d350a3>]
>>> cxusb_disconnect+0x13/0x70 [dvb_usb_cxusb]
>>> Feb 15 00:09:54 fs kernel: [11927.401277]  RSP <ffff8801112fbbd8>
>>> Feb 15 00:09:54 fs kernel: [11927.401277] CR2: 0000000000002830
>>> Feb 15 00:09:54 fs kernel: [11927.401277] ---[ end trace d6393009544ed355
>>> ]---
>>> Feb 15 00:09:54 fs kernel: [11927.527370] BUG: unable to handle kernel
>>> paging request at ffffffffffffffd8
>>>
>>
>> --
>> http://palosaari.fi/

-- 
http://palosaari.fi/
