Return-path: <mchehab@pedra>
Received: from blu0-omc2-s18.blu0.hotmail.com ([65.55.111.93]:27239 "EHLO
	blu0-omc2-s18.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab1GARUq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 13:20:46 -0400
Message-ID: <BLU0-SMTP1815E3F4BC5AA2B9C574CB8D85B0@phx.gbl>
From: Lou <tuxoholic@hotmail.de>
To: linux-media@vger.kernel.org
Subject: Re: Help getting TechniSat SkyStar HD2 working in Ubuntu 10.10
Date: Fri, 1 Jul 2011 19:14:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello John,

> I'm having problems with this card- I can get it to scan DVB-S and
> DVB-S2 using scan-s2, and can get it to tune to DVB-S channels, but I
> cannot szap to DVB-S2 channels
> 
> szap2 -p -t 2 "BBC HD" reports error ioctl DVBFE_SET_DELSYS failed:
> Operation not supported
> 
> I have tried the latest s2-liplianin and v4l-dvb mantis drivers but no joy
> 
> Can anyone help?

szap2 needs a list of channels in zap or vdr format to tune correctly,
so try this:

szap2 -c <your-szap-s2-channel-list-including-BBC HD> "BBC HD"

gathering the list using scan-s2 should work like this:

scan-s2 -s [DISEQC OUT] -t 3 -o zap -n -I 50 /usr/local/share/dvb/dvb-
s/Astra-28.2E > astra.conf

note: Astra-28.2E is the transponder file, where astra.conf will be the 
resulting list of channels.

Since you are using a mantis bridge card, consider the patch of Lutz Sammer to 
fix the tuning algo of your card [1]

And there's brand new remote support for your card in v4l-dvb, if you apply 
the patch of Christoph Pinkl [2]

[1] https://patchwork.kernel.org/patch/753382/
[2] http://www.spinics.net/lists/linux-media/msg33632.html
