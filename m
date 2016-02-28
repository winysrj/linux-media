Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33880 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbcB1L0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 06:26:39 -0500
From: Matthieu Rogez <matthieu.rogez@gmail.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Improve Terratec Grabby (hw rev 2) support
Date: Sun, 28 Feb 2016 12:26:20 +0100
Message-Id: <1456658783-32345-1-git-send-email-matthieu.rogez@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches improve support for the Terratec Grabby A/V capture device.
The first two patches add support for the REC button and led.
The third patch fixes AC97 codec detection by delaying card setup until
i2c communication to EMP202 device is reliable.

To test this:
* modprobe em28xx-alsa
* connect Grabby
* mplayer tv:// -tv driver=v4l2:width=720:height=576:device=/dev/video1:input=0:fps=25:norm=SECAM-L:alsa:adevice=plughw.2:audiorate=48000:forceaudio:amode=1:immediatemode=0 -nocache -fps 60

NOTE: for some unknown reason, if em28xx-alsa is not loaded when Grabby is
connected, there will be no sound.
NOTE2: if Grabby is connected without loading em28xx-alsa first, just deconnect
the Grabby and reconnect it.

