Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01CRZCE024444
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 07:27:35 -0500
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01CRIY8022696
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 07:27:18 -0500
Message-ID: <495CB6D1.8040808@hhs.nl>
Date: Thu, 01 Jan 2009 13:28:01 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
References: <200901010033.58093.linux@baker-net.org.uk>
In-Reply-To: <200901010033.58093.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list <video4linux-list@redhat.com>,
	sqcam-devel@lists.sourceforge.net, kilgota@banach.math.auburn.edu
Subject: Re: [REVIEW] Driver for SQ-905 based cameras
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Adam Baker wrote:
> Theodore Kilgore and I now have a driver for cameras based on the 
> SQ 905 chipset that is capable of producing images. It is based on gspca
> and uses libv4l. Issues so far are
> 
> 1) With the cameras used so far for testing the image is always upside down.
> It is known that there are cameras that have different sensor layouts but without
> a mechanism to communicate that layout to libv4l we can't do much more.
> (Yes I have read Hans de Geode's posts about this but wanted to have a real 
> driver to use as a basis before discussing further).
> 

So now that we have a real driver, any feedback on my proposal?

> 2) The code is all using the gspca PDEBUG macros not dev_err / dev_warn 
> etc. As the rest of gspca seems to do the same I thought consistency was the 
> best option but will change this on request.
> 
> 3) There seem to be a limited selection of apps that work well with it even using 
> the LD_PRELOAD tricks in libv4l but those that don't seem to misbehave similarly 
> with a pac207 camera so I'm assumming the problem isn't with the sq905 
> sub-driver (e.g. xawtv is always giving a green image).
> 

Some apps indeed are buggy, libv4l implements the v4lX API as documented. To 
stay with your example here is a fix for xawtv, which makes it work with libv4l:
http://cvs.fedoraproject.org/viewvc/devel/xawtv/xawtv-3.95-fixes.patch?revision=1.1

> 4) Only a single resolution is supported. All sq905 cameras should support a
>  lower resolution and some also support a higher resolution but I see support for
>  that as something to worry about once the basic driver is accepted.
> 

Ack.

<snip>

> +/* These cameras only support 320x200. Actually not true but good for a start*/
> +static struct v4l2_pix_format sq905_mode[1] = {
> +	{ 320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
> +		.bytesperline = 320,
> +		.sizeimage = 320 * 240,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +		.priv = 0}
> +};
> +

The comment says 320x200, the code 320x240.

> +static int sq905_command(struct usb_device *dev, __u16 index)
> +{
> +	__u8 status;
> +	int ret;
> +	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> +			      USB_REQ_SYNCH_FRAME,                /* request */
> +			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			      SQ905_COMMAND, index, "\x0", 1, 500);

"\x0" will point to const memory, this is not allowed as a buffer passed to 
usb_control_msg, instead you should use a r/w buffer suitable for DMA. We've 
got gspca_dev->usb_buf for this.

> +	if (ret != 1) {
> +		PDEBUG(D_ERR, "sq905_command: usb_control_msg failed (%d)",
> +			ret);
> +		return -EIO;
> +	}
> +
> +	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> +			      USB_REQ_SYNCH_FRAME,                /* request */
> +			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			      SQ905_PING, 0, &status, 1, 500);

status is on the stack, this is not necessarily dma-able, use 
gspca_dev->usb_buf instead. Shouldn't the resulting status be checked?

> +	if (ret != 1) {
> +		PDEBUG(D_ERR, "sq905_command: usb_control_msg failed 2 (%d)",
> +			ret);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sq905_ack_frame(struct usb_device *dev)
> +{
> +	int ret;
> +	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> +			      USB_REQ_SYNCH_FRAME,                /* request */
> +			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			      SQ905_READ_DONE, 0, "\x0", 1, 500);

"\x0" will point to const memory, this is not allowed as a buffer passed to 
usb_control_msg, instead you should use a r/w buffer suitable for DMA. We've 
got gspca_dev->usb_buf for this.

As the above function is called from a workqueue you will need to take the 
gspca_dev->usb_lock while doing the usb_control_msg (and while using 
gspca_dev->usb_buf) as this might race with for example v4l2 controls code also 
using the controlpipe.

> +	if (ret != 1) {
> +		PDEBUG(D_ERR, "sq905_ack_frame: usb_ctrl_msg failed (%d)", ret);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +sq905_read_data(struct gspca_dev *gspca_dev, __u8 *data, int size)
> +{
> +	int ret;
> +	int act_len;
> +
> +	if (!data) {
> +		PDEBUG(D_ERR, "sq905_read_data: data pointer was NULL\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = usb_control_msg(gspca_dev->dev,
> +			      usb_sndctrlpipe(gspca_dev->dev, 0),
> +			      USB_REQ_SYNCH_FRAME,                /* request */
> +			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> +			      SQ905_BULK_READ, size, "\x0", 1, 500);

"\x0" will point to const memory, this is not allowed as a buffer passed to 
usb_control_msg, instead you should use a r/w buffer suitable for DMA. We've 
got gspca_dev->usb_buf for this.

As the above function is called from a workqueue you will need to take the 
gspca_dev->usb_lock while doing the usb_control_msg (and while using 
gspca_dev->usb_buf) as this might race with for example v4l2 controls code also 
using the controlpipe.

> +	if (ret != 1) {
> +		PDEBUG(D_ERR, "sq905_read_data: usb_ctrl_msg failed (%d)", ret);
> +		return -EIO;
> +	}
> +	ret = usb_bulk_msg(gspca_dev->dev,
> +			   usb_rcvbulkpipe(gspca_dev->dev, 0x81),
> +			   data, size, &act_len, 500);
> +	/* successful, it returns 0, otherwise  negative */
> +	if ((ret != 0) || (act_len != size)) {
> +		PDEBUG(D_ERR, "sq905_read_data: bulk read fail (%d) len %d/%d",
> +			ret, act_len, size);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +

<snip>

Thats all,

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
