Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1K25yG-0006IC-Tp
	for linux-dvb@linuxtv.org; Fri, 30 May 2008 16:52:45 +0200
Received: by mu-out-0910.google.com with SMTP id w8so86399mue.1
	for <linux-dvb@linuxtv.org>; Fri, 30 May 2008 07:52:41 -0700 (PDT)
Message-ID: <484014AC.3090603@gmail.com>
Date: Fri, 30 May 2008 16:52:28 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1212079844.26238.22.camel@rommel.snap.tv>	<483EED5A.7080200@iki.fi>	<48400833.60909@gmail.com>
	<48401099.7040908@iki.fi>
In-Reply-To: <48401099.7040908@iki.fi>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] Oops in tda10023
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

Antti Palosaari schrieb:
>> I think the oops occurs, because tda10023_writereg() fails in tda10023_attach(). If 
>> tda10023_writereg fails, an error message is printed. In this case, 
>> state->frontend.dvb->num is accessed, but it isn't initialized yet.
> 
> hmm, I see the problem now. Originally state was initialized before 
> tda10023_writereg() was called but after I did some changes this is not 
> done anymore. And when writereg() fails in attach some reason it oops.

It wasn't introduced with your modifications. The frontend.dvb part is initialized after 
the attach call. tda10023_writereg() must check, if state->frontend.dvb is initialized or 
not.

-Hartmut


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
