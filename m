Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp20.orange.fr ([193.252.22.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1L3wQr-0007ox-AD
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 18:38:10 +0100
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Sat, 22 Nov 2008 18:37:57 +0100
References: <4928288B.1050306@cadsoft.de>
In-Reply-To: <4928288B.1050306@cadsoft.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811221837.58098.hftom@free.fr>
Subject: Re: [linux-dvb] How to determine DVB-S2 capability in S2API?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le samedi 22 novembre 2008 16:43:07 Klaus Schmidinger, vous avez =E9crit=A0:
> I'm currently adopting the patch that makes VDR use S2API,
> but I can't figure out how an application is supposed to find out
> whether a DVB device is DVB-S or DVB-S2.

This bit is missing in current api.
Will be added soon, i guess asa someone provides a patch :)
A that time, i solve that with a user toggleable "S2 capable device" ui =

option.

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
