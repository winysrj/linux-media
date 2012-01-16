Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab2APMo5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 07:44:57 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 2/3] radio-keene: add a driver for the Keene FM Transmitter.
Date: Mon, 16 Jan 2012 13:46:46 +0100
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl> <955b875452cd4dca966f87d45a31a718637b03c0.1326716517.git.hans.verkuil@cisco.com>
In-Reply-To: <955b875452cd4dca966f87d45a31a718637b03c0.1326716517.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161346.46474.oneukum@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, 16. Januar 2012, 13:29:19 schrieb Hans Verkuil:
> +/* check if the device is present and register with v4l and usb if it is */
> +static int usb_keene_probe(struct usb_interface *intf,
> +                               const struct usb_device_id *id)
> +{
> +       struct keene_device *radio;
> +       struct v4l2_ctrl_handler *hdl;
> +       int retval = 0;
> +
> +       radio = kzalloc(sizeof(struct keene_device), GFP_KERNEL);
> +
> +       if (!radio) {
> +               dev_err(&intf->dev, "kmalloc for keene_device failed\n");
> +               retval = -ENOMEM;
> +               goto err;
> +       }

Oh, I forgot. You have no guarantee the hid driver is already loaded.
This driver needs to also gracefully handle being called for a HID
device.

	Regards
		Oliver
