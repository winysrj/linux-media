Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <crow@linux.org.ba>) id 1Mlq4q-0000Nb-Fm
	for linux-dvb@linuxtv.org; Thu, 10 Sep 2009 22:17:09 +0200
Received: by fxm28 with SMTP id 28so380555fxm.17
	for <linux-dvb@linuxtv.org>; Thu, 10 Sep 2009 13:16:34 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 10 Sep 2009 22:16:33 +0200
Message-ID: <3c031ccc0909101316h1a76be6eg94509e9820f574e0@mail.gmail.com>
From: crow <crow@linux.org.ba>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TeVii S650 DVB-S2 USB und s2-liplianin drivers
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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
I tried today s2-liplianin drivers with tevii s650 and vdr cant lock
any channels with this error msg:

<---snip---->
<6>stv0900_search: <7><6>Search Fail
stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
<6>stb0900_set_property(..)
<6>stv0900_set_tone: On
<---snip--->

Then i found from old installation compiled drivers from rev12458 and
installed it and everything work fine
(s2-liplianin-hg-12458-1-i686.pkg.tar.gz).

I am on archlinux x86 with 2.6.30.5-1 kernel

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
