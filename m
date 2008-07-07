Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.itsystems.ro ([89.35.193.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert@itsystems.ro>) id 1KFtrB-0002iL-Rl
	for linux-dvb@linuxtv.org; Mon, 07 Jul 2008 18:46:34 +0200
Message-ID: <48724855.9090507@itsystems.ro>
Date: Mon, 07 Jul 2008 19:46:13 +0300
From: Robert Grozea <robert@itsystems.ro>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] cx24113 - SkyStar2 Rev2.8
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

I tried to compile the cx24113.o_shipped driver for SkyStar2 Rev2.8 on 
Debian but when I try to load module with modprobe cx24113 i get an 
Undefinded Symbol in module error saying that the functions 
kmem_cache_zalloc cannot be found.
Any ideea where I did wrong ?

Best regards,

Robert

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
