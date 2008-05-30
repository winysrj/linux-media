Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K25hk-0004hQ-NG
	for linux-dvb@linuxtv.org; Fri, 30 May 2008 16:35:45 +0200
Received: from localhost.localdomain (dyn3-82-128-187-102.psoas.suomi.net
	[82.128.187.102])
	by smtp1.dnainternet.fi (Postfix) with ESMTP id 5158ACB21
	for <linux-dvb@linuxtv.org>; Fri, 30 May 2008 17:35:06 +0300 (EEST)
Message-ID: <48401099.7040908@iki.fi>
Date: Fri, 30 May 2008 17:35:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <1212079844.26238.22.camel@rommel.snap.tv>	<483EED5A.7080200@iki.fi>
	<48400833.60909@gmail.com>
In-Reply-To: <48400833.60909@gmail.com>
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

e9hack wrote:
> Antti Palosaari schrieb:
>> Sigmund Augdal wrote:
>>> using latest hg v4l-dvb on a 2.6.20 kernel.
>> I did some changes recently to tda10023 (needed for Anysee driver). I 
>> wonder if these errors start coming after that? Those changes are 
>> committed to master only few days ago, 05/26/2008.
> 
> I think the oops occurs, because tda10023_writereg() fails in tda10023_attach(). If 
> tda10023_writereg fails, an error message is printed. In this case, 
> state->frontend.dvb->num is accessed, but it isn't initialized yet.

hmm, I see the problem now. Originally state was initialized before 
tda10023_writereg() was called but after I did some changes this is not 
done anymore. And when writereg() fails in attach some reason it oops.

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
