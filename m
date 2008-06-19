Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K9QzA-0007YL-36
	for linux-dvb@linuxtv.org; Thu, 19 Jun 2008 22:44:01 +0200
Message-ID: <53265.212.50.194.254.1213908236.squirrel@webmail.kapsi.fi>
In-Reply-To: <1213788359.8904.5.camel@sat>
References: <1213788359.8904.5.camel@sat>
Date: Thu, 19 Jun 2008 23:43:56 +0300 (EEST)
From: "Antti Palosaari" <crope@iki.fi>
To: "marsupilamies" <marsupilamies@free.fr>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] No frontend when using leadtek dtv dongle gold with
 last cvs	af9015 branch
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

ke 18.6.2008 14:25 marsupilamies kirjoitti:
>         [ 3588.752816] af9013: Unknown symbol __floatsidf
>         [ 3588.752888] af9013: Unknown symbol __adddf3
>         [ 3588.752960] af9013: Unknown symbol __fixdfsi
>         [ 3588.753025] af9013: Unknown symbol __divdf3
>         [ 3588.753089] af9013: Unknown symbol __muldf3
>         [ 3588.795881] DVB: Unable to find symbol af9013_attach()

>         I don't know why I've the "af9013: Unknow symbol"
>         I'm using a 2.6.24-19 kernel on a ubuntu 8.04.
>
>         Maybe the issue is related to this kernel ?
>
>         Is anybody can help me ?

I have got some reports already :( But I am now on midsummer holiday and
cannot fix it just now. I have added mistakenly some floating point
calculations and thats why it goes broken...

You could use older tree
http://linuxtv.org/hg/~anttip/af9015/rev/9bc22f1c2920
or
http://linuxtv.org/hg/~anttip/af9015-t/

Antti


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
