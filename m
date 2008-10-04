Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rouge.crans.org ([138.231.136.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <braice@braice.net>) id 1KmE0A-0002ZF-Lb
	for linux-dvb@linuxtv.org; Sat, 04 Oct 2008 22:45:23 +0200
Message-ID: <48E7D5BB.9040001@braice.net>
Date: Sat, 04 Oct 2008 22:44:43 +0200
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
To: Jelle de Jong <jelledejong@powercraft.nl>
References: <48E7CDC1.9010905@powercraft.nl>
In-Reply-To: <48E7CDC1.9010905@powercraft.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Scrambled/encrypted dvb-t channels under linux with
 a	CI CAM?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Jelle de Jong a =E9crit :
> Hello everybody,
> =

> I am searching for some solutions to be able to watch
> scrambled/encrypted dvb-t channels on Linux systems.
> =

> I don't know what my options are..., but I found this wiki page:
> http://www.linuxtv.org/wiki/index.php/DVB_Conditional_Access_Modules
> =

> The situation is that I have separate usb enabled dvb-t devices that do
> all work for non scrambled channels.
> =

> I would like to be able to add an usb device that makes it possible to
> also watch the scrambled channels, I don't know if this is possible.
> What is the exact function of a CAM? Does it decrypt date realtime or
> does it give out some special key that an other application can use?
> =


The CAM decrypt the streams, the key stays inside the cam.

The full stream is given to the cam and you ask the cam for the programs
you want to be decrypted

> I do have a usb smartcard reader that I use for gnupg encryption
> systems. Are there possibility to use this device with an cable-provider
> smartcards?
> =


Normally no.

If you can it's generrally illegal to extract the keys from the smartcard.

> Any information is appreciated,
> =


Hope this will help you

-- =

Brice


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
