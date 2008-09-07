Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KcRGv-0005iV-Uh
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 22:54:17 +0200
Message-ID: <48C43F67.6060704@gmail.com>
Date: Mon, 08 Sep 2008 00:53:59 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: ajurik@quick.cz
References: <200807170023.57637.ajurik@quick.cz>
In-Reply-To: <200807170023.57637.ajurik@quick.cz>
Cc: linux-dvb@linuxtv.org
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


When you set for a higher gain, (generally: for a Class C/tuned
amplifier) the available bandwidth becomes narrower. So what you see, is
quite typical for a pre-stage set up for a higher i/p gain factor.


> When setting those parameters constantly to values used under Windows nothing 
> change. So maybe some cooperation with stb0899 part of driver is necessary. 

When the bandwidth changes, the stb0899's step size also might change,
though the demodulator can easily track a slightly off-centered signal,
though not the ideal case. Involves a bit of an additional overhead on
the on-chip CPU, as far as i can think.


> Also it is interesting that clock speed of i2c bus is 278kHz, not 400kHz 
> (measured with digital oscilloscope). But this should not have any influence.
> 
> Maybe somebody will be so capable to continue?

The patch looks fine as to temporarily disable the PLL loop initially
and enable it later on. Will apply this change.

Thanks,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
