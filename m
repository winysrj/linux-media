Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:57771 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbZAOMYI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 07:24:08 -0500
Date: Thu, 15 Jan 2009 13:13:29 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Guinn <elyk03@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] gspca: Add MR97310A driver
Message-ID: <20090115131329.175fce4f@free.fr>
In-Reply-To: <200901142059.41383.elyk03@gmail.com>
References: <200901142059.41383.elyk03@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 14 Jan 2009 20:59:41 -0600
Kyle Guinn <elyk03@gmail.com> wrote:

> gspca: Add MR97310A driver
> 
> From: Kyle Guinn <elyk03@gmail.com>
> 
> This patch adds support for USB webcams based on the MR97310A chip.
> It was tested with an Aiptek PenCam VGA+ webcam.

Hi again,

Here are some remarks about your patch.

	[snip]
> +/* the bytes to write are in gspca_dev->usb_buf */
> +static int reg_w(struct gspca_dev *gspca_dev,
> +		 __u16 index, int len)
> +{
> +	int rc;
> +
> +	rc = usb_bulk_msg(gspca_dev->dev,
> +			  usb_sndbulkpipe(gspca_dev->dev, 4),
> +			  gspca_dev->usb_buf, len, 0, 500);
> +	if (rc < 0)
> +		PDEBUG(D_ERR, "reg write [%02x] error %d", index,
> rc);
> +	return rc;
> +}

The 'index' parameter is not useful: the register is always in the first
byte of the buffer.

	[snip]
> +/* this function is called at probe time */
> +static int sd_config(struct gspca_dev *gspca_dev,
> +		     const struct usb_device_id *id)
> +{
> +	struct cam *cam;
> +
> +	cam = &gspca_dev->cam;
> +	cam->epaddr = 0x01;

This variable has been removed in the last versions of gspca.

> +	cam->cam_mode = vga_mode;
> +	cam->nmodes = ARRAY_SIZE(vga_mode);
> +	return 0;
> +}
	[snip]
> +static int sd_start(struct gspca_dev *gspca_dev)
> +{
> +	struct sd *sd = (struct sd *) gspca_dev;
> +	__u8 *data = gspca_dev->usb_buf;
> +	int err_code;
> +	int intpipe;
> +
> +	PDEBUG(D_STREAM, "camera start, iface %d, alt 8",
> gspca_dev->iface);
> +	err_code = usb_set_interface(gspca_dev->dev,
> gspca_dev->iface, 8);
> +	if (err_code < 0) {
> +		PDEBUG(D_ERR|D_STREAM, "Set packet size: set
> interface error");
> +		return err_code;
> +	}

The usb_set_interface() is already done in the gspca main.

	[snip]
> +	sd->sof_read = 0;
> +
> +	intpipe = usb_sndintpipe(gspca_dev->dev, 0);
> +	err_code = usb_clear_halt(gspca_dev->dev, intpipe);

Is this really needed?

> +	data[0] = 0x00;
> +	data[1] = 0x4d;  /* ISOC transfering enable... */
> +	reg_w(gspca_dev, data[0], 2);
> +	return err_code;
> +}
	[snip]

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
