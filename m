Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1K63Sg-0002DW-9t
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 15:00:32 +0200
Received: from PCTL ([194.250.18.140]) (authenticated)
	by smtp06.msg.oleane.net (MTA) with ESMTP id m5AD0O5Q017316
	for <linux-dvb@linuxtv.org>; Tue, 10 Jun 2008 15:00:24 +0200
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 10 Jun 2008 15:00:23 +0200
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAAqIryAWdio0mMXVBpGpDCPQEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Subject: [linux-dvb] Nova-T 500 again, receive hangs, no USB disconnect,
	no i2c failure
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

Hello,

Here is another problem with a Hauppauge Nova-T 500 ("DiBcom 3000MC/P"),
but this is not the classical usb disconnect or i2c failure.

Distro: Fedora 8
Kernel: 2.6.24.7-92.fc8
Linux DVB: hg pull http://linuxtv.org/hg/v4l-dvb on June 9
DIB firmware: dvb-usb-dib0700-1.10.fw

Here is the problem:

The first tuner stays constantly tuned on the same frequency and is
receiving a TS: OK.

The second tuner usage is cycling over 5 different frequencies:
  open + tune + receive TS during a few seconds + close + cycle again.

After a few dozens cycles (not always the same number), a read
operation on the dvr device hangs (never returns).

If you stop the application on the second tuner and restart it,
it works again for a few cycles, then hangs again. No message is
reported with dmesg (specifically, no USB disconnect and no i2c failure).

In the meantime, the application on the first tuner continues
without problem.

Any idea?

Regards,
-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
