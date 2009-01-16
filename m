Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:33492 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZAPDnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 22:43:10 -0500
Received: by ewy10 with SMTP id 10so1696240ewy.13
        for <linux-media@vger.kernel.org>; Thu, 15 Jan 2009 19:43:08 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH 2/2] gspca: Add MR97310A driver
Date: Thu, 15 Jan 2009 21:43:04 -0600
Cc: linux-media@vger.kernel.org
References: <200901142059.41383.elyk03@gmail.com> <20090115131329.175fce4f@free.fr>
In-Reply-To: <20090115131329.175fce4f@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901152143.04843.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 15 January 2009 06:13:29 Jean-Francois Moine wrote:
> Hi again,
>
> Here are some remarks about your patch.
>
> > +/* the bytes to write are in gspca_dev->usb_buf */
> > +static int reg_w(struct gspca_dev *gspca_dev,
> > +		 __u16 index, int len)
> > +{
> > +	int rc;
> > +
> > +	rc = usb_bulk_msg(gspca_dev->dev,
> > +			  usb_sndbulkpipe(gspca_dev->dev, 4),
> > +			  gspca_dev->usb_buf, len, 0, 500);
> > +	if (rc < 0)
> > +		PDEBUG(D_ERR, "reg write [%02x] error %d", index,
> > rc);
> > +	return rc;
> > +}
>
> The 'index' parameter is not useful: the register is always in the first
> byte of the buffer.
>

Noted.  I used the mars subdriver as a basis for this driver, and apparently 
an old version of it at that.  Will be fixed in v2.

> > +/* this function is called at probe time */
> > +static int sd_config(struct gspca_dev *gspca_dev,
> > +		     const struct usb_device_id *id)
> > +{
> > +	struct cam *cam;
> > +
> > +	cam = &gspca_dev->cam;
> > +	cam->epaddr = 0x01;
>
> This variable has been removed in the last versions of gspca.
>

Will be removed in v2.

> > +static int sd_start(struct gspca_dev *gspca_dev)
> > +{
> > +	struct sd *sd = (struct sd *) gspca_dev;
> > +	__u8 *data = gspca_dev->usb_buf;
> > +	int err_code;
> > +	int intpipe;
> > +
> > +	PDEBUG(D_STREAM, "camera start, iface %d, alt 8",
> > gspca_dev->iface);
> > +	err_code = usb_set_interface(gspca_dev->dev,
> > gspca_dev->iface, 8);
> > +	if (err_code < 0) {
> > +		PDEBUG(D_ERR|D_STREAM, "Set packet size: set
> > interface error");
> > +		return err_code;
> > +	}
>
> The usb_set_interface() is already done in the gspca main.
>

Also borrowed from the mars subdriver.  Will be removed in v2.

> > +	sd->sof_read = 0;
> > +
> > +	intpipe = usb_sndintpipe(gspca_dev->dev, 0);
> > +	err_code = usb_clear_halt(gspca_dev->dev, intpipe);
>
> Is this really needed?
>

Also borrowed from the mars subdriver, and doesn't appear to be necessary for 
the camera to work.  Will be removed in v2.

Regards,
-Kyle
