Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K6Z89-00051m-Eh
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 00:49:26 +0200
Message-ID: <4850566E.8030001@iki.fi>
Date: Thu, 12 Jun 2008 01:49:18 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew Websdale <websdaleandrew@googlemail.com>
References: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
In-Reply-To: <e37d7f810806111512w46a508b0h92047728ba38cac8@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0 seems to not work properly
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

Andrew Websdale wrote:
> I got the front end info from dvbsnoop last night & it says its a 
> Zarlink MT352, but I should try to open the stick anyway to clear up 
> exactly what chips it uses, although I think its moulded plastics so 
> I'll have to cut it open. (@work now, will try later)
> Andrew (sorry if I sent an email to you direct, Antii, I'm not sure how 
> Gmail handles mailing lists

If dvbsnoop says that there is Zarlink MT352, then there should be.

It should be also seen from the log, try to look your message.log again 
to see if there is mention about Zarlink MT352 demodulator / frontend 
and Quantek QT1010 tuner.

It could be also possible that tuner is not working.

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
