Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64106 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0BVWwV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 17:52:21 -0500
Received: by bwz1 with SMTP id 1so517612bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 14:52:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B83076A.3010409@ctecworld.com>
References: <20091007101142.3b83dbf2@glory.loctelecom.ru>
	 <200912160849.17005.hverkuil@xs4all.nl>
	 <20100112172209.464e88cd@glory.loctelecom.ru>
	 <201001130838.23949.hverkuil@xs4all.nl>
	 <20100127143637.26465503@glory.loctelecom.ru>
	 <4B83076A.3010409@ctecworld.com>
Date: Mon, 22 Feb 2010 17:52:19 -0500
Message-ID: <829197381002221452k793be9d2l8f7ec3638233ecd0@mail.gmail.com>
Subject: Re: eb1a:2860 eMPIA em28xx device to usb1 ??? usb hub problem?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: j <jlafontaine@ctecworld.com>
Cc: Dmitri Belimov <d.belimov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 22, 2010 at 5:38 PM, j <jlafontaine@ctecworld.com> wrote:
> Hi I get trouble with my Kworld em28xx device, anyone can help any kernel
> issue found somewhere about that?

Hi J,

Is this device plugged directly into the USB port on the motherboard?
Or do you have a USB hub that the device is connected to.  Sometimes
low quality USB hubs will not work properly with high speed isoc
devices.

Also, I would suggest that you leave the device unplugged when
powering up the system.  Then once it is up, plug it in and send the
full dmesg output.  This will make it easier to analyze the dmesg
output because the driver will not be initializing at the same time as
all the other USB devices.

Also, please provide the *full* dmesg output, so we have more context
information about the system (things such as the kernel version, etc).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
