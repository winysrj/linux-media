Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:42348 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbaDPNOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 09:14:23 -0400
Message-ID: <534E8225.6090804@sca-uk.com>
Date: Wed, 16 Apr 2014 14:14:13 +0100
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com> <5347C57B.7000207@xs4all.nl> <5347DD94.1070000@sca-uk.com> <5347E2AF.6030205@xs4all.nl> <5347EB5D.2020408@sca-uk.com> <5347EC3D.7040107@xs4all.nl> <5348392E.40808@sca-uk.com> <534BEA8A.2040604@xs4all.nl> <534D6241.5060903@sca-uk.com> <534D68C2.6050902@xs4all.nl> <534D7E24.4010602@sca-uk.com> <534E5438.3030404@xs4all.nl>
In-Reply-To: <534E5438.3030404@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi Hans,

Thanks for this.
On 16/04/14 10:58, Hans Verkuil wrote:
 > find /lib/modules/`uname -r`/|grep altera
 >
 > If you have duplicate altera-stapl.ko files, then that might explain it.
 > In that case remove the older module.
There are indeed duplicates.  I removed the older one and dmesg went 
wild :)  Dump follows at end of email.

However looking at the tree structure I have to say I don't understand 
it.  Firstly there seem to be two equivalent branches in /lib/modules/:

1) drivers/linux/drivers/misc/altera-stapl/

and

2) drivers/misc/altera-stapl/

Before I do the patch and build, altera-stapl.ko is in 2) but the make 
install puts the new version in 1).

If I delete the version in 1), I delete the effects of the patch, if I 
delete the version in 2), I get the dump below.
 > It does install correctly for my 3.13 kernel.
I upgraded to 3.11.0.19 and reinstalled linux tv, but same effect.

Note that the dump here gives err 0, but the original error was err 
-22.  Is -22 significant, does anyone know what it means?

Also, there is an altera.h of size = 0 in 
lib/modules/...../include/config/spi but as it is not duplicated on 
linuxtv/media_build I imagine it doesn't affect the compile.

