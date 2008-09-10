Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdUEm-0007k6-CR
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 20:16:22 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Z002GAS271F01@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 10 Sep 2008 14:15:46 -0400 (EDT)
Date: Wed, 10 Sep 2008 14:15:43 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <224244.31127.qm@web38804.mail.mud.yahoo.com>
To: borisstevenson@yahoo.com
Message-id: <48C80ECF.8060607@linuxtv.org>
MIME-version: 1.0
References: <224244.31127.qm@web38804.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DSS Support
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

boris stevenson wrote:
> Hi Steve,
>  
> Regular twinhaun and Genpix dvb devices (Skywalker) have driver support 
> for DSS. Applications like MythTV have available patches to support DSS. 
> (Not sure about VDR yet). It is very critical we add this support to the 
> framework.
>  
> Below is the latest Genpix diff patch with DSS support as an example if 
> that helps.
> http://www.megaupload.com/?d=4I05OXVJ

I've looked at this patch and it has significant changes to dvb_frontend 
and other user facing API's. It's not something that can be merged as 
is, without major cleanup.

It would be possible to extract, cleanup and merge the demodulator/card 
driver, probably.

I don't have this hardware so I probably wouldn't work on the card 
specific driver.

I will use this for DSS reference though, thanks.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
