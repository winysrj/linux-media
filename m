Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx34.mail.ru ([94.100.176.48])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1M52qg-0000CR-Lu
	for linux-dvb@linuxtv.org; Fri, 15 May 2009 21:13:39 +0200
Received: from [92.101.141.47] (port=25625 helo=localhost.localdomain)
	by mx34.mail.ru with asmtp id 1M52q6-0003bT-00
	for linux-dvb@linuxtv.org; Fri, 15 May 2009 23:13:02 +0400
Date: Fri, 15 May 2009 23:16:09 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20090515231609.0ba14254@bk.ru>
In-Reply-To: <8566f5bc0905140646x6aaeb3ecq14e3c2c72b176e7@mail.gmail.com>
References: <8566f5bc0905140646x6aaeb3ecq14e3c2c72b176e7@mail.gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] DVB-S2 frontend doesn't work!
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

> I have a problem with my HVR-4000 card.
> 
> I installed the firmware cx24116 find on
> http://tevii.com/Tevii_linuxdriver_0815.rar
> sudo cp tevii_linuxdriver_0815/fw/dvb-fe-cx24116.fw
> /lib/firmware/dvb-fe-cx24116-1.23.86.1.fw
> sudo ln -s /lib/firmware/dvb-fe-cx24116-1.23.86.1.fw
> /lib/firmware/dvb-fe-cx24116.fw
> 
> I installed S2API find on http://linuxtv.org/hg/~stoth/s2/

please use http://mercurial.intuxication.org/hg/s2-liplianin

> and I installed szap-s2 find on http://mercurial.intuxication.org/hg/szap-s2
> 
> Every seems to be ok...
> I can tune an DVB-S signal, but not DVB-S2...
> I try to tune a DVB-S2 signal with a symbols rate of 75335000 (>45000000)
> and I have this error message with dmesg :
> 
> [ 450.409150] DVB: frontend 0 symbol rate 75335000 out of range
> (1000000..45000000)
> 
> So I try dvbsnoop to see the frontend information :
> 
> # dvbsnoop -s feinfo
> dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/

dvbsnoop doesn't work with s2api 


Goga




_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
