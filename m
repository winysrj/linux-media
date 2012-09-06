Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54441 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932999Ab2IFSOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Sep 2012 14:14:22 -0400
Received: by lagy9 with SMTP id y9so1301239lag.19
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2012 11:14:20 -0700 (PDT)
Date: Thu, 6 Sep 2012 23:10:14 +0400
From: Volokh Konstantin <volokh84@gmail.com>
To: Adam Rosi-Kessel <adam@rosi-kessel.org>
Cc: linux-media@vger.kernel.org, volokh@telros.ru
Subject: Re: go7007 question
Message-ID: <20120906191014.GA2540@VPir.Home>
References: <5044F8DC.20509@rosi-kessel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5044F8DC.20509@rosi-kessel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 03, 2012 at 02:37:16PM -0400, Adam Rosi-Kessel wrote:
> Hi:
> 
> I've been searching around for help with go7007 on a Plextor device
> (PX-TV402U) and can't find any forum for questions/help. You seem to
> be active in development--wondering if you might have any tips.
> 
> I'm running 3.2.23, using the go7007 drivers from your
> wis-go7007-3.2.11.patch.
I found that it very old patch and it don`t recover existing problems on new linux brunch
> 
> When I try to run gorecord, it can't find the audio device ("Unable
> to find associated ALSA device node").
> 
> If I manually specify an audio device, I get this:
> 
> gorecord -vdevice /dev/video0 -adevice /dev/dsp -format mpeg4 test.avi
> 
> Unable to open /dev/video0: Device or resource busy
> 
> 
> There seems to be a kernel oops of sort when I connect the USB device:
> 
> [469.653440] go7007-usb: probing new GO7007 USB board
> 
> [469.909932] go7007: registering new Plextor PX-TV402U-NA
> 
> [469.909987] go7007: registered device video0 [v4l2]
> 
> [469.928881] wis-saa7115: initializing SAA7115 at address 32 on WIS
> GO7007SB EZ-USB
> 
> [469.989083] go7007: probing for module i2c:wis_saa7115 failed
> 
> [470.004785] wis-uda1342: initializing UDA1342 at address 26 on WIS
> GO7007SB EZ-USB
> 
> [470.005454] go7007: probing for module i2c:wis_uda1342 failed
> 
> [470.011659] wis-sony-tuner: initializing tuner at address 96 on WIS
> GO7007SB EZ-USB
> 
> [470.011676] Modules linked in: wis_sony_tuner(O) wis_uda1342(O)
> wis_saa7115(O) go7007_usb(O+) go7007(O) v4l2_common videodev media
> cpufreq_conservative cpufreq_powersave cpufreq_stats
> cpufreq_userspace parport_pc ppdev lp parport ipt_MASQUERADE
> xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp
> ipt_REJECT ipt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat
> nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter
> ip_tables x_tables bridge stp bnep rfcomm bluetooth rfkill radeon
> ttm drm_kms_helper drm i2c_algo_bit power_supply binfmt_misc
> dm_snapshot dm_mirror dm_region_hash dm_log dm_mod fuse nfsd nfs
> lockd fscache auth_rpcgss nfs_acl sunrpc hwmon_vid
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm tpm_tis tpm snd_seq_midi
> snd_rawmidi snd_seq_midi_event snd_seq acpi_cpufreq mperf snd_timer
> snd_seq_device i2c_i801 serio_raw evdev i2c_core coretemp dcdbas
> pcspkr tpm_bios snd soundcore processor snd_page_alloc button ext4
> mbcache jbd2 crc16 sg sr_mod cdrom sd_mod crc_t10dif usb_storage uas
> ata_generic uhci_hcd ata_piix libata ehci_hcd r8169 mii floppy
> scsi_mod usbcore usb_common e1000e thermal fan thermal_sys [last
> unloaded: scsi_wait_scan]
> 
> [470.011810][<f988fdf7>] ? go7007_register_encoder+0xbf/0x11a [go7007]
> 
> [470.011816][<f9872c5c>] ? go7007_usb_probe+0x47c/0x60c [go7007_usb]
When driver probes I found bug that i2c_subdev not init properly
> 
> [470.011932] Modules linked in: wis_sony_tuner(O) wis_uda1342(O)
> wis_saa7115(O) go7007_usb(O+) go7007(O) v4l2_common videodev media
> cpufreq_conservative cpufreq_powersave cpufreq_stats
> cpufreq_userspace parport_pc ppdev lp parport ipt_MASQUERADE
> xt_tcpudp ipt_REDIRECT xt_conntrack iptable_mangle nf_conntrack_ftp
> ipt_REJECT ipt_LOG xt_limit xt_multiport xt_state iptable_nat nf_nat
> nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter
> ip_tables x_tables bridge stp bnep rfcomm bluetooth rfkill radeon
> ttm drm_kms_helper drm i2c_algo_bit power_supply binfmt_misc
> dm_snapshot dm_mirror dm_region_hash dm_log dm_mod fuse nfsd nfs
> lockd fscache auth_rpcgss nfs_acl sunrpc hwmon_vid
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm tpm_tis tpm snd_seq_midi
> snd_rawmidi snd_seq_midi_event snd_seq acpi_cpufreq mperf snd_timer
> snd_seq_device i2c_i801 serio_raw evdev i2c_core coretemp dcdbas
> pcspkr tpm_bios snd soundcore processor snd_page_alloc button ext4
> mbcache jbd2 crc16 sg sr_mod cdrom sd_mod crc_t10dif usb_storage uas
> ata_generic uhci_hcd ata_piix libata ehci_hcd r8169 mii floppy
> scsi_mod usbcore usb_common e1000e thermal fan thermal_sys [last
> unloaded: scsi_wait_scan]
> 
> [470.012070][<f988fdf7>] ? go7007_register_encoder+0xbf/0x11a [go7007]
> 
> [470.012075][<f9872c5c>] ? go7007_usb_probe+0x47c/0x60c [go7007_usb]
> 
> Thanks in advance for any pointers!
> 
I recommend to try to use latest patches:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50930.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50931.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50923.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50922.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50924.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50929.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50926.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50925.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50928.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg50927.html

It need apply at once.
But It was tested only with Angelo-MPG24 board, although it contans commonly initialization part

> Adam

Regards,
Volokh Konstantin
