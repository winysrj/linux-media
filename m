Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L4CgL-0004zQ-SL
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 11:59:14 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mANAxAOW007663
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 11:59:10 +0100
Message-ID: <4929377D.7070702@cadsoft.de>
Date: Sun, 23 Nov 2008 11:59:09 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4928288B.1050306@cadsoft.de> <200811221837.58098.hftom@free.fr>
In-Reply-To: <200811221837.58098.hftom@free.fr>
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

On 22.11.2008 18:37, Christophe Thommeret wrote:
> Le samedi 22 novembre 2008 16:43:07 Klaus Schmidinger, vous avez =E9crit :
>> I'm currently adopting the patch that makes VDR use S2API,
>> but I can't figure out how an application is supposed to find out
>> whether a DVB device is DVB-S or DVB-S2.
> =

> This bit is missing in current api.
> Will be added soon, i guess asa someone provides a patch :)
> A that time, i solve that with a user toggleable "S2 capable device" ui =

> option.

Considering that the "multiproto" API did think of handling this,
I really don't understand why the "technologically superior" *S2*API
didn't even think of this.

Requiring the user to configure this is a workaround that even
more disqualifies the decision to go S2API.

But anyway, it looks like we're stuck with this inferior API, so
I've posted a patch that adds this capability. Let's hope it gets
adopted - VDR 1.7.2 will require it, anyway.

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
