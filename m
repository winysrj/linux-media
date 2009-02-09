Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1LWUOI-00046y-Ve
	for linux-dvb@linuxtv.org; Mon, 09 Feb 2009 12:33:31 +0100
Received: from nico2.od.loc (93.63.225.36) by relay-pt2.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 498F727F00004898 for linux-dvb@linuxtv.org;
	Mon, 9 Feb 2009 12:33:26 +0100
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Mon, 9 Feb 2009 12:33:26 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902091233.26086.Nicola.Sabbi@poste.it>
Subject: [linux-dvb] mt352 no more working after suspend to disk
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

Hi,
if I suspend to disk and next resume I have to manually remove and 
reload my mt352 driver, otherwise it complains of a lot of i2c 
errors.

My kernel is suse's 2.6.27.

Is this problem fixed in recent kernels or in hg?

Thanks,
	Nico

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
