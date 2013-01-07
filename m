Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:35262 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3AGXdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 18:33:31 -0500
Received: by mail-ea0-f175.google.com with SMTP id h11so7844359eaa.6
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 15:33:30 -0800 (PST)
Message-ID: <50EB5B44.6020603@gmail.com>
Date: Tue, 08 Jan 2013 00:33:24 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Schinagl <oliver+list@schinagl.nl>, j@jannau.net,
	jarod@redhat.com, kkahn@broadcom.com
Subject: Re: [BUG] crystalhd git.linuxtv.org kernel driver: No more Oops or
 kernel crashes with Linux 3.2
References: <50E3E643.7070701@gmail.com> <50E5A116.9070307@schinagl.nl> <50E8203C.20603@gmail.com>
In-Reply-To: <50E8203C.20603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi People,

-topic-

be careful using the bleeding edge "stable" kernel series > 3.2 with this driver.

y
tom


On 05.01.2013 13:44, thomas schorpp wrote:
> -Removed Broadcom kernel module authors prasadb@broadcom.com, nsankar@broadcom.com from CC list, unreachable, see att. Trying listed official Press contact instead-
>
> Hi Oliver,  hi crystalhd users and devs,  hello Broadcom Crystal HD staff,
>
> 1.
> sorry for the delay, I had to upgrade my old debian i386 stable...squeeze-backports userspace on the old core2duo machine to amd64 by full reinstall, otherwise the driver interface of libcrystalhd3 i686 to 3.6.10...3.7.1amd64 SMP kernel.org kernels has failed permanently,
>
> please (anyone still running such a setup or You) try to confirm this and report to this thread.
>
> lspci still shows the same PCI-E errors (see my other posts to this list) with the working libcrystalhd3 amd64 and broadcom designed crystalhd driver now, so
> this data reported from the chipset or lspci has to be considered faulty or stale and irelevant now, I will build the latest lspci from source to crosscheck this.
>
>
> Please build ffmpeg rel. 1.0.1(non-MT version, not later version, git master showed up with an audio format bug, presenting wrong audio sample format as planar (sfltp, fltp, s16p) which bino cannot handle and makes mplayer cry for not having libavresample access but which is disabled by default in ffmpeg configure defaults and debian dmo source packages )
> from Your distro source package with --disable-decoders='h264, h264_vdpau, h264_vda' and leave only h264_crystalhd need as h.264 decoder
>
> and so trigger crystalhd by every app on your system accessing h.264 content for parsing or decoding and linked to libavcodec (check binaries with ldd if linked against this libavcodec54, , in libavcodec53 h264_crystalhd is flagged CAP_EXPERIMENTAL, which makes it unaccesible by other apps than the ffmpeg program (-strict -2), mplayer: -vc ffh264crystalhd, or will fail --disable-decoders='h264, h264_vdpau, h264_vda')  like mplayer (not statically linked), kaffeine, vlc, gnome nautilus media file properties (uses mplayer -identify) sequentially called and then in parallel and record and post the Ooopses in this thread here until the authors return from winter sports ;-)
> Note for Bino users: System requirement is at least debian squeeze-backports X and DRI, otherwise bino will segfault the dri driver, i965 here and you need to build libGLEW(mx) 1.6 from source for debian stable systems, see http://savannah.nongnu.org/bugs/?33368 http://bino3d.org/help-wanted.html
>
> 2.
> With the new amd64 userspace on 3.7.1 SMP PREEMPT kernel things got even more worse here now, got 5 kernel panics in IRQ handler of the crystalhd driver in 1h while watching h.264 with
> mplayer2/1 (single threaded decoding mode, stereo3d filter) resulting in system halting kernel crashes, I need to setup serial console debugging to get the logs, on my Pentium M i686 vdr machine, kernel has been able to continue at least after the null pointer oopses.
> We need to have confirmation for this, too.
>
> 3.
> Since the source code still states broadcom staff as module authors and the download on the broadcom website is packaged broken tar.bz2 and does not build here with recent kernels,
> I'm CC'ing them now, too, and because it's their basic driver skeleton design and the quality and performance of this driver is far below the windows driver, which performs h.264 1080 great with http://mpc-hc.sourceforge.net at 5-10% cpu usage even on xp x64 on a i965, this should be the reference development target.
>
> 4.
> The driver Makefile won't compile it with debian squeeze-backports 3.2 and 3.2 bpo kbuild infrastructure, missing helper scripts and includes, it needs a full ready build kernel from sources:
>
> schorpp@tom3:/usr/local/src/crystalhd/driver/linux$ LC_ALL=C make
> make -C /lib/modules/3.2.0-0.bpo.4-amd64/build SUBDIRS=/mnt/data/usr/local/src/crystalhd/driver/linux modules
> make[1]: Entering directory `/mnt/data/usr/src/linux-headers-3.2.0-0.bpo.4-amd64'
> /mnt/data/usr/src/linux-headers-3.2.0-0.bpo.4-common/Makefile:287: /mnt/data/usr/src/linux-headers-3.2.0-0.bpo.4-common/scripts/Kbuild.include: Datei oder Verzeichnis nicht gefunden
> /bin/bash: /mnt/data/usr/src/linux-headers-3.2.0-0.bpo.4-common/scripts/gcc-x86_64-has-stack-protector.sh: Datei oder Verzeichnis nicht gefunden
> /mnt/data/usr/src/linux-headers-3.2.0-0.bpo.4-common/arch/x86/Makefile:81: stack protector enabled but no compiler support
> /bin/bash: /mnt/data/usr/src/linux-headers-3.2.0-0.bpo.4-common/scripts/gcc-goto.sh: Datei oder Verzeichnis nicht gefunden
> make: *** Leerer Variablenname.  Schluss.
> make[3]: *** [_module_/mnt/data/usr/local/src/crystalhd/driver/linux] Fehler 2
> make[2]: *** [sub-make] Error 2
> make[1]: *** [all] Error 2
> make[1]: Leaving directory `/mnt/data/usr/src/linux-headers-3.2.0-0.bpo.4-amd64'
> make: *** [all] Error 2
> schorpp@tom3:/usr/local/src/crystalhd/driver/linux$
>
> 5.
> I'm focusing to the 3.x kernel source code delivered staging driver now (only BCM70012 support so far, no BCM70015) meanwhile unitil we get more information.
>
> 6.
> Mythtv and xbmc people please join and report, too.
>
> You can get a BCM70012 for just 10US$, a BCM700015 from 30US$ up on Ebay from china, mini-PCI-E to PCI-E adapter cards for not much more, I think it's worth playing ;-)
>
> y
> tom
>
> Att: Oopscrash in IRQ- handler:
>
> Jan  4 20:43:38 tom3 kernel: [  779.388263] crystalhd 0000:03:00.0: list_index:1 rx[23] rxtot[2031] Y:10 UV:0 Int:800 YDnSz:0 UVDnSz:0
> Jan  4 20:43:38 tom3 kernel: [  779.435169] crystalhd 0000:03:00.0: list_index:1 rx[24] rxtot[2033] Y:10 UV:0 Int:800 YDnSz:0 UVDnSz:0
> Jan  4 20:43:38 tom3 kernel: [  779.479479] crystalhd 0000:03:00.0: list_index:1 rx[25] rxtot[2035] Y:10 UV:0 Int:800 YDnSz:0 UVDnSz:0
> Jan  4 20:43:38 tom3 kernel: [  779.569384] crystalhd 0000:03:00.0: MISSING 2 PICTURES
> Jan  4 20:43:38 tom3 kernel: [  779.614878] crystalhd 0000:03:00.0: MISSING 3 PICTURES
> Jan  4 20:43:38 tom3 kernel: [  779.662146] crystalhd 0000:03:00.0: MISSING 2 PICTURES
> Jan  4 20:43:38 tom3 kernel: [  779.828924] crystalhd 0000:03:00.0: list_index:1 rx[26] rxtot[2057] Y:10 UV:0 Int:800 YDnSz:0 UVDnSz:0
> Jan  4 20:43:38 tom3 kernel: [  779.890531] BUG: unable to handle kernel NULL pointer dereference at 000000000000002c
> Jan  4 20:43:38 tom3 kernel: [  779.890668] IP: [<ffffffffa03ce0a0>] crystalhd_dioq_fetch_wait+0x210/0x3e0 [crystalhd]
> Jan  4 20:43:38 tom3 kernel: [  779.890800] PGD 1573f067 PUD 4a2bf067 PMD 0
> Jan  4 20:43:38 tom3 kernel: [  779.890888] Oops: 0000 [#1] PREEMPT SMP
> Jan  4 20:43:38 tom3 kernel: [  779.890974] Modules linked in: nfsv4 nfs fscache uinput parport_pc ppdev lp parport bridge stp llc bnep rfcomm bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs cpufreq_powersave cpufreq_stats cpufreq_conservative cpufreq_performance cpufreq_ondemand fuse dm_mod ext3 jbd pciehp arc4 ath5k ath mac80211 snd_hda_codec_analog cfg80211 snd_hda_intel snd_usb_audio snd_hda_codec snd_hwdep snd_pcm_oss thinkpad_acpi snd_mixer_oss rfkill snd_usbmidi_lib snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer pcmcia snd_seq_device psmouse snd yenta_socket tpm_tis pcmcia_rsrc acpi_cpufreq tpm pcmcia_core crystalhd(O) coretemp pcspkr soundcore i2c_i801 serio_raw led_class snd_page_alloc freq_table tpm_bios battery ac nvram rtc_cmos hid_generic wmi mperf evdev processor nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit xt_tcpudp
> iptable_filter ip_t
>
> ables x_tables usb_storage
> Jan  4 20:43:38 tom3 kernel: ext4 mbcache jbd2 crc16 usbhid hid sg sd_mod crc_t10dif ata_generic uhci_hcd ahci libahci ata_piix atkbd libata xhci_hcd thermal ehci_hcd usbcore e1000e usb_common
> Jan  4 20:43:38 tom3 kernel: [  779.891477] CPU 0
> Jan  4 20:43:38 tom3 kernel: [  779.891477] Pid: 6837, comm: mplayer2 Tainted: G           O 3.7.1 #10 LENOVO 7735Y1T/7735Y1T
> Jan  4 20:43:38 tom3 kernel: [  779.891477] RIP: 0010:[<ffffffffa03ce0a0>]  [<ffffffffa03ce0a0>] crystalhd_dioq_fetch_wait+0x210/0x3e0 [crystalhd]
> Jan  4 20:43:38 tom3 kernel: [  779.891477] RSP: 0018:ffff88004a387d28  EFLAGS: 00010246
> Jan  4 20:43:38 tom3 kernel: [  779.891477] RAX: 0000000000000000 RBX: ffff88004a32bf00 RCX: 0000000000000000
> Jan  4 20:43:38 tom3 kernel: [  779.891477] RDX: 0000000000000046 RSI: ffffffffa03cd57b RDI: ffffffff814d6881
> Jan  4 20:43:38 tom3 kernel: [  779.891477] RBP: ffff88004a387dd8 R08: 0000000000000000 R09: 0000000000000001
> Jan  4 20:43:38 tom3 kernel: [  779.891477] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880079e490c0
> Jan  4 20:43:38 tom3 kernel: [  779.891477] R13: 0000000000000000 R14: ffff880079e490e8 R15: ffff88004a32bf00
> Jan  4 20:43:38 tom3 kernel: [  779.891477] FS:  00007fe394b83780(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
> Jan  4 20:43:38 tom3 kernel: [  779.891477] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Jan  4 20:43:38 tom3 kernel: [  779.891477] CR2: 000000000000002c CR3: 00000000157f1000 CR4: 00000000000007f0
> Jan  4 20:43:38 tom3 kernel: [  779.891477] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Jan  4 20:43:38 tom3 kernel: [  779.891477] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jan  4 20:43:38 tom3 kernel: [  779.891477] Process mplayer2 (pid: 6837, threadinfo ffff88004a386000, task ffff88004a32bf00)
> Jan  4 20:43:38 tom3 kernel: [  779.891477] Stack:
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  ffff88004a32c5c0 000003448106c4f6 ffff88007aed2a00 ffff88007c162098
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  ffff88004a387df4 ffff8800157529b0 ffff880015752800 ffff88004a32bf00
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  ffff880079e49120 0000000100075a56 0000000000000000 ffff88004a32bf00
> Jan  4 20:43:38 tom3 kernel: [  779.891477] Call Trace:
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffff81079df0>] ? try_to_wake_up+0x230/0x230
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffffa03cf680>] ? bc_cproc_start_capture+0xf0/0xf0 [crystalhd]
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffffa03d13de>] crystalhd_hw_get_cap_buffer+0x6e/0x180 [crystalhd]
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffffa03cf73d>] bc_cproc_fetch_frame+0xbd/0x1b0 [crystalhd]
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffffa03ccdab>] chd_dec_api_cmd+0xab/0x100 [crystalhd]
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffffa03ccf42>] chd_dec_ioctl+0x142/0x160 [crystalhd]
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffff81181d6a>] do_vfs_ioctl+0x2da/0x310
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffff8118d8f0>] ? fget_light+0x70/0x160
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffff81181df7>] sys_ioctl+0x57/0x90
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffff8123c79e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  [<ffffffff814de802>] system_call_fastpath+0x16/0x1b
> Jan  4 20:43:38 tom3 kernel: [  779.891477] Code: 87 10 e1 45 85 ed 0f 85 4f 01 00 00 48 8b bd 78 ff ff ff e8 a3 e4 c9 e0 85 c0 0f 85 4e 01 00 00 4c 89 e7 e8 b3 f3 ff ff 49 89 c0 <f6> 40 2c 03 0f 85 97 01 00 00 48 8b 4d 80 48 8b 81 d0 00 00 00
> Jan  4 20:43:38 tom3 kernel: [  779.891477] RIP  [<ffffffffa03ce0a0>] crystalhd_dioq_fetch_wait+0x210/0x3e0 [crystalhd]
> Jan  4 20:43:38 tom3 kernel: [  779.891477]  RSP <ffff88004a387d28>
> Jan  4 20:43:38 tom3 kernel: [  779.891477] CR2: 000000000000002c
> Jan  4 20:43:38 tom3 kernel: [  779.912578] delay: estimated 384, actual 0
> Jan  4 20:43:38 tom3 kernel: [  779.912610] delay: estimated 384, actual 48
> Jan  4 20:43:38 tom3 kernel: [  779.914258] ---[ end trace b4d3d5bb1ad97fd7 ]---
> Jan  4 20:46:05 tom3 kernel: [  926.565061] SysRq : Emergency Remount R/O
>
>
> On 03.01.2013 16:17, Oliver Schinagl wrote:
>> I actually am one of the few that has one of those decoders so should be able to test things when needed. Just let me know what to test and I will try to comply
>>
>> On 02-01-13 08:48, thomas schorpp wrote:
>>> Hello guys,
>>>
>>> I'm working on supporting BCM 970012/15 crystalhd decoder in userspace video/tv apps and
>>>
>>> can't find where to report bugs of
>>>
>>> http://git.linuxtv.org/jarod/crystalhd.git
>>> <devinheitmueller> I think he just borrowed our git server.
>>>
>>> So I borrow this list to get more developers, testers and sw- quality guys in.
>>>
>>> Forgot to mention the attached Oopses under high load and "multithreading" in half automated stress/mass testing.
>>>
>>> Scenario e.g.:
>>> Dec 29 15:58:29 vdr1 kernel: [ 5698.364950] crystalhd 0000:02:00.0: Opening new user[0] handle
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.557932] crystalhd 0000:02:00.0: Opening new user[0] handle
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.846312] crystalhd 0000:02:00.0: Close the handle first..
>>>
>>> Looks like the driver is not "threadsave", rebuilding kernel with spinlock debugging, should show more up.
>>>
>>> y
>>> tom
>>>
>>> -Att: Kernel OOPS bt, etc
>>>
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568671] BUG: unable to handle kernel paging request at 2062696c
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568678] IP: [<2062696c>] 0x2062696b
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568681] *pdpt = 0000000008497001 *pde = 0000000000000000
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568684] Oops: 0010 [#4] PREEMPT
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568731] Modules linked in: md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 cryptomgr aead dvb_pll tda10086 saa7134_dvb tuner arc4 crypto_blkcipher crypto_algapi tda10021 snd_usb_audio snd_usbmidi_lib snd_hwdep rt73usb snd_pcm_oss rt2x00usb rt2x00lib stv0297 mac80211 snd_intel8x0 snd_ac97_codec snd_mixer_oss ac97_bus joydev snd_seq_dummy snd_pcm videobuf_dvb snd_seq_oss hid_sunplus hid_generic saa7134 videobuf2_vmalloc videobuf2_memops usbhid cfg80211 videobuf2_core snd_seq_midi hid snd_page_alloc snd_rawmidi budget_av dvb_ttpci crc_itu_t crypto budget_core saa7146_vv ttpci_eeprom saa7146 dvb_core
>>> snd_seq_midi_eve
>>> n
>>> t tveeprom videobuf_dma_sg
>>> Dec 29 15:56:10 vdr1 kernel: videobuf_core v4l2_common snd_seq rc_core videodev snd_seq_device crystalhd(O) snd_timer shpchp snd rng_core pci_hotplug serio_raw pcspkr i2c_i801 8250_pnp 8250 soundcore serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod crc_t10dif cdrom ata_piix ahci libahci uhci_hcd libata ehci_hcd scsi_mod usbcore
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568770] Pid: 11841, comm: mplayer Tainted: G      D    O 3.6.10-PM #8    /Alviso
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568772] EIP: 0060:[<2062696c>] EFLAGS: 00010286 CPU: 0
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568775] EIP is at 0x2062696c
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568777] EAX: 00370042 EBX: c843c000 ECX: 636e3800 EDX: 00001c10
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568778] ESI: 000238fc EDI: fb0068fc EBP: c842dea8 ESP: c842de74
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568780]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568781] CR0: 8005003b CR2: 2062696c CR3: 084d9000 CR4: 000007f0
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568783] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568784] DR6: ffff0ff0 DR7: 00000400
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568786] Process mplayer (pid: 11841, ti=c842c000 task=f0aba940 task.ti=c842c000)
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568787] Stack:
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568793]  fa18a569 ffffff10 c117e3f6 00000060 00010246 002a8464 f7138064 fafe3000
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568798]  002a8440 c117e811 f5920988 fafe3000 c843c000 c842ded8 fa18564d c842ded8
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568803]  fa182597 f595a400 f595a62c c842ded8 fa182977 002a8464 f5920900 f595a400
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568804] Call Trace:
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568818]  [<fa18a569>] ? crystalhd_link_download_fw+0x189/0x300 [crystalhd]
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568823]  [<c117e3f6>] ? __copy_from_user_ll+0xd6/0xf0
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568828]  [<c117e811>] ? _copy_from_user+0x41/0xb0
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568839]  [<fa18564d>] bc_cproc_download_fw+0xed/0x150 [crystalhd]
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568846]  [<fa182597>] ? chd_dec_proc_user_data+0x237/0x320 [crystalhd]
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568854]  [<fa182977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568861]  [<fa182b5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568870]  [<fa185560>] ? bc_proc_in_completion+0x70/0x70 [crystalhd]
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568877]  [<fa1829f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568881]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568886]  [<c10685ef>] ? ktime_get+0x6f/0xf0
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568891]  [<c101ca56>] ? lapic_next_event+0x16/0x20
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568895]  [<c106f287>] ? clockevents_program_event+0xe7/0x130
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568898]  [<c10e4ab8>] ? fget_light+0xe8/0x120
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568901]  [<c10e4ad1>] ? fget_light+0x101/0x120
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568904]  [<c10e4a30>] ? fget_light+0x60/0x120
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568906]  [<c10f43cd>] sys_ioctl+0x2d/0x60
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568910]  [<c137238c>] sysenter_do_call+0x12/0x32
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568914]  [<c1360000>] ? asus_hides_smbus_hostbridge+0x264/0x269
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568917] Code:  Bad EIP value.
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568922] EIP: [<2062696c>] 0x2062696c SS:ESP 0068:c842de74
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568923] CR2: 000000002062696c
>>> Dec 29 15:56:10 vdr1 kernel: [ 5558.568926] ---[ end trace f5ae98f349325070 ]---
>>>
>>> Dec 29 15:58:29 vdr1 kernel: [ 5698.364950] crystalhd 0000:02:00.0: Opening new user[0] handle
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.557932] crystalhd 0000:02:00.0: Opening new user[0] handle
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.846312] crystalhd 0000:02:00.0: Close the handle first..
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.858268] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.961171] crystalhd_hw_stats: Invalid Arguments
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.961204] BUG: unable to handle kernel NULL pointer dereference at 00000040
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] IP: [<c11848d8>] do_raw_spin_trylock+0x8/0x50
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] *pdpt = 0000000030a1d001 *pde = 0000000000000000
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Oops: 0000 [#5] PREEMPT
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Modules linked in: md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 cryptomgr aead dvb_pll tda10086 saa7134_dvb tuner arc4 crypto_blkcipher crypto_algapi tda10021 snd_usb_audio snd_usbmidi_lib snd_hwdep rt73usb snd_pcm_oss rt2x00usb rt2x00lib stv0297 mac80211 snd_intel8x0 snd_ac97_codec snd_mixer_oss ac97_bus joydev snd_seq_dummy snd_pcm videobuf_dvb snd_seq_oss hid_sunplus hid_generic saa7134 videobuf2_vmalloc videobuf2_memops usbhid cfg80211 videobuf2_core snd_seq_midi hid snd_page_alloc snd_rawmidi budget_av dvb_ttpci crc_itu_t crypto budget_core saa7146_vv ttpci_eeprom saa7146 dvb_core
>>> snd_seq_midi_eve
>>> n
>>> t tveeprom videobuf_dma_sg
>>> Dec 29 15:58:30 vdr1 kernel: videobuf_core v4l2_common snd_seq rc_core videodev snd_seq_device crystalhd(O) snd_timer shpchp snd rng_core pci_hotplug serio_raw pcspkr i2c_i801 8250_pnp 8250 soundcore serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod crc_t10dif cdrom ata_piix ahci libahci uhci_hcd libata ehci_hcd scsi_mod usbcore
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Pid: 11927, comm: mplayer Tainted: G      D    O 3.6.10-PM #8    /Alviso
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] EIP: 0060:[<c11848d8>] EFLAGS: 00210046 CPU: 0
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] EIP is at do_raw_spin_trylock+0x8/0x50
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] EAX: 00000040 EBX: 00000000 ECX: 00000040 EDX: 00000000
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] ESI: 00000040 EDI: 00200292 EBP: c85a7e5c ESP: c85a7e58
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] CR0: 8005003b CR2: 00000040 CR3: 34276000 CR4: 000007f0
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] DR6: ffff0ff0 DR7: 00000400
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Process mplayer (pid: 11927, ti=c85a6000 task=f48ce720 task.ti=c85a6000)
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Stack:
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  00000050 c85a7e80 c136c9b5 00000000 00000002 00000000 fa184bd6 f5955c00
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  f5920988 00000000 c85a7ed8 fa184bd6 00000218 c85a6000 00000000 c85a7eb0
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  c117e811 09ce6618 0c955c00 f5955c00 00000000 09ce6618 c85a7ed8 fa1823b9
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Call Trace:
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c136c9b5>] _raw_spin_lock_irqsave+0x55/0x90
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa184bd6>] ? bc_cproc_get_stats+0x226/0x280 [crystalhd]
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa184bd6>] bc_cproc_get_stats+0x226/0x280 [crystalhd]
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c117e811>] ? _copy_from_user+0x41/0xb0
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa1823b9>] ? chd_dec_proc_user_data+0x59/0x320 [crystalhd]
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa182977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa182b5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa1849b0>] ? bc_cproc_reset_stats+0x20/0x20 [crystalhd]
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa1829f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c104e73e>] ? hrtimer_nanosleep+0x6e/0xf0
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10e4ab8>] ? fget_light+0xe8/0x120
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10e4ad1>] ? fget_light+0x101/0x120
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10e4a30>] ? fget_light+0x60/0x120
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10f43cd>] sys_ioctl+0x2d/0x60
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c137238c>] sysenter_do_call+0x12/0x32
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Code: a2 66 90 c7 43 08 00 00 00 00 8b 75 f8 8b 7d fc a1 2c dc 4e c1 89 43 0c 8b 5d f4 89 ec 5d c3 8d 74 26 00 55 89 c1 89 e5 53 31 db <8b> 00 c7 01 00 00 00 00 84 c0 0f 9f c3 85 db 74 17 a1 2c dc 4e
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] EIP: [<c11848d8>] do_raw_spin_trylock+0x8/0x50 SS:ESP 0068:c85a7e58
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] CR2: 0000000000000040
>>> Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] ---[ end trace f5ae98f349325071 ]---
>>> Dec 29 15:58:30 vdr1 kernel: [ 5699.232992] note: mplayer[11927] exited with preempt_count 1
>>> Dec 29 15:58:30 vdr1 kernel: [ 5699.251706] crystalhd 0000:02:00.0: Opening new user[0] handle
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.281871] BUG: unable to handle kernel paging request at 6e757474
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] IP: [<6e757474>] 0x6e757473
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] *pdpt = 000000002fb8b001 *pde = 0000000000000000
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Oops: 0010 [#6] PREEMPT
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Modules linked in: md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 cryptomgr aead dvb_pll tda10086 saa7134_dvb tuner arc4 crypto_blkcipher crypto_algapi tda10021 snd_usb_audio snd_usbmidi_lib snd_hwdep rt73usb snd_pcm_oss rt2x00usb rt2x00lib stv0297 mac80211 snd_intel8x0 snd_ac97_codec snd_mixer_oss ac97_bus joydev snd_seq_dummy snd_pcm videobuf_dvb snd_seq_oss hid_sunplus hid_generic saa7134 videobuf2_vmalloc videobuf2_memops usbhid cfg80211 videobuf2_core snd_seq_midi hid snd_page_alloc snd_rawmidi budget_av dvb_ttpci crc_itu_t crypto budget_core saa7146_vv ttpci_eeprom saa7146 dvb_core
>>> snd_seq_midi_eve
>>> n
>>> t tveeprom videobuf_dma_sg
>>> Dec 29 15:58:31 vdr1 kernel: videobuf_core v4l2_common snd_seq rc_core videodev snd_seq_device crystalhd(O) snd_timer shpchp snd rng_core pci_hotplug serio_raw pcspkr i2c_i801 8250_pnp 8250 soundcore serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod crc_t10dif cdrom ata_piix ahci libahci uhci_hcd libata ehci_hcd scsi_mod usbcore
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Pid: 11926, comm: mplayer Tainted: G      D    O 3.6.10-PM #8    /Alviso
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP: 0060:[<6e757474>] EFLAGS: 00210206 CPU: 0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP is at 0x6e757474
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EAX: 726f6863 EBX: c538c000 ECX: 00000000 EDX: 00001c08
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] ESI: 000251ac EDI: fb55c1a8 EBP: c8497ea8 ESP: c8497e74
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] CR0: 8005003b CR2: 6e757474 CR3: 34276000 CR4: 000007f0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] DR6: ffff0ff0 DR7: 00000400
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Process mplayer (pid: 11926, ti=c8496000 task=f48c8000 task.ti=c8496000)
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Stack:
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  fa18a556 ffffffbe c117e3f6 00000060 00210246 002a8464 f7138064 fb537000
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  002a8440 c117e811 f5920988 fb537000 c538c000 c8497ed8 fa18564d c8497ed8
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  fa182597 f595a000 f595a22c c8497ed8 fa182977 002a8464 f5920900 f595a000
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Call Trace:
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa18a556>] ? crystalhd_link_download_fw+0x176/0x300 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c117e3f6>] ? __copy_from_user_ll+0xd6/0xf0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c117e811>] ? _copy_from_user+0x41/0xb0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa18564d>] bc_cproc_download_fw+0xed/0x150 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182597>] ? chd_dec_proc_user_data+0x237/0x320 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182b5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa185560>] ? bc_proc_in_completion+0x70/0x70 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa1829f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c136c865>] ? _raw_spin_lock+0x65/0x70
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c109c156>] ? handle_fasteoi_irq+0xb6/0xd0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4ab8>] ? fget_light+0xe8/0x120
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4ad1>] ? fget_light+0x101/0x120
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4a30>] ? fget_light+0x60/0x120
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10f43cd>] sys_ioctl+0x2d/0x60
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c137238c>] sysenter_do_call+0x12/0x32
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Code:  Bad EIP value.
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP: [<6e757474>] 0x6e757474 SS:ESP 0068:c8497e74
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] CR2: 000000006e757474
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.538480] ---[ end trace f5ae98f349325072 ]---
>>> Dec 29 15:58:33 vdr1 kernel: [ 5701.629049] crystalhd 0000:02:00.0: F/w Signature mismatch
>>> Dec 29 15:58:33 vdr1 kernel: [ 5701.629065] crystalhd 0000:02:00.0: Firmware Download Failure!! - 21
>>> Dec 29 15:58:33 vdr1 kernel: [ 5701.754795] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200
>>>
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.281871] BUG: unable to handle kernel paging request at 6e757474
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] IP: [<6e757474>] 0x6e757473
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] *pdpt = 000000002fb8b001 *pde = 0000000000000000
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Oops: 0010 [#6] PREEMPT
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Modules linked in: md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 cryptomgr aead dvb_pll tda10086 saa7134_dvb tuner arc4 crypto_blkcipher crypto_algapi tda10021 snd_usb_audio snd_usbmidi_lib snd_hwdep rt73usb snd_pcm_oss rt2x00usb rt2x00lib stv0297 mac80211 snd_intel8x0 snd_ac97_codec snd_mixer_oss ac97_bus joydev snd_seq_dummy snd_pcm videobuf_dvb snd_seq_oss hid_sunplus hid_generic saa7134 videobuf2_vmalloc videobuf2_memops usbhid cfg80211 videobuf2_core snd_seq_midi hid snd_page_alloc snd_rawmidi budget_av dvb_ttpci crc_itu_t crypto budget_core saa7146_vv ttpci_eeprom saa7146 dvb_core
>>> snd_seq_midi_eve
>>> n
>>> t tveeprom videobuf_dma_sg
>>> Dec 29 15:58:31 vdr1 kernel: videobuf_core v4l2_common snd_seq rc_core videodev snd_seq_device crystalhd(O) snd_timer shpchp snd rng_core pci_hotplug serio_raw pcspkr i2c_i801 8250_pnp 8250 soundcore serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod crc_t10dif cdrom ata_piix ahci libahci uhci_hcd libata ehci_hcd scsi_mod usbcore
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Pid: 11926, comm: mplayer Tainted: G      D    O 3.6.10-PM #8    /Alviso
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP: 0060:[<6e757474>] EFLAGS: 00210206 CPU: 0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP is at 0x6e757474
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EAX: 726f6863 EBX: c538c000 ECX: 00000000 EDX: 00001c08
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] ESI: 000251ac EDI: fb55c1a8 EBP: c8497ea8 ESP: c8497e74
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] CR0: 8005003b CR2: 6e757474 CR3: 34276000 CR4: 000007f0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] DR6: ffff0ff0 DR7: 00000400
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Process mplayer (pid: 11926, ti=c8496000 task=f48c8000 task.ti=c8496000)
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Stack:
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  fa18a556 ffffffbe c117e3f6 00000060 00210246 002a8464 f7138064 fb537000
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  002a8440 c117e811 f5920988 fb537000 c538c000 c8497ed8 fa18564d c8497ed8
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  fa182597 f595a000 f595a22c c8497ed8 fa182977 002a8464 f5920900 f595a000
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Call Trace:
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa18a556>] ? crystalhd_link_download_fw+0x176/0x300 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c117e3f6>] ? __copy_from_user_ll+0xd6/0xf0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c117e811>] ? _copy_from_user+0x41/0xb0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa18564d>] bc_cproc_download_fw+0xed/0x150 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182597>] ? chd_dec_proc_user_data+0x237/0x320 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182b5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa185560>] ? bc_proc_in_completion+0x70/0x70 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa1829f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c136c865>] ? _raw_spin_lock+0x65/0x70
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c109c156>] ? handle_fasteoi_irq+0xb6/0xd0
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4ab8>] ? fget_light+0xe8/0x120
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4ad1>] ? fget_light+0x101/0x120
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4a30>] ? fget_light+0x60/0x120
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10f43cd>] sys_ioctl+0x2d/0x60
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c137238c>] sysenter_do_call+0x12/0x32
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Code:  Bad EIP value.
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP: [<6e757474>] 0x6e757474 SS:ESP 0068:c8497e74
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] CR2: 000000006e757474
>>> Dec 29 15:58:31 vdr1 kernel: [ 5699.538480] ---[ end trace f5ae98f349325072 ]---
>>> Dec 29 15:58:33 vdr1 kernel: [ 5701.629049] crystalhd 0000:02:00.0: F/w Signature mismatch
>>> Dec 29 15:58:33 vdr1 kernel: [ 5701.629065] crystalhd 0000:02:00.0: Firmware Download Failure!! - 21
>>> Dec 29 15:58:33 vdr1 kernel: [ 5701.754795] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>

