Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <l.pinguin@gmail.com>) id 1JiG2c-0002lK-Um
	for linux-dvb@linuxtv.org; Sat, 05 Apr 2008 23:35:16 +0200
Received: by yw-out-2324.google.com with SMTP id 5so120950ywh.41
	for <linux-dvb@linuxtv.org>; Sat, 05 Apr 2008 14:35:09 -0700 (PDT)
Message-ID: <3efb10970804051435y335c7af0xf5c0438988aaa325@mail.gmail.com>
Date: Sat, 5 Apr 2008 23:35:09 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: linux-dvb@linuxtv.org, "Manu Abraham" <abraham.manu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] scan does not work on latest multiproto drivers
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

I hope anybody can tell me what I do wrong here.

I have a TT-3200 DVB-S2 board, and I am trying to get it up and
running while using the latest multiproto drivers.

I pulled the sources from "http://jusst.de/hg/multiproto", They
compile properly against 2.6.24.4 (fedora 8), and seem to load
properly, because the board is properly recognized.

Then I pulled the dvb-apps tools from
"http://linuxtv.org/hg/dvb-apps", and compiled towards the headers of
the multiproto drivers.
These compile properly but does not work when I start "./scan -v
dvb-s/Astra-19.2E > ./my-channels.conf", I get this error:
"stb0899_search: Unsupported delivery system" in dmesg

Then I tried the sources from: "http://jusst.de/manu/scan.tar.bz2".
These sources do not compile against the latest multiproto, I get these errors:
scan.c: In function 'tune_to_transponder':
scan.c:1682: error: 'struct dvbfe_info' has no member named 'delivery'
scan.c:1684: error: 'struct dvbfe_info' has no member named 'delivery'
scan.c:1693: error: 'struct dvbfe_info' has no member named 'delivery'
scan.c:1704: error: 'struct dvbfe_info' has no member named 'delivery'

So, I must be doing something wrong, but I have no idea what is wrong.

Does anybody have some ideas/suggestions?


Kind Regards,

Remy

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
