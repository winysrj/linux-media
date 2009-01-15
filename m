Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:41888 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbZAOLZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 06:25:40 -0500
Received: by yx-out-2324.google.com with SMTP id 8so429936yxm.1
        for <linux-media@vger.kernel.org>; Thu, 15 Jan 2009 03:25:39 -0800 (PST)
Message-ID: <9e70b14f0901150325g5c02da7dtba7c3cbbd5987fb2@mail.gmail.com>
Date: Thu, 15 Jan 2009 11:25:38 +0000
From: "Alec Christie" <alec.christie@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: kernel soft lockup on boot loading cx2388x based DVB-S card (TeVii S420)
In-Reply-To: <496F1168.3030007@bat.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496F1168.3030007@bat.id.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am getting the same with the Haupauge HVR-4000 after a recent Kernel
Upgrade in Ubuntu Hardy (8.04).

Any help greatly appreciated.

Alec Christie



2009/1/15 Aaron Theodore <aaron@bat.id.au>
>
> Hi I'm running Debian with kernel: 2.6.24-etchnhalf.1-686
> I recently baught a TeVii S420 DVB-S card and have been tring to get it to work.
>
> Firstly i built the v4l from: http://linuxtv.org/hg/v4l-dvb (hg clone) as the card was not detected.
> On first reboot after new modules are installed i get a kernel soft lockup....
>
> -------------------------------------------------
> Linux video capture interface: v2.00
> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
> ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 21
> cx88[0]: subsystem: d420:9022, board: TeVii S420 DVB-S [card=73,autodetected], frontend(s): 1
> cx88[0]: TV tuner type -1, Radio tuner type -1
> cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> tuner' 2-0068: chip found @ 0xd0 (cx88[0])
> cx88[0]/0: found at 0000:05:08.0, rev: 5, irq: 21, latency: 32, mmio: 0xd8000000
> cx88[0]/0: registered device video0 [v4l2]
> cx88[0]/0: registered device vbi0
> tuner' 2-0068: tuner type not set
> cx88[0]/2: cx2388x 8802 Driver Manager
> ACPI: PCI Interrupt 0000:05:08.2[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 21
> cx88[0]/2: found at 0000:05:08.2, rev: 5, irq: 21, latency: 32, mmio: 0xd9000000
> ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 22 (level, low) -> IRQ 17
> cx88/2: cx2388x dvb driver version 0.0.6 loaded
> cx88/2: registering cx8802 driver, type: dvb access: shared
> cx88[0]/2: subsystem: d420:9022, board: TeVii S420 DVB-S [card=73]
> cx88[0]/2: cx2388x based DVB/ATSC card
> BUG: soft lockup - CPU#0 stuck for 11s! [modprobe:1767]
>
> Pid: 1767, comm: modprobe Not tainted (2.6.24-etchnhalf.1-686 #1)
> EIP: 0060:[<c02be0a5>] EFLAGS: 00000286 CPU: 0
> EIP is at _spin_lock+0x7/0xf
> EAX: [removed]
> ESI: [removed]
> DS: [removed]
> CR0: [removed]
> DR0: [removed]
> DR6: [removed]
> [<c02bd4ba>] __mutex_lock_slowpath+0x17/0x7f
> [<c01099da>] sched_clock+0x8/0x18
> [<c02bd39a>] mutex_lock+0xa/0xb
> [<f89d60f7>] videobuf_dvb_get_frontend+0x11/0x37 [videobuf_dvb]
> [<f8a4e3b2>] cx8802_dvb_probe+0xef/0x1a15 [cx88_dvb]
> [<c0121da0>] check_preempt_wakeup+0x1e/0x7a
> [<f89de540>] cx8802_register_driver+0x128/0x1e3 [ex8802]
> [<c01437ab>] sys_int_module+0x15e3/0x16fb
> [<c0164172>] vma_prio_tree_insert+0x17/0x2a
> [<c012c887>] msleep+0x0/0x12
> [<c0103e66>] sysenter_past_esp+0x6b/0xa1
> ==============================
>
> Only way i can boot my system is to remove the PCI card.
>
> So then i tried using the drivers from TeVii ( http://www.tevii.com/Tevii_linuxdriver_0815.rar )
> These actually work but are based on what seems to be a v4l-dvb checkout from 2008-08-14.
>
> I can't use these old drivers because they conflict with other v4l-dvb modules i want to load for other tuner cards.
>
> Is there someway i can get the TeVii S420 working on the latest v4l-dvb modules?
>
> Also using the old drivers, just the following happens on boot
>
> -----------
> cx88[0]/2: subsystem: d420:9022, board: TeVii S420 DVB-S [card=73]
> cx88[0]/2: cx2388x based DVB/ATSC card
> intel8x0_measure_ac97_clock: measured 54726 usecs
> intel8x0: clocking to 46908
> stv0288 id 11
> DVB: registering new adapter (cx88[0])
> DVB: registering frontend 0 (ST STV0288 DVB-S)...
> -----------
> Could this perhaps be an issue with the intel8x0 module?
>
>
>
> -------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Regards,

Alec Christie
