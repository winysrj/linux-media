Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758783Ab2J2Lo2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 07:44:28 -0400
Date: Mon, 29 Oct 2012 09:44:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 35/68] [media] pwc-if: must check vb2_queue_init()
 success
Message-ID: <20121029094419.020a390b@redhat.com>
In-Reply-To: <CALF0-+VAVX=b9iEvQS88x5Ndr=7GGBuyi4k=18-2uJjwFL95HA@mail.gmail.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
	<1351370486-29040-36-git-send-email-mchehab@redhat.com>
	<CALF0-+VAVX=b9iEvQS88x5Ndr=7GGBuyi4k=18-2uJjwFL95HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Oct 2012 08:37:31 -0300
Ezequiel Garcia <elezegarcia@gmail.com> escreveu:

> On Sat, Oct 27, 2012 at 5:40 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > drivers/media/usb/pwc/pwc-if.c: In function 'usb_pwc_probe':
> > drivers/media/usb/pwc/pwc-if.c:1003:16: warning: ignoring return value of 'vb2_queue_init', declared with attribute warn_unused_result [-Wunused-result]
> > In the past, it used to have a logic there at queue init that would
> > BUG() on errors. This logic got removed. Drivers are now required
> > to explicitly handle the queue initialization errors, or very bad
> > things may happen.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/media/usb/pwc/pwc-if.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> > index e191572..5210239 100644
> > --- a/drivers/media/usb/pwc/pwc-if.c
> > +++ b/drivers/media/usb/pwc/pwc-if.c
> > @@ -1000,7 +1000,11 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
> >         pdev->vb_queue.buf_struct_size = sizeof(struct pwc_frame_buf);
> >         pdev->vb_queue.ops = &pwc_vb_queue_ops;
> >         pdev->vb_queue.mem_ops = &vb2_vmalloc_memops;
> > -       vb2_queue_init(&pdev->vb_queue);
> > +       rc = vb2_queue_init(&pdev->vb_queue);
> > +       if (rc < 0) {
> > +               PWC_ERROR("Oops, could not initialize vb2 queue.\n");
> > +               goto err_free_mem;
> > +       }
> >
> >         /* Init video_device structure */
> >         memcpy(&pdev->vdev, &pwc_template, sizeof(pwc_template));
> > --
> > 1.7.11.7
> >
> 
> Weird, I thought this was already fixed...
> 
> https://patchwork.kernel.org/patch/1467211/
> 
> And even weirder...
> now all my patches are marked as 'New' by patchwork...
> 
> https://patchwork.kernel.org/project/linux-media/list/?submitter=37031&state=*
> 
> (this must be the last name mess I did...)

Nah, you're looking at the wrong place. you should be looking at patchwork.linuxtv.org.

The ones I have with your name on it are those:

patches/lmml_15142_01_23_uvc_replace_memcpy_with_struct_assignment.patch
patches/lmml_15143_22_23_radio_wl1273_replace_memcpy_with_struct_assignment.patch
patches/lmml_15144_23_23_wl128x_replace_memcpy_with_struct_assignment.patch
patches/lmml_15145_21_23_dvb_frontends_replace_memcpy_with_struct_assignment.patch
patches/lmml_15146_20_23_dvb_core_replace_memcpy_with_struct_assignment.patch
patches/lmml_15147_18_23_cx18_replace_memcpy_with_struct_assignment.patch
patches/lmml_15148_19_23_bttv_replace_memcpy_with_struct_assignment.patch
patches/lmml_15149_17_23_cx23885_replace_memcpy_with_struct_assignment.patch
patches/lmml_15150_16_23_cx88_replace_memcpy_with_struct_assignment.patch
patches/lmml_15151_14_23_tuners_tda18271_replace_memcpy_with_struct_assignment.patch
patches/lmml_15152_15_23_ivtv_replace_memcpy_with_struct_assignment.patch
patches/lmml_15153_12_23_tuners_xc4000_replace_memcpy_with_struct_assignment.patch
patches/lmml_15154_13_23_tuners_xc2028_replace_memcpy_with_struct_assignment.patch
patches/lmml_15155_11_23_au0828_replace_memcpy_with_struct_assignment.patch
patches/lmml_15156_10_23_dvb_usb_friio_fe_replace_memcpy_with_struct_assignment.patch
patches/lmml_15157_08_23_cx25840_replace_memcpy_with_struct_assignment.patch
patches/lmml_15158_09_23_zr36067_replace_memcpy_with_struct_assignment.patch
patches/lmml_15159_06_23_pvrusb2_replace_memcpy_with_struct_assignment.patch
patches/lmml_15160_07_23_hdpvr_replace_memcpy_with_struct_assignment.patch
patches/lmml_15161_05_23_pwc_replace_memcpy_with_struct_assignment.patch
patches/lmml_15162_04_23_sn9c102_replace_memcpy_with_struct_assignment.patch
patches/lmml_15163_03_23_usbvision_replace_memcpy_with_struct_assignment.patch
patches/lmml_15164_02_23_cx231xx_replace_memcpy_with_struct_assignment.patch
patches/lmml_15165_stk1160_try_to_continue_with_fewer_transfer_buffers.patch
patches/lmml_14192_11_14_drivers_media_usb_stk1160_stk1160_i2c_c_fix_error_return_code.patch
patches/lmml_15197_maintainers_update_email_and_git_tree.patch


> 
>     Ezequiel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Mauro
