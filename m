Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jo0Na-0001tb-ST
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 20:04:39 +0200
Message-ID: <480CD719.9010909@iki.fi>
Date: Mon, 21 Apr 2008 21:04:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAAijN3xCp8g0Kp9uKDTg5IowEAAAAA@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAAijN3xCp8g0Kp9uKDTg5IowEAAAAA@tv-numeric.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy T USB XE Rev 2, any update ?
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

Thierry Lelegard wrote:
> Is there any news with the AF9015 and more specifically the Cinergy
> T USB XE Rev 2 ?

Main problem is that there is no tuner driver for Freescale MC44S803 
silicon tuner. Looks like there is code for MC44S803 on the net 
available (for example Terratec driver). Porting it to Linux should not 
be too big task.

There has been some development activity with AF9015 driver and now it 
initially works also for dual tuner (Maxlinear MXL5003/5) devices, like 
KWorld PlusTV 399U, TwinHan AzureWave AD-TU700(704J) and DigitalNow 
TinyTwin.

regards,
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
