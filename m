Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailsender.it.unideb.hu ([193.6.138.90])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lnovak@dragon.unideb.hu>) id 1LQLb4-00077R-Fi
	for linux-dvb@linuxtv.org; Fri, 23 Jan 2009 13:57:20 +0100
Received: from mailfilter.it.unideb.hu (mailfilter.it.unideb.hu [193.6.138.89])
	by mailsender.it.unideb.hu (Postfix) with SMTP id DDC0A14BB80
	for <linux-dvb@linuxtv.org>; Fri, 23 Jan 2009 13:56:40 +0100 (CET)
Received: from [193.6.134.187] (novak.chem.klte.hu [193.6.134.187])
	by mailgw.it.unideb.hu (Postfix) with ESMTP id 482602CEAA2
	for <linux-dvb@linuxtv.org>; Fri, 23 Jan 2009 13:56:40 +0100 (CET)
From: Levente =?ISO-8859-1?Q?Nov=E1k?= <lnovak@dragon.unideb.hu>
To: linux-dvb@linuxtv.org
Date: Fri, 23 Jan 2009 13:56:40 +0100
Message-Id: <1232715400.13587.12.camel@novak.chem.klte.hu>
Mime-Version: 1.0
Subject: [linux-dvb] Which firmware for cx23885 and xc3028?
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

I am trying to make an AverMedia AverTV Hybrid Express (A577) work under
Linux. It seems all major chips (cx23885, xc3028 and af9013) are already
supported, so it should be doable in principle.

I am stuck a little bit since AFAIK both cx23885 and xc3028 need an
uploadable firmware. Where should I download/extract such firmware from?
I tried Steven Toth's repo (the Hauppauge HVR-1400 seems to be built
around these chips as well) but even after copying the files
under /lib/firmware it didn't really work. I tried to specify different
cardtypes for the cx23885 module. For cardtype=2 I got a /dev/video0 and
a /dev/video1 (the latter is of course unusable, I don't have a MPEG
encoder chip on my card) but tuning was unsuccesful. All the other types
I tried either didn't work at all or only resulted in dvb devices
detected. For the moment, I am fine without DVB, and are interested
mainly in analog devices.

Maybe I should locate the windows driver of my card and extract the
firmware files from it? If so, how do I proceed?

Thanks in advance!

Levente



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
