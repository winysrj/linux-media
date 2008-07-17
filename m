Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1KJPda-0003t1-1E
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 11:19:13 +0200
Message-ID: <487F0E55.8020004@chaosmedia.org>
Date: Thu, 17 Jul 2008 11:18:13 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: ajurik@quick.cz, linux-dvb@linuxtv.org
References: <200807170023.57637.ajurik@quick.cz>
In-Reply-To: <200807170023.57637.ajurik@quick.cz>
Subject: Re: [linux-dvb] TT S2-3200 driver
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

just tried your patch and it seems to have its effect, i was able to 
tune to HB 13.0 11278.36 V DVB-S2 (8PSK) - 27500 2/3 - Eurosport HD 
which i wasn't able to tune before.

I've also tested all DVB-S2 QPSK / 8PSK transponders i have on astra 
19.2 and HB 13.0 and they all tune fine.
I can't really tell which ones weren't working with current multiproto 
because i don't use most of those channels but i know for sure that ESP 
HD on HB13 wasn't working, and now it is..

I've simply made quick tests with szap2 so i don't know if it's stable 
and so on but i do get a lock pretty quickly, same as DVBS transponders...

maybe other s2-3200 users can confirm thoses tests..

thx

Marc



Ales Jurik wrote:
> Hi,
>
> please try attached patch. With this patch I'm able to get lock on channels 
> before it was impossible. But not at all problematic channels and the 
> reception is not without errors. Also it seems to me that channel switching is 
> quicklier.
>
> Within investigating I've found some problems, I've tried to compare data with 
> data sent by BDA drivers under Windows (by monitoring i2c bus between stb0899 
> and stb6100):
>
> - under Windows stb6100 reports not so wide bandwith. (23-31MHz, 21-22MHz and 
> so on).
> - under Windows the gain is set by 1 or 2 higher.
>
> When setting those parameters constantly to values used under Windows nothing 
> change. So maybe some cooperation with stb0899 part of driver is necessary. 
>
> Also it is interesting that clock speed of i2c bus is 278kHz, not 400kHz 
> (measured with digital oscilloscope). But this should not have any influence.
>
> Maybe somebody will be so capable to continue?
>
> BR,
>
> Ales
>   
> ------------------------------------------------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
