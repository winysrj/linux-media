Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KN9UO-0007rE-6X
	for linux-dvb@linuxtv.org; Sun, 27 Jul 2008 18:52:58 +0200
Message-ID: <488CA7DF.2030705@gmail.com>
Date: Sun, 27 Jul 2008 20:52:47 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Andrea Venturi <a.venturi@avalpa.com>
References: <1217175868.488ca13cca2b2@webmail.iperbole.bologna.it>
In-Reply-To: <1217175868.488ca13cca2b2@webmail.iperbole.bologna.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7162 linux driver docs or development?
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

Andrea Venturi wrote:
> hi,
> 
> i've puschased a new DVB-T adapter made by lifeview:
> 
> it's called flytv express m5 mst t2a2
> 
> http://www.lifeview.com.tw/html/products/external_tv/flytv_express_m5_mst_t2a2.htm
> 
> it has a saa7162 pci-express bridge, here it's described:
> 
>   http://www.linuxtv.org/v4lwiki/index.php/Saa7162_devices
> 
> my card, an external ExpressCard is missing, maybe i'll fill the wiki with a
> description.
> 
> anyway i see that linux support of this multimedia chip has been surfacing in
> May 2007:
> 
>   http://www.linuxtv.org/pipermail/linux-dvb/2007-May/017856.html
> 
> but then it was never heard again..
> 

The SAA716x development tree is hosted here: http://jusst.de/hg/saa716x/
We've have quite some support from NXP officially. The driver is not
really functional yet though.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
