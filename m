Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bene2.itea.ntnu.no ([129.241.56.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mathieu.taillefumier@free.fr>) id 1KtHai-0005bA-E6
	for linux-dvb@linuxtv.org; Fri, 24 Oct 2008 10:00:17 +0200
Message-ID: <4901808C.30805@free.fr>
Date: Fri, 24 Oct 2008 10:00:12 +0200
From: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <1223741522.48f0d052c956b@webmail.free.fr>	
	<1223753645.3125.57.camel@palomino.walls.org>	
	<1223768859.2706.15.camel@pc10.localdom.local>
	<49004726.4020601@free.fr>
	<1224799930.4202.17.camel@pc10.localdom.local>
In-Reply-To: <1224799930.4202.17.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134 bug in 64 bits system
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

I located the problem by doing the following experiment. I boot the 
kernel with only 2G installed and everything worked fine. No if you come 
back to the initial configuration it crash badly. A little digging on 
google gave some nice information. It seems that this problem is the 
combination of a bug in the bios and/or in the pci resource allocation. 
So I will report this to the kernel list.

> Just a shot into the dark, sorry again.
> All 28 gpios are set to output, but that is not intended by the driver.
> Previously seen such devices came up with gpio init 0.
>    

> After that, all IRQs fail and i2c too.
>
> Maybe the pci=nomsi kernel boot option is worth a try.
>    
I will try that.

Thanks for the help

Mathieu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
