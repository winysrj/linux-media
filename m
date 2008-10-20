Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Krzlo-0005Yf-TF
	for linux-dvb@linuxtv.org; Mon, 20 Oct 2008 20:46:27 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K9100GA8W4D9R00@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 20 Oct 2008 14:45:50 -0400 (EDT)
Date: Mon, 20 Oct 2008 14:45:48 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200810200141.629@centrum.cz>
To: sustmi <sustmidown@centrum.cz>
Message-id: <48FCD1DC.3010701@linuxtv.org>
MIME-version: 1.0
References: <200810200120.28590@centrum.cz> <200810200121.3906@centrum.cz>
	<200810200122.4044@centrum.cz> <200810200123.28880@centrum.cz>
	<200810200124.8475@centrum.cz> <200810200125.8958@centrum.cz>
	<200810200126.978@centrum.cz> <200810200127.29920@centrum.cz>
	<200810200141.629@centrum.cz>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek WinFast DTV-1800H support
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

sustmi wrote:
> Hi,
> 
> I was working on support for Leadtek WinFast DTV-1800H.
> First I made it work with Markus Rechberger's v4l repository (there was
> better XC3028-tunner code).
> 
> Few weeks ago Markus Rechberger announced that he is no going to
> support non-ex28xx cards anymore and that I have to focus on the linuxtv
> linux-dvb repository.
> 
> So I (cooperating with Paul Chubb) made a patch against linuxtv linux-dvb.
> (attached file: leadtek_winfast_dtv1800h.patch)
> 
> It enables support for DVB-T, analogue TV, radio and IR remote control.
> 
> I have tried to use existing parts of code as much as possible.
> The creation of 'cx88_xc3028_winfast1800h_callback' function was
> necessary. Function 'cx88_xc3028_geniatech_tuner_callback' is similar,
> but the extra GPIO code makes IR remote control not work.
> 
> It will be great if patch is merged into the repository.
> 
> There is one question I want to ask you in terms of this message:
> http://www.linuxtv.org/pipermail/linux-dvb/2008-August/028117.html
> Why is using of cx_write() risky?

 From my orig email: "Don't call cx_write() inside the gpio card setup, 
you're potentially destroying the other bits, it's risky."

cx_write destroys the content of the GPIO direction-enablement and 
values bits. That's a bad thing, and can lead to unexpected behaviors if 
used generally in drivers.

It's better to have a driver read the previous register value, and/or in 
the appropriate bit and write the value back to the gpio registers. This 
is what cx_set/clear do. That way parts of the driver can toggle GPIO's 
for important pieces, without having to understand GPIO usage in other 
disconnected/unrelated parts of the driver.

Your patch uses set/clear, which is good.

Incidently, you patch cannot be merged as-is, it has C99 style comments 
'//' are not allowed, change to /* */ etc.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
