Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from alfons.lightcomp.cz ([77.78.100.69] helo=alfons.lightcomp.com)
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <michal@etc.cz>) id 1NGNTY-0005Ze-Di
	for linux-dvb@linuxtv.org; Fri, 04 Dec 2009 03:00:53 +0100
Received: from aurora.local (unknown [10.22.0.9])
	by alfons.lightcomp.com (Postfix) with ESMTP id E2581FA00DB
	for <linux-dvb@linuxtv.org>; Fri,  4 Dec 2009 03:00:47 +0100 (CET)
Message-ID: <4B186D4F.5090208@etc.cz>
Date: Fri, 04 Dec 2009 03:00:47 +0100
From: Michal Novotny <michal@etc.cz>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] The most stable DVB-T tuner
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all,

I've just bought dual tuner USB stick MyGica T1680 (af9015) and I'm 
unpleasantly surprised with the tuner stability (mxl5005s). I have a 
good signal but the card can't deliver error free streams. Femon shows 
signal 0xf000-0xffff, snr 0xb0-0x110 and ber almost always 0. Some 
errors (transport error bit set or missing TS packet) occur in the 
stream about every 3 minutes on average. It's not a problem of linux 
driver since the same errors can be found in TS recordings taken under 
windows. And it is also not a problem with the signal because I get a 
much better result with AverTV A800 USB (error about every 4 hours) and 
Nova-T LSI L64781 PCI (error about every 2 hours).

I assume that those problems are related to the tuner (correct me if I'm 
wrong). The MyGica T1680 USB stick is really bad, Nova-T PCI is quite 
good with good signal and AverTV A800 is the best, but it is 
discontinued product. I would like to build a dedicated STB with 2-3 
DVB-T tuners. So my question is: Is there any well known DVB-T card 
(preferably USB) that has a sensitive and stable tuner that can deliver 
error free streams?

Thanks for any tips,
Michal

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
