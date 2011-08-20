Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab1HTPCs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 11:02:48 -0400
Message-ID: <4E4FCC8D.3070305@redhat.com>
Date: Sat, 20 Aug 2011 08:02:37 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 2/2] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <1313851233.95109.YahooMailClassic@web121704.mail.ne1.yahoo.com>
In-Reply-To: <1313851233.95109.YahooMailClassic@web121704.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-08-2011 07:40, Chris Rankin escreveu:
> --- On Sat, 20/8/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>> No. The extension load can happen after the usb probe
>> phase. In practice, the only case where the extension init will happen
>> together with the usb probe phase is when the em28xx modules are
>> compiled builtin
> 
> It also happens when someone plugs an adapter into the machine when the modules are already loaded. E.g. someone plugging a second adapter in, or unplugging and then replugging the same one.

Yes.

>> Maybe the proper fix would be to change the logic under
>> em28xx_usb_probe() to not hold dev->lock anymore when the device is
>> loading the extensions.
> 
> I could certainly write such a patch, although I only have a PCTV 290e adapter to test with.

We can test it on more devices.

> Is this problem unique to the em28xx-dvb module? How does the em28xx-alsa module get 
> away with creating ALSA devices without causing a similar race condition?

It might also affect alsa. Pulseaudio has the bad habit of opening the device. However,
the device lock is hold when the driver is changing the lock.

It should be noticed that the current mutex lock strategy is a workaround. The proper
solution is to work on resource lock library that could be used when the access of a
device via one API blocks the access of the same device using another API.

We had some discussions about that during the USB mini-summit on last Monday. We'll
probably discuss more about that during the Kernel Summit/media workshop.

Thanks,
Mauro

