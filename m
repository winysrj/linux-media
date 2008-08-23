Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KWvQs-0001pO-L5
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 17:53:43 +0200
Received: from pub5.ifh.de (pub5.ifh.de [141.34.15.197])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id
	m7NFr5pY027331
	for <linux-dvb@linuxtv.org>; Sat, 23 Aug 2008 17:53:05 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by pub5.ifh.de (Postfix) with ESMTP id 175C42A01D8
	for <linux-dvb@linuxtv.org>; Sat, 23 Aug 2008 17:53:05 +0200 (CEST)
Date: Sat, 23 Aug 2008 17:53:05 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <200808231748.54615@orion.escape-edv.de>
Message-ID: <alpine.LRH.1.10.0808231750550.26788@pub5.ifh.de>
References: <48B00D6C.8080302@gmx.de> <200808231711.36277@orion.escape-edv.de>
	<alpine.LRH.1.10.0808231716530.26788@pub5.ifh.de>
	<200808231748.54615@orion.escape-edv.de>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
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

On Sat, 23 Aug 2008, Oliver Endriss wrote:
>> In addition (see my other mail in that thread), sending two independent
>> i2c_transfers which actually belong together is not really safe.
>
> The current code in the else path will *never* work, because the tuner
> does not support repeated start conditions. The problem is not the I2C
> master (saa7146/flexcop) but the I2C slave (s5h1420).

Wouldn't it be more correct to have a flag signaling to the 
i2c_tranfer-function that a repeated start is not wanted even though it is 
two i2c-messages glued (which are interpreted today as a read with
repeated start).

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
