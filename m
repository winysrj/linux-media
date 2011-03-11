Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2602 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1CKTVV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 14:21:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: compilation warnings/errors
Date: Fri, 11 Mar 2011 20:20:51 +0100
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D7A69EB.3060200@redhat.com>
In-Reply-To: <4D7A69EB.3060200@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103112020.52002.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, March 11, 2011 19:28:59 Mauro Carvalho Chehab wrote:
> Hi Hans/Matti
> 
> I did a compilation of the media_build tree against Fedora Rawhide, to check what warnings are happening
> with gcc 4.6, as it is easier to me to just run a VM with Rawhide than to keep an updated set of gcc
> compiled by me on some place.
> 
> The compilation, however, ended earlier due to some errors at TI WL1273 FM driver.
> 
> I'm enclosing the warnings and errors when compiling media_build on Fedora rawhide. 
> 
> Rawhide kernel is 2.6.38-rc7 - 32 bits (probably plus some Fedora patches - in general, backports from the -next tree).
> 
> I suspect that this could be due to some platform_data that might be at -next or at -rc7 that are not
> present on my tree, but it would be great to take a look on it, otherwise I'll may have problems when
> merging it upstream or submitting it to -next.

radio-wl1273 depends on include/linux/mfd/wl1273-core.h. This header was changed
for 2.6.39. Since this header is also used in drivers/mfd I think the best
approach is not to build this driver for 2.6.38. The alternative would be to
copy the header and drivers/mfd/wl1273-core.c as well and make sure it is
configured and compiled. IMHO it's not worth the effort for a platform driver.

Regards,

	Hans

