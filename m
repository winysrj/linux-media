Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Jq7Lt-000106-51
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 15:55:37 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZZ007VPLBPJXX0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 27 Apr 2008 09:55:02 -0400 (EDT)
Date: Sun, 27 Apr 2008 09:55:01 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <67bbdc0804261257x2ea440d7radaa1c5ecb5ad56f@mail.gmail.com>
To: Tomasz Belina <tomasz.belina@gmail.com>
Message-id: <481485B5.1080207@linuxtv.org>
MIME-version: 1.0
References: <67bbdc0804261257x2ea440d7radaa1c5ecb5ad56f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support for HPC2000 tuner
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

Tomasz Belina wrote:
> Hello,
> 
> Recently I've bought HPC2000 DVB-T tuner. It is  Conexant CX23880 based 
> device. I've tried to make it work under linux but without success. I 
> tried to used different card ids for cx88xx kernel module. Only for 
> card=46 (DViCO FusionHDTV DVB-T Hybrid) there was no error during insmod 
> cx88-dvb but unfortunatelly w_scan tool couldn't find any tv program.  
> Is support for this device planned in linux kernel ? Any chance to make 
> it work using latest linuxtv drivers ?

You need to find out which components are on the card, and pictures, and 
put that information into the wiki at linuxtv.org.

Based on that we'll be able to help.

Please keep all correspondence inside this mailinglist.

Regards,

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
