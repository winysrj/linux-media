Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53745 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab1FFR7O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:59:14 -0400
Received: by eyx24 with SMTP id 24so1447096eyx.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 10:59:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DED14BA.5010306@redhat.com>
References: <4DED14BA.5010306@redhat.com>
Date: Mon, 6 Jun 2011 13:59:13 -0400
Message-ID: <BANLkTim_=-8BvrpZDQGWFNZQTi5XQn3QvQ@mail.gmail.com>
Subject: Re: Which error code to return when a usb camera gets unplugged
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 6, 2011 at 1:56 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> While working on my cleanup / v4l2 compliance series for
> the pwc driver I've noticed that the pwc and gspca drivers
> are doing different things wrt what error they return to
> an app is using the device while it gets unplugged.
> gspca returns -ENODEV, where as pwc returns -EPIPE.
>
> Both make some sense. I've not looked at what other
> usb (or other hotplug capable bus) v4l2 drivers do, but
> it makes sense to me to standardize on an error here,
> preferably a reasonable unique one so that apps can
> detect unplug versus other errors. Note that the usb
> subsystem returns -ENODEV when you try to (re)submit
> an urb from its completion handler, when that
> completion handler gets called because the urb was
> unlinked because of device unplug.
>
> Given that we often return usb error codes unmodified
> and the usb subsys uses -ENODEV for trying to do things
> with unplugged devices, I guess it makes sense for
> us to also use -ENODEV.

I'm pretty sure ENODEV is what gets returned today if you attempt to
open a /dev/videoX node for a device that has been disconnected but
the device node hasn't yet been removed.  So I would agree that ENODEV
is a good choice for the scenario you described.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
