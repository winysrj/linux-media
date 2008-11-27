Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-qy0-f16.google.com ([209.85.221.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1L5b4Q-0007ul-88
	for linux-dvb@linuxtv.org; Thu, 27 Nov 2008 08:13:52 +0100
Received: by qyk9 with SMTP id 9so1141644qyk.17
	for <linux-dvb@linuxtv.org>; Wed, 26 Nov 2008 23:13:13 -0800 (PST)
Message-ID: <c74595dc0811262313w3ec5972cl54f47f624e0398af@mail.gmail.com>
Date: Thu, 27 Nov 2008 09:13:13 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: "Udo Richter" <udo_richter@gmx.de>
In-Reply-To: <492DC5F5.3060501@gmx.de>
MIME-Version: 1.0
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
	<492DC5F5.3060501@gmx.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0665475560=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0665475560==
Content-Type: multipart/alternative;
	boundary="----=_Part_37277_638303.1227769993154"

------=_Part_37277_638303.1227769993154
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Nov 26, 2008 at 11:56 PM, Udo Richter <udo_richter@gmx.de> wrote:

> Without knowing enough about the differences between -S and -S2 tuners
> and whatever cards are on the market, I'll try to step back and give
> this my 2c point of view:
>
> What does a DVB app need to know? A DVB app probably just needs to know
> "What devices are capable of tuning to channel XYZ?". The API could
> answer this the same way as it would tune to channel XYZ, just without
> actually doing it. Try-before-you-buy.
>
> This would also give maximum flexibility to the driver, as a device that
> supports some -S2 features could offer these, or a device that has known
> bugs on some tuning modes could also deny these. Non-standard modes
> could be offered without requiring yet another FE_CAN_XYZ.

Assuming you have 3 cards, one DVB-S2 and 2xDVB-S.
In case of DVB-S channel, all the cards will be able to record it, what will
be the decision? Random?
You might select DVB-S2 card for DVB-S recording, while it might be used to
record DVB-S2 channel that no other card is capable to do.

I agree that driver should tell whenever it able to tune to a channel when
its ordered to perform tuning. There shouldn't be any guess just by checking
the LOCK status.

------=_Part_37277_638303.1227769993154
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br>
<div class="gmail_quote">On Wed, Nov 26, 2008 at 11:56 PM, Udo Richter <span dir="ltr">&lt;<a href="mailto:udo_richter@gmx.de">udo_richter@gmx.de</a>&gt;</span> wrote:<br>
<blockquote class="gmail_quote" style="PADDING-LEFT: 1ex; MARGIN: 0px 0px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Without knowing enough about the differences between -S and -S2 tuners<br>and whatever cards are on the market, I&#39;ll try to step back and give<br>
this my 2c point of view:<br><br>What does a DVB app need to know? A DVB app probably just needs to know<br>&quot;What devices are capable of tuning to channel XYZ?&quot;. The API could<br>answer this the same way as it would tune to channel XYZ, just without<br>
actually doing it. Try-before-you-buy.<br><br>This would also give maximum flexibility to the driver, as a device that<br>supports some -S2 features could offer these, or a device that has known<br>bugs on some tuning modes could also deny these. Non-standard modes<br>
could be offered without requiring yet another FE_CAN_XYZ.</blockquote>
<div>Assuming you have 3 cards, one DVB-S2 and 2xDVB-S.</div>
<div>In case of DVB-S channel, all the cards will be able to record it, what will be the decision? Random?</div>
<div>You might select DVB-S2 card for DVB-S recording, while it might be used to record DVB-S2 channel that no other card is capable to do.</div>
<div>&nbsp;</div>
<div>I agree that driver should tell whenever it able to tune to a channel when its ordered to perform tuning. There shouldn&#39;t be any guess just by checking the LOCK status.</div>
<div>&nbsp;</div></div></div>

------=_Part_37277_638303.1227769993154--


--===============0665475560==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0665475560==--
