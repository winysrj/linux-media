Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51240 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336Ab1FFVrn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 17:47:43 -0400
Subject: Re: Which error code to return when a usb camera gets unplugged
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <BANLkTim_=-8BvrpZDQGWFNZQTi5XQn3QvQ@mail.gmail.com>
References: <4DED14BA.5010306@redhat.com>
	 <BANLkTim_=-8BvrpZDQGWFNZQTi5XQn3QvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 17:48:32 -0400
Message-ID: <1307396912.2432.18.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-06-06 at 13:59 -0400, Devin Heitmueller wrote:
> On Mon, Jun 6, 2011 at 1:56 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> > Hi,
> >
> > While working on my cleanup / v4l2 compliance series for
> > the pwc driver I've noticed that the pwc and gspca drivers
> > are doing different things wrt what error they return to
> > an app is using the device while it gets unplugged.
> > gspca returns -ENODEV, where as pwc returns -EPIPE.
> >
> > Both make some sense. I've not looked at what other
> > usb (or other hotplug capable bus) v4l2 drivers do, but
> > it makes sense to me to standardize on an error here,
> > preferably a reasonable unique one so that apps can
> > detect unplug versus other errors. Note that the usb
> > subsystem returns -ENODEV when you try to (re)submit
> > an urb from its completion handler, when that
> > completion handler gets called because the urb was
> > unlinked because of device unplug.
> >
> > Given that we often return usb error codes unmodified
> > and the usb subsys uses -ENODEV for trying to do things
> > with unplugged devices, I guess it makes sense for
> > us to also use -ENODEV.
> 
> I'm pretty sure ENODEV is what gets returned today if you attempt to
> open a /dev/videoX node for a device that has been disconnected but
> the device node hasn't yet been removed.  So I would agree that ENODEV
> is a good choice for the scenario you described.

Neither ENODEV nor EPIPE are correct.  POSIX requires ENXIO in this
situation.

http://pubs.opengroup.org/onlinepubs/9699919799/
http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_03

Section 2.3 describes the error numbers.  Here are some highlights:

[EIO]
        Input/output error. Some physical input or output error has
        occurred. This error may be reported on a subsequent operation
        on the same file descriptor. Any other error-causing operation
        on the same file descriptor may cause the [EIO] error indication
        to be lost.

[ENODEV]
        No such device. An attempt was made to apply an inappropriate
        function to a device; for example, trying to read a write-only
        device such as a printer.
        
[ENXIO]
        No such device or address. Input or output on a special file
        refers to a device that does not exist, or makes a request
        beyond the capabilities of the device. It may also occur when,
        for example, a tape drive is not on-line.
        
[EPIPE]
        Broken pipe. A write was attempted on a socket, pipe, or FIFO
        for which there is no process to read the data.



Also, Appendix A of

"POSIX and Linux Application Compatibility Design Rules"

https://www.opengroup.org/platform/single_unix_specification/uploads%/40/13450/POSIX_and_Linux_Application_Compatibility_Final_-_v1.0.pdf

has this note:

"Formerly, Linux permited several file system functions to return either
ENODEV or ENXIO for a non-existent device, while POSIX requires an ENXIO
return in this case. Linux now returns the correct error under this
condition. This applied to fopen(), freopen(), open(), and creat()."


Regards,
Andy


