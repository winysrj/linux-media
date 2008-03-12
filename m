Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JZOFg-0003RP-Qf
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 11:32:05 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1240920tia.13
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 03:31:59 -0700 (PDT)
Message-ID: <abf3e5070803120331h5f31e5c2nf3d1b6493b6f98ab@mail.gmail.com>
Date: Wed, 12 Mar 2008 21:31:59 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Ben Backx" <ben@bbackx.com>
In-Reply-To: <000f01c8842b$a899efe0$f9cdcfa0$@com>
MIME-Version: 1.0
Content-Disposition: inline
References: <000f01c8842b$a899efe0$f9cdcfa0$@com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Implementing support for multi-channel
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

2008/3/12 Ben Backx <ben@bbackx.com>:
>
>
>
> Hello,
>
> I was wondering if there's some info to find on how to implement (and test)
> multi-channel receiving?
>
> It's possible, because dvb uses streams and the driver is currently capable
> to filter one channel, but how can I implement the support of multi-channel
> filtering?
>
> Is there perhaps an open-source driver supporting this that I can have a
> look at?
>

AFAIK tuners can already receive from multiple channels as long as they
are on the same transponder (I think that's the right word). So in Australia
you can receive channel 7 and the channel 7 guide because they are
broadcast together. But I don't think you can do anymore than that.

I think mythtv is capable of doing it so you could have a look at that.

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
