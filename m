Return-path: <mchehab@pedra>
Received: from web30306.mail.mud.yahoo.com ([209.191.69.68]:33406 "HELO
	web30306.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752490Ab1B1Vlq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 16:41:46 -0500
Message-ID: <793949.42421.qm@web30306.mail.mud.yahoo.com>
Date: Mon, 28 Feb 2011 13:41:45 -0800 (PST)
From: AW <arne_woerner@yahoo.com>
Subject: Re: WinTV HVR-900 (usb 2040:6500) (model 65008) / no audio but clicking noise
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi!

Since I really need analog TV support, I would like to bring this up again... 
:-)

Now i hacked the em28xx module,
so that it would try to get the audio data via the em28xx_alsa module...

But that fails in the usb_submit_urb() call in the em28xx_init_audio_isoc() 
function, because:
wMaxPacketSize of endpoint 0x83 is 0...

Does someone still know how em28xx_alsa was to be used properly?
Is there some specialist, that could help me?
Markus R. doesnt like to do open src things anymore, or did I misunderstand 
that?

Btw: I have an em2882/em2883 chip, which needs to be handled by the em28xx_alsa 
module according to this page:
http://www.linuxtv.org/wiki/index.php/Em28xx_devices#em2880.2F2881.2F2883

Here is the em28xx related syslog from my box:
https://bugzilla.redhat.com/attachment.cgi?id=481332

Bye
Arne


