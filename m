Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1KeqoX-0001gK-LK
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 14:34:55 +0200
From: Matthias Dahl <mldvb@mortal-soul.de>
To: linux-dvb@linuxtv.org
Date: Sun, 14 Sep 2008 14:34:46 +0200
References: <48C3178F.6050704@gmx.de>
In-Reply-To: <48C3178F.6050704@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809141434.48564.mldvb@mortal-soul.de>
Subject: Re: [linux-dvb] Problem with mantis drivers for Terratec Cinergy C
	and CAM
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

Hello Clemens.

On Sunday 07 September 2008 01:51:43 Clemens Sutor wrote:

> [   86.389545] dvb_ca adapter 0: CAM tried to send a buffer larger than the
> link buffer size (49158 > 128)!
> [   86.491022] dvb_ca adapter 0: CAM tried to send a buffer larger than the
> ecount size!
> [   86.491027] dvb_ca adapter 0: DVB CAM link initialisation failed :(

This sounds very familiar. Due the fact that the dvb_ca_50221.c implementation 
is the same in the mantis tree, you could be suffering from the same problem 
I had. Just to be sure before I send you a patch to try: does it happen more 
or less randomly or right after vdr is up and running? Could you please 
provide some more informations about your system?

Thanks and have a nice sunday,
matthias.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
