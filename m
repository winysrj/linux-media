Return-path: <mchehab@pedra>
Received: from web30307.mail.mud.yahoo.com ([209.191.69.69]:25992 "HELO
	web30307.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751766Ab1BZKoJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 05:44:09 -0500
Message-ID: <95999.51952.qm@web30307.mail.mud.yahoo.com>
References: <980251.92504.qm@web30302.mail.mud.yahoo.com> <1298716431.18744.0.camel@localhost>
Date: Sat, 26 Feb 2011 02:44:07 -0800 (PST)
From: AW <arne_woerner@yahoo.com>
Subject: Re: WinTV HVR-900 (usb 2040:6500) (model 65008) / no audio but clicking noise
To: linux-media@vger.kernel.org
In-Reply-To: <1298716431.18744.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

yesterday i wrote:
> Now I  bought a Hauppauge WinTV HVR-900 (USB, DVB-T/analog Hybrid).
>

today i found that i have quite good DVB-T connectivity...
but sometimes there r too many errors...

so i m still interested in analog tv...

after some rebooting and
after i dropped a lot of firmware files from 
http://konstantin.filtschew.de/v4l-firmware/firmware_v3.tgz into /lib/firmware 
(in addition to xc3028-v27.fw)
i can hear the analog audio,
but from time to time there is still this strong clicking noise...
example: http://www.wgboome.de./20110226,hvr.mpg (i blurred the picture due to 
copyright considerations...)...

could it be that i use the wrong amux?
i found that theory here (but i dont know if i can just change the kernel 
module):
http://www.freak-search.com/de/thread/332374/linux-dvb_em28xx-audio_hvr-900_b3c0_id_20406502_hauppa


-arne


