Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KescM-00089m-BP
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 16:30:27 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K760098RW9RMI20@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 14 Sep 2008 10:29:52 -0400 (EDT)
Date: Sun, 14 Sep 2008 10:29:51 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <d9def9db0809140651l392282d4u87098881ce4ca382@mail.gmail.com>
To: free_beer_for_all@yahoo.com
Message-id: <48CD1FDF.8090106@linuxtv.org>
MIME-version: 1.0
References: <d9def9db0809131910h2ff43b9auf86eb340adb2fac8@mail.gmail.com>
	<391631.73780.qm@web46111.mail.sp1.yahoo.com>
	<d9def9db0809140651l392282d4u87098881ce4ca382@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Markus Rechberger wrote:
> On Sun, Sep 14, 2008 at 12:51 PM, barry bouwsma
> <free_beer_for_all@yahoo.com> wrote:
>> --- On Sun, 9/14/08, Markus Rechberger <mrechberger@gmail.com> wrote:
>>
>>>>>> (Also to be noted is that, some BSD chaps also have shown interest in
>> Does BSD == NetBSD here?  Or are there other developments
>> as well that I'm not aware of?
>>
> 
> for now it's netBSD, we're offering support to everyone who's interested.
> 
> 
>>> As for the em28xx driver I agreed with pushing all my code
>> Do you want to have patches for your repository, like the
>> following (just an example, based on the NetBSD SOC source)
>>
> 
> If you look at the chipdrivers, manufacturers often have independent
> code there, as code can be kept independent in that area.
> The bridge driver will contain operating system dependent code of course,
> The drx driver which you mention mostly uses the Code which came from
> Micronas, the module interface code which you looked at is linux
> specific yes, but it's more or less just a wrapper against the
> original source. It's the same with upcoming drivers.

xc5000 and mxl5005 drivers are good examples of this. Basically 
reference code with a DVB wrapper and whitespace + context passing changes.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
