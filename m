Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:44279 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbZAJAxM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jan 2009 19:53:12 -0500
Date: Fri, 9 Jan 2009 18:53:04 -0600 (CST)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Alexey Klimov <klimov.linux@gmail.com>
cc: Dean Anderson <dean@sensoray.com>,
	Thierry MERLE <thierry.merle@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: Fw: [PATCH] v4l/dvb: remove err macro from few usb devices
In-Reply-To: <20090108101342.58f7ce5e@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0901091851150.3993@cnc.isely.net>
References: <20090108101342.58f7ce5e@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 8 Jan 2009, Mauro Carvalho Chehab wrote:

> Alexey,
> 
> You should get the driver maintainer's ack or at least let them know that
> you're touching on their drivers.
> 
> Mike, Thierry an Dean,
> 
> Could you please review this patch?
> 
> Cheers,
> Mauro.

Alexey:

Once I understood why this was happening, I have no issue with it.  The 
pvrusb2 portion is fine.

Acked-By: Mike Isely <isely@pobox.com>

  -Mike


> 
> Forwarded message:
> 
> Date: Thu, 01 Jan 2009 11:06:08 +0300
> From: Alexey Klimov <klimov.linux@gmail.com>
> To: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: video4linux-list@redhat.com, Greg KH <greg@kroah.com>
> Subject: [PATCH] v4l/dvb: remove err macro from few usb devices
> 
> 
> Hello all
> I re-send this patch. Previous time i sent i get no response.
> Please nack, apply or criticize :)
> 
> --
> 
> Patch removes err() macros from few usb devices.
> It places pr_err in pvrusb2-v4l2.c, dev_err in dabusb and in usbvision
> drivers. Beside placing dev_err, patch defines new s2255_dev_err macro
> with S2255_DRIVER_NAME in s2255 module.
> 
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
> 
> ---
> diff -r 6a189bc8f115 linux/drivers/media/video/dabusb.c
> --- a/linux/drivers/media/video/dabusb.c	Wed Dec 31 15:26:57 2008 -0200
> +++ b/linux/drivers/media/video/dabusb.c	Thu Jan 01 10:59:06 2009 +0300
> @@ -199,17 +199,20 @@
>  					dst += len;
>  				}
>  				else
> -					err("dabusb_iso_complete: invalid len %d", len);
> +					dev_err(&purb->dev->dev,
> +						"dabusb_iso_complete: invalid len %d\n", len);
>  			}
>  			else
>  				dev_warn(&purb->dev->dev, "dabusb_iso_complete: corrupted packet status: %d\n", purb->iso_frame_desc[i].status);
>  		if (dst != purb->actual_length)
> -			err("dst!=purb->actual_length:%d!=%d", dst, purb->actual_length);
> +			dev_err(&purb->dev->dev,
> +				"dst!=purb->actual_length:%d!=%d\n",
> +					dst, purb->actual_length);
>  	}
>  
>  	if (atomic_dec_and_test (&s->pending_io) && !s->remove_pending && s->state != _stopped) {
>  		s->overruns++;
> -		err("overrun (%d)", s->overruns);
> +		dev_err(&purb->dev->dev, "overrun (%d)\n", s->overruns);
>  	}
>  	wake_up (&s->wait);
>  }
> @@ -230,13 +233,14 @@
>  	while (transfer_len < (s->total_buffer_size << 10)) {
>  		b = kzalloc(sizeof (buff_t), GFP_KERNEL);
>  		if (!b) {
> -			err("kzalloc(sizeof(buff_t))==NULL");
> +			dev_err(&s->usbdev->dev,
> +				"kzalloc(sizeof(buff_t))==NULL\n");
>  			goto err;
>  		}
>  		b->s = s;
>  		b->purb = usb_alloc_urb(packets, GFP_KERNEL);
>  		if (!b->purb) {
> -			err("usb_alloc_urb == NULL");
> +			dev_err(&s->usbdev->dev, "usb_alloc_urb == NULL\n");
>  			kfree (b);
>  			goto err;
>  		}
> @@ -245,7 +249,8 @@
>  		if (!b->purb->transfer_buffer) {
>  			kfree (b->purb);
>  			kfree (b);
> -			err("kmalloc(%d)==NULL", transfer_buffer_length);
> +			dev_err(&s->usbdev->dev,
> +				"kmalloc(%d)==NULL\n", transfer_buffer_length);
>  			goto err;
>  		}
>  
> @@ -289,10 +294,11 @@
>  
>  	ret=usb_bulk_msg(s->usbdev, pipe, pb->data, pb->size, &actual_length, 100);
>  	if(ret<0) {
> -		err("dabusb: usb_bulk_msg failed(%d)",ret);
> +		dev_err(&s->usbdev->dev,
> +			"usb_bulk_msg failed(%d)\n", ret);
>  
>  		if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
> -			err("set_interface failed");
> +			dev_err(&s->usbdev->dev, "set_interface failed\n");
>  			return -EINVAL;
>  		}
>  
> @@ -301,7 +307,7 @@
>  	if( ret == -EPIPE ) {
>  		dev_warn(&s->usbdev->dev, "CLEAR_FEATURE request to remove STALL condition.\n");
>  		if(usb_clear_halt(s->usbdev, usb_pipeendpoint(pipe)))
> -			err("request failed");
> +			dev_err(&s->usbdev->dev, "request failed\n");
>  	}
>  
>  	pb->size = actual_length;
> @@ -319,7 +325,8 @@
>  	unsigned char *transfer_buffer =  kmalloc (len, GFP_KERNEL);
>  
>  	if (!transfer_buffer) {
> -		err("dabusb_writemem: kmalloc(%d) failed.", len);
> +		dev_err(&s->usbdev->dev,
> +			"dabusb_writemem: kmalloc(%d) failed.\n", len);
>  		return -ENOMEM;
>  	}
>  
> @@ -352,7 +359,8 @@
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
>  	ret = request_ihex_firmware(&fw, "dabusb/firmware.fw", &s->usbdev->dev);
>  	if (ret) {
> -		err("Failed to load \"dabusb/firmware.fw\": %d\n", ret);
> +		dev_err(&s->usbdev->dev,
> +			"Failed to load \"dabusb/firmware.fw\": %d\n", ret);
>  		goto out;
>  	}
>  #endif
> @@ -378,11 +386,14 @@
>  #endif
>  		if (ret < 0) {
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
> -			err("dabusb_writemem failed (%d %04X %p %d)", ret, ptr->Address, ptr->Data, ptr->Length);
> +			dev_err(&s->usbdev->dev,
> +				"dabusb_writemem failed (%d %04X %p %d)\n",
> +				ret, ptr->Address, ptr->Data, ptr->Length);
>  #else
> -			err("dabusb_writemem failed (%d %04X %p %d)", ret,
> -			    be32_to_cpu(rec->addr), rec->data,
> -			    be16_to_cpu(rec->len));
> +			dev_err(&s->usbdev->dev,
> +				"dabusb_writemem failed (%d %04X %p %d)\n",
> +				ret, be32_to_cpu(rec->addr),
> +				rec->data, be16_to_cpu(rec->len));
>  #endif
>  			break;
>  		}
> @@ -443,14 +454,16 @@
>  	dbg("Enter dabusb_fpga_download (internal)");
>  
>  	if (!b) {
> -		err("kmalloc(sizeof(bulk_transfer_t))==NULL");
> +		dev_err(&s->usbdev->dev,
> +			"kmalloc(sizeof(bulk_transfer_t))==NULL\n");
>  		return -ENOMEM;
>  	}
>  
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
>  	ret = request_firmware(&fw, "dabusb/bitstream.bin", &s->usbdev->dev);
>  	if (ret) {
> -		err("Failed to load \"dabusb/bitstream.bin\": %d\n", ret);
> +		dev_err(&s->usbdev->dev,
> +			"Failed to load \"dabusb/bitstream.bin\": %d\n", ret);
>  		kfree(b);
>  		return ret;
>  	}
> @@ -482,7 +495,7 @@
>  #endif
>  		ret = dabusb_bulk (s, b);
>  		if (ret < 0) {
> -			err("dabusb_bulk failed.");
> +			dev_err(&s->usbdev->dev, "dabusb_bulk failed.\n");
>  			break;
>  		}
>  		mdelay (1);
> @@ -537,9 +550,11 @@
>  
>  			ret = usb_submit_urb (end->purb, GFP_KERNEL);
>  			if (ret) {
> -				err("usb_submit_urb returned:%d", ret);
> +				dev_err(&s->usbdev->dev,
> +					"usb_submit_urb returned:%d\n", ret);
>  				if (dabusb_add_buf_tail (s, &s->free_buff_list, &s->rec_buff_list))
> -					err("startrek: dabusb_add_buf_tail failed");
> +					dev_err(&s->usbdev->dev,
> +						"startrek: dabusb_add_buf_tail failed\n");
>  				break;
>  			}
>  			else
> @@ -582,7 +597,8 @@
>  
>  			spin_unlock_irqrestore(&s->lock, flags);
>  
> -			err("error: rec_buf_list is empty");
> +			dev_err(&s->usbdev->dev,
> +				"error: rec_buf_list is empty\n");
>  			goto err;
>  		}
>  
> @@ -611,7 +627,8 @@
>  
>  			if (list_empty (&s->rec_buff_list)) {
>  				spin_unlock_irqrestore(&s->lock, flags);
> -				err("error: still no buffer available.");
> +				dev_err(&s->usbdev->dev,
> +					"error: still no buffer available.\n");
>  				goto err;
>  			}
>  			spin_unlock_irqrestore(&s->lock, flags);
> @@ -632,7 +649,7 @@
>  		dbg("copy_to_user:%p %p %d",buf, purb->transfer_buffer + s->readptr, cnt);
>  
>  		if (copy_to_user (buf, purb->transfer_buffer + s->readptr, cnt)) {
> -			err("read: copy_to_user failed");
> +			dev_err(&s->usbdev->dev, "read: copy_to_user failed\n");
>  			if (!ret)
>  				ret = -EFAULT;
>  			goto err;
> @@ -646,7 +663,8 @@
>  		if (s->readptr == purb->actual_length) {
>  			// finished, take next buffer
>  			if (dabusb_add_buf_tail (s, &s->free_buff_list, &s->rec_buff_list))
> -				err("read: dabusb_add_buf_tail failed");
> +				dev_err(&s->usbdev->dev,
> +					"read: dabusb_add_buf_tail failed\n");
>  			s->readptr = 0;
>  		}
>  	}
> @@ -682,7 +700,7 @@
>  	}
>  	if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
>  		mutex_unlock(&s->mutex);
> -		err("set_interface failed");
> +		dev_err(&s->usbdev->dev, "set_interface failed\n");
>  		return -EINVAL;
>  	}
>  	s->opened = 1;
> @@ -707,7 +725,7 @@
>  
>  	if (!s->remove_pending) {
>  		if (usb_set_interface (s->usbdev, _DABUSB_IF, 0) < 0)
> -			err("set_interface failed");
> +			dev_err(&s->usbdev->dev, "set_interface failed\n");
>  	}
>  	else
>  		wake_up (&s->remove_ok);
> @@ -827,7 +845,7 @@
>  	s->devnum = intf->minor;
>  
>  	if (usb_reset_configuration (usbdev) < 0) {
> -		err("reset_configuration failed");
> +		dev_err(&intf->dev, "reset_configuration failed\n");
>  		goto reject;
>  	}
>  	if (le16_to_cpu(usbdev->descriptor.idProduct) == 0x2131) {
> @@ -838,7 +856,7 @@
>  		dabusb_fpga_download (s, NULL);
>  
>  		if (usb_set_interface (s->usbdev, _DABUSB_IF, 0) < 0) {
> -			err("set_interface failed");
> +			dev_err(&intf->dev, "set_interface failed\n");
>  			goto reject;
>  		}
>  	}
> diff -r 6a189bc8f115 linux/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
> --- a/linux/drivers/media/video/pvrusb2/pvrusb2-v4l2.c	Wed Dec 31 15:26:57 2008 -0200
> +++ b/linux/drivers/media/video/pvrusb2/pvrusb2-v4l2.c	Thu Jan 01 10:59:06 2009 +0300
> @@ -1275,8 +1275,9 @@
>  		dip->minor_type = pvr2_v4l_type_video;
>  		nr_ptr = video_nr;
>  		if (!dip->stream) {
> -			err("Failed to set up pvrusb2 v4l video dev"
> -			    " due to missing stream instance");
> +			pr_err(KBUILD_MODNAME
> +				": Failed to set up pvrusb2 v4l video dev"
> +				" due to missing stream instance\n");
>  			return;
>  		}
>  		break;
> @@ -1293,8 +1294,8 @@
>  		break;
>  	default:
>  		/* Bail out (this should be impossible) */
> -		err("Failed to set up pvrusb2 v4l dev"
> -		    " due to unrecognized config");
> +		pr_err(KBUILD_MODNAME ": Failed to set up pvrusb2 v4l dev"
> +		    " due to unrecognized config\n");
>  		return;
>  	}
>  
> @@ -1310,7 +1311,8 @@
>  				   dip->v4l_type, mindevnum) < 0) &&
>  	    (video_register_device(&dip->devbase,
>  				   dip->v4l_type, -1) < 0)) {
> -		err("Failed to register pvrusb2 v4l device");
> +		pr_err(KBUILD_MODNAME
> +			": Failed to register pvrusb2 v4l device\n");
>  	}
>  
>  	printk(KERN_INFO "pvrusb2: registered device %s%u [%s]\n",
> diff -r 6a189bc8f115 linux/drivers/media/video/s2255drv.c
> --- a/linux/drivers/media/video/s2255drv.c	Wed Dec 31 15:26:57 2008 -0200
> +++ b/linux/drivers/media/video/s2255drv.c	Thu Jan 01 10:59:06 2009 +0300
> @@ -337,13 +337,18 @@
>  			     u16 index, u16 value, void *buf,
>  			     s32 buf_len, int bOut);
>  
> +/* dev_err macro with driver name */
> +#define S2255_DRIVER_NAME "s2255"
> +#define s2255_dev_err(dev, fmt, arg...)					\
> +		dev_err(dev, S2255_DRIVER_NAME " - " fmt, ##arg)
> +
>  #define dprintk(level, fmt, arg...)					\
>  	do {								\
>  		if (*s2255_debug >= (level)) {				\
> -			printk(KERN_DEBUG "s2255: " fmt, ##arg);	\
> +			printk(KERN_DEBUG S2255_DRIVER_NAME		\
> +				": " fmt, ##arg);			\
>  		}							\
>  	} while (0)
> -
>  
>  static struct usb_driver s2255_driver;
>  
> @@ -529,14 +534,14 @@
>  	int len;
>  	dprintk(100, "udev %p urb %p", udev, urb);
>  	if (urb->status) {
> -		dev_err(&udev->dev, "URB failed with status %d", urb->status);
> +		dev_err(&udev->dev, "URB failed with status %d\n", urb->status);
>  		atomic_set(&data->fw_state, S2255_FW_FAILED);
>  		/* wake up anything waiting for the firmware */
>  		wake_up(&data->wait_fw);
>  		return;
>  	}
>  	if (data->fw_urb == NULL) {
> -		dev_err(&udev->dev, "s2255 disconnected\n");
> +		s2255_dev_err(&udev->dev, "disconnected\n");
>  		atomic_set(&data->fw_state, S2255_FW_FAILED);
>  		/* wake up anything waiting for the firmware */
>  		wake_up(&data->wait_fw);
> @@ -1279,7 +1284,7 @@
>  	}
>  
>  	if (!res_get(dev, fh)) {
> -		dev_err(&dev->udev->dev, "s2255: stream busy\n");
> +		s2255_dev_err(&dev->udev->dev, "stream busy\n");
>  		return -EBUSY;
>  	}
>  
> @@ -1546,7 +1551,8 @@
>  
>  	switch (atomic_read(&dev->fw_data->fw_state)) {
>  	case S2255_FW_FAILED:
> -		err("2255 firmware load failed. retrying.\n");
> +		s2255_dev_err(&dev->udev->dev,
> +			"firmware load failed. retrying.\n");
>  		s2255_fwload_start(dev, 1);
>  		wait_event_timeout(dev->fw_data->wait_fw,
>  				   ((atomic_read(&dev->fw_data->fw_state)
> @@ -2174,7 +2180,8 @@
>  
>  	printk(KERN_INFO "2255 usb firmware version %d \n", fw_ver);
>  	if (fw_ver < CUR_USB_FWVER)
> -		err("usb firmware not up to date %d\n", fw_ver);
> +		dev_err(&dev->udev->dev,
> +			"usb firmware not up to date %d\n", fw_ver);
>  
>  	for (j = 0; j < MAX_CHANNELS; j++) {
>  		dev->b_acquire[j] = 0;
> @@ -2229,13 +2236,13 @@
>  	dprintk(100, "read pipe completion %p, status %d\n", purb,
>  		purb->status);
>  	if (pipe_info == NULL) {
> -		err("no context !");
> +		dev_err(&purb->dev->dev, "no context!\n");
>  		return;
>  	}
>  
>  	dev = pipe_info->dev;
>  	if (dev == NULL) {
> -		err("no context !");
> +		dev_err(&purb->dev->dev, "no context!\n");
>  		return;
>  	}
>  	status = purb->status;
> @@ -2287,7 +2294,7 @@
>  		pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
>  		if (!pipe_info->stream_urb) {
>  			dev_err(&dev->udev->dev,
> -				"ReadStream: Unable to alloc URB");
> +				"ReadStream: Unable to alloc URB\n");
>  			return -ENOMEM;
>  		}
>  		/* transfer buffer allocated in board_init */
> @@ -2392,7 +2399,7 @@
>  	int j;
>  
>  	if (dev == NULL) {
> -		err("s2255: invalid device");
> +		s2255_dev_err(&dev->udev->dev, "invalid device\n");
>  		return;
>  	}
>  	dprintk(4, "stop read pipe\n");
> @@ -2454,7 +2461,7 @@
>  	/* allocate memory for our device state and initialize it to zero */
>  	dev = kzalloc(sizeof(struct s2255_dev), GFP_KERNEL);
>  	if (dev == NULL) {
> -		err("s2255: out of memory");
> +		s2255_dev_err(&interface->dev, "out of memory\n");
>  		goto error;
>  	}
>  
> @@ -2488,7 +2495,7 @@
>  	}
>  
>  	if (!dev->read_endpoint) {
> -		dev_err(&interface->dev, "Could not find bulk-in endpoint");
> +		dev_err(&interface->dev, "Could not find bulk-in endpoint\n");
>  		goto error;
>  	}
>  
> @@ -2584,7 +2591,7 @@
>  }
>  
>  static struct usb_driver s2255_driver = {
> -	.name = "s2255",
> +	.name = S2255_DRIVER_NAME,
>  	.probe = s2255_probe,
>  	.disconnect = s2255_disconnect,
>  	.id_table = s2255_table,
> @@ -2598,7 +2605,8 @@
>  	result = usb_register(&s2255_driver);
>  
>  	if (result)
> -		err("usb_register failed. Error number %d", result);
> +		pr_err(KBUILD_MODNAME
> +			": usb_register failed. Error number %d\n", result);
>  
>  	dprintk(2, "s2255_init: done\n");
>  	return result;
> diff -r 6a189bc8f115 linux/drivers/media/video/usbvision/usbvision-core.c
> --- a/linux/drivers/media/video/usbvision/usbvision-core.c	Wed Dec 31 15:26:57 2008 -0200
> +++ b/linux/drivers/media/video/usbvision/usbvision-core.c	Thu Jan 01 10:59:06 2009 +0300
> @@ -381,8 +381,9 @@
>  	usbvision->scratch = vmalloc_32(scratch_buf_size);
>  	scratch_reset(usbvision);
>  	if(usbvision->scratch == NULL) {
> -		err("%s: unable to allocate %d bytes for scratch",
> -		    __func__, scratch_buf_size);
> +		dev_err(&usbvision->dev->dev,
> +			"%s: unable to allocate %d bytes for scratch\n",
> +				__func__, scratch_buf_size);
>  		return -ENOMEM;
>  	}
>  	return 0;
> @@ -491,8 +492,9 @@
>  	int IFB_size = MAX_FRAME_WIDTH * MAX_FRAME_HEIGHT * 3 / 2;
>  	usbvision->IntraFrameBuffer = vmalloc_32(IFB_size);
>  	if (usbvision->IntraFrameBuffer == NULL) {
> -		err("%s: unable to allocate %d for compr. frame buffer",
> -		    __func__, IFB_size);
> +		dev_err(&usbvision->dev->dev,
> +			"%s: unable to allocate %d for compr. frame buffer\n",
> +				__func__, IFB_size);
>  		return -ENOMEM;
>  	}
>  	return 0;
> @@ -1519,8 +1521,9 @@
>  	errCode = usb_submit_urb (urb, GFP_ATOMIC);
>  
>  	if(errCode) {
> -		err("%s: usb_submit_urb failed: error %d",
> -		    __func__, errCode);
> +		dev_err(&usbvision->dev->dev,
> +			"%s: usb_submit_urb failed: error %d\n",
> +				__func__, errCode);
>  	}
>  
>  	return;
> @@ -1551,7 +1554,8 @@
>  				0, (__u16) reg, buffer, 1, HZ);
>  
>  	if (errCode < 0) {
> -		err("%s: failed: error %d", __func__, errCode);
> +		dev_err(&usbvision->dev->dev,
> +			"%s: failed: error %d\n", __func__, errCode);
>  		return errCode;
>  	}
>  	return buffer[0];
> @@ -1579,7 +1583,8 @@
>  				USB_RECIP_ENDPOINT, 0, (__u16) reg, &value, 1, HZ);
>  
>  	if (errCode < 0) {
> -		err("%s: failed: error %d", __func__, errCode);
> +		dev_err(&usbvision->dev->dev,
> +			"%s: failed: error %d\n", __func__, errCode);
>  	}
>  	return errCode;
>  }
> @@ -1859,7 +1864,8 @@
>  				 0, (__u16) USBVISION_LXSIZE_O, value, 4, HZ);
>  
>  		if (errCode < 0) {
> -			err("%s failed: error %d", __func__, errCode);
> +			dev_err(&usbvision->dev->dev,
> +				"%s failed: error %d\n", __func__, errCode);
>  			return errCode;
>  		}
>  		usbvision->curwidth = usbvision->stretch_width * UsbWidth;
> @@ -2245,7 +2251,7 @@
>  			     (__u16) USBVISION_DRM_PRM1, value, 8, HZ);
>  
>  	if (rc < 0) {
> -		err("%sERROR=%d", __func__, rc);
> +		dev_err(&usbvision->dev->dev, "%sERROR=%d\n", __func__, rc);
>  		return rc;
>  	}
>  
> @@ -2453,8 +2459,9 @@
>  		PDEBUG(DBG_FUNC,"setting alternate %d with wMaxPacketSize=%u", dev->ifaceAlt,dev->isocPacketSize);
>  		errCode = usb_set_interface(dev->dev, dev->iface, dev->ifaceAlt);
>  		if (errCode < 0) {
> -			err ("cannot change alternate number to %d (error=%i)",
> -							dev->ifaceAlt, errCode);
> +			dev_err(&dev->dev->dev,
> +				"cannot change alternate number to %d (error=%i)\n",
> +					dev->ifaceAlt, errCode);
>  			return errCode;
>  		}
>  	}
> @@ -2505,7 +2512,8 @@
>  
>  		urb = usb_alloc_urb(USBVISION_URB_FRAMES, GFP_KERNEL);
>  		if (urb == NULL) {
> -			err("%s: usb_alloc_urb() failed", __func__);
> +			dev_err(&usbvision->dev->dev,
> +				"%s: usb_alloc_urb() failed\n", __func__);
>  			return -ENOMEM;
>  		}
>  		usbvision->sbuf[bufIdx].urb = urb;
> @@ -2537,8 +2545,9 @@
>  			errCode = usb_submit_urb(usbvision->sbuf[bufIdx].urb,
>  						 GFP_KERNEL);
>  		if (errCode) {
> -			err("%s: usb_submit_urb(%d) failed: error %d",
> -			    __func__, bufIdx, errCode);
> +			dev_err(&usbvision->dev->dev,
> +				"%s: usb_submit_urb(%d) failed: error %d\n",
> +					__func__, bufIdx, errCode);
>  		}
>  	}
>  
> @@ -2587,8 +2596,9 @@
>  		errCode = usb_set_interface(usbvision->dev, usbvision->iface,
>  					    usbvision->ifaceAlt);
>  		if (errCode < 0) {
> -			err("%s: usb_set_interface() failed: error %d",
> -			    __func__, errCode);
> +			dev_err(&usbvision->dev->dev,
> +				"%s: usb_set_interface() failed: error %d\n",
> +					__func__, errCode);
>  			usbvision->last_error = errCode;
>  		}
>  		regValue = (16-usbvision_read_reg(usbvision, USBVISION_ALTER_REG)) & 0x0F;
> diff -r 6a189bc8f115 linux/drivers/media/video/usbvision/usbvision-i2c.c
> --- a/linux/drivers/media/video/usbvision/usbvision-i2c.c	Wed Dec 31 15:26:57 2008 -0200
> +++ b/linux/drivers/media/video/usbvision/usbvision-i2c.c	Thu Jan 01 10:59:06 2009 +0300
> @@ -120,7 +120,8 @@
>  		/* try extended address code... */
>  		ret = try_write_address(i2c_adap, addr, retries);
>  		if (ret != 1) {
> -			err("died at extended address code, while writing");
> +			dev_err(&i2c_adap->dev,
> +				"died at extended address code,	while writing\n");
>  			return -EREMOTEIO;
>  		}
>  		add[0] = addr;
> @@ -129,7 +130,8 @@
>  			addr |= 0x01;
>  			ret = try_read_address(i2c_adap, addr, retries);
>  			if (ret != 1) {
> -				err("died at extended address code, while reading");
> +				dev_err(&i2c_adap->dev,
> +					"died at extended address code, while reading\n");
>  				return -EREMOTEIO;
>  			}
>  		}
> diff -r 6a189bc8f115 linux/drivers/media/video/usbvision/usbvision-video.c
> --- a/linux/drivers/media/video/usbvision/usbvision-video.c	Wed Dec 31 15:26:57 2008 -0200
> +++ b/linux/drivers/media/video/usbvision/usbvision-video.c	Thu Jan 01 10:59:06 2009 +0300
> @@ -329,7 +329,7 @@
>  			return;
>  	} while (0);
>  
> -	err("%s error: %d\n", __func__, res);
> +	dev_err(&vdev->dev, "%s error: %d\n", __func__, res);
>  }
>  
>  static void usbvision_remove_sysfs(struct video_device *vdev)
> @@ -487,8 +487,9 @@
>  	/* NT100x has a 8-bit register space */
>  	errCode = usbvision_read_reg(usbvision, reg->reg&0xff);
>  	if (errCode < 0) {
> -		err("%s: VIDIOC_DBG_G_REGISTER failed: error %d",
> -		    __func__, errCode);
> +		dev_err(&usbvision->vdev->dev,
> +			"%s: VIDIOC_DBG_G_REGISTER failed: error %d\n",
> +				__func__, errCode);
>  		return errCode;
>  	}
>  	reg->val = errCode;
> @@ -507,8 +508,9 @@
>  	/* NT100x has a 8-bit register space */
>  	errCode = usbvision_write_reg(usbvision, reg->reg&0xff, reg->val);
>  	if (errCode < 0) {
> -		err("%s: VIDIOC_DBG_S_REGISTER failed: error %d",
> -		    __func__, errCode);
> +		dev_err(&usbvision->vdev->dev,
> +			"%s: VIDIOC_DBG_S_REGISTER failed: error %d\n",
> +				__func__, errCode);
>  		return errCode;
>  	}
>  	return 0;
> @@ -1189,7 +1191,9 @@
>  	mutex_lock(&usbvision->lock);
>  
>  	if (usbvision->user) {
> -		err("%s: Someone tried to open an already opened USBVision Radio!", __func__);
> +		dev_err(&usbvision->rdev->dev,
> +			"%s: Someone tried to open an already opened USBVision Radio!\n",
> +				__func__);
>  		errCode = -EBUSY;
>  	}
>  	else {
> @@ -1413,7 +1417,8 @@
>  	struct video_device *vdev;
>  
>  	if (usb_dev == NULL) {
> -		err("%s: usbvision->dev is not set", __func__);
> +		dev_err(&usbvision->dev->dev,
> +			"%s: usbvision->dev is not set\n", __func__);
>  		return NULL;
>  	}
>  
> @@ -1524,7 +1529,9 @@
>  	return 0;
>  
>   err_exit:
> -	err("USBVision[%d]: video_register_device() failed", usbvision->nr);
> +	dev_err(&usbvision->dev->dev,
> +		"USBVision[%d]: video_register_device() failed\n",
> +			usbvision->nr);
>  	usbvision_unregister_video(usbvision);
>  	return -1;
>  }
> @@ -1676,20 +1683,20 @@
>  	endpoint = &interface->endpoint[1].desc;
>  	if (usb_endpoint_type(endpoint) !=
>  	    USB_ENDPOINT_XFER_ISOC) {
> -		err("%s: interface %d. has non-ISO endpoint!",
> +		dev_err(&intf->dev, "%s: interface %d. has non-ISO endpoint!\n",
>  		    __func__, ifnum);
> -		err("%s: Endpoint attributes %d",
> +		dev_err(&intf->dev, "%s: Endpoint attributes %d",
>  		    __func__, endpoint->bmAttributes);
>  		return -ENODEV;
>  	}
>  	if (usb_endpoint_dir_out(endpoint)) {
> -		err("%s: interface %d. has ISO OUT endpoint!",
> +		dev_err(&intf->dev, "%s: interface %d. has ISO OUT endpoint!\n",
>  		    __func__, ifnum);
>  		return -ENODEV;
>  	}
>  
>  	if ((usbvision = usbvision_alloc(dev)) == NULL) {
> -		err("%s: couldn't allocate USBVision struct", __func__);
> +		dev_err(&intf->dev, "%s: couldn't allocate USBVision struct\n", __func__);
>  		return -ENOMEM;
>  	}
>  
> @@ -1712,7 +1719,7 @@
>  	usbvision->alt_max_pkt_size = kmalloc(32*
>  					      usbvision->num_alt,GFP_KERNEL);
>  	if (usbvision->alt_max_pkt_size == NULL) {
> -		err("usbvision: out of memory!\n");
> +		dev_err(&intf->dev, "usbvision: out of memory!\n");
>  		mutex_unlock(&usbvision->lock);
>  		return -ENOMEM;
>  	}
> @@ -1773,7 +1780,8 @@
>  	PDEBUG(DBG_PROBE, "");
>  
>  	if (usbvision == NULL) {
> -		err("%s: usb_get_intfdata() failed", __func__);
> +		dev_err(&usbvision->dev->dev,
> +			"%s: usb_get_intfdata() failed\n", __func__);
>  		return;
>  	}
>  	usb_set_intfdata (intf, NULL);
> 
> 
> 
> 

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
