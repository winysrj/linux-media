Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anothersname@googlemail.com>) id 1Jg78o-0000Pz-94
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 01:40:47 +0200
Received: by wa-out-1112.google.com with SMTP id m28so1719782wag.13
	for <linux-dvb@linuxtv.org>; Sun, 30 Mar 2008 16:40:40 -0700 (PDT)
Message-ID: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
Date: Mon, 31 Mar 2008 00:40:40 +0100
From: "Another Sillyname" <anothersname@googlemail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Lifeview DVB-T from v4l-dvb and Pinnacle Hybrid USb
	from v4l-dvb-kernel......help
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

I have a machine that has an internal card that's a Lifeview DVB and
works fine using the v4l-dvb mercurial sources.

I want to add a Pinnacle USB Hybrid stick (em28xx) that does not work
using the v4l-dvb sources but does work using the v4l-dvb-kernel
version.

1.  Will the number of em28xx cards supported by v4l-dvb be increased
shortly?  (My card id was 94 IIRC ).

2.  Can I mix and match from the sources...i.e. can I graft the em28xx
stuff from v4l-dvb-kernel into the v4l-dvb source and compile
successfully or has the underlying code changed at a more strategic
level?

3.  Why did the sources branch?  Was there a good technical reason for this?

4.  If I can't use the v4l-dvb sources to get my em28xx working what's
the chances of getting the v4l-dvb-kernel stuff working for the
lifeview flydvb card?

Thanks in advance.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
