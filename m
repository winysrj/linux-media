Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qb-out-0506.google.com ([72.14.204.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.s.zakharin@gmail.com>) id 1Kpogj-00083v-FM
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 20:32:12 +0200
Received: by qb-out-0506.google.com with SMTP id e11so2163374qbe.25
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 11:32:05 -0700 (PDT)
Message-ID: <48F4E5A2.7080509@gmail.com>
Date: Tue, 14 Oct 2008 22:32:02 +0400
From: =?UTF-8?B?0JDQvdGC0L7QvQ==?= <a.s.zakharin@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  AverMedia AverTV Hybrid Express Slim
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

Hello to all.

I also have this card:
http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_Hybrid_Express_Slim_HC81R

I found all kernel modules for chips in this card (CX23885 XC3028 AF9013)
But nothing happened when I load them. For example when I load tuner-xc2028 or tuner-xc3028,
it seems that firmware doesn't loaded.
Only when I load cx23885 card=2 I found video0 and video1 in /dev
And if card=4 there is dvb/adapter0 folder and  "demux0  dvr0  frontend0  net0" on it.
They doesn't work in tvtime/kdetv. May be I do something wrong? It is my first tuner.
Can I test it otherwise?

P.S. Sorry for bad English.

Best regards,
Anton


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
