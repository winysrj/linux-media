Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63068 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1D1LER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 07:04:17 -0400
Received: by qyg14 with SMTP id 14so1355270qyg.19
        for <linux-media@vger.kernel.org>; Thu, 28 Apr 2011 04:04:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104271309.41106.laurent.pinchart@ideasonboard.com>
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com>
	<BANLkTim9gwZUx+Y-ji72_Jv6mmCUiEDc-Q@mail.gmail.com>
	<BANLkTimtiTxMNDQTZKNpbsVrKvXKdf5NZA@mail.gmail.com>
	<201104271309.41106.laurent.pinchart@ideasonboard.com>
Date: Thu, 28 Apr 2011 13:04:15 +0200
Message-ID: <BANLkTin9mpzQGsekUiWQHhZUvbsgUKdtdQ@mail.gmail.com>
Subject: Re: OMAP3 ISP deadlocks on my new arm
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	David Cohen <dacohen@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/4/27 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Bastian,
>
> On Wednesday 27 April 2011 12:55:24 Bastian Hecht wrote:
>> 2011/4/27 Bastian Hecht <hechtb@googlemail.com>:
>> > 2011/4/26 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> >> On Tuesday 26 April 2011 17:39:41 Bastian Hecht wrote:
>> >>> 2011/4/21 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> >>> > On Tuesday 19 April 2011 09:31:05 Sakari Ailus wrote:
>> >>> >> Laurent Pinchart wrote:
>> >>> >> ...
>> >>> >>
>> >>> >> > That's the ideal situation: sensors should not produce any data
>> >>> >> > (or rather any transition on the VS/HS signals) when they're
>> >>> >> > supposed to be stopped. Unfortunately that's not always easy, as
>> >>> >> > some dumb sensors (or sensor-like hardware) can't be stopped. The
>> >>> >> > ISP driver should be able to cope with that in a way that doesn't
>> >>> >> > kill the system completely.
>> >>> >> >
>> >>> >> > I've noticed the same issue with a Caspa camera module and an
>> >>> >> > OMAP3503-based Gumstix. I'll try to come up with a good fix.
>> >>> >>
>> >>> >> Hi Laurent, others,
>> >>> >>
>> >>> >> Do you think the cause for this is that the system is jammed in
>> >>> >> handling HS_VS interrupts triggered for every HS?
>> >>> >
>> >>> > That was my initial guess, yes.
>> >>> >
>> >>> >> A quick fix for this could be just choosing either VS configuration
>> >>> >> when configuring the CCDC. Alternatively, HS_VS interrupts could be
>> >>> >> just disabled until omap3isp_configure_interface().
>> >>> >>
>> >>> >> But as the sensor is sending images all the time, proper VS
>> >>> >> configuration would be needed, or the counting of lines in the CCDC
>> >>> >> (VD* interrupts) is affected as well. The VD0 interrupt, which is
>> >>> >> used to trigger an interrupt near the end of the frame, may be
>> >>> >> triggered one line too early on the first frame, or too late. But
>> >>> >> this is up to a configuration. I don't think it's a real issue to
>> >>> >> trigger it one line too early.
>> >>> >>
>> >>> >> Anything else?
>> >>>
>> >>> Hello Laurent,
>> >>>
>> >>> > I've tried delaying the HS_VS interrupt enable to the CCDC
>> >>> > configuration function, after configuring the bridge (and thus the
>> >>> > HS/VS interrupt source selection). To my surprise it didn't fix the
>> >>> > problem, I still get tons of HS_VS interrupts (100000 in about 2.6
>> >>> > seconds) that kill the system.
>> >>> >
>> >>> > I'll need to hook a scope to the HS and VS signals.
>> >>>
>> >>> have you worked on this problem? Today in my setup I took a longer
>> >>> cable and ran again into the hs/vs interrupt storm (it still works
>> >>> with a short cable).
>> >>> I can tackle this issue too, but to avoid double work I wanted to ask
>> >>> if you worked out something in the meantime.
>> >>
>> >> In my case the issue was caused by a combination of two hardware design
>> >> mistakes. The first one was to use a TXB0801 chip to translate the 3.3V
>> >> sensor levels to the 1.8V OMAP levels. The TXB0801 4kΩ output
>> >> impedance, combined with the OMAP3 100µA pull-ups on the HS and VS
>> >> signals, produces a ~400mV voltage for low logic levels.
>> >>
>> >> Then, the XCLKA signal is next to the VS signal on the cable connecting
>> >> the camera module to the OMAP board. When XCLKA is turned on,
>> >> cross-talk produces a 400mV peak-to-peak noise on the VS signal.
>> >>
>> >> The combination of those two effects create a noisy VS signal that
>> >> crosses the OMAP3 input level detection gap at high frequency, leading
>> >> to an interrupt storm. The workaround is to disable the pull-ups on the
>> >> HS and VS signals, the solution is to redesign the hardware to replace
>> >> the level translators and reorganize signals on the camera module
>> >> cable.
>> >
>> > Hi Laurent,
>> >
>> >> Is your situation any similar ?
>> >
>> > The long data line (~35cm now at 24MHz) certainly can have an impact
>> > but I haven't measured any crosstalk so far. But I'm on another trail
>> > now. I found out that on my board the interrupt line is shared with
>> >  24:          0        INTC  omap-iommu.0
>> >
>> > Is the following scenario possible?
>> >
>> > 1. The omap-iommu isr is registered
>> > 2. The isp gets set up (it enables interrupts and disables them again
>> > at the end of the probe function)
>> > 3. Later I activate the xclk from within my driver
>> >  3a. isp_set_xclk() gets the lock omap3isp_get(isp) and so
>> > enable_interrupts() is called
>> >  3b. The new xclk on my chip makes my hardware create a hs/vs int
>> > (either crosstalk, another hardware bug like yours, or simply my chip
>> > sends a spurious interrupt for any reason)
>> >  3c.  isp_set_xclk() puts the lock omap3isp_put(isp) and so
>> > disable_interrupts() is called
>> >
>> > Can there exist a race condition between the omap3isp raising the
>> > interrupt pin before 3c or after 3c?
>>
>> Argh... I oversaw that the omap3isp isr handler stays registered all
>> time long so the theory is wrong.
>
> No luck :-)
>
> The first investigation step is to check which interrupt source causes the
> interrupts storm. The following test patch should help.
>
> diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
> index de2dec5..c4e6455 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -400,6 +400,38 @@ static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
>        printk(KERN_CONT "\n");
>  }
>
> +static unsigned int isp_isr_count[32];
> +
> +static inline void isp_isr_account(struct isp_device *isp, u32 irqstatus)
> +{
> +       unsigned int i;
> +
> +       spin_lock(&isp->isr_account_lock);
> +       for (i = 0; i < 32; i++) {
> +               if (irqstatus & (1 << i))
> +                       isp_isr_count[i]++;
> +       }
> +       spin_unlock(&isp->isr_account_lock);
> +}
> +
> +static ssize_t isp_isr_account_show(struct device *dev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       struct isp_device *isp = container_of(to_media_device(to_media_devnode(dev)), struct isp_device, media_dev);
> +       unsigned long flags;
> +       unsigned int i;
> +       int ret = 0;
> +
> +       spin_lock_irqsave(&isp->isr_account_lock, flags);
> +       for (i = 0; i < 32; i++)
> +               ret += sprintf(buf + ret, "%u\t%u\n", i, isp_isr_count[i]);
> +       spin_unlock_irqrestore(&isp->isr_account_lock, flags);
> +
> +       return ret;
> +}
> +
> +static DEVICE_ATTR(isr_account, S_IRUGO, isp_isr_account_show, NULL);
> +
>  static void isp_isr_sbl(struct isp_device *isp)
>  {
>        struct device *dev = isp->dev;
> @@ -462,6 +494,7 @@ static irqreturn_t isp_isr(int irq, void *_isp)
>                                       IRQ0STATUS_CCDC_VD0_IRQ |
>                                       IRQ0STATUS_CCDC_VD1_IRQ |
>                                       IRQ0STATUS_HS_VS_IRQ;
> +       static unsigned int count = 0;
>        struct isp_device *isp = _isp;
>        u32 irqstatus;
>        int ret;
> @@ -469,6 +502,10 @@ static irqreturn_t isp_isr(int irq, void *_isp)
>        irqstatus = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
>        isp_reg_writel(isp, irqstatus, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
>
> +       isp_isr_account(isp, irqstatus);
> +       if (count++ >= 100000)
> +               isp_disable_interrupts(isp);
> +
>        isp_isr_sbl(isp);
>
>        if (irqstatus & IRQ0STATUS_CSIA_IRQ) {
> @@ -1971,6 +2008,7 @@ static int isp_remove(struct platform_device *pdev)
>        struct isp_device *isp = platform_get_drvdata(pdev);
>        int i;
>
> +       device_remove_file(&isp->media_dev.devnode.dev, &dev_attr_isr_account);
>        isp_unregister_entities(isp);
>        isp_cleanup_modules(isp);
>
> @@ -2067,6 +2105,7 @@ static int isp_probe(struct platform_device *pdev)
>
>        mutex_init(&isp->isp_mutex);
>        spin_lock_init(&isp->stat_lock);
> +       spin_lock_init(&isp->isr_account_lock);
>
>        isp->dev = &pdev->dev;
>        isp->pdata = pdata;
> @@ -2156,6 +2195,8 @@ static int isp_probe(struct platform_device *pdev)
>        isp_power_settings(isp, 1);
>        omap3isp_put(isp);
>
> +       ret = device_create_file(&isp->media_dev.devnode.dev, &dev_attr_isr_account);
> +
>        return 0;
>
>  error_modules:
> diff --git a/drivers/media/video/omap3isp/isp.h b/drivers/media/video/omap3isp/isp.h
> index 2620c40..b3f8448 100644
> --- a/drivers/media/video/omap3isp/isp.h
> +++ b/drivers/media/video/omap3isp/isp.h
> @@ -259,6 +259,7 @@ struct isp_device {
>
>        /* ISP Obj */
>        spinlock_t stat_lock;   /* common lock for statistic drivers */
> +       spinlock_t isr_account_lock;
>        struct mutex isp_mutex; /* For handling ref_count field */
>        bool needs_reset;
>        int has_context;
>
> Start a capture, wait a couple of settings for ISP interrupts to get disabled,
> and cat the isr_account sysfs file
> (/sys/bus/platform/devices/omap3isp/media0/isr_account if I remember
> correctly). My guess is that you will get approximatively 100000 HS_VS
> interrupts (31). Let's then move on from there after you've confirmed that the
> guess is correct.

Hello Laurent,

thank you very much for the patch. It are indeed hs/vs interrupts.

I discovered a heisenbug in my setup :)

When the igep stuck in the interrupts I meassured the hs line. I saw a
slight offset from ground. As I wondered how this small offset can
trigger the interrupt I realized that my system was running again. So
debugging my system with the oscilloscope made it run again. I try to
terminate the hs line with a pulldown to ground and see if I can
"simulate the debugging".
I probably had 24MI/s (megainterrupts per second) cause hs copied the
xclk wave (I discovered it before applying the patch)

Best regards,

 Bastian


> --
> Regards,
>
> Laurent Pinchart
>
