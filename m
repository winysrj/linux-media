Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdD1h-0006Li-IH
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 01:53:44 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Y007B6D09NMC0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 09 Sep 2008 19:52:57 -0400 (EDT)
Date: Tue, 09 Sep 2008 19:52:57 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809092012.04927.liplianin@tut.by>
To: "Igor M. Liplianin" <liplianin@tut.by>
Message-id: <48C70C59.5080905@linuxtv.org>
MIME-version: 1.0
References: <48BF6A09.3020205@linuxtv.org>
	<200809082334.04511.liplianin@tut.by>
	<200809091750.38009.liplianin@tut.by>
	<200809092012.04927.liplianin@tut.by>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] S2 cx24116:  MPEG initialization
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
> Hi again Steven,
> 
> Please apply this patch.
> Patch to adjust MPEG initialization in cx24116 in order to accomodate 
> different MPEG CLK positions and polarities for different cards.
> 
> Igor Liplianin
> 

Merged, thanks.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
