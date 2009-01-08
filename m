Return-path: <video4linux-list-bounces@redhat.com>
Date: Thu, 8 Jan 2009 09:38:49 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Nam =?UTF-8?B?UGjhuqFtIFRow6BuaA==?="  <phamthanhnam.ptn@gmail.com>
Message-ID: <20090108093849.0e885ec5@pedra.chehab.org>
In-Reply-To: <2ac79fa40901072131m10be588axb3de61ef81bb943f@mail.gmail.com>
References: <2ac79fa40901072131m10be588axb3de61ef81bb943f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list <video4linux-list@redhat.com>, Linux Media Mailing
	List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pwc: add support for webcam snapshot button
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>


On Thu, 8 Jan 2009 12:31:48 +0700
"Nam Phạm Thành"  <phamthanhnam.ptn@gmail.com> wrote:

> OK, resent. Hope it's OK now.

Unfortunately, it is not 100% ok. See the comments bellow.

You shouldn't add any comment before the patch (like the above). Otherwise, it
will be committed by the scripts also, or I need to double check your comments
and remove it manually (I always review the message, so this is not a big
issue, but it is better if you learn the proper way for sending patches).

> This patch adds support for Philips webcam snapshot button as an
> event input device, for consistency with other webcam drivers.
> Signed-off-by: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
> 
> diff -uNr a/linux/drivers/media/video/pwc/pwc.h b/linux/drivers/media/video/pwc/pwc.h
> --- a/linux/drivers/media/video/pwc/pwc.h	2009-01-03 20:03:43.000000000 +0700
> +++ b/linux/drivers/media/video/pwc/pwc.h	2009-01-07 02:10:58.000000000 +0700
> @@ -38,6 +38,7 @@
>  #include <linux/videodev.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ioctl.h>
> +#include <linux/input.h>

If you added input code here, you need also to change the Kconfig file, since
the driver will now depend on having input support. This is done by adding
"depends on INPUT" at the Kconfig entry for pwc. Something like this:

config USB_PWC
        tristate "USB Philips Cameras"
        depends on VIDEO_V4L1
+	depends on INPUT
        default n
        depends on VIDEO_KERNEL_VERSION

