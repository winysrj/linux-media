Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail.elion.ee ([194.126.117.142])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kasjas@hot.ee>) id 1JMicx-0006lU-0k
	for linux-dvb@linuxtv.org; Wed, 06 Feb 2008 12:39:43 +0100
Message-ID: <47A99C60.4070305@hot.ee>
Date: Wed, 06 Feb 2008 13:39:12 +0200
From: Arthur Konovalov <kasjas@hot.ee>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Changeset 7161 compile error on 2.6.24 kernel]
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Compiling of the current HG tree fails on kernel 2.6.24:

In file included from /usr/local/src/v4l-dvb/v4l/bt87x.c:34:
include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in a function)
make[3]: *** [/usr/local/src/v4l-dvb/v4l/bt87x.o] Error 1
make[2]: *** [_module_/usr/local/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.24'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/local/src/v4l-dvb/v4l'
make: *** [all] Error 2

Please help,
Arthur



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
