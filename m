Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53456 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab0IWCpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 22:45:14 -0400
Received: by eyb6 with SMTP id 6so348813eyb.19
        for <linux-media@vger.kernel.org>; Wed, 22 Sep 2010 19:45:12 -0700 (PDT)
Date: Thu, 23 Sep 2010 12:45:24 -0400
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Felipe Sanches <juca@members.fsf.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
Subject: Re: [PATCH v2] tm6000+audio
Message-ID: <20100923124524.73a28b0c@glory.local>
In-Reply-To: <4C99177F.9060100@redhat.com>
References: <20100622180521.614eb85d@glory.loctelecom.ru>
	<4C20D91F.500@redhat.com>
	<4C212A90.7070707@arcor.de>
	<4C213257.6060101@redhat.com>
	<4C222561.4040605@arcor.de>
	<4C224753.2090109@redhat.com>
	<4C225A5C.7050103@arcor.de>
	<20100716161623.2f3314df@glory.loctelecom.ru>
	<4C4C4DCA.1050505@redhat.com>
	<20100728113158.0f1495c0@glory.loctelecom.ru>
	<4C4FD659.9050309@arcor.de>
	<20100729140936.5bddd275@glory.loctelecom.ru>
	<4C51ADB5.7010906@redhat.com>
	<20100731122428.4ee569b4@glory.loctelecom.ru>
	<4C53A837.3070700@redhat.com>
	<20100825043746.225a352a@glory.local>
	<4C7543DA.1070307@redhat.com>
	<AANLkTimr3=1QHzX3BzUVyo6uqLdCKt8SS9sDtHfZtHGZ@mail.gmail.com>
	<4C767302.7070506@redhat.com>
	<20100920160715.7594ee2e@glory.local>
	<4C99177F.9060100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

