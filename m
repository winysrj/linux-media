Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm15.bullet.mail.ne1.yahoo.com ([98.138.90.78]:38809 "HELO
	nm15.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750842Ab1IYVgq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 17:36:46 -0400
Message-ID: <1316986605.56272.YahooMailClassic@web121708.mail.ne1.yahoo.com>
Date: Sun, 25 Sep 2011 14:36:45 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [PATCH v3] EM28xx - fix deadlock when unplugging and replugging a DVB adapter
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4E7F84C8.6010505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Sun, 25/9/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Yes. Just after creating a device, udev tries to access it.
> This bug is more sensitive on multi-CPU machines, as udev may run on
> another CPU.

Heh, I have a hyper-threaded quad-core here. I suspect that counts as "multi-CPU" :-).

However, I think we can agree that the first "plugging" event is not causing problems (in the modular case). The interesting thing about this first event is that it requests that the em28xx_dvb module be loaded, which in turn means that em28xx_init_extension() cannot invoke the dvb_init() function during em28xx_usb_probe(), thus avoiding the deadlock. So one of the following sequences of events must be occurring instead:

Either:
1) em28xx_usb_probe() runs
2) em28xx_dvb module loads, invoking em28xx_register_extension() and dvb_init()
3) udev runs for V4L nodes

Or:
1) em28xx_usb_probe() runs
2) udev runs for V4L nodes
3) em28xx_dvb module loads, invoking em28xx_register_extension() and dvb_init()

The steps in both of these sequences are serialised by the dev->lock mutex. So wouldn't moving em28xx_init_extension() out of em28xx_init_dev() to the bottom of em28xx_usb_probe() (after the dev->lock mutex has been unlocked) be logically identical to the case where the em28xx-dvb module is loaded?

Cheers,
Chris

