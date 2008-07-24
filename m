Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n25.bullet.mail.ukl.yahoo.com ([87.248.110.142])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1KLyMi-0006M7-NT
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 12:48:11 +0200
Date: Thu, 24 Jul 2008 10:06:39 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <200807170023.57637.ajurik@quick.cz>
MIME-Version: 1.0
Message-ID: <903564.39081.qm@web23201.mail.ird.yahoo.com>
Subject: Re: [linux-dvb] TT S2-3200 driver
Reply-To: newspaperman_germany@yahoo.com
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

Any idea why there are still parts of stream lost on DVB-s2 transponders with SR 30000 7/8? Is it a problem of HW Pid filters or SW Pid filters?

kind regards

Newsy


--- Ales Jurik <ajurik@quick.cz> schrieb am Do, 17.7.2008:

> Von: Ales Jurik <ajurik@quick.cz>
> Betreff: [linux-dvb] TT S2-3200 driver
> An: linux-dvb@linuxtv.org
> Datum: Donnerstag, 17. Juli 2008, 0:23
> Hi,
> 
> please try attached patch. With this patch I'm able to
> get lock on channels 
> before it was impossible. But not at all problematic
> channels and the 
> reception is not without errors. Also it seems to me that
> channel switching is 
> quicklier.
> 
> Within investigating I've found some problems, I've
> tried to compare data with 
> data sent by BDA drivers under Windows (by monitoring i2c
> bus between stb0899 
> and stb6100):
> 
> - under Windows stb6100 reports not so wide bandwith.
> (23-31MHz, 21-22MHz and 
> so on).
> - under Windows the gain is set by 1 or 2 higher.
> 
> When setting those parameters constantly to values used
> under Windows nothing 
> change. So maybe some cooperation with stb0899 part of
> driver is necessary. 
> 
> Also it is interesting that clock speed of i2c bus is
> 278kHz, not 400kHz 
> (measured with digital oscilloscope). But this should not
> have any influence.
> 
> Maybe somebody will be so capable to continue?
> 
> BR,
> 
> Ales_______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


      __________________________________________________________
Gesendet von Yahoo! Mail.
Dem pfiffigeren Posteingang.
http://de.overview.mail.yahoo.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
