Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:56942 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab2CIDVR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Mar 2012 22:21:17 -0500
Received: by iaoo28 with SMTP id o28so1760208iao.12
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2012 19:21:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120126210514.GC15297@valkosipuli.localdomain>
References: <1322698500-29924-7-git-send-email-saaguirre@ti.com>
 <20120114175111.GA11467@valkosipuli.localdomain> <CAKnK67SnZZ95JC6hzqv4saR8KXTayV4gkbGy4rJFq8qYCZ23sg@mail.gmail.com>
 <20120126210514.GC15297@valkosipuli.localdomain>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Thu, 8 Mar 2012 21:14:32 -0600
Message-ID: <CAKnK67R7uZ8eLLgtvLwHnnxvkcS=UdJ4VSvcAjLQra8_LXT=0w@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] v4l: Add support for omap4iss driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, Jan 26, 2012 at 3:05 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Sergio,
>
>
> Aguirre, Sergio wrote:
>>>
>>> On Wed, Nov 30, 2011 at 06:14:55PM -0600, Sergio Aguirre wrote:
>
> ...
>
>>>> +/*
>>>> + * iss_save_ctx - Saves ISS context.
>>>> + * @iss: OMAP4 ISS device
>>>> + *
>>>> + * Routine for saving the context of each module in the ISS.
>>>> + */
>>>> +static void iss_save_ctx(struct iss_device *iss)
>>>> +{
>>>> +     iss_save_context(iss, iss_reg_list);
>>>> +}
>>>
>>>
>>> Do you really, really need to save context related data? Couldn't you
>>> initialise the device the usual way when e.g. returning from suspended
>>> state?
>>
>>
>> I'll actually have to revisit this more carefuly. I haven't really
>> tested Runtime PM on this.
>>
>> I think I'll remove this for now, until i come up with something better.
>
>
> Usually it's best to recreate the configuration the same way the driver did
> it in the first place. Some registers have side effects so that restoring
> them requires extra care.
>
>
>>>> +/*
>>>> + * iss_restore_ctx - Restores ISS context.
>>>> + * @iss: OMAP4 ISS device
>>>> + *
>>>> + * Routine for restoring the context of each module in the ISS.
>>>> + */
>>>> +static void iss_restore_ctx(struct iss_device *iss)
>>>> +{
>>>> +     iss_restore_context(iss, iss_reg_list);
>>>> +}
>>>> +
>
>
> ...
>
>
>>>> +/*
>>>> + * csi2_irq_ctx_set - Enables CSI2 Context IRQs.
>>>> + * @enable: Enable/disable CSI2 Context interrupts
>>>> + */
>>>> +static void csi2_irq_ctx_set(struct iss_csi2_device *csi2, int enable)
>>>> +{
>>>> +     u32 reg = CSI2_CTX_IRQ_FE;
>>>> +     int i;
>>>> +
>>>> +     if (csi2->use_fs_irq)
>>>> +             reg |= CSI2_CTX_IRQ_FS;
>>>> +
>>>> +     for (i = 0; i<  8; i++) {
>>>
>>>
>>> 8 == number of contexts?
>>
>>
>> Yes. This loops from 0 to 7.
>>
>> Are you implying that I need to add a define to this?
>
>
> I think something that tells it is the number of contexts would be nicer.
>
> ...
>
>
>>>> +     writel(readl(csi2->regs1 + CSI2_SYSCONFIG) |
>>>> +             CSI2_SYSCONFIG_SOFT_RESET,
>>>> +             csi2->regs1 + CSI2_SYSCONFIG);
>>>> +
>>>> +     do {
>>>> +             reg = readl(csi2->regs1 + CSI2_SYSSTATUS)&
>>>> +                                 CSI2_SYSSTATUS_RESET_DONE;
>>>> +             if (reg == CSI2_SYSSTATUS_RESET_DONE)
>>>> +                     break;
>>>> +             soft_reset_retries++;
>>>> +             if (soft_reset_retries<  5)
>>>> +                     udelay(100);
>>>
>>>
>>> How about usleep_range() here? Or omit such a long busyloop. Hardware
>>> typically resets quite fast.
>>
>>
>> I guess i'll try to fine-tune this then.
>
>
> I think it's fine to replace it with usleep_range() for now. Fine
> optimisations can be left for later if really needed.
>
> ...
>
>
>>>> +static void csi2_print_status(struct iss_csi2_device *csi2)
>>>> +{
>>>> +     struct iss_device *iss = csi2->iss;
>>>> +
>>>> +     if (!csi2->available)
>>>> +             return;
>>>> +
>>>> +     dev_dbg(iss->dev, "-------------CSI2 Register
>>>> dump-------------\n");
>>>> +
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, SYSCONFIG);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, SYSSTATUS);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, IRQENABLE);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, IRQSTATUS);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, CTRL);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, DBG_H);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, COMPLEXIO_CFG);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, COMPLEXIO_IRQSTATUS);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, SHORT_PACKET);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, COMPLEXIO_IRQENABLE);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, DBG_P);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, TIMING);
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_CTRL1(0));
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_CTRL2(0));
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_DAT_OFST(0));
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_PING_ADDR(0));
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_PONG_ADDR(0));
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_IRQENABLE(0));
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_IRQSTATUS(0));
>>>> +     CSI2_PRINT_REGISTER(iss, csi2->regs1, CTX_CTRL3(0));
>>>> +
>>>> +     dev_dbg(iss->dev,
>>>> "--------------------------------------------\n");
>>>
>>>
>>> _If_ this is user-triggered, you might want to consider using debugfs for
>>> the same. Just FYI.
>>
>>
>> Ok. I'll see what can I do.
>
>
> Just FYI. :-) Thinking about this agian, debugfs might not go well with this
> since the prints may be triggered by the driver.
>
> ...
>
>
>>>> +     /* Skip interrupts until we reach the frame skip count. The CSI2
>>>> will be
>>>> +      * automatically disabled, as the frame skip count has been
>>>> programmed
>>>> +      * in the CSI2_CTx_CTRL1::COUNT field, so reenable it.
>>>> +      *
>>>> +      * It would have been nice to rely on the FRAME_NUMBER interrupt
>>>> instead
>>>> +      * but it turned out that the interrupt is only generated when the
>>>> CSI2
>>>> +      * writes to memory (the CSI2_CTx_CTRL1::COUNT field is decreased
>>>> +      * correctly and reaches 0 when data is forwarded to the video
>>>> port only
>>>> +      * but no interrupt arrives). Maybe a CSI2 hardware bug.
>>>> +      */
>>>> +     if (csi2->frame_skip) {
>>>> +             csi2->frame_skip--;
>>>> +             if (csi2->frame_skip == 0) {
>>>> +                     ctx->format_id = csi2_ctx_map_format(csi2);
>>>> +                     csi2_ctx_config(csi2, ctx);
>>>
>>>
>>> Is configuration of the context needed elsewhere than in streamon? What
>>> changes while streaming?
>>
>>
>> Nothing I think...
>>
>> Same thing is done for OMAP3, so I tried to keep the driver as similar
>> as possible.
>
>
> Ok. Perhaps this could be fixed for OMAP 3, too. :-)

Actually, I just realized something while enabling ISP support for OMAP4.

If you have a sensor that returns something bigger than zero for
"g_skip_frames",
removing the csi2_ctx_config() call breaks VP output.

So, CSI2 is first enabled with VP only enabled, but the context format
doesn't have
a "+ VP", with a framecount = g_skip_frames... then when this is done,
and you have
a videoport, the next FE IRQ, ti hsould reconfigure the right VP
enabled context format.

This made me scratch my head several times when i wasn't receiving any
ISP interrupts :P

So please, don't try removing this from OMAP3 CSI2 driver! :)

Regards,
Sergio

>
>
>> I'll try removing this then.
>>
>
> ...
>
>>>> +/* This is not an exhaustive list */
>>>> +enum iss_csi2_pix_formats {
>>>> +     CSI2_PIX_FMT_OTHERS = 0,
>>>> +     CSI2_PIX_FMT_YUV422_8BIT = 0x1e,
>>>> +     CSI2_PIX_FMT_YUV422_8BIT_VP = 0x9e,
>>>> +     CSI2_PIX_FMT_RAW10_EXP16 = 0xab,
>>>> +     CSI2_PIX_FMT_RAW10_EXP16_VP = 0x12f,
>>>> +     CSI2_PIX_FMT_RAW8 = 0x2a,
>>>> +     CSI2_PIX_FMT_RAW8_DPCM10_EXP16 = 0x2aa,
>>>> +     CSI2_PIX_FMT_RAW8_DPCM10_VP = 0x32a,
>>>> +     CSI2_PIX_FMT_RAW8_VP = 0x12a,
>>>> +     CSI2_USERDEF_8BIT_DATA1_DPCM10_VP = 0x340,
>>>> +     CSI2_USERDEF_8BIT_DATA1_DPCM10 = 0x2c0,
>>>> +     CSI2_USERDEF_8BIT_DATA1 = 0x40,
>>>
>>>
>>> What are the USERDEF formats?
>>
>>
>> Again, inherited and adapted these from OMAP3 driver.
>>
>> Should I delete them?
>
>
> It's fine to keep them for now I guess --- Laurent must know what they
> actually are. :-) Looks like CSI-2 pixel format codes (plus VP control, I
> guess).
>
> ...
>
>>>> +struct iss_video {
>>>> +     struct video_device video;
>>>> +     enum v4l2_buf_type type;
>>>> +     struct media_pad pad;
>>>> +
>>>> +     struct mutex mutex;             /* format and crop settings */
>>>> +     atomic_t active;
>>>> +
>>>> +     struct iss_device *iss;
>>>> +
>>>> +     unsigned int capture_mem;
>>>> +     unsigned int bpl_alignment;     /* alignment value */
>>>> +     unsigned int bpl_zero_padding;  /* whether the alignment is
>>>> optional */
>>>> +     unsigned int bpl_max;           /* maximum bytes per line value */
>>>> +     unsigned int bpl_value;         /* bytes per line value */
>>>> +     unsigned int bpl_padding;       /* padding at end of line */
>>>> +
>>>> +     /* Entity video node streaming */
>>>> +     unsigned int streaming:1;
>>>> +
>>>> +     /* Pipeline state */
>>>> +     struct iss_pipeline pipe;
>>>> +     struct mutex stream_lock;       /* pipeline and stream states */
>>>> +
>>>> +     /* Video buffers queue */
>>>> +     struct vb2_queue *queue;
>>>> +     spinlock_t qlock;       /* Spinlock for dmaqueue */
>>>> +     struct list_head dmaqueue;
>>>> +     enum iss_video_dmaqueue_flags dmaqueue_flags;
>>>> +     struct vb2_alloc_ctx *alloc_ctx;
>>>> +
>>>> +     const struct iss_video_operations *ops;
>>>> +};
>>>> +
>>>> +#define to_iss_video(vdev)   container_of(vdev, struct iss_video,
>>>> video)
>>>> +
>>>> +struct iss_video_fh {
>>>> +     struct v4l2_fh vfh;
>>>> +     struct iss_video *video;
>>>> +     struct vb2_queue queue;
>>>> +     struct v4l2_format format;
>>>
>>>
>>> Format shouldn't be part of the file handle anymore. There was a reason
>>> for
>>> it in the past before PREPARE_BUF --- which is also supported by
>>> videobuf2.
>>
>>
>> Ok. So should I just remove it completely?
>>
>> Sorry if i'm not understanding this PREPARE_BUF thing... What should I
>> have there?
>
>
> PREPARE_BUF prepares the buffer for the use in the device's DMA engine. This
> is exactly what QBUF does, except that PREPARE_BUF doesn't put the buffer to
> the driver's queue (calling QBUF will then do that, and only that).
>
> Together with CREATE_BUFS this allows having different kinds of buffers in
> the same queue. This didn't use to be possible.
>
> Think of sets of buffers for still capture and viewfinder. They can now
> co-exist in the same queue.
>
> Kind regards,
>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
