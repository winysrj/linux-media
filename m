Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KQY2x-0003eJ-J0
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 03:42:41 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5500HXBOQ16B01@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 05 Aug 2008 21:42:02 -0400 (EDT)
Date: Tue, 05 Aug 2008 21:42:00 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <4898DB39.6020606@yahoo.gr>
To: rvf16 <rvf16@yahoo.gr>
Message-id: <48990168.1070807@linuxtv.org>
MIME-version: 1.0
References: <4898DB39.6020606@yahoo.gr>
Cc: Linux-DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] CX23885 based AVerMedia AVerTV Hybrid Express Slim
 tv card
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


> How can i go on from here ?
> Thank you in advance.
> Regards.

Start by identifying the tuner and demodulator, then patch the cx23885 
tree - adding support for these devices - and submit your patches here 
for review.

Regards,

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
