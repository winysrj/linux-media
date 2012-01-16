Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:18794 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab2APNDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:03:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Oliver Neukum <oneukum@suse.de>
Subject: Re: [RFC PATCH 2/3] radio-keene: add a driver for the Keene FM Transmitter.
Date: Mon, 16 Jan 2012 14:03:07 +0100
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl> <955b875452cd4dca966f87d45a31a718637b03c0.1326716517.git.hans.verkuil@cisco.com> <201201161346.46474.oneukum@suse.de>
In-Reply-To: <201201161346.46474.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161403.07867.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 January 2012 13:46:46 Oliver Neukum wrote:
> Am Montag, 16. Januar 2012, 13:29:19 schrieb Hans Verkuil:
> > +/* check if the device is present and register with v4l and usb if it is
> > */ +static int usb_keene_probe(struct usb_interface *intf,
> > +                               const struct usb_device_id *id)
> > +{
> > +       struct keene_device *radio;
> > +       struct v4l2_ctrl_handler *hdl;
> > +       int retval = 0;
> > +
> > +       radio = kzalloc(sizeof(struct keene_device), GFP_KERNEL);
> > +
> > +       if (!radio) {
> > +               dev_err(&intf->dev, "kmalloc for keene_device failed\n");
> > +               retval = -ENOMEM;
> > +               goto err;
> > +       }
> 
> Oh, I forgot. You have no guarantee the hid driver is already loaded.
> This driver needs to also gracefully handle being called for a HID
> device.

And how do I do that? Do you have a pointer to another driver for me?

Regards,

	Hans
