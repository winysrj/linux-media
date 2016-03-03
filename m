Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34290 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbcCCSwF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 13:52:05 -0500
Date: Thu, 3 Mar 2016 15:52:00 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] media: rc: nuvoton: support
 reading / writing wakeup sequence via sysfs
Message-ID: <20160303155200.43d4c5e7@recife.lan>
In-Reply-To: <56D87FE9.4000408@gmail.com>
References: <E1abRXi-00035h-0E@www.linuxtv.org>
	<56D87FE9.4000408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Mar 2016 19:18:17 +0100
Heiner Kallweit <hkallweit1@gmail.com> escreveu:

> Am 03.03.2016 um 12:28 schrieb Mauro Carvalho Chehab:
> > This is an automatic generated email to let you know that the following patch were queued at the 
> > http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
> > 
> > Subject: [media] media: rc: nuvoton: support reading / writing wakeup sequence via sysfs
> > Author:  Heiner Kallweit <hkallweit1@gmail.com>
> > Date:    Mon Feb 8 17:25:59 2016 -0200
> > 
> > This patch adds a binary attribute /sys/class/rc/rc?/wakeup_data which
> > allows to read / write the wakeup sequence.
> >   
> When working on another module I was reminded not to forget updating Documentation/ABI.
> I think the same applies here. This patch introduces a new sysfs attribute that should
> be documented. I'll submit a patch for adding Documentation/ABI/testing/sysfs-class-rc-nuvoton

Good point.

Another thing: wouldn't be better to use a text format? This would make
esier to import from LIRC's irrecord format:

      begin raw_codes

          name power
              850     900    1750    1800     850     900
              850     900    1750     900     850    1800
              850     900     850     900     850     900
             1750    1800     800

      end raw_codes

Regards,
Mauro

