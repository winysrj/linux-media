Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout.perfora.net ([74.208.4.194])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tlenz@vorgon.com>) id 1MWa8f-0002os-AY
	for linux-dvb@linuxtv.org; Thu, 30 Jul 2009 20:14:03 +0200
Message-ID: <000901ca1141$7cc4f730$0a00a8c0@vorg>
From: "Timothy D. Lenz" <tlenz@vorgon.com>
To: <linux-dvb@linuxtv.org>
Date: Thu, 30 Jul 2009 11:13:42 -0700
MIME-Version: 1.0
Subject: [linux-dvb] FusionHDTV7 Dual - second tunner crashing
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

I am runing vdr-1.7.8
linux 2.6.26.8
v4l hg - 315bc4b65b4f+

I have noticed that after vdr has been running for awhile, when I select the first channel in the conf i get the no signal xine
screen. Channel up/down or direct select does the same thing. other channels would work, but not that one. I went to the femon
plugin and noticed it was switching to the second tunner for that channel. I switched to the first and had signal. Tried other
channels and found that the second tunner wasn't working. restarted vdr and both tunners worked again.


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
