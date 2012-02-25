Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2BYWbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 17:31:03 -0500
Received: by daed14 with SMTP id d14so3768662dae.19
        for <linux-media@vger.kernel.org>; Sat, 25 Feb 2012 14:31:03 -0800 (PST)
Date: Sat, 25 Feb 2012 14:30:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ezequiel =?iso-8859-1?Q?Garc=EDa?= <elezegarcia@gmail.com>
Cc: kernelnewbies <kernelnewbies@kernelnewbies.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: [question] between probe() and open()
Message-ID: <20120225223055.GA10469@kroah.com>
References: <CALF0-+W7epb+-qFq_OLX0BoMTjszZ81-owo8HT4wr2-emqgNwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALF0-+W7epb+-qFq_OLX0BoMTjszZ81-owo8HT4wr2-emqgNwQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 25, 2012 at 07:09:49PM -0300, Ezequiel García wrote:
> Hello,
> 
> This is a question in general about usb drivers and
> in particular about easycap driver.
> 
> Is there any way a driver can be accesed
> between after usb_probe() but before device open()?

usb_remove() can always be called without open() ever happening.

> I guess not, since any further operation on
> the device needs a struct file pointer, i.e. a file descriptor on
> the user side.

That is usually true.  Oh, suspend can happen, along with resume, those
come in from the usb side of the device, so watch out for those as well.

hope this helps,

greg k-h
