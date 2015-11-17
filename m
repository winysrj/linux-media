Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57433 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbbKQI1K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 03:27:10 -0500
Date: Tue, 17 Nov 2015 06:27:02 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: fix kernel hang in media_device_unregister()
 during device removal
Message-ID: <20151117062702.33e5141e@recife.lan>
In-Reply-To: <564A3474.2070901@osg.samsung.com>
References: <1447339307-2838-1-git-send-email-shuahkh@osg.samsung.com>
	<20151115230255.GZ17128@valkosipuli.retiisi.org.uk>
	<20151116163652.591e992d@recife.lan>
	<564A3474.2070901@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Nov 2015 12:54:28 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 11/16/2015 11:36 AM, Mauro Carvalho Chehab wrote:
> > Em Mon, 16 Nov 2015 01:02:56 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > 
> >> Hi Shuah,
> >>
> >> On Thu, Nov 12, 2015 at 07:41:47AM -0700, Shuah Khan wrote:
> >>> Media core drivers (dvb, v4l2, bridge driver) unregister
> >>> their entities calling media_device_unregister_entity()
> >>> during device removal from their unregister paths. In
> >>> addition media_device_unregister() tries to unregister
> >>> entity calling media_device_unregister_entity() for each
> >>> one of them. This adds lot of contention on mdev->lock in
> >>> device removal sequence. Fix to not unregister entities
> >>> from media_device_unregister(), and let drivers take care
> >>> of it. Drivers need to unregister to cover the case of
> >>> module removal. This patch fixes the problem by deleting
> >>> the entity list walk to call media_device_unregister_entity()
> >>> for each entity. With this fix there is no kernel hang after
> >>> a sequence of device insertions followed by removal.
> >>>
> >>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >>> ---
> >>>  drivers/media/media-device.c | 5 -----
> >>>  1 file changed, 5 deletions(-)
> >>>
> >>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> >>> index 1312e93..c7ab7c9 100644
> >>> --- a/drivers/media/media-device.c
> >>> +++ b/drivers/media/media-device.c
> >>> @@ -577,8 +577,6 @@ EXPORT_SYMBOL_GPL(__media_device_register);
> >>>   */
> >>>  void media_device_unregister(struct media_device *mdev)
> >>>  {
> >>> -	struct media_entity *entity;
> >>> -	struct media_entity *next;
> >>>  	struct media_link *link, *tmp_link;
> >>>  	struct media_interface *intf, *tmp_intf;
> >>>  
> >>> @@ -596,9 +594,6 @@ void media_device_unregister(struct media_device *mdev)
> >>>  		kfree(intf);
> >>>  	}
> >>>  
> >>> -	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> >>> -		media_device_unregister_entity(entity);
> >>> -
> >>>  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> >>>  	media_devnode_unregister(&mdev->devnode);
> >>>  
> >>
> >> media_device_unregister() is expected to clean up all the entities still
> >> registered with it (as it does to links and interfaces). Could you share
> >> details of the problems you saw in case you haven't found the actual
> >> underlying issue causing them?
> >>
> > 
> > I was not able to reproduce here with au0828. Tried to register/unregister 20
> > times with:
> > 	$ i=1; while :; do echo $i; sudo modprobe au0828 && sleep 2 && sudo rmmod au0828; i=$((i+1)); done
> > 
> > The results are at:
> > 	http://pastebin.com/1B9c9nYm
> 
> Mauro,
> 
> Please remove the device physically to see the problem I am seeing.
> Also make sure you have the locking debug enabled. I just have to
> remove the device physically just once to see the hang.

I did that too: no problem. I can remove/reinsert the device without
causing any hangs or any dmesg related to locking issues.

> 
> > 
> > 
> > PS.: I had to add the 2 seconds sleep there, as otherwise unregister may
> > fail, because udev is started every time the devnodes are created. Without
> > that, sometimes it returns -EBUSY, because udev didn't close the devnode
> > yet. Still no problem, as a later rmmod works:
> > 
> > 	$ sudo modprobe au0828 && sudo rmmod au0828
> > 	$ sudo modprobe au0828 && sudo rmmod au0828
> > 	rmmod: ERROR: Module au0828 is in use
> > 	$  sudo rmmod au0828
> > 	$ 
> > 
> > So, I don't think that the issues you're experiencing are related to the
> > MC next generation.
> 
> On my system it is the case. I have run physical removal of the device
> on MC and didn't see the problem.

Sorry. Do you mean that rmmod au0828 never works on your system?

Then indeed there's something broken with udev and some other module,
and the radeon patch you've applied didn't actually solve the bug.