>  
>  #include "pwc-uncompress.h"
>  #include <media/pwc-ioctl.h>
> @@ -256,6 +257,7 @@
>     int pan_angle;			/* in degrees * 100 */
>     int tilt_angle;			/* absolute angle; 0,0 is home position */
>     int snapshot_button_status;		/* set to 1 when the user push the button, reset to 0 when this value is read */
> +   struct input_dev *button_dev;	/* webcam snapshot button input */
>  
>     /*** Misc. data ***/
>     wait_queue_head_t frameq;		/* When waiting for a frame to finish... */
> diff -uNr a/linux/drivers/media/video/pwc/pwc-if.c b/linux/drivers/media/video/pwc/pwc-if.c
> --- a/linux/drivers/media/video/pwc/pwc-if.c	2009-01-03 20:03:43.000000000 +0700
> +++ b/linux/drivers/media/video/pwc/pwc-if.c	2009-01-08 10:38:45.000000000 +0700
> @@ -53,6 +53,7 @@
>     - Xavier Roche: QuickCam Pro 4000 ID
>     - Jens Knudsen: QuickCam Zoom ID
>     - J. Debert: QuickCam for Notebooks ID
> +   - Pham Thanh Nam: webcam snapshot button as an event input device
>  */
>  
>  #include <linux/errno.h>
> @@ -61,6 +62,11 @@
>  #include <linux/module.h>
>  #include <linux/poll.h>
>  #include <linux/slab.h>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 18)
> +#include <linux/usb_input.h>
> +#else
> +#include <linux/usb/input.h>
> +#endif
>  #include <linux/vmalloc.h>
>  #include <linux/version.h>
>  #include <asm/io.h>
> @@ -587,6 +593,22 @@
>  				pdev->vframe_count);
>  }
>  
> +static void pwc_snapshot_button(struct pwc_device *pdev, int down)
> +{
> +	if (down) {
> +		PWC_TRACE("Snapshot button pressed.\n");
> +		pdev->snapshot_button_status = 1;
> +	}
> +	else {

Coding Style error. Always use:
	} else {

If you have checked your patch with checkpatch.pl, you would have gotten this
error. If you haven't committed the patch on your tree, you can check such
errors with:
	make checkpatch

> +		PWC_TRACE("Snapshot button released.\n");
> +	}
> +
> +	if (pdev->button_dev) {
> +		input_report_key(pdev->button_dev, BTN_0, down);
> +		input_sync(pdev->button_dev);
> +	}
> +}
> +
>  static int pwc_rcv_short_packet(struct pwc_device *pdev, const struct pwc_frame_buf *fbuf)
>  {
>  	int awake = 0;
> @@ -604,13 +626,7 @@
>  			pdev->vframes_error++;
>  		}
>  		if ((ptr[0] ^ pdev->vmirror) & 0x01) {
> -			if (ptr[0] & 0x01) {
> -				pdev->snapshot_button_status = 1;
> -				PWC_TRACE("Snapshot button pressed.\n");
> -			}
> -			else {
> -				PWC_TRACE("Snapshot button released.\n");
> -			}
> +			pwc_snapshot_button(pdev, ptr[0] & 0x01);
>  		}
>  		if ((ptr[0] ^ pdev->vmirror) & 0x02) {
>  			if (ptr[0] & 0x02)
> @@ -634,12 +650,7 @@
>  	else if (pdev->type == 740 || pdev->type == 720) {
>  		unsigned char *ptr = (unsigned char *)fbuf->data;
>  		if ((ptr[0] ^ pdev->vmirror) & 0x01) {
> -			if (ptr[0] & 0x01) {
> -				pdev->snapshot_button_status = 1;
> -				PWC_TRACE("Snapshot button pressed.\n");
> -			}
> -			else
> -				PWC_TRACE("Snapshot button released.\n");
> +			pwc_snapshot_button(pdev, ptr[0] & 0x01);
>  		}
>  		pdev->vmirror = ptr[0] & 0x03;
>  	}
> @@ -1221,6 +1232,11 @@
>  {
>  	pwc_remove_sysfs_files(pdev->vdev);
>  	video_unregister_device(pdev->vdev);
> +	if (pdev->button_dev) {
> +		input_unregister_device(pdev->button_dev);
> +		input_free_device(pdev->button_dev);
> +		pdev->button_dev = NULL;
> +	}
>  }
>  
>  /* Note that all cleanup is done in the reverse order as in _open */
> @@ -1488,6 +1504,7 @@
>  	int features = 0;
>  	int video_nr = -1; /* default: use next available device */
>  	char serial_number[30], *name;
> +	char *phys = NULL;
>  
>  	vendor_id = le16_to_cpu(udev->descriptor.idVendor);
>  	product_id = le16_to_cpu(udev->descriptor.idProduct);
> @@ -1812,6 +1829,39 @@
>  	pwc_set_leds(pdev, 0, 0);
>  	pwc_camera_power(pdev, 0);
>  
> +	/* register webcam snapshot button input device */
> +	pdev->button_dev = input_allocate_device();
> +	if (!pdev->button_dev) {
> +		PWC_ERROR("Err, insufficient memory for webcam snapshot button device.");
> +		return -ENOMEM;
> +	}
> +
> +	pdev->button_dev->name = "PWC snapshot button";
> +	phys = kmalloc(6 + strlen(pdev->udev->bus->bus_name) + strlen(pdev->udev->devpath),
> +			GFP_KERNEL);

Don't use magic numbers ("6") here... Instead, see the next comment

> +	if (phys == NULL) {
> +		input_free_device(pdev->button_dev);
> +		return -ENOMEM;
> +	}
> +
> +	sprintf(phys, "usb-%s-%s", pdev->udev->bus->bus_name, pdev->udev->devpath);

Instead of allocating with kmalloc and then use sprintf, use this construction:

	phys = kasprintf(GFP_KERNEL,"usb-%s-%s", pdev->udev->bus->bus_name,
						 pdev->udev->devpath);
	if (!phys) {
		input_free_device(pdev->button_dev);
		return -ENOMEM;
	}

> +	pdev->button_dev->phys = phys;
> +	usb_to_input_id(pdev->udev, &pdev->button_dev->id);
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
> +	pdev->button_dev->dev.parent = &pdev->udev->dev;
> +#else
> +	pdev->button_dev->cdev.dev = &pdev->udev->dev;
> +#endif
> +	pdev->button_dev->evbit[0] = BIT_MASK(EV_KEY);
> +	pdev->button_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
> +
> +	rc = input_register_device(pdev->button_dev);
> +	if (rc) {
> +		input_free_device(pdev->button_dev);

You forgot to free the input name with something like this:
		kfree(pdev->button_dev->phys);

> +		pdev->button_dev = NULL;
> +		return rc;
> +	}
> +
>  	return 0;
>  
>  err_unreg:

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
