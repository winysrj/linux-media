Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@makhutov.org>) id 1LR2FF-0005D1-V7
	for linux-dvb@linuxtv.org; Sun, 25 Jan 2009 11:29:38 +0100
Received: from [IPv6:2001:6f8:115f:1:218:8bff:feb8:de92] (unknown
	[IPv6:2001:6f8:115f:1:218:8bff:feb8:de92])
	by bane.moelleritberatung.de (Postfix) with ESMTPSA id 9A5FD99BE0
	for <linux-dvb@linuxtv.org>; Sun, 25 Jan 2009 11:29:34 +0100 (CET)
Message-ID: <497C3F0F.1040107@makhutov.org>
Date: Sun, 25 Jan 2009 11:29:35 +0100
From: Artem Makhutov <artem@makhutov.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] How to use scan-s2?
Reply-To: linux-media@vger.kernel.org
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

I am wondering on how to use scan-s2.

When running scan-s2 like this I am only getting 13 services:

scan-s2 -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf

when running

scan-s2 -a 2 -n -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf

then I am getting 152 services.

When running the old dvbscan application I am getting 1461 services:

dvbscan -a 2 -o zap /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf


Have I missed a parameter in scan-s2 or what else could be the problem?

Thanks, Artem



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