> 
> > 
> > As a reference, those are the modules I'm using on my test machine
> > (after removing the remaining media modules):
> > 
> > $ lsmod
> > Module                  Size  Used by
> > cpufreq_powersave      16384  0
> > cpufreq_conservative    16384  0
> > cpufreq_userspace      16384  0
> > cpufreq_stats          16384  0
> > parport_pc             28672  0
> > ppdev                  20480  0
> > lp                     20480  0
> > parport                40960  3 lp,ppdev,parport_pc
> > snd_usb_audio         151552  0
> > snd_hda_codec_hdmi     53248  1
> > snd_usbmidi_lib        28672  1 snd_usb_audio
> > snd_rawmidi            24576  1 snd_usbmidi_lib
> > snd_seq_device         16384  1 snd_rawmidi
> > btusb                  40960  0
> > btrtl                  16384  1 btusb
> > btbcm                  16384  1 btusb
> > btintel                16384  1 btusb
> > bluetooth             434176  5 btbcm,btrtl,btusb,btintel
> > rfkill                 20480  1 bluetooth
> > i915                 1110016  4
> > intel_rapl             20480  0
> > iosf_mbi               16384  1 intel_rapl
> > x86_pkg_temp_thermal    16384  0
> > intel_powerclamp       16384  0
> > coretemp               16384  0
> > kvm_intel             163840  0
> > kvm                   446464  1 kvm_intel
> > irqbypass              16384  1 kvm
> > crct10dif_pclmul       16384  0
> > snd_hda_codec_realtek    65536  1
> > crc32_pclmul           16384  0
> > crc32c_intel           24576  0
> > i2c_algo_bit           16384  1 i915
> > snd_hda_codec_generic    65536  1 snd_hda_codec_realtek
> > drm_kms_helper        102400  1 i915
> > snd_hda_intel          32768  0
> > snd_hda_codec         102400  4 snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_codec_generic,snd_hda_intel
> > jitterentropy_rng      16384  0
> > drm                   278528  5 i915,drm_kms_helper
> > sha256_ssse3           32768  1
> > sha256_generic         24576  1 sha256_ssse3
> > snd_hwdep              16384  2 snd_usb_audio,snd_hda_codec
> > hmac                   16384  1
> > snd_hda_core           49152  5 snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_codec_generic,snd_hda_codec,snd_hda_intel
> > drbg                   24576  1
> > iTCO_wdt               16384  0
> > snd_pcm                86016  5 snd_usb_audio,snd_hda_codec_hdmi,snd_hda_codec,snd_hda_intel,snd_hda_core
> > iTCO_vendor_support    16384  1 iTCO_wdt
> > evdev                  24576  8
> > aesni_intel           167936  0
> > snd_timer              28672  1 snd_pcm
> > aes_x86_64             20480  1 aesni_intel
> > psmouse               110592  0
> > mei_me                 28672  0
> > lrw                    16384  1 aesni_intel
> > snd                    57344  12 snd_hda_codec_realtek,snd_usb_audio,snd_hwdep,snd_timer,snd_hda_codec_hdmi,snd_pcm,snd_rawmidi,snd_hda_codec_generic,snd_usbmidi_lib,snd_hda_codec,snd_hda_intel,snd_seq_device
> > gf128mul               16384  1 lrw
> > glue_helper            16384  1 aesni_intel
> > mei                    81920  1 mei_me
> > ablk_helper            16384  1 aesni_intel
> > cryptd                 20480  2 aesni_intel,ablk_helper
> > soundcore              16384  1 snd
> > serio_raw              16384  0
> > shpchp                 32768  0
> > pcspkr                 16384  0
> > sg                     32768  0
> > i2c_i801               20480  0
> > lpc_ich                24576  0
> > mfd_core               16384  1 lpc_ich
> > battery                16384  0
> > i2c_designware_platform    16384  0
> > i2c_designware_core    20480  1 i2c_designware_platform
> > dw_dmac                16384  0
> > tpm_tis                20480  0
> > video                  32768  1 i915
> > tpm                    36864  1 tpm_tis
> > dw_dmac_core           24576  1 dw_dmac
> > button                 16384  1 i915
> > acpi_pad               24576  0
> > ext4                  495616  6
> > crc16                  16384  2 ext4,bluetooth
> > mbcache                20480  1 ext4
> > jbd2                   90112  1 ext4
> > dm_mod                 98304  18
> > sd_mod                 40960  3
> > ahci                   36864  2
> > libahci                28672  1 ahci
> > libata                192512  2 ahci,libahci
> > ehci_pci               16384  0
> > scsi_mod              192512  3 sg,libata,sd_mod
> > ehci_hcd               73728  1 ehci_pci
> > e1000e                208896  0
> > xhci_pci               16384  0
> > ptp                    20480  1 e1000e
> > xhci_hcd              155648  1 xhci_pci
> > pps_core               16384  1 ptp
> > fan                    16384  0
> > thermal                20480  0
> > sdhci_acpi             16384  0
> > sdhci                  36864  1 sdhci_acpi
> > mmc_core              106496  2 sdhci,sdhci_acpi
> > i2c_hid                20480  0
> > hid                   110592  1 i2c_hid
> > 
> > A clear difference is that this machine uses the i915 graph driver,
> > instead of the Radeon driver that you're using on your machine.
> > 
> > So, I still think that the problem you've noticed is related to the
> > radeon driver. Please test without it, booting the machine on
> > console mode, in order to isolate eventual issues with the graphics
> > stack.
> 
> Please see above comment on physically removing the device. I am curious
> to see what happens on your system with lock debug enabled and then
> remove the device.

It works.

Regards,
Mauro
