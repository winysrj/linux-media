Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1KUQ9x-0007VO-3L
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 20:05:54 +0200
Message-ID: <48A716F9.8030206@kolumbus.fi>
Date: Sat, 16 Aug 2008 21:05:45 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Possible stream quality improvement for jusst.de branch
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


Hi Manu and others who use jusst.de/mantis branch.

I've heard from Jouni Karvo that my Mantis DMA transfer patch
has removed glitches from the DVB stream.

He has Terratec Cinergy C DVB card (jusst.de branch).
I've seen similar improvement, but I have Twinhan 2033 C DVB card (my 
own version of jusst.de branch).

Here is a reference to my DMA transfer patch:
http://linuxtv.org/pipermail/linux-dvb/2008-July/027226.html

I hope that some of those who have glitches or who loses the stream 
(audio/video) entirely with jusst.de branch,
will test my patch.

Regards,
Marko Ristola


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
