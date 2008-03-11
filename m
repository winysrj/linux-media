Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hs-out-0708.google.com ([64.233.178.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JZDgT-0003WP-0W
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 00:15:07 +0100
Received: by hs-out-0708.google.com with SMTP id 4so2375796hsl.1
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 16:14:56 -0700 (PDT)
Message-ID: <47D71267.3090901@googlemail.com>
Date: Tue, 11 Mar 2008 23:14:47 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dvb fronted: LOCK but no data received.
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

I'd like to understand the behavior and meaning of the LOCK returned by the fronted.

If I open the fronted in readonly, and ask for the INFO, it is possible that I get a LOCK but no 
data is actually received.

This because the fronted receives data ONLY while it is opened in READ/WRITE.

In dvb_frontend.c, in dvb_frontend_open, the fronted is started via
dvb_frontend_start
only if it opened in READ/WRITE.

I see it as a misbehavior:

1) either a LOCK should NOT be returned
2) or the frontend should be started in any case (even if READ only)

Which ioctl call should I use to know if the fronted is currently active?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
