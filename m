Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58725 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1FPCan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 22:30:43 -0400
Received: by ywe9 with SMTP id 9so576999ywe.19
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2011 19:30:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110614084948.2d158323@bike.lwn.net>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
	<1307814409-46282-3-git-send-email-corbet@lwn.net>
	<BANLkTikVeHLL6+T74tpmwmsL4_3h5f3PmA@mail.gmail.com>
	<20110614084948.2d158323@bike.lwn.net>
Date: Thu, 16 Jun 2011 10:30:42 +0800
Message-ID: <BANLkTikztbcm_+PR5oFVB+v0Jn4q8GCVTQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] marvell-cam: Separate out the Marvell camera core
From: Kassey Lee <kassey1216@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daniel Drake <dsd@laptop.org>, ytang5@marvell.com,
	leiwen@marvell.com, qingx@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/14 Jonathan Corbet <corbet@lwn.net>:
> On Tue, 14 Jun 2011 10:58:47 +0800
> Kassey Lee <kassey1216@gmail.com> wrote:
>
>> > +#include <linux/wait.h>
>> > +#include <linux/delay.h>
>> > +#include <linux/io.h>
>> > +
>> Would be good to sort headers alphabetically
>
> Um, I suppose.  You're sure you don't want inverse Christmas-tree ordering?
> :)
>
>> > +static int cafe_smbus_write_done(struct mcam_camera *mcam)
>> > +{
>> > +       unsigned long flags;
>> > +       int c1;
>> > +
>> > +       /*
>> > +        * We must delay after the interrupt, or the controller gets confused
>> > +        * and never does give us good status.  Fortunately, we don't do this
>> > +        * often.
>> > +        */
>> > +       udelay(20);
>> > +       spin_lock_irqsave(&mcam->dev_lock, flags);
>> > +       c1 = mcam_reg_read(mcam, REG_TWSIC1);
>> > +       spin_unlock_irqrestore(&mcam->dev_lock, flags);
>> do you really want to use spin_lock to protect REG_TWSIC1, this
>> register is not access in ISR ?
>
> I use the spinlock to protect all accesses to the MMIO space; I don't think
> it makes sense to have multiple threads mucking around in there at ths same
> time.
>
> Also, once again, this is a reshuffle of code which has worked for years; I
> don't think it's the right time to mess with the locking decisions.
OK, that is fine.
>
>> > +/*
>> > + * Controller-level stuff
>> > + */
>> > +
>> > +static void cafe_ctlr_init(struct mcam_camera *mcam)
>> cafe_init is enough
>
> Disagree.  This is controller-level (as opposed to TWSI) programming, so
> the related functions have "ctlr" in them.  This doesn't seem like a level
> of detail that needs a great deal of discussion...?
>
>> > +#define cam_err(cam, fmt, arg...) \
>> > +       dev_err((cam)->dev, fmt, ##arg);
>> > +#define cam_warn(cam, fmt, arg...) \
>> > +       dev_warn((cam)->dev, fmt, ##arg);
>> > +#define cam_dbg(cam, fmt, arg...) \
>> > +       dev_dbg((cam)->dev, fmt, ##arg);
>> > +
>> you 've define these in cafe_driver.c, better to share one
>
> Do look at the cafe version:
>
> #define cam_err(cam, fmt, arg...) \
>        dev_err(&(cam)->pdev->dev, fmt, ##arg);
>
> They're not the same, so can't be shared.  Probably the cafe ones should be
> renamed to cafe_err() or whatever to avoid this sort of confusion.
>
>> > +static void mcam_ctlr_image(struct mcam_camera *cam)
>> > +{
>> > +       int imgsz;
>> > +       struct v4l2_pix_format *fmt = &cam->pix_format;
>> > +
>> > +       imgsz = ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
>> > +               (fmt->bytesperline & IMGSZ_H_MASK);
>> Superfluous parenthesis
>
> See http://lwn.net/Articles/382023/ :)
>
> I feel that use of parentheses to make order of evaluation in complex
> expressions explicit is no sin.
>
>> > +static void mcam_ctlr_irq_enable(struct mcam_camera *cam)
>> mcam_irq_enable is OK
>
> Sure, it would be OK; there isn't the distinction with the TWSI IRQs that
> the cafe driver has.  I also don't think that the longer name contributes
> greatly to global warming.
>
>> > +/*
>> > + * We have found the sensor on the i2c.  Let's try to have a
>> > + * conversation.
>> > + */
>> > +static int mcam_cam_init(struct mcam_camera *cam)
>> > +{
>> > +       struct v4l2_dbg_chip_ident chip;
>> > +       int ret;
>> > +
>> > +       mutex_lock(&cam->s_mutex);
>> > +       if (cam->state != S_NOTREADY)
>> > +               cam_warn(cam, "Cam init with device in funky state %d",
>> > +                               cam->state);
>> > +       ret = __mcam_cam_reset(cam);
>> > +       if (ret)
>> > +               goto out;
>> > +       chip.ident = V4L2_IDENT_NONE;
>> > +       chip.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
>> > +       chip.match.addr = cam->sensor_addr;
>> > +       ret = sensor_call(cam, core, g_chip_ident, &chip);
>> > +       if (ret)
>> > +               goto out;
>> > +       cam->sensor_type = chip.ident;
>> > +       if (cam->sensor_type != V4L2_IDENT_OV7670) {
>> again, CCIC do not need to know sensor's name.
>
> And, again, that will be fixed.  But that's a job for a separate patch.
>
>> > +static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
>> > +               struct v4l2_requestbuffers *req)
>> > +{
>> > +       struct mcam_camera *cam = filp->private_data;
>> > +       int ret = 0;  /* Silence warning */
>> > +
>> > +       /*
>> > +        * Make sure it's something we can do.  User pointers could be
>> > +        * implemented without great pain, but that's not been done yet.
>> > +        */
>> > +       if (req->memory != V4L2_MEMORY_MMAP)
>> > +               return -EINVAL;
>> only MMAP ?
>
> Yes, the current code doesn't do USERPTR, never has.  The vb2 conversion
> (already working in my tree here, BTW) will fix that.
>
>> > +static int mcam_vidioc_qbuf(struct file *filp, void *priv,
>> > +               struct v4l2_buffer *buf)
>> > +{
>> > +       struct mcam_camera *cam = filp->private_data;
>> > +       struct mcam_sio_buffer *sbuf;
>> > +       int ret = -EINVAL;
>> > +       unsigned long flags;
>> > +
>> > +       mutex_lock(&cam->s_mutex);
>> > +       if (buf->index >= cam->n_sbufs)
>> > +               goto out;
>> > +       sbuf = cam->sb_bufs + buf->index;
>> > +       if (sbuf->v4lbuf.flags & V4L2_BUF_FLAG_QUEUED) {
>> > +               ret = 0; /* Already queued?? */
>> > +               goto out;
>> > +       }
>> > +       if (sbuf->v4lbuf.flags & V4L2_BUF_FLAG_DONE) {
>> > +               /* Spec doesn't say anything, seems appropriate tho */
>> > +               ret = -EBUSY;
>> > +               goto out;
>> > +       }
>> > +       sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_QUEUED;
>> > +       spin_lock_irqsave(&cam->dev_lock, flags);
>> > +       list_add(&sbuf->list, &cam->sb_avail);
>> list_add_tail is better.
>
> I would dispute that - I'd rather reuse cache-hot buffers.  But it's
> totally irrelevant; all this buffer-handling code is headed for the bit
> bucket with vb2.
>
>> > +static int mcam_vidioc_querycap(struct file *file, void *priv,
>> > +               struct v4l2_capability *cap)
>> > +{
>> > +       strcpy(cap->driver, "marvell_ccic");
>> > +       strcpy(cap->card, "marvell_ccic");
>> strlcpy is better
>
> Why?  There's no mystery about the length of the string.
>
>> > +static int mcam_vidioc_enum_input(struct file *filp, void *priv,
>> > +               struct v4l2_input *input)
>> > +{
>> > +       if (input->index != 0)
>> > +               return -EINVAL;
>> > +
>> > +       input->type = V4L2_INPUT_TYPE_CAMERA;
>> > +       input->std = V4L2_STD_ALL; /* Not sure what should go here */
>> > +       strcpy(input->name, "Camera");
>> strlcpy
>
> Ditto.
>
>> > +int mccic_register(struct mcam_camera *cam)
>> > +{
>> > +       struct i2c_board_info ov7670_info = {
>> > +               .type = "ov7670",
>> > +               .addr = 0x42,
>> > +               .platform_data = &sensor_cfg,
>> > +       };
>> you can put this in board.c
>
> Agreed, that's exactly where it needs to be.  Or in the device tree, if
> that's in use.  All that will be done when the ov7670 dependency is
> removed.
>
>> > +       /*
>> > +        * Try to find the sensor.
>> > +        */
>> > +       cam->sensor_addr = ov7670_info.addr;
>> > +       cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
>> > +                       &cam->i2c_adapter, &ov7670_info, NULL);
>> I do not thinks so.
>
> I don't understand what this comment is meant to mean...?
this should be move out to arch/arm/mach-xxx/board.c
>
>> > +/*
>> > + * Register I/O functions.  These are here because the platform code
>> > + * may legitimately need to mess with the register space.
>> > + */
>> > +/*
>> > + * Device register I/O
>> > + */
>> > +static inline void mcam_reg_write(struct mcam_camera *cam, unsigned int reg,
>> > +               unsigned int val)
>> u32 val
>
> *shrug*, that would work too, yes.
>
> Thanks,
>
> jon
>



-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.
