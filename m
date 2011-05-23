Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322Ab1EWURK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 16:17:10 -0400
Message-ID: <4DDAC0C2.7090508@redhat.com>
Date: Mon, 23 May 2011 17:17:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [ANNOUNCE] experimental alsa stream support at xawtv3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Due to the alsa detection code that I've added at libv4l2util (at v4l2-utils)
during the weekend, I decided to add alsa support also on xawtv3, basically
to provide a real usecase example. Of course, for it to work, it needs the
very latest v4l2-utils version from the git tree.

I've basically added there the code that Devin wrote for tvtime, with a few
small fixes and with the audio device auto-detection.

With this patch, xawtv will now get the alsa device associated with a video
device node (if any), and start streaming from it, on a separate thread.

As the code is the same as the one at tvtime, it should work at the
same devices that are supported there. I tested it only on two em28xx devices:
	- HVR-950;
	- WinTV USB-2.

It worked with HVR-950, but it didn't work with WinTV USB-2. It seems that
snd-usb-audio do something different to set the framerate, that the alsa-stream
code doesn't recognize. While I didn't test, I think it probably won't work
with saa7134, as the code seems to hardcode the frame rate to 48 kHz, but
saa7134 supports only 32 kHz.

It would be good to add an option to disable this behavior and to allow manually
select the alsa out device, so please send us patches ;)

Anyway, patches fixing it and more tests are welcome.

The git repositories for xawtv3 and v4l-utils is at:

http://git.linuxtv.org/xawtv3.git
http://git.linuxtv.org/v4l-utils.git

Thanks,
Mauro.
