Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.krastelcom.ru ([88.151.248.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vpr@krastelcom.ru>) id 1K6eN6-0004i0-7M
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 06:27:12 +0200
Message-Id: <20B2C1F8-9DFE-43C1-BACD-22DC74AE9136@krastelcom.ru>
From: Vladimir Prudnikov <vpr@krastelcom.ru>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Thu, 12 Jun 2008 08:12:04 +0400
Subject: [linux-dvb] Smit CAM problems
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

Hello!

I'm using SMIT cams to descramble channels on TT S-1500 and TT- 
S2-3200. After some time of normal operation SMIT cams drop out and  
stop decrypting the stream. It needs to be removed from the CI slot  
and reinserted to resume normal operation. Aston CAMs have no such  
problems, but they don't support 0x652 Irdeto.
I'm streaming with vlc. Tried many SMITs (Viaccess and Irdeto). Same  
problem everywhere.

Regards,
Vladimir

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
