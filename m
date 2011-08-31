Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1HaUxx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 16:53:53 -0400
Message-ID: <4E5E9F5C.8030107@redhat.com>
Date: Wed, 31 Aug 2011 17:53:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 15/21] [staging] tm6000: Execute lightweight reset on
 close.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-16-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-16-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2011 04:14, Thierry Reding escreveu:
> When the last user closes the device, perform a lightweight reset of the
> device to bring it into a well-known state.
> 
> Note that this is not always enough with the TM6010, which sometimes
> needs a hard reset to get into a working state again.
> ---
>  drivers/staging/tm6000/tm6000-core.c  |   43 +++++++++++++++++++++++++++++++++
>  drivers/staging/tm6000/tm6000-video.c |    8 +++++-
>  drivers/staging/tm6000/tm6000.h       |    1 +
>  3 files changed, 51 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
> index 317ab7e..58c1399 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -597,6 +597,49 @@ int tm6000_init(struct tm6000_core *dev)
>  	return rc;
>  }
>  
> +int tm6000_reset(struct tm6000_core *dev)
> +{
> +	int pipe;
> +	int err;
> +
> +	msleep(500);
> +
> +	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 0);
> +	if (err < 0) {
> +		tm6000_err("failed to select interface %d, alt. setting 0\n",
> +				dev->isoc_in.bInterfaceNumber);
> +		return err;
> +	}
> +
> +	err = usb_reset_configuration(dev->udev);
> +	if (err < 0) {
> +		tm6000_err("failed to reset configuration\n");
> +		return err;
> +	}
> +
> +	msleep(5);
> +
> +	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 2);
> +	if (err < 0) {
> +		tm6000_err("failed to select interface %d, alt. setting 2\n",
> +				dev->isoc_in.bInterfaceNumber);
> +		return err;
> +	}
> +
> +	msleep(5);
> +
> +	pipe = usb_rcvintpipe(dev->udev,
> +			dev->int_in.endp->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
> +
> +	err = usb_clear_halt(dev->udev, pipe);
> +	if (err < 0) {
> +		tm6000_err("usb_clear_halt failed: %d\n", err);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
>  int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
>  {
>  	int val = 0;
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index 492ec73..70fc19e 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -1503,7 +1503,6 @@ static int tm6000_open(struct file *file)
>  	tm6000_get_std_res(dev);
>  
>  	file->private_data = fh;
> -	fh->vdev = vdev;
>  	fh->dev = dev;
>  	fh->radio = radio;
>  	fh->type = type;
> @@ -1606,9 +1605,16 @@ static int tm6000_release(struct file *file)
>  	dev->users--;
>  
>  	res_free(dev, fh);
> +
>  	if (!dev->users) {
> +		int err;
> +
>  		tm6000_uninit_isoc(dev);
>  		videobuf_mmap_free(&fh->vb_vidq);
> +
> +		err = tm6000_reset(dev);
> +		if (err < 0)
> +			dev_err(&vdev->dev, "reset failed: %d\n", err);
>  	}
>  
>  	kfree(fh);
> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
> index cf57e1e..dac2063 100644
> --- a/drivers/staging/tm6000/tm6000.h
> +++ b/drivers/staging/tm6000/tm6000.h
> @@ -311,6 +311,7 @@ int tm6000_set_reg_mask(struct tm6000_core *dev, u8 req, u16 value,
>  						u16 index, u16 mask);
>  int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep);
>  int tm6000_init(struct tm6000_core *dev);
> +int tm6000_reset(struct tm6000_core *dev);
>  
>  int tm6000_init_analog_mode(struct tm6000_core *dev);
>  int tm6000_init_digital_mode(struct tm6000_core *dev);

Something went wrong with the patchset. Got an OOPS during device probe.
Maybe it were caused due to udev, that opens V4L devices, as soon as they're
registered.


[34883.426065] tm6000 #0: registered device video0
[34883.430591] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: 0)
[34883.437763] usbcore: registered new interface driver tm6000
[34884.608372] BUG: unable to handle kernel NULL pointer dereference at 00000002
[34884.615514] IP: [<f8c4ceea>] tm6000_reset+0xd7/0x11c [tm6000]
[34884.621260] *pde = 00000000 
[34884.624139] Oops: 0000 [#1] SMP 
[34884.627375] Modules linked in: tuner_xc2028 tuner ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder tm6000 ir_nec_decoder videobuf_vmalloc videobuf_core rc_core v4l2_common videodev media tcp_lp fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle bridge stp llc bnep bluetooth sunrpc cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter nf_conntrack_ipv4 ip6_tables nf_defrag_ipv4 xt_state nf_conntrack snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm i7core_edac edac_core snd_timer tg3 snd iTCO_wdt iTCO_vendor_support hp_wmi soundcore pcspkr snd_page_alloc floppy sparse_keymap rfkill serio_raw tpm_infineon microcode vboxnetadp vboxnetflt vboxdrv firewire_ohci firewire_core crc_itu_t nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi wmi video [last unloaded: tuner_xc2028]
[34884.712113] 
[34884.713599] Pid: 7448, comm: v4l_id Tainted: G        W   3.0.0+ #1 Hewlett-Packard HP Z400 Workstation/0AE4h
[34884.723513] EIP: 0060:[<f8c4ceea>] EFLAGS: 00010246 CPU: 0
[34884.728983] EIP is at tm6000_reset+0xd7/0x11c [tm6000]
[34884.734104] EAX: f676c800 EBX: e38e5800 ECX: 00000000 EDX: 00000003
[34884.740349] ESI: 00000000 EDI: efc3c400 EBP: efc19f18 ESP: efc19f04
[34884.746594]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[34884.751974] Process v4l_id (pid: 7448, ti=efc18000 task=f6608000 task.ti=efc18000)
[34884.759517] Stack:
[34884.761519]  f2b51c00 efc19f18 f8be3f96 e38e5800 f2b51c00 efc19f44 f8c4e6e5 f1b75a40
[34884.769318]  efc19f2c c0429397 efc19f34 c0810501 efc19f44 efc3c400 eb4b8cc0 00000010
[34884.777121]  efc19f54 f8bb619d eb4b8cc0 f66ffe08 efc19f84 c04e9eaf 00000001 00000000
[34884.784918] Call Trace:
[34884.787360]  [<f8be3f96>] ? __videobuf_free+0x10c/0x112 [videobuf_core]
[34884.793958]  [<f8c4e6e5>] tm6000_release+0xc7/0xf3 [tm6000]
[34884.799513]  [<c0429397>] ? should_resched+0xd/0x27
[34884.804378]  [<c0810501>] ? _cond_resched+0xd/0x21
[34884.809158]  [<f8bb619d>] v4l2_release+0x35/0x52 [videodev]
[34884.814713]  [<c04e9eaf>] fput+0x100/0x1a5
[34884.818798]  [<c04e75a1>] filp_close+0x5c/0x64
[34884.823228]  [<c04e7608>] sys_close+0x5f/0x93
[34884.827571]  [<c081745f>] sysenter_do_call+0x12/0x28
[34884.832519] Code: 24 04 40 10 c5 f8 c7 04 24 56 1d c5 f8 89 44 24 08 eb 4b b8 05 00 00 00 e8 b2 a7 7f c7 8b 83 44 06 00 00 8b 8b 78 06 00 00 8b 10 <0f> b6 49 02 c1 e2 08 83 e1 0f 81 ca 80 00 00 40 c1 e1 0f 09 ca 
[34884.851965] EIP: [<f8c4ceea>] tm6000_reset+0xd7/0x11c [tm6000] SS:ESP 0068:efc19f04
[34884.859623] CR2: 0000000000000002

