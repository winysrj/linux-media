Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rouge.crans.org ([138.231.136.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <braice@braice.net>) id 1LISg8-0000Z9-0C
	for linux-dvb@linuxtv.org; Thu, 01 Jan 2009 19:53:57 +0100
Message-ID: <495D113E.9050109@braice.net>
Date: Thu, 01 Jan 2009 19:53:50 +0100
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
To: Artem Makhutov <artem@makhutov.org>
References: <20081220224557.GF12059@titan.makhutov-it.de>
In-Reply-To: <20081220224557.GF12059@titan.makhutov-it.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to stream DVB-S2 channels over network?
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

Artem Makhutov a =E9crit :
> Hello,
> =

> I would like to stream a DVB-S2, H264 channel over my network to an STB.
> =

> I an using the TT 3200 DVB-S2 card with multiproto drivers from Igors rep=
ository.
> =

> So faar I have tried 3 different solutions:
> =

> [...]
>
> Do you know any other methods to stream a DVB-S2 channel over network?
> =


Hello

You can try to use mumudvb (http://mumudvb.braice.net)

In order to stream dvb-s2 I've implemented an option dont_tune in
mumudvb wich permit to skip the tuning part of mumudvb wich is "old gen".

The solution of using this option and tuning the card before launching
mumudvb have been reported to work with dvb-s2

To get the snapshot with this option, follow this link
http://gitweb.braice.net/gitweb?p=3Dmumudvb.git;a=3Dsnapshot;h=3Df430989cbe=
696345872b6ccf66d30e57a8bd8abc

Best regards,

-- =

Brice


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
