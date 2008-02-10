Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dirk@brenken.org>) id 1JO6KW-00064U-S1
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 08:10:24 +0100
Message-ID: <47AEA346.9090406@brenken.org>
Date: Sun, 10 Feb 2008 08:09:58 +0100
From: Dirk Brenken <dirk@brenken.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <Pine.LNX.4.64.0801271922040.21518@pub2.ifh.de>	<479D1632.4010006@t-online.de>	<Pine.LNX.4.64.0801292211380.23532@pub2.ifh.de>	<479FB52A.6010401@t-online.de>	<Pine.LNX.4.64.0801300047520.23532@pub2.ifh.de>	<47A6438B.3060606@t-online.de>	<47A96D0E.1070509@web.de>	<1202288256.3442.20.camel@pc08.localdom.local>	<47AA53AC.6050402@t-online.de>	<Pine.LNX.4.64.0802072145030.14018@pub3.ifh.de>
	<47AE432A.3070007@t-online.de>
In-Reply-To: <47AE432A.3070007@t-online.de>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Subject: Re: [linux-dvb] TDA10086 with Pinnacle 400e tuning broken
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,
please do that - it's a fix for the following bugzilla entry ...

http://bugzilla.kernel.org/show_bug.cgi?id=9887

Best regards
Dirk

Hartmut Hackmann schrieb:
> Hi, all
> 
> I pushed the patch to my personal repository at
> 
>   http://linuxtv.org/hg/~hhackmann/v4l-dvb/
> 
> Do you agree that we should ask Linus to pull it as a bug fix?
> 
> Btw: tda10086 contains a number of coding style violations. I did not
> fix them to keep the patch as small as possible.
> 
> Best regards
>   Hartmut
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
