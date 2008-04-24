Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx38.mail.ru ([194.67.23.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1Jp6k9-0005qc-Em
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 21:04:31 +0200
Received: from [83.149.3.179] (port=2466 helo=localhost.localdomain)
	by mx38.mail.ru with asmtp id 1Jp6jY-000JIA-00
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 23:03:54 +0400
Date: Thu, 24 Apr 2008 22:29:51 +0400
From: Igor Nikanov <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080424222951.1580e34d@bk.ru>
Mime-Version: 1.0
Subject: [linux-dvb] HVR4000 & szap2 - ioctl DVBFE_GET_INFO failed:
 Operation not supported
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

Hi

I have installed the latest multiproto with hvr4000 patch from Gregoire Favre 
http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024487.html

after that I have installed the szap2 from dvb-apps 
But with szap2 I have the error ioctl DVBFE_GET_INFO failed: Operation not supported
Can somebody comment ?

# ./szap2 -c 19 -n1

reading channels from file '19'
zapping to 1 'Pro7':
sat 0, frequency = 12722 MHz H, symbolrate 22000000, vpid = 0x00ff, apid = 0x0103 sid = 0x27d8
Querying info .. Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ioctl DVBFE_GET_INFO failed: Operation not supported


Igor

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
