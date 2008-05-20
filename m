Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JyPEX-0006hP-Ik
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 12:38:18 +0200
Received: from pub6.ifh.de (pub6.ifh.de [141.34.15.118])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id
	m4KAbd89024443
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 12:37:39 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by pub6.ifh.de (Postfix) with ESMTP id 6910B1199B9
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 12:37:39 +0200 (CEST)
Date: Tue, 20 May 2008 12:37:39 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <Pine.LNX.4.64.0804062251380.6749@pub5.ifh.de>
Message-ID: <Pine.LNX.4.64.0805201233050.23556@pub6.ifh.de>
References: <Pine.LNX.4.64.0804062251380.6749@pub5.ifh.de>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Technisat SkyStar2 rev 2.7 and 2.8 status
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

Update:

Technisat just told me, that they will release a binary driver for the 
cx24113 quite soon on their website (along with instructions). It will 
work with a recent v4l-dvb, if not with the latest.

They did not give me a date. I just know that they have something and that 
they are going to release it.

Patrick.

On Sun, 6 Apr 2008, Patrick Boettcher wrote:

> Hi all,
>
> I have some good news for some of you and not yet good news for some others.
>
> First of all I have to say sorry, because I was relatively quiet recently 
> even though I promised to be more open. To cut things short, I could not give 
> any docs or code to other to help development, that's why I had to do it 
> myself.
>
> To cut things even shorter: on http://linuxtv.org/hg/~pb/v4l-dvb/ I just 
> committed support for the SkyStar2 rev 2.7. I finished the changes needed in 
> the s5h1420-driver and added the itd1000-driver. I'm using this card right 
> now - it works. I don't know whether it works for everyone (I can't try 
> Diseqc or any Satelite except Astra 19.2). I'm looking forward to hear some 
> feedback about the driver.
>
> Not so good news for the rev 2.8 users, yet. The driver is finished (I'm 
> using it since 2 weeks under the same conditions as above), but I cannot make 
> it open source yet, I'm doing my best to do it and will announce it, as soon 
> as I have news.
>
> Good luck at least for the 2.7 testers,
> Patrick.
>
> --
>   Mail: patrick.boettcher@desy.de
>   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
>
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
