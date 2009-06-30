Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:56941 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZF3RzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 13:55:13 -0400
Received: by ewy6 with SMTP id 6so411791ewy.37
        for <linux-media@vger.kernel.org>; Tue, 30 Jun 2009 10:55:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A48C4E8.6010107@kernellabs.com>
References: <3833b9400906201508w14f15b96i41e0963186a0a2cb@mail.gmail.com>
	 <3833b9400906290548wd8b2ba1s22266f0152e83f40@mail.gmail.com>
	 <4A48C4E8.6010107@kernellabs.com>
Date: Tue, 30 Jun 2009 13:55:16 -0400
Message-ID: <37219a840906301055y72647f10vae7a584fb7bd04aa@mail.gmail.com>
Subject: Re: cx23885, new hardware revision found
From: Michael Krufky <mkrufky@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: linux-media@vger.kernel.org, Michael Kutyna <mkutyna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 29, 2009 at 9:43 AM, Steven Toth<stoth@kernellabs.com> wrote:
>>> cx23885_dev_checkrevision() New hardware revision found 0x0
>>> cx23885_dev_checkrevision() Hardware revision unknown 0x0
>>> cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 17, latency: 0,
>>> mmio: 0xfd800000
>>> cx23885 0000:02:00.0: setting latency timer to 64
>>>
>>> I'm pretty sure that is the problem but I don't know how to fix it.  I
>
> The new revision isn't the problem, the above code is for information
> purposes so we can track new revs of the silicon in this mailing list. Most
> likely the demodulators / tuners are not configured correctly. DViCO
> probably changed something.
>
> Double check that the silicon and gpios / settings inside the cx23885 driver
> for the existing card definition match the silicon and configuration for
> this new card you have.
>

It's not a new revision.  Something else is wrong.  I have both
revisions of this board, and they display the same revision
information as Hauppauge cx23885-based products:

mk@codes:~$ dmesg | grep checkrevision
[  136.689267] cx23885_dev_checkrevision() Hardware revision = 0xb0
[  136.914968] cx23885_dev_checkrevision() Hardware revision = 0xb0
[  137.086548] cx23885_dev_checkrevision() Hardware revision = 0xb0

If it was a PCI card I would suggest moving it to another PCI slot,
but I'm not sure that would help at all in the case of PCIe.

DViCO has not updated their Windows driver since April of last year.
I think that Michael Kutyna should confirm that the device works in
windows before anybody proceeds to troubleshoot this any further -- it
might just be a bad board / platform.

-Mike Krufky
