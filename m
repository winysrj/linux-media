Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <glemsom@gmail.com>) id 1LCvaU-0000sT-69
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 13:33:16 +0100
Received: by ug-out-1314.google.com with SMTP id x30so327896ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 04:33:10 -0800 (PST)
Message-ID: <d65b1b150812170433j717c673ak4489cdbbc10c29a3@mail.gmail.com>
Date: Wed, 17 Dec 2008 13:33:10 +0100
From: "Glenn Sommer" <glemsom@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] TT c-1501 getting timed out waiting for end of xfer
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

I'm using a TT c-1501 card on a asrock p43twin1600 mainbaord.

I keep getting these messages: "saa7146 (0) saa7146_i2c_writeout
[irq]: timed out waiting for end of xfer"
As far as I can see it happens often during tuning to channels.

Google tells me other people have seen this - but I'm unable to find a
solution... And I cannot quite figure out why it happens?

(I've tried the latest snapshot of v4l-dvb.)


Regards
Glenn Sommer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
