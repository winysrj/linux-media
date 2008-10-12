Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38806.mail.mud.yahoo.com ([209.191.125.97])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <krabaey@yahoo.com>) id 1Kow9n-00008I-W8
	for linux-dvb@linuxtv.org; Sun, 12 Oct 2008 10:18:35 +0200
Date: Sun, 12 Oct 2008 01:17:56 -0700 (PDT)
From: Koen Rabaey <krabaey@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <442626.63058.qm@web38806.mail.mud.yahoo.com>
Subject: [linux-dvb] cx88_wakeup message with HVR4000
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

I don't know if it is of any use to anyone, but when I do a dmesg after booting, 
at the end I get (from time to time, not consistently, the number of buffers also varies)

[  123.601789] cx88_wakeup: 7 buffers handled (should be 1)
[  123.751892] cx88_wakeup: 7 buffers handled (should be 1)

This does not seem to interfere with dvb playback however.

I'm owning an HVR4000, compiled with http://linuxtv.org/hg/~stoth/s2/ 
on a '2.6.27-4-generic' kernel.

Kind regards,

Koen


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
