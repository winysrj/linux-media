Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43144 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbcBOI2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 03:28:10 -0500
Subject: Re: tw68000
To: Tony IBM-MAIN <v1i9v6a6@gmail.com>, linux-media@vger.kernel.org
References: <56C0F52D.3020708@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C18C14.6020308@xs4all.nl>
Date: Mon, 15 Feb 2016 09:28:04 +0100
MIME-Version: 1.0
In-Reply-To: <56C0F52D.3020708@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2016 10:44 PM, Tony IBM-MAIN wrote:
> Hi,
> 
> This is my first post on Majorodomo so please excuse any misdemeanor.
> 
> I have been running a CCTV system under Linux, lubuntu 12.10 for 3 
> years. I use 6 analog cameras attached to a techwell 6800 card. I use 
> package motion 3.2.12-3.2.
> 
> 02:04.0 Multimedia video controller: Techwell Inc. TW6816 multimedia 
> video controller (rev 10)
> 02:04.1 Multimedia video controller: Techwell Inc. TW6816 multimedia 
> video controller (rev 10)
> 02:04.2 Multimedia video controller: Techwell Inc. TW6816 multimedia 
> video controller (rev 10)
> 02:04.3 Multimedia video controller: Techwell Inc. TW6816 multimedia 
> video controller (rev 10)
> 02:04.4 Multimedia controller: Techwell Inc. Device 6814 (rev 10)
> 02:04.5 Multimedia controller: Techwell Inc. Device 6815 (rev 10)
> 02:04.6 Multimedia controller: Techwell Inc. Device 6816 (rev 10)
> 02:04.7 Multimedia controller: Techwell Inc. Device 6817 (rev 10)
> 02:05.0 Multimedia video controller: Techwell Inc. TW6816 multimedia 
> video controller (rev 10)
> 02:05.1 Multimedia video controller: Techwell Inc. TW6816 multimedia 
> video controller (rev 10)
> 02:05.2 Multimedia video controller: Techwell Inc. TW6816 multimedia 
> video controller (rev 10)
> 02:05.3 Multimedia video controller: Techwell Inc. TW6816 multimedia 
> video controller (rev 10)
> 02:05.4 Multimedia controller: Techwell Inc. Device 6814 (rev 10)
> 02:05.5 Multimedia controller: Techwell Inc. Device 6815 (rev 10)
> 02:05.6 Multimedia controller: Techwell Inc. Device 6816 (rev 10)
> 02:05.7 Multimedia controller: Techwell Inc. Device 6817 (rev 10)
> 
> I have been using the TW68-v2 driver from github. The system has run 
> flawlessly for three years, for months at a time without reboot.
> 
> For the past 2 years I have been trying to upgrade to a later version of 
> lubuntu with no luck. I have never been able to compile the driver under 
> later versions on lubuntu. Too many errors and attempts to list here.
> 
> I thought my luck had changed with Linux kernel 3.18 and above. TW68 now 
> included. But it does work correctly. I am now trying 3.19 kernel, no 
> change. So I tried the version on linux-media. I still have the same 
> problems.
> 
> Before I go into details of the error I have some question about 
> confirming I really am running the latest and greatest version of tw68. 
> I would hate my first post to be a user error.
> 
> How do i check I am running the right version of tw68. Here's my attempt 
> to validate what is running.
> 
> tony@AJS2:~$ lsmod
> Module                  Size  Used by
> unix_diag              16384  0
> tcp_diag               16384  0
> inet_diag              20480  1 tcp_diag
> rfcomm                 69632  0
> bnep                   20480  2
> bluetooth             491520  10 bnep,rfcomm
> binfmt_misc            20480  1
> snd_hda_codec_realtek    86016  1
> snd_hda_codec_generic    69632  1 snd_hda_codec_realtek
> ppdev                  20480  0
> joydev                 20480  0
> nouveau              1368064  2
> kvm                   479232  0
> mxm_wmi                16384  1 nouveau
> wmi                    20480  2 mxm_wmi,nouveau
> serio_raw              16384  0
> snd_hda_intel          36864  0
> snd_hda_controller     32768  1 snd_hda_intel
> snd_hda_codec         143360  4 
> snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller
> snd_hwdep              20480  1 snd_hda_codec
> k10temp                16384  0
> video                  20480  1 nouveau
> ttm                    94208  1 nouveau
> drm_kms_helper        126976  1 nouveau
> edac_core              53248  0
> edac_mce_amd           24576  0
> drm                   344064  5 ttm,drm_kms_helper,nouveau
> snd_pcm               106496  3 
> snd_hda_codec,snd_hda_intel,snd_hda_controller
> snd_seq_midi           16384  0
> snd_seq_midi_event     16384  1 snd_seq_midi
> i2c_algo_bit           16384  1 nouveau
> snd_rawmidi            32768  1 snd_seq_midi
> snd_seq                65536  2 snd_seq_midi_event,snd_seq_midi
> shpchp                 40960  0
> snd_seq_device         16384  3 snd_seq,snd_rawmidi,snd_seq_midi
> snd_timer              32768  2 snd_pcm,snd_seq
> 8250_fintek            16384  0
> snd                    86016  10 
> snd_hda_codec_realtek,snd_hwdep,snd_timer,snd_pcm,snd_seq,snd_rawmidi,snd_hda_codec_generic,snd_hda_codec,snd_hda_intel,snd_seq_device
> parport_pc             32768  1
> mac_hid                16384  0
> soundcore              16384  2 snd,snd_hda_codec
> i2c_nforce2            16384  0
> tw68                   28672  4
> videobuf2_dma_sg       20480  1 tw68
> videobuf2_memops       16384  1 videobuf2_dma_sg
> videobuf2_core         53248  1 tw68
> v4l2_common            16384  2 tw68,videobuf2_core
> videodev              159744  7 tw68,v4l2_common,videobuf2_core
> media                  24576  1 videodev
> lp                     20480  0
> parport                45056  3 lp,ppdev,parport_pc
> hid_generic            16384  0
> usbhid                 53248  0
> hid                   110592  2 hid_generic,usbhid
> pata_acpi              16384  0
> forcedeth              69632  0
> sata_nv                28672  6
> pata_amd               20480  2
> 
> 
> tony@AJS2:~$ sudo modinfo tw68
> filename: 
> /lib/modules/3.19.0-49-generic/kernel/drivers/media/pci/tw68/tw68.ko
> license:        GPL
> author:         Hans Verkuil <hverkuil@xs4all.nl>
> author:         William M. Brack
> description:    v4l2 driver module for tw6800 based video capture cards
> srcversion:     FB3C913977198E340B58A2E
> depends: videobuf2-core,videodev,videobuf2-dma-sg,v4l2-common
> intree:         Y
> vermagic:       3.19.0-49-generic SMP mod_unload modversions
> signer:         Magrathea: Glacier signing key
> sig_key: A9:32:DC:23:78:95:A4:4D:39:59:BF:91:A3:56:6A:20:EE:21:1F:37
> sig_hashalgo:   sha512
> parm:           latency:pci latency timer (int)
> parm:           video_nr:video device number (array of int)
> parm:           card:card type (array of int)
> 
> tony@AJS2:~$ sudo find / -name tw68.ko -ls
> 2107490  848 -rw-rw-r--   1 tony     tony       864803 Feb  5 22:06 
> /home/tony/media_build/v4l/tw68.ko
> 1050468   44 -rw-r--r--   1 root     root        43856 Feb  5 22:12 
> /lib/modules/3.13.0-74-generic/kernel/drivers/media/pci/tw68/tw68.ko
> 1314223   44 -rw-r--r--   1 root     root        43564 Jan 22 15:27 
> /lib/modules/3.19.0-49-generic/kernel/drivers/media/pci/tw68/tw68.ko
> 
> 
> tony@AJS2:~$ sudo find / -name tw68 -ls
>   18134    0 drwxr-xr-x   2 root     root            0 Feb 14 18:46 
> /sys/bus/pci/drivers/tw68
>   18098    0 drwxr-xr-x   7 root     root            0 Feb 14 17:02 
> /sys/module/tw68
>   18111    0 lrwxrwxrwx   1 root     root            0 Feb 14 19:31 
> /sys/module/v4l2_common/holders/tw68 -> ../../tw68
>   18113    0 lrwxrwxrwx   1 root     root            0 Feb 14 19:31 
> /sys/module/videobuf2_dma_sg/holders/tw68 -> ../../tw68
>   18114    0 lrwxrwxrwx   1 root     root            0 Feb 14 19:31 
> /sys/module/videobuf2_core/holders/tw68 -> ../../tw68
>   18112    0 lrwxrwxrwx   1 root     root            0 Feb 14 19:31 
> /sys/module/videodev/holders/tw68 -> ../../tw68
> 2097903    4 drwxrwxr-x   2 tony     tony         4096 Feb  5 21:44 
> /home/tony/media_build/linux/drivers/media/pci/tw68
> 1050464    4 drwxr-xr-x   2 root     root         4096 Feb  5 22:12 
> /lib/modules/3.13.0-74-generic/kernel/drivers/media/pci/tw68
> 1314222    4 drwxr-xr-x   2 root     root         4096 Feb  8 19:54 
> /lib/modules/3.19.0-49-generic/kernel/drivers/media/pci/tw68
> 1317661    4 drwxr-xr-x   2 root     root         4096 Feb  8 19:54 
> /usr/src/linux-headers-3.19.0-49/drivers/media/pci/tw68
> tony@AJS2:~$
> 
> Why is the size of the module reported in lsmod different from what is 
> in /lib/modules......
> 
> Can I be sure I am running the Hans Verkuil, William M. Brack version 
> rather than version rather that any supplied with 3.19 kernel.

Yes. The vermagic string in modinfo tw68 clearly says that that version
is used.

So you are good in that respect.

> Once i have eliminated a user error I post details of the problem I have.

I'm curious to hear what the problem is.

Regards,

	Hans

> Thanks for reading this and hope you can help,
> 
> Tony.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

