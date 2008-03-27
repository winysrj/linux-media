Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.krastelcom.ru ([88.151.248.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vpr@krastelcom.ru>) id 1JesT7-0005Kq-2T
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 14:48:37 +0100
Message-Id: <B4C067E3-1E8B-417B-9FBD-E979C0809751@krastelcom.ru>
From: Vladimir Prudnikov <vpr@krastelcom.ru>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Thu, 27 Mar 2008 16:48:27 +0300
Subject: [linux-dvb] Discontinuity and errors with multiple PCI DVB S2-3200
	in one PC
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

Trying to make multiple S2-3200 work in one PC. Out of 5 cards fitted  
at the same time only one is working fine. Others give discontinuity  
and transport errors. When I leave 4 cards - I have 2 working.
I'm using a passive PCI backplane with 12 PCI (CAM module requires a  
separate PCI just for fitting. Could be a problem with IRQ (4 cards  
get the same IRQ and are detected on the same bus in BIOS). Any clue  
someone?

Regards,
Vladimir

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
