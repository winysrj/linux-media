Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:58421 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZLZMqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Dec 2009 07:46:09 -0500
Date: Sat, 26 Dec 2009 14:45:35 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: passing stack variables to usb_control_msg()
Message-ID: <20091226124535.GD6075@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I saw a patch earlier from Johan Hovold which said you shouldn't pass
stack variables to usb_control_msg() so I used smatch to do an audit.
Here are the results for 2.6.33-rc1 + Johan's patch.

regards,
dan carpenter

drivers/media/dvb/dvb-usb/a800.c +82 a800_rc_query(3) error: doing dma on the stack (key)
drivers/media/dvb/dvb-usb/au6610.c +51 au6610_usb_msg(20) error: doing dma on the stack (usb_buf)
drivers/media/dvb/dvb-usb/ce6230.c +76 ce6230_rw_udev(42) error: doing dma on the stack (buf)
drivers/media/dvb/dvb-usb/dib0700_core.c +35 dib0700_get_version(4) error: doing dma on the stack (b)
drivers/media/dvb/dvb-usb/dib0700_core.c +35 dib0700_get_version(4) error: doing dma on the stack (b)
drivers/media/dvb/dvb-usb/dib0700_core.c +212 dib0700_i2c_xfer_new(76) error: doing dma on the stack (buf)
drivers/media/dvb/dvb-usb/dib0700_core.c +302 dib0700_identify_state(4) error: doing dma on the stack (b)
drivers/media/dvb/dvb-usb/dib0700_core.c +302 dib0700_identify_state(4) error: doing dma on the stack (b)
drivers/media/dvb/dvb-usb/dib0700_core.c +407 dib0700_download_firmware(46) error: doing dma on the stack (b)
drivers/media/dvb/dvb-usb/dw2102.c +111 dw210x_op_rw(12) error: doing dma on the stack (u8buf)
drivers/media/dvb/dvb-usb/ec168.c +86 ec168_rw_udev(52) error: doing dma on the stack (buf)
drivers/media/dvb/dvb-usb/friio.c +248 friio_initialize(31) error: doing dma on the stack (wbuf)
drivers/media/dvb/dvb-usb/friio.c +266 friio_initialize(49) error: doing dma on the stack (wbuf)
drivers/media/dvb/dvb-usb/opera1.c +66 opera1_xilinx_rw(14) error: doing dma on the stack (u8buf)
drivers/media/dvb/dvb-usb/vp7045.c +50 vp7045_usb_op(22) error: doing dma on the stack (outbuf)
drivers/media/dvb/dvb-usb/vp7045.c +61 vp7045_usb_op(33) error: doing dma on the stack (inbuf)
drivers/media/video/se401.c +157 se401_get_feature(7) error: doing dma on the stack (cp)
drivers/media/video/usbvideo/ibmcam.c +1173 ibmcam_veio(14) error: doing dma on the stack (cp)
drivers/media/video/usbvideo/ultracam.c +148 ultracam_veio(15) error: doing dma on the stack (cp)
drivers/media/video/usbvision/usbvision-core.c +1542 usbvision_read_reg(8) error: doing dma on the stack (buffer)
drivers/media/video/usbvision/usbvision-core.c +1783 usbvision_set_video_format(20) error: doing dma on the stack (value)
drivers/media/video/usbvision/usbvision-core.c +1848 usbvision_set_output(46) error: doing dma on the stack (value)
drivers/media/video/usbvision/usbvision-core.c +2021 usbvision_set_compress_params(22) error: doing dma on the stack (value)
drivers/media/video/usbvision/usbvision-core.c +2053 usbvision_set_compress_params(54) error: doing dma on the stack (value)
drivers/media/video/usbvision/usbvision-core.c +2157 usbvision_set_input(80) error: doing dma on the stack (value)
drivers/media/video/usbvision/usbvision-core.c +2234 usbvision_set_dram_settings(44) error: doing dma on the stack (value)
drivers/media/video/usbvision/usbvision-i2c.c +372 usbvision_i2c_write_max4(17) error: doing dma on the stack (value)
drivers/net/usb/hso.c +2863 hso_get_config_data(7) error: doing dma on the stack (config_data)
drivers/staging/comedi/drivers/usbdux.c +738 usbduxsub_start(7) error: doing dma on the stack (local_transfer_buffer)
drivers/staging/comedi/drivers/usbdux.c +771 usbduxsub_stop(8) error: doing dma on the stack (local_transfer_buffer)
drivers/staging/comedi/drivers/usbduxfast.c +455 usbduxfastsub_start(7) error: doing dma on the stack (local_transfer_buffer)
drivers/staging/comedi/drivers/usbduxfast.c +477 usbduxfastsub_stop(7) error: doing dma on the stack (local_transfer_buffer)
drivers/staging/udlfb/udlfb.c +61 dlfb_edid(8) error: doing dma on the stack (rbuf)
drivers/staging/udlfb/udlfb.c +768 dlfb_probe(39) error: doing dma on the stack (rbuf)
drivers/usb/host/hwa-hc.c +308 __hwahc_op_bwa_set(22) error: doing dma on the stack (mas_le)
drivers/usb/serial/cypress_m8.c +395 cypress_serial_control(55) error: doing dma on the stack (feature_buffer)
drivers/usb/serial/cypress_m8.c +435 cypress_serial_control(95) error: doing dma on the stack (feature_buffer)
drivers/usb/serial/kl5kusb105.c +219 klsi_105_get_line_state(8) error: doing dma on the stack (status_buf)
drivers/watchdog/pcwd_usb.c +250 usb_pcwd_send_command(23) error: doing dma on the stack (buf)

