Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZBZONO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 09:13:14 -0500
Date: Thu, 26 Feb 2009 11:12:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Igor M. Liplianin" <liplianin@tut.by>
Cc: linux-media@vger.kernel.org
Subject: Re: dm1105: not demuxing from interrupt context
Message-ID: <20090226111236.470cf9a0@caramujo.chehab.org>
In-Reply-To: <200902190718.47890.liplianin@tut.by>
References: <200902190718.47890.liplianin@tut.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Feb 2009 07:18:47 +0200
"Igor M. Liplianin" <liplianin@tut.by> wrote:

> I read in mailing list about design error in dm1105.
> So I am designer.
> DMA buffer in the driver itself organized like ringbuffer
> and not difficult to bind it to tasklet or work queue.
> I choose work queue, because it is like trend :)
> The code tested by me on quite fast computer and it works as usual.
> I think, on slow computer difference must be noticeable.
> The patch is preliminary.
> Anyone can criticize.

The patch looks fine for me, but, as you said this i preliminary, I'm marking
it as RFC on patchwork. Please send me the final revision of it, after having a
final version.

Cheers,
Mauro.
> 
> diff -r 359d95e1d541 -r f22da8d6a83c linux/drivers/media/dvb/dm1105/dm1105.c
> --- a/linux/drivers/media/dvb/dm1105/dm1105.c   Wed Feb 18 09:49:37 2009 -0300
> +++ b/linux/drivers/media/dvb/dm1105/dm1105.c   Thu Feb 19 04:38:32 2009 +0200
> @@ -220,10 +220,14 @@
>         /* i2c */
>         struct i2c_adapter i2c_adap;
>  
> +       /* irq */
> +       struct work_struct work;
> +
>         /* dma */
>         dma_addr_t dma_addr;
>         unsigned char *ts_buf;
>         u32 wrp;
> +       u32 nextwrp;
>         u32 buffer_size;
>         unsigned int    PacketErrorCount;
>         unsigned int dmarst;
> @@ -418,6 +422,9 @@
>         u8 data;
>         u16 keycode;
>  
> +       if (ir_debug)
> +               printk(KERN_INFO "%s: received byte 0x%04x\n", __func__, ircom);
> +
>         data = (ircom >> 8) & 0x7f;
>  
>         input_event(ir->input_dev, EV_MSC, MSC_RAW, (0x0000f8 << 16) | data);
> @@ -434,6 +441,50 @@
>  
>  }
>  
> +/* work handler */
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
> +static void dm1105_dmx_buffer(void *_dm1105dvb)
> +#else
> +static void dm1105_dmx_buffer(struct work_struct *work)
> +#endif
> +{
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
> +       struct dm1105dvb *dm1105dvb = _dm1105dvb;
> +#else
> +       struct dm1105dvb *dm1105dvb =
> +                               container_of(work, struct dm1105dvb, work);
> +#endif
> +       unsigned int nbpackets;
> +       u32 oldwrp = dm1105dvb->wrp;
> +       u32 nextwrp = dm1105dvb->nextwrp;
> +
> +       if (!((dm1105dvb->ts_buf[oldwrp] == 0x47) &&
> +                       (dm1105dvb->ts_buf[oldwrp + 188] == 0x47) &&
> +                       (dm1105dvb->ts_buf[oldwrp + 188 * 2] == 0x47))) {
> +               dm1105dvb->PacketErrorCount++;
> +               /* bad packet found */
> +               if ((dm1105dvb->PacketErrorCount >= 2) &&
> +                               (dm1105dvb->dmarst == 0)) {
> +                       outb(1, dm_io_mem(DM1105_RST));
> +                       dm1105dvb->wrp = 0;
> +                       dm1105dvb->PacketErrorCount = 0;
> +                       dm1105dvb->dmarst = 0;
> +                       return;
> +               }
> +       }
> +
> +       if (nextwrp < oldwrp) {
> +               memcpy(dm1105dvb->ts_buf + dm1105dvb->buffer_size,
> +                                               dm1105dvb->ts_buf, nextwrp);
> +               nbpackets = ((dm1105dvb->buffer_size - oldwrp) + nextwrp) / 188;
> +       } else
> +               nbpackets = (nextwrp - oldwrp) / 188;
> +
> +       dm1105dvb->wrp = nextwrp;
> +       dvb_dmx_swfilter_packets(&dm1105dvb->demux,
> +                                       &dm1105dvb->ts_buf[oldwrp], nbpackets);
> +}
> +
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
>  static irqreturn_t dm1105dvb_irq(int irq, void *dev_id, struct pt_regs *regs)
>  #else
> @@ -441,11 +492,6 @@
>  #endif
>  {
>         struct dm1105dvb *dm1105dvb = dev_id;
> -       unsigned int piece;
> -       unsigned int nbpackets;
> -       u32 command;
> -       u32 nextwrp;
> -       u32 oldwrp;
>  
>         /* Read-Write INSTS Ack's Interrupt for DM1105 chip 16.03.2008 */
>         unsigned int intsts = inb(dm_io_mem(DM1105_INTSTS));
> @@ -454,48 +500,17 @@
>         switch (intsts) {
>         case INTSTS_TSIRQ:
>         case (INTSTS_TSIRQ | INTSTS_IR):
> -               nextwrp = inl(dm_io_mem(DM1105_WRP)) -
> -                       inl(dm_io_mem(DM1105_STADR)) ;
> -               oldwrp = dm1105dvb->wrp;
> -               spin_lock(&dm1105dvb->lock);
> -               if (!((dm1105dvb->ts_buf[oldwrp] == 0x47) &&
> -                               (dm1105dvb->ts_buf[oldwrp + 188] == 0x47) &&
> -                               (dm1105dvb->ts_buf[oldwrp + 188 * 2] == 0x47))) {
> -                       dm1105dvb->PacketErrorCount++;
> -                       /* bad packet found */
> -                       if ((dm1105dvb->PacketErrorCount >= 2) &&
> -                                       (dm1105dvb->dmarst == 0)) {
> -                               outb(1, dm_io_mem(DM1105_RST));
> -                               dm1105dvb->wrp = 0;
> -                               dm1105dvb->PacketErrorCount = 0;
> -                               dm1105dvb->dmarst = 0;
> -                               spin_unlock(&dm1105dvb->lock);
> -                               return IRQ_HANDLED;
> -                       }
> -               }
> -               if (nextwrp < oldwrp) {
> -                       piece = dm1105dvb->buffer_size - oldwrp;
> -                       memcpy(dm1105dvb->ts_buf + dm1105dvb->buffer_size, dm1105dvb->ts_buf, 
> nextwrp);
> -                       nbpackets = (piece + nextwrp)/188;
> -               } else  {
> -                       nbpackets = (nextwrp - oldwrp)/188;
> -               }
> -               dvb_dmx_swfilter_packets(&dm1105dvb->demux, &dm1105dvb->ts_buf[oldwrp], 
> nbpackets);
> -               dm1105dvb->wrp = nextwrp;
> -               spin_unlock(&dm1105dvb->lock);
> +               dm1105dvb->nextwrp = inl(dm_io_mem(DM1105_WRP)) -
> +                                       inl(dm_io_mem(DM1105_STADR));
> +               schedule_work(&dm1105dvb->work);
>                 break;
>         case INTSTS_IR:
> -               command = inl(dm_io_mem(DM1105_IRCODE));
> -               if (ir_debug)
> -                       printk("dm1105: received byte 0x%04x\n", command);
> -
> -               dm1105dvb->ir.ir_command = command;
> +               dm1105dvb->ir.ir_command = inl(dm_io_mem(DM1105_IRCODE));
>                 tasklet_schedule(&dm1105dvb->ir.ir_tasklet);
>                 break;
>         }
> +
>         return IRQ_HANDLED;
> -
> -
>  }
>  
>  /* register with input layer */
> @@ -717,7 +732,7 @@
>  
>         dm1105dvb = kzalloc(sizeof(struct dm1105dvb), GFP_KERNEL);
>         if (!dm1105dvb)
> -               goto out;
> +               return -ENOMEM;
>  
>         dm1105dvb->pdev = pdev;
>         dm1105dvb->buffer_size = 5 * DM1105_DMA_BYTES;
> @@ -747,13 +762,9 @@
>         spin_lock_init(&dm1105dvb->lock);
>         pci_set_drvdata(pdev, dm1105dvb);
>  
> -       ret = request_irq(pdev->irq, dm1105dvb_irq, IRQF_SHARED, DRIVER_NAME, dm1105dvb);
> +       ret = dm1105dvb_hw_init(dm1105dvb);
>         if (ret < 0)
>                 goto err_pci_iounmap;
> -
> -       ret = dm1105dvb_hw_init(dm1105dvb);
> -       if (ret < 0)
> -               goto err_free_irq;
>  
>         /* i2c */
>         i2c_set_adapdata(&dm1105dvb->i2c_adap, dm1105dvb);
> @@ -820,8 +831,19 @@
>  
>         dvb_net_init(dvb_adapter, &dm1105dvb->dvbnet, dmx);
>         dm1105_ir_init(dm1105dvb);
> -out:
> -       return ret;
> +
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
> +       INIT_WORK(&dm1105dvb->work, dm1105_dmx_buffer, dm1105dvb);
> +#else
> +       INIT_WORK(&dm1105dvb->work, dm1105_dmx_buffer);
> +#endif
> +
> +       ret = request_irq(pdev->irq, dm1105dvb_irq, IRQF_SHARED,
> +                                               DRIVER_NAME, dm1105dvb);
> +       if (ret < 0)
> +               goto err_free_irq;
> +
> +       return 0;
>  
>  err_disconnect_frontend:
>         dmx->disconnect_frontend(dmx);
> @@ -850,7 +872,7 @@
>  err_kfree:
>         pci_set_drvdata(pdev, NULL);
>         kfree(dm1105dvb);
> -       goto out;
> +       return ret;
>  }
>  
>  static void __devexit dm1105_remove(struct pci_dev *pdev)
> [Erro ao decodificar BASE64]




Cheers,
Mauro
