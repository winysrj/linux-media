Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.cooptel.qc.ca ([216.144.115.12] helo=amy.cooptel.qc.ca)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rlemieu@cooptel.qc.ca>) id 1KOtlx-0001ZX-6c
	for linux-dvb@linuxtv.org; Fri, 01 Aug 2008 14:30:18 +0200
Message-ID: <489301B6.3070706@cooptel.qc.ca>
Date: Fri, 01 Aug 2008 08:29:42 -0400
From: Richard Lemieux <rlemieu@cooptel.qc.ca>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dvbscan won't tune any channel while kaffeine does
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

I am not a developper so please forgive me for asking this question on this
list.

I just got a TBS8920 dvb-s2 PCI card that is based on the cx24116 chip.
The card came with a v4l driver that I compiled and installed.  The
kernel modules load and the card is recognized.

I have installe Kaffeine and the Kaffeine scan will find stations and
I can watch those stations.

I also compiled and installed dvb-apps-73b910014d07.tar.bz2 from which I
get 'dvbscan'

The problem is that 'dvbscan' won't find any channel. I used the command
'dvbscan /opt/dvb-apps-73b910014d07/util/scan/dvb-s/Galaxy3C-95w'
since I live in North-America and the dish points on that satellite.

Would anyone have a clue?  Why dvbscan does not find any station
while kaffeine does?

Thank's very much.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
