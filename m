Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gavermer@gmail.com>) id 1L7yJt-0007mC-81
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 21:27:38 +0100
Received: by ug-out-1314.google.com with SMTP id x30so3433323ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 03 Dec 2008 12:27:33 -0800 (PST)
Message-ID: <468e5d620812031227i18f646ebk1b098b88b2e56289@mail.gmail.com>
Date: Wed, 3 Dec 2008 21:27:32 +0100
From: "ga ver" <gavermer@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] error in make for scan-s2-51eceb97c3bd
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

I try to update my channels.conf file for vdr-1.7.0 and want tu use scan-s2
make scan-s2..... gives

:/usr/local/src/scan-s2# make
gcc -I../s2/linux/include -c diseqc.c -o diseqc.o
In file included from diseqc.c:7:
scan.h:86: fout: expected specifier-qualifier-list before 'fe_rolloff_t'
make: *** [diseqc.o] Fout 1

Fout=Error

I use Ubuntu 8.10
Kernel : Linux gv3 2.6.27-9-generic #1 SMP Thu Nov 20 22:15:32 UTC
2008 x86_64 GNU/Linux

thanks in advance
gavermer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