> 
> Could you please take a look on it?
> 
> Thanks!
> Mauro.
> 
> 
> /home/mchehab/new_build/v4l/au0828-dvb.c: In function 'urb_completion':
> /home/mchehab/new_build/v4l/au0828-dvb.c:99:6: warning: variable 'ptr' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/au0828-video.c: In function 'au0828_irq_callback':
> /home/mchehab/new_build/v4l/au0828-video.c:126:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/au0828-video.c: In function 'au0828_set_format':
> /home/mchehab/new_build/v4l/au0828-video.c:1180:25: warning: variable 'maxheight' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/au0828-video.c:1180:15: warning: variable 'maxwidth' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/bttv-input.c: In function 'bttv_rc5_timer_end':
> /home/mchehab/new_build/v4l/bttv-input.c:196:16: warning: variable 'current_jiffies' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cpia2_core.c: In function 'cpia2_send_command':
> /home/mchehab/new_build/v4l/cpia2_core.c:529:14: warning: variable 'dir' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cpia2_core.c:526:5: warning: variable 'block_index' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx18-alsa-main.c: In function 'cx18_alsa_exit':
> /home/mchehab/new_build/v4l/cx18-alsa-main.c:281:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx18-alsa-pcm.c: In function 'snd_cx18_pcm_capture_open':
> /home/mchehab/new_build/v4l/cx18-alsa-pcm.c:156:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx18-alsa-pcm.c: In function 'snd_cx18_pcm_capture_close':
> /home/mchehab/new_build/v4l/cx18-alsa-pcm.c:202:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx18-alsa-pcm.c: In function 'snd_cx18_pcm_hw_params':
> /home/mchehab/new_build/v4l/cx18-alsa-pcm.c:255:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx18-streams.c: In function 'cx18_stop_v4l2_encode_stream':
> /home/mchehab/new_build/v4l/cx18-streams.c:786:16: warning: variable 'then' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx18-mailbox.c: In function 'cx18_api_call':
> /home/mchehab/new_build/v4l/cx18-mailbox.c:540:6: warning: variable 'state' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-audio.c: In function 'snd_cx231xx_hw_capture_params':
> /home/mchehab/new_build/v4l/cx231xx-audio.c:510:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-audio.c:509:31: warning: variable 'format' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-audio.c:509:25: warning: variable 'rate' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-audio.c:509:15: warning: variable 'channels' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-audio.c: In function 'snd_cx231xx_capture_trigger':
> /home/mchehab/new_build/v4l/cx231xx-audio.c:572:6: warning: variable 'retval' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-video.c: In function 'cx231xx_isoc_copy':
> /home/mchehab/new_build/v4l/cx231xx-video.c:331:17: warning: variable 'outp' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-video.c: In function 'cx231xx_bulk_copy':
> /home/mchehab/new_build/v4l/cx231xx-video.c:434:17: warning: variable 'outp' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-video.c: In function 'cx231xx_reset_video_buffer':
> /home/mchehab/new_build/v4l/cx231xx-video.c:704:7: warning: variable 'outp' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-core.c: In function 'cx231xx_set_mode':
> /home/mchehab/new_build/v4l/cx231xx-core.c:696:6: warning: variable 'errCode' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-core.c: In function 'cx231xx_ep5_bulkout':
> /home/mchehab/new_build/v4l/cx231xx-core.c:758:6: warning: variable 'errCode' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-core.c: In function 'cx231xx_isoc_irq_callback':
> /home/mchehab/new_build/v4l/cx231xx-core.c:795:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-core.c: In function 'cx231xx_bulk_irq_callback':
> /home/mchehab/new_build/v4l/cx231xx-core.c:841:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-core.c: In function 'cx231xx_stop_TS1':
> /home/mchehab/new_build/v4l/cx231xx-core.c:1229:6: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-core.c: In function 'cx231xx_start_TS1':
> /home/mchehab/new_build/v4l/cx231xx-core.c:1249:6: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-avcore.c: In function 'cx231xx_enable656':
> /home/mchehab/new_build/v4l/cx231xx-avcore.c:935:6: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-avcore.c: In function 'cx231xx_disable656':
> /home/mchehab/new_build/v4l/cx231xx-avcore.c:953:6: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-avcore.c: In function 'cx231xx_dump_HH_reg':
> /home/mchehab/new_build/v4l/cx231xx-avcore.c:1321:5: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-avcore.c: In function 'cx231xx_dump_SC_reg':
> /home/mchehab/new_build/v4l/cx231xx-avcore.c:1356:6: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-avcore.c: In function 'cx231xx_Setup_AFE_for_LowIF':
> /home/mchehab/new_build/v4l/cx231xx-avcore.c:1442:5: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-avcore.c: In function 'cx231xx_set_Colibri_For_LowIF':
> /home/mchehab/new_build/v4l/cx231xx-avcore.c:1502:5: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-avcore.c: In function 'cx231xx_set_DIF_bandpass':
> /home/mchehab/new_build/v4l/cx231xx-avcore.c:1557:6: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-avcore.c: In function 'cx231xx_gpio_i2c_write':
> /home/mchehab/new_build/v4l/cx231xx-avcore.c:3089:6: warning: variable 'status' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-417.c: In function 'cx231xx_initialize_codec':
> /home/mchehab/new_build/v4l/cx231xx-417.c:1098:9: warning: variable 'data' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-417.c: In function 'vidioc_streamon':
> /home/mchehab/new_build/v4l/cx231xx-417.c:1796:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-vbi.c: In function 'cx231xx_isoc_vbi_copy':
> /home/mchehab/new_build/v4l/cx231xx-vbi.c:86:25: warning: variable 'buf' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx231xx-vbi.c: In function 'cx231xx_irq_vbi_callback':
> /home/mchehab/new_build/v4l/cx231xx-vbi.c:313:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx23888-ir.c: In function 'pulse_clocks_to_clock_divider':
> /home/mchehab/new_build/v4l/cx23888-ir.c:334:6: warning: variable 'rem' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx25840-ir.c: In function 'pulse_clocks_to_clock_divider':
> /home/mchehab/new_build/v4l/cx25840-ir.c:318:6: warning: variable 'rem' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cx25840-ir.c: In function 'cx25840_ir_tx_write':
> /home/mchehab/new_build/v4l/cx25840-ir.c:858:21: warning: variable 'c' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/dvb_frontend.c: In function 'dvb_frontend_thread':
> /home/mchehab/new_build/v4l/dvb_frontend.c:538:16: warning: variable 'timeout' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/af9005-fe.c: In function 'af9005_write_word_agc':
> /home/mchehab/new_build/v4l/af9005-fe.c:66:5: warning: variable 'temp' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/az6027.c: In function 'az6027_set_voltage':
> /home/mchehab/new_build/v4l/az6027.c:785:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/az6027.c: In function 'az6027_i2c_xfer':
> /home/mchehab/new_build/v4l/az6027.c:957:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/dib0700_core.c: In function 'dib0700_rc_urb_completion':
> /home/mchehab/new_build/v4l/dib0700_core.c:564:24: warning: variable 'st' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/dw2102.c: In function 'dw2102_i2c_transfer':
> /home/mchehab/new_build/v4l/dw2102.c:145:13: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/dw2102.c: In function 'dw2102_serit_i2c_transfer':
> /home/mchehab/new_build/v4l/dw2102.c:218:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/dw2102.c: In function 'dw2102_earda_i2c_transfer':
> /home/mchehab/new_build/v4l/dw2102.c:273:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/dw2102.c: In function 'dw2104_i2c_transfer':
> /home/mchehab/new_build/v4l/dw2102.c:346:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/dw2102.c: In function 'dw3101_i2c_transfer':
> /home/mchehab/new_build/v4l/dw2102.c:429:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/dw2102.c: In function 's6x0_i2c_transfer':
> /home/mchehab/new_build/v4l/dw2102.c:493:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/lmedm04.c: In function 'lme2510_probe':
> /home/mchehab/new_build/v4l/lmedm04.c:927:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/em28xx-audio.c: In function 'snd_em28xx_capture_open':
> /home/mchehab/new_build/v4l/em28xx-audio.c:289:7: warning: variable 'errCode' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/em28xx-audio.c: In function 'snd_em28xx_hw_capture_params':
> /home/mchehab/new_build/v4l/em28xx-audio.c:339:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/em28xx-audio.c:338:31: warning: variable 'format' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/em28xx-audio.c:338:25: warning: variable 'rate' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/em28xx-audio.c:338:15: warning: variable 'channels' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/em28xx-audio.c: In function 'snd_em28xx_capture_trigger':
> /home/mchehab/new_build/v4l/em28xx-audio.c:396:6: warning: variable 'retval' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/em28xx-i2c.c: In function 'em28xx_i2c_check_for_device':
> /home/mchehab/new_build/v4l/em28xx-i2c.c:221:7: warning: variable 'msg' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/em28xx-cards.c: In function 'em28xx_card_setup':
> /home/mchehab/new_build/v4l/em28xx-cards.c:2629:23: warning: variable 'sd' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/em28xx-core.c: In function 'em28xx_irq_callback':
> /home/mchehab/new_build/v4l/em28xx-core.c:919:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/et61x251_core.c: In function 'et61x251_urb_complete':
> /home/mchehab/new_build/v4l/et61x251_core.c:367:16: warning: variable 'len' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/et61x251_core.c: In function 'et61x251_stream_interrupt':
> /home/mchehab/new_build/v4l/et61x251_core.c:578:7: warning: variable 'timeout' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cpia1.c: In function 'monitor_exposure':
> /home/mchehab/new_build/v4l/cpia1.c:1259:27: warning: variable 'coarseL' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/cpia1.c:1259:21: warning: variable 'gain' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/jeilinj.c: In function 'jlj_dostream':
> /home/mchehab/new_build/v4l/jeilinj.c:186:6: warning: variable 'size_in_blocks' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/stv06xx.c: In function 'stv06xx_config':
> /home/mchehab/new_build/v4l/stv06xx.c:528:14: warning: variable 'cam' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/hdpvr-control.c: In function 'get_input_lines_info':
> /home/mchehab/new_build/v4l/hdpvr-control.c:98:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/hdpvr-video.c: In function 'hdpvr_try_ctrl':
> /home/mchehab/new_build/v4l/hdpvr-video.c:937:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/hopper_cards.c: In function 'hopper_irq_handler':
> /home/mchehab/new_build/v4l/hopper_cards.c:68:37: warning: variable 'mstat' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/ivtv-ioctl.c: In function 'ivtv_set_speed':
> /home/mchehab/new_build/v4l/ivtv-ioctl.c:138:22: warning: variable 's' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/mantis_cards.c: In function 'mantis_irq_handler':
> /home/mchehab/new_build/v4l/mantis_cards.c:76:37: warning: variable 'mstat' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/mantis_dma.c: In function 'mantis_dma_stop':
> /home/mchehab/new_build/v4l/mantis_dma.c:224:16: warning: variable 'mask' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/mantis_dma.c:224:6: warning: variable 'stat' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/mantis_evm.c: In function 'mantis_hifevm_work':
> /home/mchehab/new_build/v4l/mantis_evm.c:43:17: warning: variable 'gpif_mask' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/pvrusb2-v4l2.c: In function 'pvr2_v4l2_do_ioctl':
> /home/mchehab/new_build/v4l/pvrusb2-v4l2.c:798:23: warning: variable 'cap' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/radio-si470x-usb.c: In function 'si470x_int_in_callback':
> /home/mchehab/new_build/v4l/radio-si470x-usb.c:399:16: warning: variable 'buf' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/saa7134-video.c: In function 'saa7134_s_tuner':
> /home/mchehab/new_build/v4l/saa7134-video.c:2029:6: warning: variable 'rx' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/saa7146_video.c: In function 'video_close':
> /home/mchehab/new_build/v4l/saa7146_video.c:1350:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/saa7164-api.c: In function 'saa7164_api_i2c_read':
> /home/mchehab/new_build/v4l/saa7164-api.c:1370:6: warning: variable 'regval' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/sn9c102_core.c: In function 'sn9c102_stream_interrupt':
> /home/mchehab/new_build/v4l/sn9c102_core.c:998:7: warning: variable 'timeout' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/stb0899_drv.c: In function 'stb0899_init_calc':
> /home/mchehab/new_build/v4l/stb0899_drv.c:640:5: warning: variable 'agc1cn' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/stb0899_drv.c: In function 'stb0899_diseqc_init':
> /home/mchehab/new_build/v4l/stb0899_drv.c:830:13: warning: variable 'f22_rx' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/stb0899_drv.c:826:31: warning: variable 'tx_data' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/stv0900_sw.c: In function 'stv0900_track_optimization':
> /home/mchehab/new_build/v4l/stv0900_sw.c:838:26: warning: variable 'rolloff' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/usbvision-core.c: In function 'usbvision_decompress':
> /home/mchehab/new_build/v4l/usbvision-core.c:696:23: warning: variable 'max_pos' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/usbvision-core.c: In function 'usbvision_parse_compress':
> /home/mchehab/new_build/v4l/usbvision-core.c:797:39: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/usbvision-core.c:797:22: warning: variable 'bytes_per_pixel' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/zoran_device.c: In function 'write_overlay_mask':
> /home/mchehab/new_build/v4l/zoran_device.c:545:6: warning: variable 'reg' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/mt20xx.c: In function 'mt2050_set_antenna':
> /home/mchehab/new_build/v4l/mt20xx.c:433:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/mt20xx.c: In function 'mt2050_init':
> /home/mchehab/new_build/v4l/mt20xx.c:577:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/mxl5005s.c: In function 'MXL_TuneRF':
> /home/mchehab/new_build/v4l/mxl5005s.c:2327:6: warning: variable 'Xtal_Int' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/imon.c:29:0: warning: "pr_fmt" redefined [enabled by default]
> include/linux/printk.h:145:0: note: this is the location of the previous definition
> /home/mchehab/new_build/v4l/imon.c: In function 'imon_incoming_packet':
> /home/mchehab/new_build/v4l/imon.c:1468:7: warning: variable 'norelease' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/imon.c: In function 'imon_probe':
> /home/mchehab/new_build/v4l/imon.c:2248:13: warning: variable 'code_length' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/nuvoton-cir.c: In function 'nvt_process_rx_ir_data':
> /home/mchehab/new_build/v4l/nuvoton-cir.c:594:6: warning: variable 'carrier' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/tvaudio.c: In function 'tvaudio_s_ctrl':
> /home/mchehab/new_build/v4l/tvaudio.c:1697:15: warning: variable 'balance' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/tvaudio.c:1697:7: warning: variable 'volume' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/adv7343.c: In function 'adv7343_setstd':
> /home/mchehab/new_build/v4l/adv7343.c:133:6: warning: variable 'output_idx' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/vpx3220.c: In function 'vpx3220_status':
> /home/mchehab/new_build/v4l/vpx3220.c:299:6: warning: variable 'res' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/bt819.c: In function 'bt819_status':
> /home/mchehab/new_build/v4l/bt819.c:219:6: warning: variable 'res' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/tvp7002.c: In function 'tvp7002_query_dv_preset':
> /home/mchehab/new_build/v4l/tvp7002.c:679:18: warning: variable 'device' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/mt9v011.c: In function 'set_balance':
> /home/mchehab/new_build/v4l/mt9v011.c:186:19: warning: variable 'green2_gain' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/ov2640.c: In function 'ov2640_try_fmt':
> /home/mchehab/new_build/v4l/ov2640.c:969:32: warning: variable 'win' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/c-qcam.c: In function 'qc_capture':
> /home/mchehab/new_build/v4l/c-qcam.c:382:33: warning: variable 'bitsperxfer' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/pms.c: In function 'pms_s_std':
> /home/mchehab/new_build/v4l/pms.c:740:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/pms.c: In function 'init_mediavision':
> /home/mchehab/new_build/v4l/pms.c:961:6: warning: variable 'id' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/videobuf-dvb.c: In function 'videobuf_dvb_thread':
> /home/mchehab/new_build/v4l/videobuf-dvb.c:48:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/zr364xx.c: In function 'zr364xx_fillbuff':
> /home/mchehab/new_build/v4l/zr364xx.c:512:25: warning: variable 'frm' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/s2255drv.c: In function 's2255_fillbuff':
> /home/mchehab/new_build/v4l/s2255drv.c:635:23: warning: variable 'frm' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/s2255drv.c: In function 'vidioc_s_fmt_vid_cap':
> /home/mchehab/new_build/v4l/s2255drv.c:988:6: warning: variable 'norm' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/ivtvfb.c: In function 'ivtvfb_init':
> /home/mchehab/new_build/v4l/ivtvfb.c:1279:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/ivtvfb.c: In function 'ivtvfb_cleanup':
> /home/mchehab/new_build/v4l/ivtvfb.c:1300:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
> In file included from /usr/src/kernels/2.6.38-0.rc7.git2.3.fc16.i686/arch/x86/include/asm/uaccess.h:571:0,
>                  from /usr/src/kernels/2.6.38-0.rc7.git2.3.fc16.i686/arch/x86/include/asm/sections.h:5,
>                  from /usr/src/kernels/2.6.38-0.rc7.git2.3.fc16.i686/arch/x86/include/asm/hw_irq.h:26,
>                  from include/linux/irq.h:211,
>                  from /usr/src/kernels/2.6.38-0.rc7.git2.3.fc16.i686/arch/x86/include/asm/hardirq.h:5,
>                  from include/linux/hardirq.h:7,
>                  from include/linux/interrupt.h:12,
>                  from /home/mchehab/new_build/v4l/si4713-i2c.c:27:
> In function 'copy_from_user',
>     inlined from 'si4713_write_econtrol_string' at /home/mchehab/new_build/v4l/si4713-i2c.c:1040:24:
> /usr/src/kernels/2.6.38-0.rc7.git2.3.fc16.i686/arch/x86/include/asm/uaccess_32.h:212:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]
> In function 'copy_from_user',
>     inlined from 'si4713_write_econtrol_string' at /home/mchehab/new_build/v4l/si4713-i2c.c:1064:24:
> /usr/src/kernels/2.6.38-0.rc7.git2.3.fc16.i686/arch/x86/include/asm/uaccess_32.h:212:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]
> /home/mchehab/new_build/v4l/radio-si4713.c: In function 'radio_si4713_querycap':
> /home/mchehab/new_build/v4l/radio-si4713.c:95:30: warning: variable 'rsdev' set but not used [-Wunused-but-set-variable]
> /home/mchehab/new_build/v4l/radio-wl1273.c: In function 'wl1273_fm_rds':
> /home/mchehab/new_build/v4l/radio-wl1273.c:169:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c: In function 'wl1273_fm_irq_thread_handler':
> /home/mchehab/new_build/v4l/radio-wl1273.c:237:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:261:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:311:12: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:330:12: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c: In function 'wl1273_fm_get_freq':
> /home/mchehab/new_build/v4l/radio-wl1273.c:471:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:481:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c: In function 'wl1273_fm_get_tx_ctune':
> /home/mchehab/new_build/v4l/radio-wl1273.c:878:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c: In function 'wl1273_fm_fops_write':
> /home/mchehab/new_build/v4l/radio-wl1273.c:1072:6: error: 'struct wl1273_core' has no member named 'write_data'
> /home/mchehab/new_build/v4l/radio-wl1273.c: In function 'wl1273_fm_fops_read':
> /home/mchehab/new_build/v4l/radio-wl1273.c:1204:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c: In function 'wl1273_fm_vidioc_g_tuner':
> /home/mchehab/new_build/v4l/radio-wl1273.c:1533:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1542:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1551:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c: In function 'wl1273_fm_vidioc_g_modulator':
> /home/mchehab/new_build/v4l/radio-wl1273.c:1782:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c: In function 'wl1273_fm_vidioc_log_status':
> /home/mchehab/new_build/v4l/radio-wl1273.c:1819:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1825:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1831:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1837:10: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1844:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1850:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1858:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1864:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1875:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1886:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1896:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1902:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1908:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1914:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1926:11: error: 'struct wl1273_core' has no member named 'read'
> /home/mchehab/new_build/v4l/radio-wl1273.c:1933:11: error: 'struct wl1273_core' has no member named 'read'
> make[3]: ** [/home/mchehab/new_build/v4l/radio-wl1273.o] Erro 1
> make[2]: *** [_module_/home/mchehab/new_build/v4l] Error 2
> make[1]: ** [default] Erro 2
> make: ** [all] Erro 2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
