Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51495 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830Ab2BYWJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 17:09:50 -0500
Received: by obcva7 with SMTP id va7so4172161obc.19
        for <linux-media@vger.kernel.org>; Sat, 25 Feb 2012 14:09:49 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 25 Feb 2012 19:09:49 -0300
Message-ID: <CALF0-+W7epb+-qFq_OLX0BoMTjszZ81-owo8HT4wr2-emqgNwQ@mail.gmail.com>
Subject: [question] between probe() and open()
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: kernelnewbies <kernelnewbies@kernelnewbies.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is a question in general about usb drivers and
in particular about easycap driver.

Is there any way a driver can be accesed
between after usb_probe() but before device open()?
I guess not, since any further operation on
the device needs a struct file pointer, i.e. a file descriptor on
the user side.

In particular:
easycap driver currently calls reset() on usb_probe(),
reset() does some hardware initialization among other stuff.
However, the reset() is called once again on open().
This seems redundant, right?

The reset() is a heavy function since it access the hardware, so
it would be benefitial to change it,
but I would like someone to ack this, since it is not so trivial.

Some measures on the device shows how heavy the reset() is:

# calling reset() on usb_probe()
time modprobe easycap

real    0m1.516s
user    0m0.000s
sys     0m0.009s

---

# not calling reset() on usb_probe()
time modprobe easycap

real    0m0.003s
user    0m0.000s
sys     0m0.002s

Thanks,
Ezequiel.
