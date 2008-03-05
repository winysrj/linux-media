Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JX13u-00031l-J6
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 22:22:07 +0100
Received: from [87.194.114.122] (helo=wolf.philpem.me.uk)
	by holly.castlecore.com with esmtp (Exim 4.68)
	(envelope-from <lists@philpem.me.uk>) id 1JX13o-0001xc-0q
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 21:22:00 +0000
Received: from [10.0.0.8] (cheetah.homenet.philpem.me.uk [10.0.0.8])
	by wolf.philpem.me.uk (Postfix) with ESMTP id 7DE6E1AFD9D5
	for <linux-dvb@linuxtv.org>; Wed,  5 Mar 2008 21:22:41 +0000 (GMT)
Message-ID: <47CF0EEC.6080706@philpem.me.uk>
Date: Wed, 05 Mar 2008 21:21:48 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <47CF08B2.50008@philpem.me.uk>
In-Reply-To: <47CF08B2.50008@philpem.me.uk>
Subject: Re: [linux-dvb] Hauppauge Nova T-500 / Nova-TD Stick (DiBcom
 tuners/demods) - the plot thickens...
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

Philip Pemberton wrote:
> [ 3097.541301] ep 0 write error (status = -19, len: 4)
> [ 3097.541302] dvb-usb: error while stopping stream.

Forgot to mention -- after this mess, both tuners on the Nova-TD were dead.

I restarted mythbackend and they woke up again, then as soon as I tuned to a 
channel both of them fell over again (USB disconnect).

I think the EMI thing might have been a one-off -- the second disconnect was a 
standard one, not a "hub has disabled the port".

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
