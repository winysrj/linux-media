Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KEOZO-0006wS-K9
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 15:09:59 +0200
Message-ID: <486CCF9E.7070109@iki.fi>
Date: Thu, 03 Jul 2008 16:09:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alistair M <tlli@hotmail.com>
References: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>	<486B3617.3070702@iki.fi>
	<BAY136-W33BDD7C9C5D3A806143D41D2980@phx.gbl>	<486CB3D2.3000702@iki.fi>
	<BAY136-W3875504CF84B7D3DF87BDFD2980@phx.gbl>
In-Reply-To: <BAY136-W3875504CF84B7D3DF87BDFD2980@phx.gbl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
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

Alistair M wrote:
> Hi Antii,
> 
> Thanks for that, it worked. When I press the numbers (0-9), it will 
> repeat on the screen (with the key code appearing in the messages file). 
> Is that expected?
> 
> Here are the codes:
> number 0 = af9015_rc_query: 00 00 27 00 00 00 00 00
> number 1 = af9015_rc_query: 00 00 1e 00 00 00 00 00
> number 2 = af9015_rc_query: 00 00 1f 00 00 00 00 00
> number 3 = af9015_rc_query: 00 00 20 00 00 00 00 00
> number 4 = af9015_rc_query: 00 00 21 00 00 00 00 00
> number 5 = af9015_rc_query: 00 00 22 00 00 00 00 00
> number 6 = af9015_rc_query: 00 00 23 00 00 00 00 00
> number 7 = af9015_rc_query: 00 00 24 00 00 00 00 00
> number 8 = af9015_rc_query: 00 00 25 00 00 00 00 00
> number 9 = af9015_rc_query: 00 00 26 00 00 00 00 00
> channel up = af9015_rc_query: 00 00 52 00 00 00 00 00
> channel down = af9015_rc_query: 00 00 51 00 00 00 00 00
> volume up = af9015_rc_query: 00 00 4f 00 00 00 00 00
> volume down = af9015_rc_query: 00 00 50 00 00 00 00 00
> Enter key = af9015_rc_query: 00 00 28 00 00 00 00 00

Key codes are now mapped to the key events. Please test.

> For some reason the last key i press on the remote will repeat on screen 
> after i have pressed it. For example, i just hit the enter key on the 
> remote, now in this email if i hit enter it repeats on screen. Strange...

Did not understand fully what you mean. All keys are repeating until 
next key is pressed?

> OK hope this helps.
> Thanks Antii.
> Alistair

Antti

-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
