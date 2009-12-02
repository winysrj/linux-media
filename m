Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbZLBMqC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2009 07:46:02 -0500
Message-ID: <4B16616B.6010505@redhat.com>
Date: Wed, 02 Dec 2009 10:45:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com> <1259682428.18599.10.camel@maxim-laptop> <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com> <4B154C54.5090906@redhat.com> <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com> <4B155288.1060509@redhat.com> <20091201175400.GA19259@core.coreip.homeip.net> <4B1567D8.7080007@redhat.com> <20091201201158.GA20335@core.coreip.homeip.net> <4B15852D.4050505@redhat.com> <4B164EEC.9030504@redhat.com>
In-Reply-To: <4B164EEC.9030504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gerd Hoffmann wrote:
> On 12/01/09 22:05, Mauro Carvalho Chehab wrote:
>> So, I would just add the IR sysfs parameters at the /sys/class/input, if
>> the device is an IR (or create it is /sys/class/input/IR).
> 
> No, you add it to the physical device node.
> 
> The usb mouse on the system I'm working on is here:
> 
> zweiblum kraxel $ ll /sys/class/input/ | grep usb2
> lrwxrwxrwx. 1 root root 0 Dec  2 12:07 event7 ->
> ../../devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input7/event7/
> lrwxrwxrwx. 1 root root 0 Dec  2 12:07 input7 ->
> ../../devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input7/
> lrwxrwxrwx. 1 root root 0 Dec  2 12:07 mouse2 ->
> ../../devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input7/mouse2/
> 
> So "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0" is the device
> node of the physical device, and the input devices belonging to it are
> in the "input" subdirectory.
> 
> If the mouse would be a usb IR receiver the IR attributes should go to
> /sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0 or maybe a 'ir'
> subdirectory there.

This makes sense to me.

Cheers,
Mauro.
