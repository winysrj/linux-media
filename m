Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JYg1P-0001OS-Jp
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 12:19:10 +0100
Received: by ti-out-0910.google.com with SMTP id y6so840566tia.13
	for <linux-dvb@linuxtv.org>; Mon, 10 Mar 2008 04:12:43 -0700 (PDT)
Message-ID: <abf3e5070803100412y30a97679uf339a94fae00dfae@mail.gmail.com>
Date: Mon, 10 Mar 2008 22:12:42 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47D505DC.3030409@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>
	<47D49309.8020607@linuxtv.org>
	<abf3e5070803092042q6f4e90d9h890efb0ea441419e@mail.gmail.com>
	<47D4B8D0.9090401@linuxtv.org>
	<abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>
	<47D505DC.3030409@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

>  You can update af9015-tree to master level easily:
>  hg pull -u http://linuxtv.org/hg/v4l-dvb
>  hg merge
>
Thanks, that worked well.

>
>  > Also if I could somehow get this working with the right
>  > code, I don't know how to set up the values in the tda182171_config
>  > struct.
>
>  Take USB-sniffs and look there correct configuration values.
>
I've looked at usb sniffs, and unfortunately I have no idea what I'm
looking at, I don't have a clue what goes where. I've never even
looked at a driver for anything before, so this is all new to me.

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
