Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rouge.crans.org ([138.231.136.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <braice@braice.net>) id 1KUHDY-0001P4-4r
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 10:33:01 +0200
Message-ID: <48A690B7.9090602@braice.net>
Date: Sat, 16 Aug 2008 10:32:55 +0200
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
To: "Ali H.M. Hoseini" <alihmh@gmail.com>
References: <66caf1560808160130w714d1b1r4339ccd4577447aa@mail.gmail.com>
In-Reply-To: <66caf1560808160130w714d1b1r4339ccd4577447aa@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] how to prevent scan utility from scaning
	other	transponders?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Ali H.M. Hoseini a =E9crit :
> Hi all,
> =

> When I use scan utility to scan a transponder, in some freq. scan
> continues to scan other transponders (I think find them in NIT tables),
> and that mean I should wait 2-3 minutes for scan to complete it's work,
> and list all the transponders it found.
> =

> how should I prevent scan utility from scaning other transponders? And
> force it to scan just the transponder I want?
> =

> =

> Thanks.
> =

> Ali.
> =


Hello

Lock on the transponder

and use scan -c

Regards

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
