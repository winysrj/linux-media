Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [195.156.147.13] (helo=kirsi2.rokki.sonera.fi)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lwgt@iki.fi>) id 1K10X0-0002v8-4p
	for linux-dvb@linuxtv.org; Tue, 27 May 2008 16:52:06 +0200
Received: from [127.0.0.1] (84.249.53.62) by kirsi2.rokki.sonera.fi (8.5.014)
	id 483BB4130004A6A4 for linux-dvb@linuxtv.org;
	Tue, 27 May 2008 17:52:02 +0300
Message-ID: <483C2010.3070609@iki.fi>
Date: Tue, 27 May 2008 17:52:00 +0300
From: Lauri Tischler <lwgt@iki.fi>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <483BD07E.3050802@iki.fi> <483BEBEB.6030705@iki.fi>
In-Reply-To: <483BEBEB.6030705@iki.fi>
Subject: Re: [linux-dvb] Success with af9015 tree
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Antti Palosaari wrote:
> Lauri Tischler wrote:
>> Just spent a horrendous amount of =8019,90 for a DVB-T USB-stick
>> name of this el-cheapo thing is Fuj:tech DTV PRO
>> Needed to get Antti's af9015 tree and install
>> Works now with Kaffeine
>>
>> Are there any plans of adding this stuff to maintree ?
> =

> Maybe later, haven't worked this one much nowadays. Currently problem is =

> that it does not work very well with dual tuner devices. Picture goes =

> jittery when both FE's are streaming.

Ummm... I really would like to have a combination of various trees,
based on v4l-dvb, then added multiproto_plus-stuff and af9xxx things
because I want to build a testbox for all my DVB-cards.
I have various NEXUS-S and NEXUS-T cards, various incarnations
of Hauppauge NOVA-T cards, one AF9015 based USB stick and
I will soon buy some DVB-S2 card.
It seems that there is no single tree to support all that.
Is it possible to merge all known trees ?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
