Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [195.156.147.13] (helo=jenni2.rokki.sonera.fi)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lwgt@iki.fi>) id 1JqUeN-0001TM-Lj
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 16:48:15 +0200
Received: from [127.0.0.1] (84.249.53.62) by jenni2.rokki.sonera.fi (8.0.013.9)
	id 481578A9000734AE for linux-dvb@linuxtv.org;
	Mon, 28 Apr 2008 17:48:12 +0300
Message-ID: <4815E3A9.1000306@iki.fi>
Date: Mon, 28 Apr 2008 17:48:09 +0300
From: Lauri Tischler <lwgt@iki.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Error messages with multiproto_plus
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

My syslog has zillions of these messages, one every 20 seconds

Apr 26 12:17:18 vdr2 kernel: dvb_frontend_ioctl: FESTATE_RETUNE:
fepriv->state=2
Apr 26 12:17:39 vdr2 kernel: dvb_frontend_ioctl: FESTATE_RETUNE:
fepriv->state=2

Running multiproto_plus + VDR 1.7.0
1xNEXUS-S + 2x NOVA-T

How do I get rid of those pesky things.

Cheers...


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
