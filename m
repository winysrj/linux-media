Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1L0Ehk-00046p-V2
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 13:20:20 +0100
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Wed, 12 Nov 2008 12:44:53 +0100
References: <20081112023112.94740@gmx.net>
	<c74595dc0811120243m4819b86bk84a5d23c8e00e467@mail.gmail.com>
	<alpine.DEB.2.00.0811121212280.22461@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0811121212280.22461@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811121244.53182.ajurik@quick.cz>
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
Reply-To: ajurik@quick.cz
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

On Wednesday 12 of November 2008, BOUWSMA Barry wrote:
> I can see the logic for 8PSK=>DVB-S2, but as far as I
> can see, QPSK does not imply purely DVB-S...
> NIT result:  12324000 V 29500000   pos  28.2E    FEC 3/4  DVB-S2 QPSK
> one of eight such transponders, based on parsing the NIT
> tables.  Also, a note from my inital 19E2 scan file to
> remind me why it failed:
> S 11914500      h       27500   ##      DVB-S2 QPSK (0x05)
> May be no longer up-to-date.
>
> Of course, if I'm misunderstanding, or failing to grasp
> something obvious if I actually laid my hands on the
> code, please feel free to slap me hard and tell me to
> shove off.
>

You are right, it is working for me with this two lines from channels.conf 
(with vdr), both DVB-S2, QPSK:

ASTRA 
HD+;BetaDigital:11914:hC910M2O35S1:S19.2E:27500:1279:0;1283=deu:0:0:131:133:6:0
HD Retail 
Info;BSkyB:12324:vC34M2O35S1:S28.2E:29500:512:640=NAR;660=eng:2305:960,961,963:3801:2:2032:0

BR,

Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
