Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.40]:26012 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752039AbdEDTFG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 15:05:06 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id DA6F61E0497
        for <linux-media@vger.kernel.org>; Thu,  4 May 2017 14:05:03 -0500 (CDT)
Date: Thu, 04 May 2017 14:05:02 -0500
Message-ID: <20170504140502.Horde.e_TqvS0_CEqTDsNh1soDOGo@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [media-s3c-camif] question about arguments position
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello everybody,

While looking into Coverity ID 1248800 I ran into the following piece  
of code at drivers/media/platform/s3c-camif/camif-capture.c:67:

/* Locking: called with camif->slock spinlock held */
static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp *vp)
{
         const struct s3c_camif_variant *variant = camif->variant;

         if (camif->sensor.sd == NULL || vp->out_fmt == NULL)
                 return -EINVAL;

         if (variant->ip_revision == S3C244X_CAMIF_IP_REV)
                 camif_hw_clear_fifo_overflow(vp);
         camif_hw_set_camera_bus(camif);
         camif_hw_set_source_format(camif);
         camif_hw_set_camera_crop(camif);
         camif_hw_set_test_pattern(camif, camif->test_pattern);
         if (variant->has_img_effect)
                 camif_hw_set_effect(camif, camif->colorfx,
                                 camif->colorfx_cb, camif->colorfx_cr);
         if (variant->ip_revision == S3C6410_CAMIF_IP_REV)
                 camif_hw_set_input_path(vp);
         camif_cfg_video_path(vp);
         vp->state &= ~ST_VP_CONFIG;

         return 0;
}


The issue here is that the position of arguments in the call to  
camif_hw_set_effect() function do not match the order of the parameters:

camif->colorfx_cb is passed to cr
camif->colorfx_cr is passed to cb

This is the function prototype:

void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
			unsigned int cr, unsigned int cb)

My question here is if this is intentional?

In case it is not, I will send a patch to fix it. But first it would  
be great to hear any comment about it.

By the way... the same is happening at  
drivers/media/platform/s3c-camif/camif-capture.c:366

Thank you
--
Gustavo A. R. Silva
