Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JUPIm-0003qM-R6
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 17:38:40 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JWW0075GOV5VK70@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 27 Feb 2008 11:37:56 -0500 (EST)
Date: Wed, 27 Feb 2008 11:37:53 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <B9656900C45B4C1ABB0826229026D123@office.orcon.net.nz>
To: Craig Whitmore <lennon@orcon.net.nz>
Message-id: <47C591E1.5030001@linuxtv.org>
MIME-version: 1.0
References: <6101.203.163.71.197.1204088558.squirrel@webmail.stevencherie.no-ip.org>
	<B9656900C45B4C1ABB0826229026D123@office.orcon.net.nz>
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
> From: "Steven Ellis" <mail_lists@stevencherie.net>
> To: <linux-dvb@linuxtv.org>
> Sent: Wednesday, February 27, 2008 6:02 PM
> Subject: [linux-dvb] New Hauppauge DVB PCIe devices HVR-2200,HVR-1700 and 
> HVR-1200
> 
> 
>> Been reading up on these as it appears that the HVR-2200 is now available
>> in Australia. I've updated the Wiki
>> (http://www.linuxtv.org/wiki/index.php/Hauppauge) with initial pages for
>> all of these cards, but I don't have any chip or technical details yet.
>>
> 
> The wholesalers in NZ have these 3 new cards as well in (but only the 2200 
> in stock at the moment). If I read right a while ago no PCI-E cards have any 
> drivers yet
> 
> Its low profile which is good and from the pictures I've found can't really 
> see the chipset its using.

These are Philips/NXP PCIe bridges, not supported under Linux.  Manu is 
working on a driver for the same family of silicon but don't assume 
anything.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
