Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53514 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1FPDMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 23:12:05 -0400
Received: by yxi11 with SMTP id 11so592209yxi.19
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2011 20:12:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikztbcm_+PR5oFVB+v0Jn4q8GCVTQ@mail.gmail.com>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
	<1307814409-46282-3-git-send-email-corbet@lwn.net>
	<BANLkTikVeHLL6+T74tpmwmsL4_3h5f3PmA@mail.gmail.com>
	<20110614084948.2d158323@bike.lwn.net>
	<BANLkTikztbcm_+PR5oFVB+v0Jn4q8GCVTQ@mail.gmail.com>
Date: Thu, 16 Jun 2011 11:12:03 +0800
Message-ID: <BANLkTi=gLkmuheH0aCwx=7-DuxDH3q769w@mail.gmail.com>
Subject: Re: [PATCH 2/8] marvell-cam: Separate out the Marvell camera core
From: Kassey Lee <kassey1216@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daniel Drake <dsd@laptop.org>, ytang5@marvell.com,
	leiwen@marvell.com, qingx@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jon:
      after review your code:
      1)  here is the code, that deal with controller we can share.but
still need to tune.
      2) for mcam_ctlr_stop_dma implementation, I guess you know
something about the silicon limitation,  but we found it can not pass
our stress test(1000 times capture test, which will switch format
between JPEG and YUV again and again).
       our solution is :
       stop the ccic controller and wait for about one frame transfer
time, and the stop the sensor.
       this passed our stress test. for your info.

       3) for videoubuf2, will you use videoubuf2 only or combined
with soc-camera ? when can your driver for videoubuf2 ready ?
        thanks, i am happy to verify on our PXA910, MMP2, MMP3 chip.
       4) the point is: ccic and sensor driver should be independent,
and support two CCIC controller.

       I've added the MMAP feature in my driver as you asked.


thank you very much!





