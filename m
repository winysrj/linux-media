Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1LMKI6-0005CZ-IL
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 11:45:10 +0100
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LMKI2-0001Zd-Sv
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 10:45:02 +0000
Received: from actimag014716-2.clients.easynet.fr ([212.11.28.50])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 12 Jan 2009 10:45:02 +0000
Received: from ticapix by actimag014716-2.clients.easynet.fr with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 12 Jan 2009 10:45:02 +0000
To: linux-dvb@linuxtv.org
From: Pierre Gronlier <ticapix@gmail.com>
Date: Mon, 12 Jan 2009 11:40:56 +0100
Message-ID: <496B1E38.4050807@gmail.com>
References: <20090109154005.3295d447@bk.ru>
	<1231719484.10277.4.camel@palomino.walls.org>
Mime-Version: 1.0
In-Reply-To: <1231719484.10277.4.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] [PATCH] cx88-dvb: Fix order of frontend allocations
 (Re: current v4l-dvb - cannot access /dev/dvb/: No such file or directory)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andy Walls wrote:
> On Fri, 2009-01-09 at 15:40 +0300, Goga777 wrote:
>> hI
>>
>> With today v4l-dvb I couldn't run my hvr4000 card on 2.6.27 kernel 
> 
> 
>> [   14.555162] cx88/2: cx2388x dvb driver version 0.0.6 loaded
>> [   14.555231] cx88/2: registering cx8802 driver, type: dvb access: shared
>> [   14.555303] cx88[0]/2: subsystem: 0070:6900, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
>> [   14.555374] cx88[0]/2: cx2388x based DVB/ATSC card
>> [   14.555446] BUG: unable to handle kernel NULL pointer dereference at 00000000
>> [   14.555560] IP: [<c02e6bff>] __mutex_lock_common+0x3c/0xe4
>> [   14.555652] *pde = 00000000
>> [   14.555735] Oops: 0002 [#1] SMP
>> [   14.555851] Modules linked in: cx88_dvb(+) cx88_vp3054_i2c videobuf_dvb wm8775 dvb_core tuner_simple tuner_types snd_seq_dummy tda9887 snd_seq_oss(+) snd_intel8x0(+) tda8290 snd_seq_midi snd_seq_midi_event snd_ac97_codec cx88_alsa(+) snd_seq ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_rawmidi snd_timer tuner snd_seq_device psmouse snd serio_raw ivtv(+) cx8800 cx8802 cx88xx soundcore cx2341x ir_common ns558 i2c_i801 v4l2_common videodev i2c_algo_bit gameport v4l1_compat snd_page_alloc tveeprom pcspkr floppy videobuf_dma_sg videobuf_core btcx_risc i2c_core parport_pc parport button intel_agp agpgart shpchp pci_hotplug rng_core iTCO_wdt sd_mod evdev usbhid hid ff_memless ext3 jbd mbcache ide_cd_mod cdrom ide_disk ata_piix libata dock 8139too usb_storage scsi_mod piix 8139cp mii ide_co
>  re uhci_hcd ehci_hcd usbcore thermal processor fan thermal_sys
>> [   14.557013]
>> [   14.557013] Pid: 2310, comm: modprobe Not tainted (2.6.27.1-custom-default1 #1)
>> [   14.557013] EIP: 0060:[<c02e6bff>] EFLAGS: 00010246 CPU: 1
>> [   14.557013] EIP is at __mutex_lock_common+0x3c/0xe4
>> [   14.557013] EAX: de653e98 EBX: de739118 ECX: de739120 EDX: 00000000
>> [   14.557013] ESI: dd4209e0 EDI: de73911c EBP: de653eb0 ESP: de653e88
>> [   14.557013]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> [   14.557013] Process modprobe (pid: 2310, ti=de652000 task=dd4209e0 task.ti=de652000)
>> [   14.557013] Stack: 3535352e 5d343733 00000002 de739120 de739120 00000000 c044a6c0 de739110
>> [   14.557013]        de739118 00000001 de653ebc c02e6d38 c02e6b88 de653ec4 c02e6b88 de653ed8
>> [   14.557013]        e1ac7115 de6a9000 00000001 00000000 de653f0c e1aeca62 de739004 de739000
>> [   14.557013] Call Trace:
>> [   14.557013]  [<c02e6d38>] ? __mutex_lock_slowpath+0x17/0x1a
>> [   14.557013]  [<c02e6b88>] ? mutex_lock+0x12/0x14
>> [   14.557013]  [<c02e6b88>] ? mutex_lock+0x12/0x14
>> [   14.557013]  [<e1ac7115>] ? videobuf_dvb_get_frontend+0x19/0x40 [videobuf_dvb]
>> [   14.557013]  [<e1aeca62>] ? cx8802_dvb_probe+0xc9/0x1945 [cx88_dvb]
>> [   14.557013]  [<e09ee41e>] ? cx8802_register_driver+0xbd/0x1ac [cx8802]
>> [   14.557013]  [<e09ee467>] ? cx8802_register_driver+0x106/0x1ac [cx8802]
>> [   14.557013]  [<e1aee37f>] ? dvb_init+0x22/0x27 [cx88_dvb]
>> [   14.557013]  [<c0101132>] ? _stext+0x42/0x11a
>> [   14.557013]  [<e1aee35d>] ? dvb_init+0x0/0x27 [cx88_dvb]
>> [   14.557013]  [<c013d2ca>] ? __blocking_notifier_call_chain+0xe/0x51
>> [   14.557013]  [<c014970b>] ? sys_init_module+0x8c/0x17d
>> [   14.557013]  [<c0103b42>] ? syscall_call+0x7/0xb
>> [   14.557013]  [<c013007b>] ? round_jiffies_relative+0x14/0x16
>> [   14.557013]  =======================
>> [   14.557013] Code: 78 04 89 f8 89 55 e0 64 8b 35 00 30 3f c0 e8 2e 0c 00 00 8d 43 08 89 45 e4 8b 53 0c 8d 45 e8 8b 4d e4 89 43 0c 89 4d e8 89 55 ec <89> 02 89 75 f0 83 c8 ff 87 03 48 74 55 8a 45 e0 8b 4d e0 83 e0
>> [   14.557013] EIP: [<c02e6bff>] __mutex_lock_common+0x3c/0xe4 SS:ESP 0068:de653e88
>> [   14.565211] ---[ end trace 94d8b014e067ac7b ]---
> 
> 
> I don't have the hardware to test with.  Please try this patch.
> 
> Regards,
> Andy
> 

Hi

I got the same error on my box with a hvr4000 and tt3200.
This path solved this issue for me.

-- 
pierre


> 
> Signed-off-by: Andy Walls <awalls@radix.net>
> 
> diff -r a28c39659c25 linux/drivers/media/video/cx88/cx88-dvb.c
> --- a/linux/drivers/media/video/cx88/cx88-dvb.c	Sat Jan 10 16:04:45 2009 -0500
> +++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Sun Jan 11 19:13:10 2009 -0500
> @@ -621,33 +621,40 @@ static struct stv0288_config tevii_tuner
>  	.set_ts_params = cx24116_set_ts_param,
>  };
>  
> +static int cx8802_alloc_frontends(struct cx8802_dev *dev)
> +{
> +	struct cx88_core *core = dev->core;
> +	struct videobuf_dvb_frontend *fe = NULL;
> +	int i;
> +
> +	mutex_init(&dev->frontends.lock);
> +	INIT_LIST_HEAD(&dev->frontends.felist);
> +
> +	if (!core->board.num_frontends)
> +		return -ENODEV;
> +
> +	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
> +			 core->board.num_frontends);
> +	for (i = 1; i <= core->board.num_frontends; i++) {
> +		fe = videobuf_dvb_alloc_frontend(&dev->frontends, i);
> +		if (!fe) {
> +			printk(KERN_ERR "%s() failed to alloc\n", __func__);
> +			videobuf_dvb_dealloc_frontends(&dev->frontends);
> +			return -ENOMEM;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int dvb_register(struct cx8802_dev *dev)
>  {
>  	struct cx88_core *core = dev->core;
>  	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
>  	int mfe_shared = 0; /* bus not shared by default */
> -	int i;
>  
>  	if (0 != core->i2c_rc) {
>  		printk(KERN_ERR "%s/2: no i2c-bus available, cannot attach dvb drivers\n", core->name);
>  		goto frontend_detach;
> -	}
> -
> -	if (!core->board.num_frontends)
> -		return -EINVAL;
> -
> -	mutex_init(&dev->frontends.lock);
> -	INIT_LIST_HEAD(&dev->frontends.felist);
> -
> -	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
> -			 core->board.num_frontends);
> -	for (i = 1; i <= core->board.num_frontends; i++) {
> -		fe0 = videobuf_dvb_alloc_frontend(&dev->frontends, i);
> -		if (!fe0) {
> -			printk(KERN_ERR "%s() failed to alloc\n", __func__);
> -			videobuf_dvb_dealloc_frontends(&dev->frontends);
> -			goto frontend_detach;
> -		}
>  	}
>  
>  	/* Get the first frontend */
> @@ -1253,6 +1260,8 @@ static int cx8802_dvb_probe(struct cx880
>  	struct cx88_core *core = drv->core;
>  	struct cx8802_dev *dev = drv->core->dvbdev;
>  	int err;
> +	struct videobuf_dvb_frontend *fe;
> +	int i;
>  
>  	dprintk( 1, "%s\n", __func__);
>  	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
> @@ -1268,39 +1277,34 @@ static int cx8802_dvb_probe(struct cx880
>  	/* If vp3054 isn't enabled, a stub will just return 0 */
>  	err = vp3054_i2c_probe(dev);
>  	if (0 != err)
> -		goto fail_probe;
> +		goto fail_core;
>  
>  	/* dvb stuff */
>  	printk(KERN_INFO "%s/2: cx2388x based DVB/ATSC card\n", core->name);
>  	dev->ts_gen_cntrl = 0x0c;
>  
> +	err = cx8802_alloc_frontends(dev);
> +	if (err)
> +		goto fail_core;
> +
>  	err = -ENODEV;
> -	if (core->board.num_frontends) {
> -		struct videobuf_dvb_frontend *fe;
> -		int i;
> -
> -		for (i = 1; i <= core->board.num_frontends; i++) {
> -			fe = videobuf_dvb_get_frontend(&core->dvbdev->frontends, i);
> -			if (fe == NULL) {
> -				printk(KERN_ERR "%s() failed to get frontend(%d)\n",
> +	for (i = 1; i <= core->board.num_frontends; i++) {
> +		fe = videobuf_dvb_get_frontend(&core->dvbdev->frontends, i);
> +		if (fe == NULL) {
> +			printk(KERN_ERR "%s() failed to get frontend(%d)\n",
>  					__func__, i);
> -				goto fail_probe;
> -			}
> -			videobuf_queue_sg_init(&fe->dvb.dvbq, &dvb_qops,
> +			goto fail_probe;
> +		}
> +		videobuf_queue_sg_init(&fe->dvb.dvbq, &dvb_qops,
>  				    &dev->pci->dev, &dev->slock,
>  				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
>  				    V4L2_FIELD_TOP,
>  				    sizeof(struct cx88_buffer),
>  				    dev);
> -			/* init struct videobuf_dvb */
> -			fe->dvb.name = dev->core->name;
> -		}
> -	} else {
> -		/* no frontends allocated */
> -		printk(KERN_ERR "%s/2 .num_frontends should be non-zero\n",
> -			core->name);
> -		goto fail_core;
> +		/* init struct videobuf_dvb */
> +		fe->dvb.name = dev->core->name;
>  	}
> +
>  	err = dvb_register(dev);
>  	if (err)
>  		/* frontends/adapter de-allocated in dvb_register */
> 
> 
> 


> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
