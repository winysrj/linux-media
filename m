Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35337 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757929AbeD0SrX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 14:47:23 -0400
Date: Fri, 27 Apr 2018 15:47:16 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] media: Revert cleanup ktime_set() usage
Message-ID: <20180427154716.11397b40@vento.lan>
In-Reply-To: <bbc3d1e2-9d54-b6c4-99d9-b57d055570d4@anw.at>
References: <1523662294-17971-1-git-send-email-jasmin@anw.at>
        <20180416065415.38f5ef37@vento.lan>
        <bbc3d1e2-9d54-b6c4-99d9-b57d055570d4@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 27 Apr 2018 20:15:00 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> Hello Mauro!
> 
> > This patch looks fine, but not for the above-mentioned.  
> So I shall reword the commit message?

Yes.
> 
> > The thing is that it is not consistent to have some places with
> > things like:
> > 	timeout = ktime_set(1, ir->polling * 1000000);
> > 
> > and others with:
> > 	timeout = ir->polling * 1000000;  
> With my patch applied I can find ONLY two "ir->polling * 1000000" and both are used
> together with ktime_set.
> 
> $ grep -r "ir->polling" *
> media/i2c/ir-kbd-i2c.c:	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling_interval));
> media/i2c/ir-kbd-i2c.c:	ir->polling_interval = DEFAULT_POLLING_INTERVAL;
> media/i2c/ir-kbd-i2c.c:			ir->polling_interval = init_data->polling_interval;
> media/usb/em28xx/em28xx-input.c:	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
> media/usb/em28xx/em28xx-input.c:	ir->polling = 100; /* ms */
> media/usb/em28xx/em28xx-input.c:		schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
> media/usb/tm6000/tm6000-input.c:	if (!ir->polling)
> media/usb/tm6000/tm6000-input.c:	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
> media/usb/tm6000/tm6000-input.c:		ir->polling = 50;
> media/usb/tm6000/tm6000-input.c:	if (!ir->polling)
> media/usb/au0828/au0828-input.c:	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
> media/usb/au0828/au0828-input.c:	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
> media/usb/au0828/au0828-input.c:	ir->polling = 100; /* ms */
> media/usb/au0828/au0828-input.c:	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
> media/pci/saa7134/saa7134-input.c:	if (ir->polling) {
> media/pci/saa7134/saa7134-input.c:	if (ir->polling) {
> media/pci/saa7134/saa7134-input.c:	if (!ir->polling && !ir->raw_decode) {
> media/pci/saa7134/saa7134-input.c:	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
> media/pci/saa7134/saa7134-input.c:	if (ir->polling) {
> media/pci/saa7134/saa7134-input.c:	if (ir->polling)
> media/pci/saa7134/saa7134-input.c:	ir->polling      = polling;
> media/pci/cx88/cx88-input.c:	if (ir->polling) {
> media/pci/cx88/cx88-input.c:		   ir->polling ? "poll" : "irq",
> media/pci/cx88/cx88-input.c:				     ktime_set(0, ir->polling * 1000000));
> media/pci/cx88/cx88-input.c:	if (ir->polling) {
> media/pci/cx88/cx88-input.c:			      ktime_set(0, ir->polling * 1000000),
> media/pci/cx88/cx88-input.c:	if (ir->polling)
> media/pci/cx88/cx88-input.c:		ir->polling = 50; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling = 50; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling = 1; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling = 5; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling = 10; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling = 1; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling = 1; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling = 50; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling = 1; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling      = 50; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling      = 50; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling      = 50; /* ms */
> media/pci/cx88/cx88-input.c:		ir->polling      = 100; /* ms */
> media/pci/bt8xx/bttv-input.c:	if (ir->polling) {
> media/pci/bt8xx/bttv-input.c:		ir->polling               ? "poll"  : "irq",
> media/pci/bt8xx/bttv-input.c:	else if (!ir->polling)
> media/pci/bt8xx/bttv-input.c:	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
> media/pci/bt8xx/bttv-input.c:	if (ir->polling) {
> media/pci/bt8xx/bttv-input.c:		ir->polling      = 50; // ms
> media/pci/bt8xx/bttv-input.c:		ir->polling      = 50; // ms
> media/pci/bt8xx/bttv-input.c:		ir->polling      = 50; // ms
> media/pci/bt8xx/bttv-input.c:		ir->polling      = 50; // ms
> media/pci/bt8xx/bttv-input.c:		ir->polling      = 50; // ms
> media/pci/bt8xx/bttv-input.c:		ir->polling      = 50; // ms
> media/pci/bt8xx/bttv-input.c:		ir->polling      = 50; /* ms */
> media/pci/bt8xx/bttv-input.c:		ir->polling      = 50; /* ms */
> media/pci/bt8xx/bttv-input.c:		ir->polling      = 1; /* ms */
> 
> Currently I am using the exact same patch in media-build. media-build would
> not be able to compile without error for all Kernels, if I would have
> overlook a setting of ktime_t without ktime_set.
> Please point me where I can find the "timeout = ir->polling * 1000000;"
> you mentioned.

I don't really care on how many places it is used. The point is that,
at least on media, we should either call ktime_set() everywhere or
don't call it at all. I think that using the macro makes it better 
documented.

> > My preference is to keep using it, as it makes it better documented.  
> This is also my preference.
> 
> > The fact that it makes maintainership of the media_build backport
> > tree easier is just a plus, but it makes no sense upstream.  
> We fixed all those issues in the past in media-tree. All drivers which
> are able (enabled) to be compiled for Kernels older than 4.10 are using
> ktime_set.

That is irrelevant for upstream. We should confine backport-only
fixes at media_build, as we won't be preventing kAPI changes due
to backports. I mean: if some day ktime_set() gets replaced with
something else, we'll do such change upstream no matter how much
efforts it would mean for backports.

Yet, in this specific case, ktime_set() is not being removed,
and, IMO, mixing it with direct assigns makes the API very
confusing.

> When you mean we shall change all drivers to use ktime_set (even the ones
> which are currently not compiled for <4.10), then I can try to find those
> and add it to the patch.
> 
> Even the mentioned 8b0e195314fa commit did not fix all existing ktime_set(0, 0):
> $ grep -r ktime_set | grep "0, 0"
> drivers/scsi/ufs/ufshcd.c:	hba->lrb[task_tag].compl_time_stamp = ktime_set(0, 0);
> drivers/scsi/ufs/ufshcd.c:	hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
> drivers/scsi/ufs/ufshcd.c:		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
> drivers/scsi/ufs/ufshcd.c:	hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
> drivers/ntb/test/ntb_perf.c:		pthr->duration = ktime_set(0, 0);
> drivers/net/can/usb/peak_usb/pcan_usb_core.c:		time_ref->tv_host = ktime_set(0, 0);
> drivers/thermal/thermal_sysfs.c:		stats->time_in_state[i] = ktime_set(0, 0);
> drivers/dma-buf/sync_file.c:		ktime_set(0, 0);
> drivers/staging/greybus/loopback.c:	gb->ts = ktime_set(0, 0);
> arch/mips/kvm/emulate.c:	ktime_t now = ktime_set(0, 0); /* silence bogus GCC warning */

I mean all "media drivers". We should stick with either:
	ktime_t now = 10;
or
	ktime_t now = ktime_set(0, 10);
	
everywhere along the subsystem.

It is up to other subsystem maintainers to decide what works best
for them. Nothing prevents you to contact other subsystems and submit
patches to make it more consistent along the subsystem. On such
case, there's no need to c/c linux-media (or me).

> 
> BR,
>    Jasmin



Thanks,
Mauro
