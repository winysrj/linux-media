Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JZXxc-0007H1-SK
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 21:54:05 +0100
Received: by el-out-1112.google.com with SMTP id o28so1754730ele.2
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 13:54:00 -0700 (PDT)
Message-ID: <47D842E4.4090504@googlemail.com>
Date: Wed, 12 Mar 2008 20:53:56 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  dvb fronted: LOCK but no data received.
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

 > Hi,
 >
 > I'd like to understand the behavior and meaning of the LOCK returned by the fronted.
 >
 > If I open the fronted in readonly, and ask for the INFO, it is possible that I get a LOCK but no
 > data is actually received.
 >
 > This because the fronted receives data ONLY while it is opened in READ/WRITE.
 >
 > In dvb_frontend.c, in dvb_frontend_open, the fronted is started via
 > dvb_frontend_start
 > only if it opened in READ/WRITE.
 >
 > I see it as a misbehavior:
 >
 > 1) either a LOCK should NOT be returned
 > 2) or the frontend should be started in any case (even if READ only)
 >
 > Which ioctl call should I use to know if the fronted is currently active?

Anybody has an opinion about that?
I know, I cant spell frontend properly :-),

but other than that, what would be the correct behavior when opening the frontend in readonly?

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