> Em 20-09-2010 17:07, Dmitri Belimov escreveu:
> > Hi 
> > 
> > I rework my last patch for audio and now audio works well. This
> > patch can be submited to GIT tree Quality of audio now is good for
> > SECAM-DK. For other standard I set some value from datasheet need
> > some tests.
> > 
> > 1. Fix pcm buffer overflow
> > 2. Rework pcm buffer fill method
> > 3. Swap bytes in audio stream
> > 4. Change some registers value for TM6010
> > 5. Change pcm buffer size
> > --- a/drivers/staging/tm6000/tm6000-stds.c
> > +++ b/drivers/staging/tm6000/tm6000-stds.c
> > @@ -96,6 +96,7 @@ static struct tm6000_std_tv_settings tv_stds[] = {
> >  
> >  			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> >  			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> > +			{TM6010_REQ08_R05_A_STANDARD_MOD,
> > 0x21}, /* FIXME */
> 
> This didn't seem to work for PAL-M. Probably, the right value for it
> is 0x22, to follow NTSC/M, since both uses the same audio standard.
> 
> On some tests, I was able to receive some audio there, at the proper
> rate, with a tm6010-based device. It died when I tried to change the
> channel, so I didn't rear yet the real audio, but I suspect it will
> work on my next tests.
> 
> Yet, is being hard to test, as the driver has a some spinlock logic
> broken. I'm enclosing the logs.

Yes. I have some as crash from mplayer and arecord.

> I was able to test only when using a monitor on the same machine. All
> trials of using vnc and X11 export ended by not receiving any audio
> and hanging the machine.
> 
> I suspect that we need to fix the spinlock issue, in order to better
> test it.

Who can fix it?

> Cheers,
> Mauro.
> 
> [  564.483502] [drm] nouveau 0000:0f:00.0: Allocating FIFO number 1

<snip>

My dumps:
arecord

[  249.943299] BUG: scheduling while atomic: arecord/3112/0x00000004
[  249.943302] Modules linked in: tm6000_alsa(C) xc5000 tuner tm6000(C) ir_lirc_codec lirc_dev v4l2_common videodev ir_sony_decoder v4l1_compat videobuf_vmalloc ir_jvc_decoder videobuf_core ir_rc6_decoder ir_rc5_decoder ir_nec_decoder ir_common ir_core ppdev lp ipv6 dm_snapshot dm_mirror dm_region_hash dm_log dm_mod sha1_generic arc4 ecb ppp_mppe ppp_generic slhc loop snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd parport_pc processor parport soundcore button psmouse snd_page_alloc intel_agp tpm_tis tpm i2c_i801 agpgart tpm_bios i2c_core rng_core serio_raw pcspkr evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic ata_piix libata ehci_hcd uhci_hcd scsi_mod ide_pci_generic r8169 mii usbcore ide_core nls_base thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[  249.943373] Pid: 3112, comm: arecord Tainted: G         C  2.6.35-tm6000-01+ #1
[  249.943375] Call Trace:
[  249.943383]  [<c10289a8>] __schedule_bug+0x4d/0x52
[  249.943388]  [<c125ccac>] schedule+0x85/0x6df
[  249.943392]  [<c125ee10>] ? _raw_spin_lock_irqsave+0x19/0x33
[  249.943396]  [<c103df81>] ? lock_timer_base+0x24/0x43
[  249.943399]  [<c125d6cb>] schedule_timeout+0x1e4/0x204
[  249.943402]  [<c103e126>] ? process_timeout+0x0/0xf
[  249.943405]  [<c125ca7f>] wait_for_common+0x9d/0xf3
[  249.943408]  [<c102f9ed>] ? default_wake_function+0x0/0x12
[  249.943412]  [<c125cb5b>] wait_for_completion_timeout+0x12/0x14
[  249.943424]  [<f8091b0b>] usb_start_wait_urb+0x66/0xed [usbcore]
[  249.943433]  [<f8091dc5>] usb_control_msg+0x115/0x12e [usbcore]
[  249.943437]  [<f81872ff>] tm6000_read_write_usb+0x1be/0x267 [tm6000]
[  249.943440]  [<c1027bcd>] ? get_parent_ip+0xb/0x31
[  249.943444]  [<f8187472>] tm6000_get_reg+0x2a/0x3a [tm6000]
[  249.943447]  [<f81da343>] snd_tm6000_card_trigger+0x56/0xb2 [tm6000_alsa]
[  249.943453]  [<f869b8a1>] snd_pcm_do_start+0x21/0x28 [snd_pcm]
[  249.943458]  [<f869b7fa>] snd_pcm_action_single+0x2a/0x50 [snd_pcm]
[  249.943463]  [<f869cce4>] snd_pcm_action+0x6d/0x79 [snd_pcm]
[  249.943467]  [<f869cdd6>] snd_pcm_start+0x19/0x1b [snd_pcm]
[  249.943472]  [<f86a2895>] snd_pcm_lib_read1+0x7d/0x28b [snd_pcm]
[  249.943477]  [<f86a2b4f>] snd_pcm_lib_read+0x47/0x55 [snd_pcm]
[  249.943482]  [<f86a1105>] ? snd_pcm_lib_read_transfer+0x0/0x83 [snd_pcm]
[  249.943487]  [<f869f907>] snd_pcm_capture_ioctl1+0xa9/0x355 [snd_pcm]
[  249.943492]  [<f869fbde>] snd_pcm_capture_ioctl+0x2b/0x38 [snd_pcm]
[  249.943497]  [<f869fbb3>] ? snd_pcm_capture_ioctl+0x0/0x38 [snd_pcm]
[  249.943501]  [<c10cab95>] vfs_ioctl+0x27/0x8c
[  249.943504]  [<c10cb0dc>] do_vfs_ioctl+0x439/0x45e
[  249.943508]  [<c10bf6e4>] ? vfs_write+0x104/0x142
[  249.943511]  [<c10cb146>] sys_ioctl+0x45/0x5f
[  249.943515]  [<c100290c>] sysenter_do_call+0x12/0x22

mplayer

[15186.564022] BUG: scheduling while atomic: mplayer/3899/0x00000004
[15186.564026] Modules linked in: tm6000_alsa(C) xc5000 tuner tm6000(C) ir_lirc_codec lirc_dev v4l2_common videodev ir_sony_decoder v4l1_compat videobuf_vmalloc videobuf_core ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder ir_common ir_core nls_iso8859_1 nls_cp437 vfat fat usb_storage ppdev lp ipv6 dm_snapshot dm_mirror dm_region_hash dm_log dm_mod sha1_generic arc4 ecb ppp_mppe ppp_generic slhc loop snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd parport_pc parport psmouse soundcore processor button intel_agp tpm_tis serio_raw snd_page_alloc tpm i2c_i801 agpgart tpm_bios i2c_core rng_core pcspkr evdev ext3 jbd mbcache sg sd_mod sr_mod cdrom ata_generic ata_piix libata scsi_mod uhci_hcd ehci_hcd r8169 mii ide_pci_generic ide_core usbcore nls_base thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[15186.564100] Pid: 3899, comm: mplayer Tainted: G         C  2.6.35-tm6000-01+ #1
[15186.564101] Call Trace:
[15186.564109]  [<c10289a8>] __schedule_bug+0x4d/0x52
[15186.564113]  [<c125ccac>] schedule+0x85/0x6df
[15186.564117]  [<c125ee10>] ? _raw_spin_lock_irqsave+0x19/0x33
[15186.564121]  [<c103df81>] ? lock_timer_base+0x24/0x43
[15186.564124]  [<c125d6cb>] schedule_timeout+0x1e4/0x204
[15186.564127]  [<c103e126>] ? process_timeout+0x0/0xf
[15186.564130]  [<c125ca7f>] wait_for_common+0x9d/0xf3
[15186.564133]  [<c102f9ed>] ? default_wake_function+0x0/0x12
[15186.564136]  [<c125cb5b>] wait_for_completion_timeout+0x12/0x14
[15186.564149]  [<f8091b0b>] usb_start_wait_urb+0x66/0xed [usbcore]
[15186.564158]  [<f8091dc5>] usb_control_msg+0x115/0x12e [usbcore]
[15186.564163]  [<f822d2ff>] tm6000_read_write_usb+0x1be/0x267 [tm6000]
[15186.564166]  [<c102cda7>] ? enqueue_task_fair+0x21/0x55
[15186.564170]  [<c10200cc>] ? free_memtype+0x61/0x148
[15186.564174]  [<f822d472>] tm6000_get_reg+0x2a/0x3a [tm6000]
[15186.564177]  [<f8267343>] snd_tm6000_card_trigger+0x56/0xb2 [tm6000_alsa]
[15186.564184]  [<f869d8a1>] snd_pcm_do_start+0x21/0x28 [snd_pcm]
[15186.564189]  [<f869d7fa>] snd_pcm_action_single+0x2a/0x50 [snd_pcm]
[15186.564193]  [<f869e5d0>] snd_pcm_action_lock_irq+0x79/0x98 [snd_pcm]
[15186.564199]  [<f86a0ddd>] snd_pcm_common_ioctl1+0x63a/0x10bb [snd_pcm]
[15186.564203]  [<c1148cf7>] ? number+0x153/0x231
[15186.564207]  [<c10a70ec>] ? __mod_zone_page_state+0x1d/0x58
[15186.564210]  [<c1148b60>] ? put_dec+0x25/0x69
[15186.564213]  [<c10cec5d>] ? __d_lookup+0xf7/0x113
[15186.564216]  [<c1148cf7>] ? number+0x153/0x231
[15186.564219]  [<c10cffff>] ? inode_init_once+0x39/0xfc
[15186.564222]  [<c102aadd>] ? cpuacct_charge+0x5e/0x76
[15186.564226]  [<c1096687>] ? perf_event_task_sched_out+0x1d/0x302
[15186.564233]  [<f86a1b5e>] snd_pcm_capture_ioctl1+0x300/0x355 [snd_pcm]
[15186.564238]  [<f86a1bde>] snd_pcm_capture_ioctl+0x2b/0x38 [snd_pcm]
[15186.564243]  [<f86a1bb3>] ? snd_pcm_capture_ioctl+0x0/0x38 [snd_pcm]
[15186.564246]  [<c10cab95>] vfs_ioctl+0x27/0x8c
[15186.564249]  [<c10cb0dc>] do_vfs_ioctl+0x439/0x45e
[15186.564253]  [<c1027bcd>] ? get_parent_ip+0xb/0x31
[15186.564255]  [<c1028aa2>] ? sub_preempt_count+0x88/0x95
[15186.564259]  [<c10bfe7b>] ? fget_light+0x8f/0xb6
[15186.564262]  [<c10cb146>] sys_ioctl+0x45/0x5f
[15186.564265]  [<c100290c>] sysenter_do_call+0x12/0x22

With my best regards, Dmitry.
