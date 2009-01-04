Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx38.mail.ru ([194.67.23.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1LJO2P-00018x-CG
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 09:08:46 +0100
Received: from [92.101.131.52] (port=14599 helo=localhost.localdomain)
	by mx38.mail.ru with asmtp id 1LJO1q-000HOa-00
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 11:08:10 +0300
Date: Sun, 4 Jan 2009 11:14:29 +0300
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20090104111429.1f828fc8@bk.ru>
In-Reply-To: <20090103193718.GB3118@gmail.com>
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] DVB-S Channel searching problem
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

> I would suggest not using S2API as it's seems to be broken for our card
> at this time, 

why do you think so ? 

>I did test steven s2 repo which is better that all other
> S2API repo 

have you tested http://mercurial.intuxication.org/hg/s2-liplianin ?

>I have tested but still worse than lipliandvb (multiproto
> hg).

please try 

http://mercurial.intuxication.org/hg/s2-liplianin (yesterday Igor synchronized it with current v4l-dvb)
+
http://hg.kewl.org/dvb2010/ - new dvb scaner 

for me everything is working without any problem with my hvr4000. Also patched vdr 170 works well with s2api


Goga


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
