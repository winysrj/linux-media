Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jcibt-00078k-Iv
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 15:52:46 +0100
Received: from [192.168.1.106] (84.251.151.89) by
	pne-smtpout3-sn2.hy.skanova.net (7.3.129)
	id 478BDB960039B811 for linux-dvb@linuxtv.org;
	Fri, 21 Mar 2008 15:51:46 +0100
Message-ID: <47E3CB84.3060208@iki.fi>
Date: Fri, 21 Mar 2008 16:51:48 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] How to disable RC-polling from driver
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

moi
Is there any designed way (for example callback) to disable RC-polling 
(disable_rc_polling) from dvb-usb-driver module in runtime? There is 
information regarding remote controller usage stored in eeprom and 
therefore it is not possible use dvb_usb_device_properties structure 
(structure is populated earlier).

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
