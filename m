Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L0EWe-0003DS-KK
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 13:08:49 +0100
Received: by qw-out-2122.google.com with SMTP id 9so244317qwb.17
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 04:08:44 -0800 (PST)
Message-ID: <c74595dc0811120408l4ef3cf92g9b1efc850e3b0b48@mail.gmail.com>
Date: Wed, 12 Nov 2008 14:08:44 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "BOUWSMA Barry" <freebeer.bouwsma@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0811121212280.22461@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
References: <20081112023112.94740@gmx.net>
	<c74595dc0811120243m4819b86bk84a5d23c8e00e467@mail.gmail.com>
	<alpine.DEB.2.00.0811121212280.22461@ybpnyubfg.ybpnyqbznva>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1100095985=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1100095985==
Content-Type: multipart/alternative;
	boundary="----=_Part_4580_26006211.1226491724519"

------=_Part_4580_26006211.1226491724519
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Nov 12, 2008 at 1:24 PM, BOUWSMA Barry
<freebeer.bouwsma@gmail.com>wrote:

> Howdy, this is probably a stupid question, as I neither
> have DVB-S2 hardware nor have attempted to use anything
> but a rather hacked scan from dvb-apps, but...
>
> On Wed, 12 Nov 2008, Alex Betis wrote:
>
> > DVB-S2 by specifying S1 or S2 in freq file, also if you implicitly
> specify
> > QPSK in frequency file the utility will not scan DVB-S2, same logic also
> for
> > 8PSK that will scan only DVB-S2 and will not try to scan DVB-S.
> (implicitly -> explicitly?)

Oh man, I'll probably never remember the difference :)
I meant explicitly in that case.


>
>
> I can see the logic for 8PSK=>DVB-S2, but as far as I
> can see, QPSK does not imply purely DVB-S...
> NIT result:  12324000 V 29500000   pos  28.2E    FEC 3/4  DVB-S2 QPSK
> one of eight such transponders, based on parsing the NIT
> tables.  Also, a note from my inital 19E2 scan file to
> remind me why it failed:
> S 11914500      h       27500   ##      DVB-S2 QPSK (0x05)
> May be no longer up-to-date.

Google search shows that you're right about it, thanks for pointing on that.
I'll leave only 8PSK => DVB-S2 binding. People who want to insist on DVB-S
only scanning will have to specify S1 in their frequency file.
I'll probably add also a switch to block S2 scanning at all for those who
don't have S2 compatable card.

BTW, you give here example of NIT parsing, do you know the format of the
message and what field specifies that the delivery system is DVB-S2? scan
utility code doesn't parse it, so I just add both DVB-S and DVB-S2 scans for
newly added transponder from NITmessage.

>
>
> Of course, if I'm misunderstanding, or failing to grasp
> something obvious if I actually laid my hands on the
> code, please feel free to slap me hard and tell me to
> shove off.
>
> thanks
> barry bouwsma
>

------=_Part_4580_26006211.1226491724519
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br>
<div class="gmail_quote">On Wed, Nov 12, 2008 at 1:24 PM, BOUWSMA Barry <span dir="ltr">&lt;<a href="mailto:freebeer.bouwsma@gmail.com" target="_blank">freebeer.bouwsma@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Howdy, this is probably a stupid question, as I neither<br>have DVB-S2 hardware nor have attempted to use anything<br>
but a rather hacked scan from dvb-apps, but...<br>
<div><br>On Wed, 12 Nov 2008, Alex Betis wrote:<br><br>&gt; DVB-S2 by specifying S1 or S2 in freq file, also if you implicitly specify<br>&gt; QPSK in frequency file the utility will not scan DVB-S2, same logic also for<br>
&gt; 8PSK that will scan only DVB-S2 and will not try to scan DVB-S.<br></div>(implicitly -&gt; explicitly?)</blockquote>
<div>Oh man, I&#39;ll probably never remember the difference :)</div>
<div>I meant explicitly in that case.</div>
<div>&nbsp;</div>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span></span><br><br>I can see the logic for 8PSK=&gt;DVB-S2, but as far as I<br>can see, QPSK does not imply purely DVB-S...<br>
NIT result: &nbsp;12324000 V 29500000 &nbsp; pos &nbsp;28.2E &nbsp; &nbsp;FEC 3/4 &nbsp;DVB-S2 QPSK<br>one of eight such transponders, based on parsing the NIT<br>tables. &nbsp;Also, a note from my inital 19E2 scan file to<br>remind me why it failed:<br>S 11914500 &nbsp; &nbsp; &nbsp;h &nbsp; &nbsp; &nbsp; 27500 &nbsp; ## &nbsp; &nbsp; &nbsp;DVB-S2 QPSK (0x05)<br>
May be no longer up-to-date.</blockquote>
<div>Google search shows that you&#39;re right about it, thanks for pointing on that.</div>
<div>I&#39;ll leave only 8PSK =&gt; DVB-S2 binding. People who want to insist on DVB-S only scanning will have to specify S1 in their frequency file.</div>
<div>I&#39;ll probably add also a switch to block S2 scanning at all for those who don&#39;t have S2 compatable card.</div>
<div>&nbsp;</div>
<div>BTW, you give here example of NIT parsing, do you know the format of the message and what field specifies that the delivery system is DVB-S2? scan utility code doesn&#39;t parse it, so I just add both DVB-S and DVB-S2 scans for newly added transponder from NITmessage.</div>

<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><span id=""></span><br><br>Of course, if I&#39;m misunderstanding, or failing to grasp<br>something obvious if I actually laid my hands on the<br>
code, please feel free to slap me hard and tell me to<br>shove off.<br><br>thanks<br><font color="#888888">barry bouwsma<br></font></blockquote></div><br></div>

------=_Part_4580_26006211.1226491724519--


--===============1100095985==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1100095985==--