/* ------------------------------------------------------------------- */
+/*
+ * Deal with the controller.
+ */
+
+/*
+ * Do everything we think we need to have the interface operating
+ * according to the desired format.
+ */
+static void mcam_ctlr_dma(struct mcam_camera *cam)
+{
+       /*
+        * Store the first two Y buffers (we aren't supporting
+        * planar formats for now, so no UV bufs).  Then either
+        * set the third if it exists, or tell the controller
+        * to just use two.
+        */
+       mcam_reg_write(cam, REG_Y0BAR, cam->dma_handles[0]);
+       mcam_reg_write(cam, REG_Y1BAR, cam->dma_handles[1]);
+       if (cam->nbufs > 2) {
+               mcam_reg_write(cam, REG_Y2BAR, cam->dma_handles[2]);
+               mcam_reg_clear_bit(cam, REG_CTRL1, C1_TWOBUFS);
+       } else
+               mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
+       mcam_reg_write(cam, REG_UBAR, 0); /* 32 bits only for now */
+}
+
+static void mcam_ctlr_image(struct mcam_camera *cam)
+{
+       int imgsz;
+       struct v4l2_pix_format *fmt = &cam->pix_format;
+
+       imgsz = ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
+               (fmt->bytesperline & IMGSZ_H_MASK);
+       mcam_reg_write(cam, REG_IMGSIZE, imgsz);
+       mcam_reg_write(cam, REG_IMGOFFSET, 0);
+       /* YPITCH just drops the last two bits */
+       mcam_reg_write_mask(cam, REG_IMGPITCH, fmt->bytesperline,
+                       IMGP_YP_MASK);
+       /*
+        * Tell the controller about the image format we are using.
+        */
+       switch (cam->pix_format.pixelformat) {
+       case V4L2_PIX_FMT_YUYV:
+           mcam_reg_write_mask(cam, REG_CTRL0,
+                           C0_DF_YUV|C0_YUV_PACKED|C0_YUVE_YUYV,
+                           C0_DF_MASK);
+           break;
+
+       case V4L2_PIX_FMT_RGB444:
+           mcam_reg_write_mask(cam, REG_CTRL0,
+                           C0_DF_RGB|C0_RGBF_444|C0_RGB4_XRGB,
+                           C0_DF_MASK);
+               /* Alpha value? */
+           break;
+
+       case V4L2_PIX_FMT_RGB565:
+           mcam_reg_write_mask(cam, REG_CTRL0,
+                           C0_DF_RGB|C0_RGBF_565|C0_RGB5_BGGR,
+                           C0_DF_MASK);
+           break;
+
+       default:
+           cam_err(cam, "Unknown format %x\n", cam->pix_format.pixelformat);
+           break;
+       }
+       /*
+        * Make sure it knows we want to use hsync/vsync.
+        */
+       mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
+                       C0_SIFM_MASK);
+}
+
+
+/*
+ * Configure the controller for operation; caller holds the
+ * device mutex.
+ */
+static int mcam_ctlr_configure(struct mcam_camera *cam)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&cam->dev_lock, flags);
+       mcam_ctlr_dma(cam);
+       mcam_ctlr_image(cam);
+       mcam_set_config_needed(cam, 0);
+       spin_unlock_irqrestore(&cam->dev_lock, flags);
+       return 0;
+}
+
+static void mcam_ctlr_irq_enable(struct mcam_camera *cam)
+{
+       /*
+        * Clear any pending interrupts, since we do not
+        * expect to have I/O active prior to enabling.
+        */
+       mcam_reg_write(cam, REG_IRQSTAT, FRAMEIRQS);
+       mcam_reg_set_bit(cam, REG_IRQMASK, FRAMEIRQS);
+}
+
+static void mcam_ctlr_irq_disable(struct mcam_camera *cam)
+{
+       mcam_reg_clear_bit(cam, REG_IRQMASK, FRAMEIRQS);
+}
+
+/*
+ * Make the controller start grabbing images.  Everything must
+ * be set up before doing this.
+ */
+static void mcam_ctlr_start(struct mcam_camera *cam)
+{
+       /* set_bit performs a read, so no other barrier should be
+          needed here */
+       mcam_reg_set_bit(cam, REG_CTRL0, C0_ENABLE);
+}
+
+static void mcam_ctlr_stop(struct mcam_camera *cam)
+{
+       mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
+}
+
+static void mcam_ctlr_init(struct mcam_camera *cam)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&cam->dev_lock, flags);
+       /*
+        * Make sure it's not powered down.
+        */
+       mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
+       /*
+        * Turn off the enable bit.  It sure should be off anyway,
+        * but it's good to be sure.
+        */
+       mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
+       /*
+        * Clock the sensor appropriately.  Controller clock should
+        * be 48MHz, sensor "typical" value is half that.
+        */
+       mcam_reg_write_mask(cam, REG_CLKCTRL, 2, CLK_DIV_MASK);
+       spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
+
+/*
+ * Stop the controller, and don't return until we're really sure that no
+ * further DMA is going on.
+ */
+static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
+{
+       unsigned long flags;
+
+       /*
+        * Theory: stop the camera controller (whether it is operating
+        * or not).  Delay briefly just in case we race with the SOF
+        * interrupt, then wait until no DMA is active.
+        */
+       spin_lock_irqsave(&cam->dev_lock, flags);
+       mcam_ctlr_stop(cam);
+       spin_unlock_irqrestore(&cam->dev_lock, flags);
+       mdelay(1);
+       wait_event_timeout(cam->iowait,
+                       !test_bit(CF_DMA_ACTIVE, &cam->flags), HZ);
+       if (test_bit(CF_DMA_ACTIVE, &cam->flags))
+               cam_err(cam, "Timeout waiting for DMA to end\n");
+               /* This would be bad news - what now? */
+       spin_lock_irqsave(&cam->dev_lock, flags);
+       cam->state = S_IDLE;
+       mcam_ctlr_irq_disable(cam);
+       spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
+/*
+ * Power up and down.
+ */
+static void mcam_ctlr_power_up(struct mcam_camera *cam)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&cam->dev_lock, flags);
+       mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
+       cam->plat_power_up(cam);
+       spin_unlock_irqrestore(&cam->dev_lock, flags);
+       msleep(5); /* Just to be sure */
+}
+
+static void mcam_ctlr_power_down(struct mcam_camera *cam)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&cam->dev_lock, flags);
+       cam->plat_power_down(cam);
+       mcam_reg_set_bit(cam, REG_CTRL1, C1_PWRDWN);
+       spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.
