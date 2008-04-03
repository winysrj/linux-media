Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JhPRt-0000mA-0g
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 15:25:49 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JYR000I73Y1OZ81@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 03 Apr 2008 09:25:13 -0400 (EDT)
Date: Thu, 03 Apr 2008 09:25:13 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <1207202813.3472.4.camel@localhost>
To: Craig Whitmore <lennon@orcon.net.nz>
Message-id: <47F4DAB9.1030109@linuxtv.org>
MIME-version: 1.0
References: <1D3AE29367104EEB927390EDBF0EB688@mce>
	<1207202813.3472.4.camel@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support for Dual Tuner DVB-T PCI and PCIe Cards
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
>> It is being replaced by the Hauppauge HVR-2200 dual tuner DVB-T PCIe card. 
>> This is currently available but there are no Linux drivers for it.
> 
>> I would be grateful for information about the likelyhood of support for 
>> Hauppauge HVR2200 or any other dual tuner DVB-T cards that anyone may know 
>> about, or be working on.
>>
> 
> I got an HVR-2200 a week ago and am looking into getting it working and
> have updated
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2200 with its
> details.
> 
> I have contacted Philips regarding the chips on the board as its based
> on the PC TV PCV520/20PC reference card, but have yet to get any info
> from them yet.
> 
> It'll be a while before someone gets it started/working :-(
> 
> If any one else has started with a driver any details would be great.

Support for the tda18271 is already done, thanks fto mkrufky.

Support for the TDA10048 is almost done, I have this working on a 
different product.

Manu is working on a Linux driver for the 716x product family, contact him.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
