Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KtRZt-0003x3-4V
	for linux-dvb@linuxtv.org; Fri, 24 Oct 2008 20:40:06 +0200
Date: Fri, 24 Oct 2008 20:39:25 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: sinter.mann@gmx.de
In-Reply-To: <20081024163050.10790@gmx.net>
Message-ID: <alpine.LRH.1.10.0810242036450.19293@pub2.ifh.de>
References: <20081024163050.10790@gmx.net>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat Skystar Revision 2.8 broken in kernel
 2.6.28-rc1
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

On Fri, 24 Oct 2008, sinter.mann@gmx.de wrote:
> Hi everybody,
>
> neither with the latest Mercurial tree from linuxtv.org nor within the 
> latest kernel 2.6.28-rc1 the Technisat Skystar DVB-S card is usable.
>
> To resolve this as an intermediate solution I appended 2 patchsets as 
> outline attachment:
>
> a. skystar2_rev2.8.tar.bz2: the basic patch to run this card with a 
> current kernel >= 2.6.27 - including a self-written docu and patches by 
> Patrick Boettcher plus a precompiled cx24113 module, because this part 
> is still not GPL
>
> b. skystar2628.diff: A reversion concerning modules dvb_frontend.c and 
> dvb_frontend.h: Without that reversion that card runs excellently under 
> kernel 2.6.27. With that reversion that card runs excellently under 
> 2.6.28-rc1.

As part of this driver (cx24113) is a out-of-tree driver and even worse 
only available as a binary, please also request support from Technisat. 
They should handle that for the user who does not want to patch his 
kernel.

best regards,
Patrick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
