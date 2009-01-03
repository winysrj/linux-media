Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1LJCJn-0007Ia-Je
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 20:37:56 +0100
Received: by bwz11 with SMTP id 11so14742666bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 11:37:22 -0800 (PST)
Date: Sat, 3 Jan 2009 20:37:18 +0100
To: linux-dvb@linuxtv.org
Message-ID: <20090103193718.GB3118@gmail.com>
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: Re: [linux-dvb] DVB-S Channel searching problem
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

Well,

I would suggest not using S2API as it's seems to be broken for our card
at this time, I did test steven s2 repo which is better that all other
S2API repo I have tested but still worse than lipliandvb (multiproto
hg).

I wrote about the problem of the cx88 cards on this exact same ml ;-)
-- =

Gr=E9goire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
