Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:53625 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZEDPPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2009 11:15:00 -0400
Date: Mon, 4 May 2009 17:15:29 +0200
From: Janne Grunau <j@jannau.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [questions] dmesg: Non-NULL drvdata on register
Message-ID: <20090504151529.GB19257@aniel.lan>
References: <18097.62.70.2.252.1241442220.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18097.62.70.2.252.1241442220.squirrel@webmail.xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 04, 2009 at 03:03:40PM +0200, Hans Verkuil wrote:
> 
> > Not so many time ago i noticed such line in dmesg:
> >
> > radio-mr800 2-1:1.0: Non-NULL drvdata on register
> >
> > Quick review showed that it appears in usb_amradio_probe fucntions. Then
> > i found such code in v4l2_device_register() function (v4l2-device.c
> > file):
> >
> > /* Set name to driver name + device name if it is empty. */
> >         if (!v4l2_dev->name[0])
> >                 snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "%s %
> > s",
> >                         dev->driver->name, dev_name(dev));
> >         if (dev_get_drvdata(dev))
> >                 v4l2_warn(v4l2_dev, "Non-NULL drvdata on register\n");
> >         dev_set_drvdata(dev, v4l2_dev);
> >         return 0;
> >
> > The questions is - should i deal with this warning in dmesg? Probably
> > the order of callbacks in radio-mr800 probe function is incorrect.
> 
> I (or you :-) should look into this: I think the usb subsystem is calling
> dev_set_drvdata as well, so we could have a clash here.

I don't think so. But probably all USB drivers call usb_set_intfdata
(just a wrapper around dev_set_drvdata). Most (media) drivers use it to
get driver struct back on a disconnect.

My change to use usb interface's struct device for v4l2_device_register
caused an oops on disconnect for em28xx based devices. Other drivers
(hdpvr, au0828) fortunately call usb_set_intfdata after calling
v4l2_device_register.

I'm not sure how to resolve this. USB drivers need for the disconnect a
way of of getting their private driver struct. We could add a data field
to v4l2_device. A couple of drivers seems to be already based on the
assumption that dev_get_drvdata(parent.dev) returns a v4l2_device.

Janne
