Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KVv3z-0001MG-9J
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 23:17:56 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5X00M1Q4GUE360@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 20 Aug 2008 17:17:19 -0400 (EDT)
Date: Wed, 20 Aug 2008 17:17:18 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080820211005.GA32022@raven.wolf.lan>
To: Josef Wolf <jw@raven.inka.de>, linux-dvb@linuxtv.org
Message-id: <48AC89DE.9010502@linuxtv.org>
MIME-version: 1.0
References: <20080820211005.GA32022@raven.wolf.lan>
Subject: Re: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
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

Josef Wolf wrote:
> Hello,
> 
> I'd like to convert live mpeg-ts streams from DVB-S on the fly into
> a mpeg-ps stream.  I know that (for example)
> 
>   mencoder -oac copy -ovc copy -of mpeg -quiet infile -o outfile.mpg

Can't you use named pipes with mencoder and direct the flow into your 
target process?

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
