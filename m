Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01LJjI0009000
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 16:19:45 -0500
Received: from mk-outboundfilter-6.mail.uk.tiscali.com
	(mk-outboundfilter-6.mail.uk.tiscali.com [212.74.114.14])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01LJU4A018070
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 16:19:30 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: sqcam-devel@lists.sourceforge.net
Date: Thu, 1 Jan 2009 21:19:27 +0000
References: <200901010033.58093.linux@baker-net.org.uk>
	<495CB6D1.8040808@hhs.nl>
In-Reply-To: <495CB6D1.8040808@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901012119.27626.linux@baker-net.org.uk>
Cc: video4linux-list <video4linux-list@redhat.com>,
	kilgota@banach.math.auburn.edu
Subject: Re: [sqcam-devel] [REVIEW] Driver for SQ-905 based cameras
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

On Thursday 01 January 2009, Hans de Goede wrote:
> Adam Baker wrote:
> > Theodore Kilgore and I now have a driver for cameras based on the
> > SQ 905 chipset that is capable of producing images. It is based on gspca
> > and uses libv4l. Issues so far are
> >
> > 1) With the cameras used so far for testing the image is always upside
> > down. It is known that there are cameras that have different sensor
> > layouts but without a mechanism to communicate that layout to libv4l we
> > can't do much more. (Yes I have read Hans de Geode's posts about this but
> > wanted to have a real driver to use as a basis before discussing
> > further).
>
> So now that we have a real driver, any feedback on my proposal?

I'll re-read it and comment more fully later but I'm currently wondering if 
the driver could provide the required shared memory making it available to 
libv4l via an mmap call to ensure the memory lifetime matches the driver 
lifetime.

<snip>
>
> > +/* These cameras only support 320x200. Actually not true but good for a
> > start*/ +static struct v4l2_pix_format sq905_mode[1] = {
> > +	{ 320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
> > +		.bytesperline = 320,
> > +		.sizeimage = 320 * 240,
> > +		.colorspace = V4L2_COLORSPACE_SRGB,
> > +		.priv = 0}
> > +};
> > +
>
> The comment says 320x200, the code 320x240.

I'll fix the comment

>
> > +static int sq905_command(struct usb_device *dev, __u16 index)
> > +{
> > +	__u8 status;
> > +	int ret;
> > +	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> > +			      USB_REQ_SYNCH_FRAME,                /* request */
> > +			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > +			      SQ905_COMMAND, index, "\x0", 1, 500);
>
> "\x0" will point to const memory, this is not allowed as a buffer passed to
> usb_control_msg, instead you should use a r/w buffer suitable for DMA.
> We've got gspca_dev->usb_buf for this.
>

Good point - I'll fix it

> > +	if (ret != 1) {
> > +		PDEBUG(D_ERR, "sq905_command: usb_control_msg failed (%d)",
> > +			ret);
> > +		return -EIO;
> > +	}
> > +
> > +	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> > +			      USB_REQ_SYNCH_FRAME,                /* request */
> > +			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > +			      SQ905_PING, 0, &status, 1, 500);
>
> status is on the stack, this is not necessarily dma-able, use
> gspca_dev->usb_buf instead. Shouldn't the resulting status be checked?

Good point re DMA. The meaning of status is unknown - maybe there should be a 
comment to that effect.

>
> > +	if (ret != 1) {
> > +		PDEBUG(D_ERR, "sq905_command: usb_control_msg failed 2 (%d)",
> > +			ret);
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int sq905_ack_frame(struct usb_device *dev)
> > +{
> > +	int ret;
> > +	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> > +			      USB_REQ_SYNCH_FRAME,                /* request */
> > +			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > +			      SQ905_READ_DONE, 0, "\x0", 1, 500);
>
> "\x0" will point to const memory, this is not allowed as a buffer passed to
> usb_control_msg, instead you should use a r/w buffer suitable for DMA.
> We've got gspca_dev->usb_buf for this.

Ack

>
> As the above function is called from a workqueue you will need to take the
> gspca_dev->usb_lock while doing the usb_control_msg (and while using
> gspca_dev->usb_buf) as this might race with for example v4l2 controls code
> also using the controlpipe.

It might if the camera had any controls. Maybe a comment to that effect is 
appropriate.

>
> > +	if (ret != 1) {
> > +		PDEBUG(D_ERR, "sq905_ack_frame: usb_ctrl_msg failed (%d)", ret);
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +sq905_read_data(struct gspca_dev *gspca_dev, __u8 *data, int size)
> > +{
> > +	int ret;
> > +	int act_len;
> > +
> > +	if (!data) {
> > +		PDEBUG(D_ERR, "sq905_read_data: data pointer was NULL\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = usb_control_msg(gspca_dev->dev,
> > +			      usb_sndctrlpipe(gspca_dev->dev, 0),
> > +			      USB_REQ_SYNCH_FRAME,                /* request */
> > +			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > +			      SQ905_BULK_READ, size, "\x0", 1, 500);
>
> "\x0" will point to const memory, this is not allowed as a buffer passed to
> usb_control_msg, instead you should use a r/w buffer suitable for DMA.
> We've got gspca_dev->usb_buf for this.

Ack

>
> As the above function is called from a workqueue you will need to take the
> gspca_dev->usb_lock while doing the usb_control_msg (and while using
> gspca_dev->usb_buf) as this might race with for example v4l2 controls code
> also using the controlpipe.

As above

>
> > +	if (ret != 1) {
> > +		PDEBUG(D_ERR, "sq905_read_data: usb_ctrl_msg failed (%d)", ret);
> > +		return -EIO;
> > +	}
> > +	ret = usb_bulk_msg(gspca_dev->dev,
> > +			   usb_rcvbulkpipe(gspca_dev->dev, 0x81),
> > +			   data, size, &act_len, 500);
> > +	/* successful, it returns 0, otherwise  negative */
> > +	if ((ret != 0) || (act_len != size)) {
> > +		PDEBUG(D_ERR, "sq905_read_data: bulk read fail (%d) len %d/%d",
> > +			ret, act_len, size);
> > +		return -EIO;
> > +	}
> > +	return 0;
> > +}
> > +
>
> <snip>
>
> Thats all,

Thanks.

Adam.



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
