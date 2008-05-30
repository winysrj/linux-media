Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2.dnainternet.fi ([87.94.96.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K2BFc-0008LA-8t
	for linux-dvb@linuxtv.org; Fri, 30 May 2008 22:31:01 +0200
Received: from localhost.localdomain (dyn3-82-128-187-102.psoas.suomi.net
	[82.128.187.102])
	by smtp2.dnainternet.fi (Postfix) with ESMTP id 82D3DCD3C
	for <linux-dvb@linuxtv.org>; Fri, 30 May 2008 23:30:25 +0300 (EEST)
Message-ID: <484063E1.9010109@iki.fi>
Date: Fri, 30 May 2008 23:30:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1212079844.26238.22.camel@rommel.snap.tv>	<483EED5A.7080200@iki.fi>	<48400833.60909@gmail.com>	<48401099.7040908@iki.fi>	<484014AC.3090603@gmail.com>
	<48401C63.1010601@iki.fi>
In-Reply-To: <48401C63.1010601@iki.fi>
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

Antti Palosaari wrote:
> e9hack wrote:
>> Antti Palosaari schrieb:
>>>> I think the oops occurs, because tda10023_writereg() fails in tda10023_attach(). If 
>>>> tda10023_writereg fails, an error message is printed. In this case, 
>>>> state->frontend.dvb->num is accessed, but it isn't initialized yet.
>>> hmm, I see the problem now. Originally state was initialized before 
>>> tda10023_writereg() was called but after I did some changes this is not 
>>> done anymore. And when writereg() fails in attach some reason it oops.
>> It wasn't introduced with your modifications. The frontend.dvb part is initialized after 
>> the attach call. tda10023_writereg() must check, if state->frontend.dvb is initialized or 
>> not.
> 
> yeah, you are correct. I looked through all frontend drivers and only 
> TDA10021 and TDA10023 was using dvb->num in writereg. Anyhow, TDA10021 
> is not affected because it does not write in attach.

TDA10023 uses writereg to wakeup from standby for reading chip id. I 
wonder if this is necessary at all. I will test that later.

Anyhow, I see there is two ways to fix that (only Oops from TDA10023, 
not issue why it actually fails):
1) remove state->frontend.dvb->num from tda10023_writereg()
2) remove wakeup if in standby from tda10023_attach()

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
