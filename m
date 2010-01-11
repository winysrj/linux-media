Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:36245 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0AKIVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 03:21:49 -0500
Received: by ewy6 with SMTP id 6so21626974ewy.29
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 00:21:47 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 11 Jan 2010 09:21:46 +0100
Message-ID: <885896af1001110021h62213059p4e6bcf52593b1ee8@mail.gmail.com>
Subject: Pinnacle Pctv Hybrid Pro Stick 330E and DVB
From: Giacomo <delleceste@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good morning.

I have a Pinnacle Pctv Hybrid Pro Stick 330E. Downloaded, compiled and
install last
drivers from v4l-dvb via mercurial.

- Downloaded the windows driver fromt
http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
- Extracted the firmware xc3028-v27.fw  into /lib/firmware

Analog TV works, but what about dvb?

I see /dev/vbi0 in /dev, but it seems not to be enough to have neither
kdetv nor klear nor dvbscan work...

They are probably looking for something inside /dev/dvb/adapter...

Is this card supported?

I remember, maybe about one year ago, I had watched DVB-T tv with the
Pctv Hybrid Pro Stick...

Thanks in advance.

Giacomo.

-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
