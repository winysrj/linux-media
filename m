Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab1GCOOi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2011 10:14:38 -0400
Message-ID: <4E10792B.3040109@redhat.com>
Date: Sun, 03 Jul 2011 11:14:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Dmitry Butskoy <buc@odusz.so-cdu.ru>,
	Hans De Goede <hdegoede@redhat.com>,
	Asterios Dramis <asterios.dramis@gmail.com>
Subject: Xawtv version 3.101 released
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Today, we're releasing the version 3.101 of xawtv, with the following
fixes:

* Man fix to remove mention of v4l1, and describe libv4l instead
* Fixes at fr/es manuals
* Warning fixes
* Addition of alsa streaming at xawtv: now, for devices with video
  associated with audio inputs.
* Use X11 editres, instead of its on version, based on a port from
  a motif library released under a licence that is not GPL compatible
* Add auto-detection logic for xawtv: by default, it will now seek for
  the first TV device. If not available, fall back to the first grabber
  device.
* Add auto-detection logic for scanv: by default, it will now seek for
  the first TV device. If not available, fails.
* Add optional support for libexplain at the v4l2/libv4l driver.
  Libexplain provides a  more complete explanation for the error codes,
  helping developers to better track what's happened.
* Don't expose tuner commands, on devices that are grabber or  webcams
  at xawtv.

Dmitry Butskoy fixed the manuals and some warnings.

Asterios Dramis pointed to a trouble with a file imported from Motif, used
on "motv" with a non-GPL license. The code were replaced to use a X11 
library instead.

Hans de Goede fixed the alsa stream code, added the auto-detection
mode and fixing more warnings.

The tarball is available at:

http://linuxtv.org/downloads/xawtv/xawtv-3.101.tar.bz2

Enjoy!
Mauro
