Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JUl44-00012H-DK
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 16:52:56 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JWY001RLHEUB430@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 28 Feb 2008 10:52:07 -0500 (EST)
Date: Thu, 28 Feb 2008 10:52:05 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <050744F346934852A708EE5DB9CE8BBE@CraigPC>
To: Craig Whitmore <lennon@orcon.net.nz>
Message-id: <47C6D8A5.2070906@linuxtv.org>
MIME-version: 1.0
References: <6101.203.163.71.197.1204088558.squirrel@webmail.stevencherie.no-ip.org>
	<B9656900C45B4C1ABB0826229026D123@office.orcon.net.nz>
	<47C591E1.5030001@linuxtv.org> <002a01c87962$8d8293c0$2727a8c0@pc1>
	<47C5996A.2070404@linuxtv.org>
	<001b01c8793b$92ab2460$6e00a8c0@barny1e59e583e>
	<001e01c87991$fd84d960$2727a8c0@pc1>
	<050744F346934852A708EE5DB9CE8BBE@CraigPC>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] New Hauppauge DVB PCIe devices HVR-2200,
 HVR-1700 and HVR-1200
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

Craig Whitmore wrote:
> ----- Original Message ----- 
> From: "Halim Sahin" <halim.sahin@t-online.de>
> To: <linux-dvb@linuxtv.org>
> Sent: Thursday, February 28, 2008 11:42 AM
> Subject: Re: [linux-dvb] New Hauppauge DVB PCIe devices HVR-2200,HVR-1700 
> and HVR-1200
> 
> 
> Has anyone actually put a HVR-2200 in a linux box and seen what happens? 
> does linux find nothing or what? What exactly makes PCI-E cards hard to 
> start to get right (or its not hard.. just no one has had time to do it?)

lspci It will look like a normal PCI/PCI-e device with the appropriate 
PCI device id's.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