There has been quite a bit of discussion about this error in previous 
releases and patches have been applied (as I'm sure you saw).  It seems 
we still haven't quite got to the bottom of it as it is still 
reappearing.  I think it would be quite useful to put it to bed once and 
for all.

Thanks so much for your help.

Regards

Steve.

dmesg | grep -i cx
[    9.048582] cx23885: module verification failed: signature and/or 
required key missing - tainting kernel
[    9.048599] cx23885: Unknown symbol videobuf_streamoff (err 0)
[    9.048605] cx23885: Unknown symbol v4l2_norm_to_name (err 0)
[    9.048608] cx23885: Unknown symbol videobuf_poll_stream (err 0)
[    9.048611] cx23885: Unknown symbol video_ioctl2 (err 0)
[    9.048615] cx23885: Unknown symbol v4l2_get_timestamp (err 0)
[    9.048618] cx23885: Unknown symbol videobuf_read_stop (err 0)
[    9.048623] cx23885: Unknown symbol ir_raw_event_handle (err 0)
[    9.048626] cx23885: Unknown symbol videobuf_dma_map (err 0)
[    9.048632] cx23885: Unknown symbol dvb_ca_en50221_init (err 0)
[    9.048637] cx23885: Unknown symbol altera_init (err 0)
[    9.048641] cx23885: Unknown symbol snd_pcm_new (err 0)
[    9.048647] cx23885: Unknown symbol cx2341x_ext_ctrls (err 0)
[    9.048651] cx23885: Unknown symbol tda18271_attach (err 0)
[    9.048659] cx23885: Unknown symbol videobuf_dma_free (err 0)
[    9.048663] cx23885: Unknown symbol ir_raw_event_store (err 0)
[    9.048667] cx23885: Unknown symbol videobuf_reqbufs (err 0)
[    9.048674] cx23885: Unknown symbol videobuf_waiton (err 0)
[    9.048677] cx23885: Unknown symbol snd_pcm_format_physical_width (err 0)
[    9.048680] cx23885: Unknown symbol v4l2_subdev_init (err 0)
[    9.048684] cx23885: Unknown symbol videobuf_dqbuf (err 0)
[    9.048691] cx23885: Unknown symbol videobuf_dvb_alloc_frontend (err 0)
[    9.048695] cx23885: Unknown symbol v4l2_i2c_subdev_addr (err 0)
[    9.048698] cx23885: Unknown symbol v4l2_device_register_subdev (err 0)
[    9.048701] cx23885: Unknown symbol cx2341x_ctrl_query (err 0)
[    9.048706] cx23885: Unknown symbol video_devdata (err 0)
[    9.048710] cx23885: Unknown symbol v4l_bound_align_image (err 0)
[    9.048713] cx23885: Unknown symbol v4l2_type_names (err 0)
[    9.048716] cx23885: Unknown symbol v4l2_device_unregister_subdev (err 0)
[    9.048719] cx23885: Unknown symbol v4l2_ctrl_next (err 0)
[    9.048723] cx23885: Unknown symbol altera_ci_tuner_reset (err 0)
[    9.048727] cx23885: Unknown symbol btcx_riscmem_alloc (err 0)
[    9.048729] cx23885: Unknown symbol videobuf_dvb_get_frontend (err 0)
[    9.048732] cx23885: Unknown symbol snd_pcm_lib_ioctl (err 0)
[    9.048736] cx23885: Unknown symbol tveeprom_read (err 0)
[    9.048739] cx23885: Unknown symbol videobuf_queue_sg_init (err 0)
[    9.048741] cx23885: Unknown symbol btcx_riscmem_free (err 0)
[    9.048744] cx23885: Unknown symbol v4l2_ctrl_query_menu (err 0)
[    9.048747] cx23885: Unknown symbol videobuf_dma_unmap (err 0)
[    9.048749] cx23885: Unknown symbol videobuf_read_stream (err 0)
[    9.048753] cx23885: Unknown symbol dvb_ca_en50221_release (err 0)
[    9.048757] cx23885: Unknown symbol rc_register_device (err 0)
[    9.048761] cx23885: Unknown symbol videobuf_querybuf (err 0)
[    9.048763] cx23885: Unknown symbol snd_pcm_hw_constraint_pow2 (err 0)
[    9.048767] cx23885: Unknown symbol altera_ci_irq (err 0)
[    9.048769] cx23885: Unknown symbol snd_pcm_set_ops (err 0)
[    9.048772] cx23885: Unknown symbol video_unregister_device (err 0)
[    9.048775] cx23885: Unknown symbol videobuf_qbuf (err 0)
[    9.048779] cx23885: Unknown symbol altera_ci_release (err 0)
[    9.048782] cx23885: Unknown symbol cx2341x_update (err 0)
[    9.048785] cx23885: Unknown symbol video_device_alloc (err 0)
[    9.048789] cx23885: Unknown symbol videobuf_read_one (err 0)
[    9.048792] cx23885: Unknown symbol rc_free_device (err 0)
[    9.048794] cx23885: Unknown symbol videobuf_dma_init (err 0)
[    9.048799] cx23885: Unknown symbol dvb_ca_en50221_frda_irq (err 0)
[    9.048802] cx23885: Unknown symbol cx2341x_ctrl_get_menu (err 0)
[    9.048804] cx23885: Unknown symbol v4l2_device_register (err 0)
[    9.048807] cx23885: Unknown symbol videobuf_dvb_unregister_bus (err 0)
[    9.048812] cx23885: Unknown symbol dvb_ca_en50221_camready_irq (err 0)
[    9.048814] cx23885: Unknown symbol rc_allocate_device (err 0)
[    9.048817] cx23885: Unknown symbol cx2341x_log_status (err 0)
[    9.048821] cx23885: Unknown symbol videobuf_dma_init_kernel (err 0)
[    9.048824] cx23885: Unknown symbol cx2341x_fill_defaults (err 0)
[    9.048826] cx23885: Unknown symbol videobuf_dvb_register_bus (err 0)
[    9.048830] cx23885: Unknown symbol videobuf_iolock (err 0)
[    9.048834] cx23885: Unknown symbol __video_register_device (err 0)
[    9.048837] cx23885: Unknown symbol videobuf_streamon (err 0)
[    9.048839] cx23885: Unknown symbol videobuf_queue_cancel (err 0)
[    9.048842] cx23885: Unknown symbol videobuf_dvb_dealloc_frontends 
(err 0)
[    9.048844] cx23885: Unknown symbol v4l2_i2c_tuner_addrs (err 0)
[    9.048848] cx23885: Unknown symbol v4l2_device_unregister (err 0)
[    9.048851] cx23885: Unknown symbol tveeprom_hauppauge_analog (err 0)
[    9.048854] cx23885: Unknown symbol video_device_release (err 0)
[    9.048857] cx23885: Unknown symbol snd_pcm_period_elapsed (err 0)
[    9.048860] cx23885: Unknown symbol v4l2_i2c_new_subdev (err 0)
[    9.048863] cx23885: Unknown symbol videobuf_mmap_mapper (err 0)
[    9.048866] cx23885: Unknown symbol cx2341x_mpeg_ctrls (err 0)
[    9.048871] cx23885: Unknown symbol altera_ci_init (err 0)
[    9.048876] cx23885: Unknown symbol rc_unregister_device (err 0)
[    9.048880] cx23885: Unknown symbol videobuf_to_dma (err 0)
[    9.048883] cx23885: Unknown symbol videobuf_mmap_free (err 0)
image@image-H61M-DS2:~/media_build$
