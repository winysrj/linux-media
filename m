Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KecwO-00020g-G4
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 23:46:05 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7500FJ4LRTN7H0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 13 Sep 2008 17:45:30 -0400 (EDT)
Date: Sat, 13 Sep 2008 17:45:29 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48CC219C.9010007@singlespoon.org.au>
To: Paul Chubb <paulc@singlespoon.org.au>
Message-id: <48CC3479.5080706@linuxtv.org>
MIME-version: 1.0
References: <466191.65236.qm@web46110.mail.sp1.yahoo.com>
	<48CC219C.9010007@singlespoon.org.au>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Why I need to choose better Subject: headers [was:
 Re: Why (etc.)]
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

Paul Chubb wrote:
> Barry,
> I drew the line at porting the xc3028 tuner module from mcentral.de into 
> v4l-dvb, so no didn't solve the firmware issues. If you know what you 
> are doing it should be trivial work - just linking in yet another tuner 
> module and then calling it like all the others. For me because I don't 
> know the code well it would take a week or two.

No porting required.

xc3028 tuner is already in the kernel, it should just be a case of 
configuring the attach/config structs correctly.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
