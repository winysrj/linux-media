Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KWuvs-0007fg-KV
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 17:21:41 +0200
Received: from pub5.ifh.de (pub5.ifh.de [141.34.15.197])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id
	m7NFL3EK024271
	for <linux-dvb@linuxtv.org>; Sat, 23 Aug 2008 17:21:03 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by pub5.ifh.de (Postfix) with ESMTP id 5F1312A01D8
	for <linux-dvb@linuxtv.org>; Sat, 23 Aug 2008 17:21:03 +0200 (CEST)
Date: Sat, 23 Aug 2008 17:21:03 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <200808231711.36277@orion.escape-edv.de>
Message-ID: <alpine.LRH.1.10.0808231716530.26788@pub5.ifh.de>
References: <48B00D6C.8080302@gmx.de> <48B01765.8020104@gmail.com>
	<200808231711.36277@orion.escape-edv.de>
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

Hi,

On Sat, 23 Aug 2008, Oliver Endriss wrote:
> Btw, I don't understand Patrick's workaround.

The Flexcop i2c-interface is not very flexible. You cannot send just a 
single write request with an independent read request following.

The same problematic applies for several USB-I2C requests as we have it in 
dvb-usb at several places.

In addition (see my other mail in that thread), sending two independent 
i2c_transfers which actually belong together is not really safe. (However 
I understand that for most single-receiver boards it is no real problem, 
as long as no one is using this i2c-adapter from user-space at the same 
time.)

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
