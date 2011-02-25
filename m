Return-path: <mchehab@pedra>
Received: from web30302.mail.mud.yahoo.com ([209.191.69.64]:26603 "HELO
	web30302.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756089Ab1BYS1I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 13:27:08 -0500
Message-ID: <980251.92504.qm@web30302.mail.mud.yahoo.com>
Date: Fri, 25 Feb 2011 10:27:07 -0800 (PST)
From: AW <arne_woerner@yahoo.com>
Subject: WinTV HVR-900 (usb 2040:6500) (model 65008) / no audio but clicking noise
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi!

Now I bought a Hauppauge WinTV HVR-900 (USB, DVB-T/analog Hybrid).

video is ok...
But: Audio sounds almost as bad as before (with that Pinnacle stick):
http://www.wgboome.de./hvr900.wav

I used this mplayer command:
mplayer -tv 
driver=v4l2:input=0:width=768:height=576:device=/dev/video2:alsa=1:forceaudio=1:adevice=hw.1:audiorate=48000:immediatemode=0:amode=0:norm=pal:chanlist=europe-west:freq=280
 tv://

The difference to the Pinnacle thingy is:
The correct audio isnt even in the background...
I hear just that clicking noise...

What did I do wrong?

PS: With my PCI PVR-250 i have no problem...

Thx.

Bye
Arne


