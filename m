Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdmOs-0005Qv-JZ
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 15:39:59 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7100H3M9XKBGW0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 11 Sep 2008 09:39:21 -0400 (EDT)
Date: Thu, 11 Sep 2008 09:39:20 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809110151.08382.liplianin@tut.by>
To: "Igor M. Liplianin" <liplianin@tut.by>
Message-id: <48C91F88.5010506@linuxtv.org>
MIME-version: 1.0
References: <48C70F88.4050701@linuxtv.org>
	<E1KdLOn-0002ri-00.goga777-bk-ru@f147.mail.ru>
	<48C80D58.3010705@linuxtv.org>
	<200809110151.08382.liplianin@tut.by>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API simple szap-s2 utility
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

Igor M. Liplianin wrote:
> There is a program to zap satellite channels with S2API:
> 
> http://liplianindvb.sourceforge.net/cgi-bin/hgwebdir.cgi/szap-s2/archive/tip.tar.gz
> 
> For easy understanding and quickly testing S2API (and even viewing TV with 
> mplayer) 
>  
> Igor M. Liplianin

Thanks Igor, Just FYI...

I've made some frontend.h changes to the tree today, which change some 
definitions and wil cause this tool to fail. I expect to make more this 
evening.

Everyone,

If you want to test szap-s2, be sure to pull the tree prior to todays 
changes, or wait until we can complete frontend.h changes and update the 
userland tools again.

Thanks,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
