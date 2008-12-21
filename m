Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@moelleritberatung.de>) id 1LEOim-0000vV-Jo
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 14:51:54 +0100
Date: Sun, 21 Dec 2008 14:51:49 +0100
From: Artem Makhutov <artem@makhutov.org>
To: Faruk A <fa@elwak.com>
Message-ID: <20081221135149.GH12059@titan.makhutov-it.de>
References: <20081220224557.GF12059@titan.makhutov-it.de>
	<854d46170812201646u3414788dh6cbbe6eb9c9ba8ca@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <854d46170812201646u3414788dh6cbbe6eb9c9ba8ca@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to stream DVB-S2 channels over network?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

On Sun, Dec 21, 2008 at 01:46:48AM +0100, Faruk A wrote:
> The best streaming method in linux that i found is vdr with streamdev plugin.

Yes, I know :) And I am trying to help with the UDP multicast streaming.

> try streaming the whole transponder with 8192.
> szap2 -r -p 'ASTRA HD'
> dvbstream 8192 -udp -i 239.255.0.1 -r 1234

Yes, the stream is still corrupted.

> vlc 0.8??: you can change the channel in the "Navigation" sub menu.
> vlc 09??:  I think they change the location, I can't help you with
> that since my locale is in Swedish.

I can not use the build in DVB-Tuning of VLC because it does not support multiproto
and therefore can not tune to DVB-S2 channels.

Regards, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