> 
> Rgds, Heiner
> 
> > In combination with the core extension for exposing the most recent raw
> > packet this allows to easily define and set a wakeup sequence.
> > 
> > At least on my Zotac CI321 the BIOS resets the wakeup sequence at each boot
> > to a factory default. Therefore I use a udev rule
> > SUBSYSTEM=="rc", DRIVERS=="nuvoton-cir", ACTION=="add", RUN+="<script>"
> > with the script basically doing
> > cat <stored wakeup sequence> >/sys${DEVPATH}/wakeup_data
> > 
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> >  drivers/media/rc/nuvoton-cir.c | 85 ++++++++++++++++++++++++++++++++++++++++++
> >  drivers/media/rc/nuvoton-cir.h |  3 ++
> >  2 files changed, 88 insertions(+)
> > 
> > ---
> > 
> > http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=449c1fcd86f5077d5076a955e65c07a7c4cbbf9d
> > diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> > index c96da3aaf00b..c2ee5bdc6c7d 100644
> > --- a/drivers/media/rc/nuvoton-cir.c
> > +++ b/drivers/media/rc/nuvoton-cir.c
> > @@ -39,6 +39,8 @@
> >  
> >  #include "nuvoton-cir.h"
> >  
> > +static void nvt_clear_cir_wake_fifo(struct nvt_dev *nvt);
> > +
> >  static const struct nvt_chip nvt_chips[] = {
> >  	{ "w83667hg", NVT_W83667HG },
> >  	{ "NCT6775F", NVT_6775F },
> > @@ -177,6 +179,83 @@ static void nvt_set_ioaddr(struct nvt_dev *nvt, unsigned long *ioaddr)
> >  	}
> >  }
> >  
> > +static ssize_t wakeup_data_read(struct file *fp, struct kobject *kobj,
> > +				struct bin_attribute *bin_attr,
> > +				char *buf, loff_t off, size_t count)
> > +{
> > +	struct device *dev = kobj_to_dev(kobj);
> > +	struct rc_dev *rc_dev = to_rc_dev(dev);
> > +	struct nvt_dev *nvt = rc_dev->priv;
> > +	int fifo_len, len;
> > +	unsigned long flags;
> > +	int i;
> > +
> > +	spin_lock_irqsave(&nvt->nvt_lock, flags);
> > +
> > +	fifo_len = nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT);
> > +	len = min(fifo_len, WAKEUP_MAX_SIZE);
> > +
> > +	if (off >= len) {
> > +		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
> > +		return 0;
> > +	}
> > +
> > +	if (len > count)
> > +		len = count;
> > +
> > +	/* go to first element to be read */
> > +	while (nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX) != off)
> > +		nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY);
> > +
> > +	for (i = 0; i < len; i++)
> > +		buf[i] = nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY);
> > +
> > +	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
> > +
> > +	return len;
> > +}
> > +
> > +static ssize_t wakeup_data_write(struct file *fp, struct kobject *kobj,
> > +				struct bin_attribute *bin_attr,
> > +				char *buf, loff_t off, size_t count)
> > +{
> > +	struct device *dev = kobj_to_dev(kobj);
> > +	struct rc_dev *rc_dev = to_rc_dev(dev);
> > +	struct nvt_dev *nvt = rc_dev->priv;
> > +	unsigned long flags;
> > +	u8 tolerance, config;
> > +	int i;
> > +
> > +	if (off > 0)
> > +		return -EINVAL;
> > +
> > +	/* hardcode the tolerance to 10% */
> > +	tolerance = DIV_ROUND_UP(count, 10);
> > +
> > +	spin_lock_irqsave(&nvt->nvt_lock, flags);
> > +
> > +	nvt_clear_cir_wake_fifo(nvt);
> > +	nvt_cir_wake_reg_write(nvt, count, CIR_WAKE_FIFO_CMP_DEEP);
> > +	nvt_cir_wake_reg_write(nvt, tolerance, CIR_WAKE_FIFO_CMP_TOL);
> > +
> > +	config = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON);
> > +
> > +	/* enable writes to wake fifo */
> > +	nvt_cir_wake_reg_write(nvt, config | CIR_WAKE_IRCON_MODE1,
> > +			       CIR_WAKE_IRCON);
> > +
> > +	for (i = 0; i < count; i++)
> > +		nvt_cir_wake_reg_write(nvt, buf[i], CIR_WAKE_WR_FIFO_DATA);
> > +
> > +	nvt_cir_wake_reg_write(nvt, config, CIR_WAKE_IRCON);
> > +
> > +	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
> > +
> > +	return count;
> > +}
> > +
> > +static BIN_ATTR_RW(wakeup_data, WAKEUP_MAX_SIZE);
> > +
> >  /* dump current cir register contents */
> >  static void cir_dump_regs(struct nvt_dev *nvt)
> >  {
> > @@ -1133,6 +1212,10 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
> >  			     NVT_DRIVER_NAME "-wake", (void *)nvt))
> >  		goto exit_unregister_device;
> >  
> > +	ret = device_create_bin_file(&rdev->dev, &bin_attr_wakeup_data);
> > +	if (ret)
> > +		goto exit_unregister_device;
> > +
> >  	device_init_wakeup(&pdev->dev, true);
> >  
> >  	dev_notice(&pdev->dev, "driver has been successfully loaded\n");
> > @@ -1156,6 +1239,8 @@ static void nvt_remove(struct pnp_dev *pdev)
> >  {
> >  	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
> >  
> > +	device_remove_bin_file(&nvt->rdev->dev, &bin_attr_wakeup_data);
> > +
> >  	nvt_disable_cir(nvt);
> >  
> >  	/* enable CIR Wake (for IR power-on) */
> > diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
> > index 4a5650dffa29..c9c98ebb19ee 100644
> > --- a/drivers/media/rc/nuvoton-cir.h
> > +++ b/drivers/media/rc/nuvoton-cir.h
> > @@ -417,3 +417,6 @@ struct nvt_dev {
> >  /* as VISTA MCE definition, valid carrier value */
> >  #define MAX_CARRIER 60000
> >  #define MIN_CARRIER 30000
> > +
> > +/* max wakeup sequence length */
> > +#define WAKEUP_MAX_SIZE 65
> >   
> 


-- 
Thanks,
Mauro
