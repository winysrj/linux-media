Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35503 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbcCDVel (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 16:34:41 -0500
From: Matthieu Rogez <matthieu.rogez@gmail.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Fix Terratec Grabby AC97 codec detection
Date: Fri,  4 Mar 2016 22:33:07 +0100
Message-Id: <1457127188-7574-1-git-send-email-matthieu.rogez@gmail.com>
In-Reply-To: <20160303142621.62325571@recife.lan>
References: <20160303142621.62325571@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Mauro for commenting on my work.
With respect to first version, I've:
* added a timeout mecanism as requested
* added an extra check to avoid cases when the same value is constantly
returned no matter which register is accessed.

---

To test this:
* modprobe em28xx-alsa
* connect Grabby
* mplayer tv:// -tv driver=v4l2:width=720:height=576:device=/dev/video1:input=0:fps=25:norm=SECAM-L:alsa:adevice=plughw.2:audiorate=48000:forceaudio:amode=1:immediatemode=0 -nocache -fps 60

NOTE: for some unknown reason, if em28xx-alsa is not loaded when Grabby is
connected, there will be no sound.
NOTE2: if Grabby is connected without loading em28xx-alsa first, just deconnect
the Grabby and reconnect it.

