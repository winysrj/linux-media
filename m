Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.245])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1KpPRP-0003tr-9L
	for linux-dvb@linuxtv.org; Mon, 13 Oct 2008 17:34:42 +0200
Received: by an-out-0708.google.com with SMTP id c18so134696anc.125
	for <linux-dvb@linuxtv.org>; Mon, 13 Oct 2008 08:34:32 -0700 (PDT)
Message-ID: <854d46170810130834p6118793co49ecb6ed8809062@mail.gmail.com>
Date: Mon, 13 Oct 2008 17:34:32 +0200
From: "Faruk A" <fa@elwak.com>
To: christian@heidingsfelder.eu
In-Reply-To: <48F360B1.7070705@heidingsfelder.eu>
MIME-Version: 1.0
Content-Disposition: inline
References: <48F360B1.7070705@heidingsfelder.eu>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend TT-Connect S2-3650 CI
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

> Hi all,
>
> again, if somebody is
> working on
> or interested in
> that DVB-S USB Reciever with Card Interface he can msg me for informations
> or whatever :- )
>
> Regards Chris

Hi Chris!

As i told you before this card is working with multiproto with kernel
2.6.25 and under.

driver support:
- Remote Control
- LNB Power (13/18V)
- 22kHz
- DiSEqC
- DVB-S
- DVB-S2
- Common Interface
more info @ http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI
and search this mailing list.

S2 API support you have to wait i think because this card depends
stb0899 and stb6100
which as far as i know is not ported yet.

Regards
Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
