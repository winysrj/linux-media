Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KeE9N-0002sQ-1W
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 21:17:52 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7300AW8K8GW1S0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 12 Sep 2008 15:17:06 -0400 (EDT)
Date: Fri, 12 Sep 2008 15:17:04 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809122102.27540.liplianin@tut.by>
To: "Igor M. Liplianin" <liplianin@tut.by>
Message-id: <48CAC030.1090906@linuxtv.org>
MIME-version: 1.0
References: <48C70F88.4050701@linuxtv.org>
	<200809122102.27540.liplianin@tut.by>
Cc: Steven Toth <stoth@hauppauge.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] S2API Bug fix: ioctl
 FE_SET_PROPERTY/FE_GET_PROPERTY always return error
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
> Hi Steven,
> 
> It seems a bug - ioctl FE_SET_PROPERTY/FE_GET_PROPERTY always return error.
> Though it can be fixed by many ways, send you patch
> 
> Igor
> 

Thanks Igor.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
