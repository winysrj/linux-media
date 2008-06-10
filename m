Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1K6AOm-0000ER-5R
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 22:24:56 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K29006Y6KODVX81@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 10 Jun 2008 16:24:21 -0400 (EDT)
Date: Tue, 10 Jun 2008 16:24:12 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <de8cad4d0806101321x659cdec7n77714ba6e69cb563@mail.gmail.com>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Message-id: <484EE2EC.40501@linuxtv.org>
MIME-version: 1.0
References: <de8cad4d0806101321x659cdec7n77714ba6e69cb563@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 multiple cards question
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

Brandon Jenkins wrote:
> Greetings,
> 
> I currently have 3 HVR-1600 cards installed in my system. I am able to
> get analog signal on all 3, but the ATSC scanning does not return any
> data on the third card. I have swapped cables with a known working
> card, but this does not resolve the issue.
> 
> 2 of the cards are brand new, dmesg output seems to indicate no
> issues. Does anyone know if there is an issue with 3 HD tuners? Is
> there a method of trouble shooting I should follow?

Remove the two working cards and test the failing card, report back.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
