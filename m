Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm14-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.52]:23373 "HELO
	nm14-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752034Ab1HTOke convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 10:40:34 -0400
Message-ID: <1313851233.95109.YahooMailClassic@web121704.mail.ne1.yahoo.com>
Date: Sat, 20 Aug 2011 07:40:33 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [PATCH 2/2] EM28xx - fix deadlock when unplugging and replugging a DVB adapter
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
In-Reply-To: <4E4FA9BA.1020306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Sat, 20/8/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> No. The extension load can happen after the usb probe
> phase. In practice, the only case where the extension init will happen
> together with the usb probe phase is when the em28xx modules are
> compiled builtin

It also happens when someone plugs an adapter into the machine when the modules are already loaded. E.g. someone plugging a second adapter in, or unplugging and then replugging the same one.

> Maybe the proper fix would be to change the logic under
> em28xx_usb_probe() to not hold dev->lock anymore when the device is
> loading the extensions.

I could certainly write such a patch, although I only have a PCTV 290e adapter to test with.

Is this problem unique to the em28xx-dvb module? How does the em28xx-alsa module get away with creating ALSA devices without causing a similar race condition?

Cheers,
Chris

