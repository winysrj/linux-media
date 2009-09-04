Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta006e.interbusiness.it ([88.44.62.6])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <assorgia@acagliari.it>) id 1MjVdz-0003Wy-Ok
	for linux-dvb@linuxtv.org; Fri, 04 Sep 2009 12:03:48 +0200
Received: from localhost (mail.vlk.it [127.0.0.1])
	by mail.retevenditaitalia.com (Postfix) with ESMTP id 9010D2DAB79
	for <linux-dvb@linuxtv.org>; Fri,  4 Sep 2009 12:03:10 +0200 (CEST)
Received: from mail.retevenditaitalia.com ([127.0.0.1])
	by localhost (mail.vlk.it [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Gql+snxmXkv4 for <linux-dvb@linuxtv.org>;
	Fri,  4 Sep 2009 12:03:10 +0200 (CEST)
Received: from [192.168.1.60] (unknown [192.168.1.60])
	by mail.retevenditaitalia.com (Postfix) with ESMTPS id 6BAB42DAB78
	for <linux-dvb@linuxtv.org>; Fri,  4 Sep 2009 12:03:10 +0200 (CEST)
Message-ID: <4AA0E5DC.1020605@acagliari.it>
Date: Fri, 04 Sep 2009 12:03:08 +0200
From: Andrea Assorgia <assorgia@acagliari.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Dump from dvr0 at constant rate even on no-signal
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello to all

I'm dumping a dvb-t stream from dvr0 using tzap -r

The problem is that in case of temporary signal loss the stream outputs 
no data, producing recordings slightly shorter  then one would expect.   
For example, if I dump the stream for half an hour, and during that 
time, some signal loss occur for a total of 10 seconds I get an mpeg of 
1790 secs instead of 1800.

Is there a way to tell tzap (or some other mean of dumping from dvb-t) 
to stream blank frames instead of handing no data at all in case of 
signal loss?

I've been trying to use ffmpeg to mux the stream with a local (and thus 
more stable) silent audio track, but with poor results. Do you think 
this is the right way and deserve some more investingation?

Has anyone had the same problem and solved it?

Thanks for your replies.

Andrea Assorgia



-- 
Andrea Assorgia
Acagliari.it

email: assorgia@acagliari.it
mob: +39 328 7544769
 


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
