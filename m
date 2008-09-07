Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KcDbz-0007x6-Pm
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 08:19:04 +0200
Message-ID: <48C37250.5090902@gmail.com>
Date: Sun, 07 Sep 2008 10:18:56 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Stefan Ellenberger <stefan_ell@hotmail.com>
References: <mailman.1.1219312801.18695.linux-dvb@linuxtv.org>
	<BAY108-W34A6237D826B4119100E1AFE6B0@phx.gbl>
In-Reply-To: <BAY108-W34A6237D826B4119100E1AFE6B0@phx.gbl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [multiproto patch] add support for using multiproto
 drivers with old api
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

Stefan Ellenberger wrote:
> hello list
> 
> I'm using Anssi Hannula patch (multiproto-support-old-api.diff from May 23) to use my Azurwave/Twinhan 1041 card with the old dvb api.
> 
> I can perfectly scan (using modified scan from manu) and tune the card (using szap2), but kaffeine (v0.8.6) and vdr (v1.6.0) show problems tuning with that card. It is sort of unreliable: sometimes tuning works fast and fine (namely if you stay on the sane transponder, just changing the pids) but sometimes output of vdr syslog stays like this:


> #lscpi
> 01:05.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] (rev 01)
> 
> The mantis sources I applied the patch to are from hg repository: http://www.linuxtv.org/wiki/index.php/Azurewave_AD_SP400_CI_(VP-1041)#Drivers> (Method 2)
> 
> I hope someone can shatter some light what I'm doing wrong and how it can be fixed to tune a little faster than one station lock per minute :-)
> 
> If modular log output is to short I can offer you a "verbosity level = 5"-built mantis module in action... actually it is built with verbosity level=1

Please load the modules with the following verbosity

stb0899 verbose=5
stb6100 verbose=5
mantis verbose=1

and send the logs

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
