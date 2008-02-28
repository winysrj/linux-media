Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JUgU1-0004fx-2i
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 11:59:25 +0100
Message-ID: <47C69404.3040504@shikadi.net>
Date: Thu, 28 Feb 2008 20:59:16 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: Martin Thompson <hireach@internode.on.net>
References: <9FC6541BF8D049BB839E9F30F5258D64@LaptopPC>	<47C67A3C.6050602@shikadi.net>
	<99BC16843B464C4C9081D5DF5DDA98BE@LaptopPC>
In-Reply-To: <99BC16843B464C4C9081D5DF5DDA98BE@LaptopPC>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvico dual digital 4 revision 2.0
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

> nothing in dmesg
> firmware in folder
> chris asked me for a ssh box
> is installed and ready to go
> only thing loaded is chris's v4l tree
> if you wanted to have a look ill email you the details

If Chris is looking into it then that's good, I'm not exactly an expert
in these sorts of things.

> heres the lsusb
> 
> Bus 005 Device 003: ID 0fe9:db98 DVICO
> Bus 005 Device 002: ID 0fe9:db98 DVICO
> 
> Note the hw id mine end in 98 yours in 78

If nothing is showing up in dmesg then the driver mustn't be trying to
load the firmware - I suspect that getting the driver to load the
firmware, and finding the right firmware, will be enough to get it to
work - they don't usually change that much between hardware revisions.

Cheers,
Adam.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
