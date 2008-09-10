Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdDAb-0007Vh-N1
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 02:02:54 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Y00NQ5DFQ38B0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 09 Sep 2008 20:02:14 -0400 (EDT)
Date: Tue, 09 Sep 2008 20:02:13 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <d9def9db0809091414t5953e696s521aa2f7525d182d@mail.gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Message-id: <48C70E85.4050001@linuxtv.org>
MIME-version: 1.0
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<1220993974.17270.22.camel@localhost>
	<d9def9db0809091414t5953e696s521aa2f7525d182d@mail.gmail.com>
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

> Anyway I'd appreciate to get back to the topic again and the question
> which I pointed out to, how many devices
> are supported by Steven's patch and how many by the work which Manu
> used to managed for years with a couple of
> people. There are multiple ways which can lead to success, the beauty
> of a patch or framework won't matter too much (nevermind
> if Steven's or Manu's work seems to be more prettier to someone).

I'm going to post this notice in a new thread, as this is getting long 
but, to respond generally....

I merged patches from Igor today, so the S2API tree has five S2 devices.

HVR4000 S/S2 card
HVR4000LITE (Also known as the S2 Lite) S/S2 card
TeVii S460 S/S2 card
TeVii S650 S2 card
DvbWorld DVB-S/S2 USB2.0 S/S2

It's a pretty good start, thanks to Igor.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
