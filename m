Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KhazY-0003FA-J6
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 04:17:38 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7K00AAXRODC7J0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 21 Sep 2008 22:17:02 -0400 (EDT)
Date: Sun, 21 Sep 2008 22:17:01 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809211905.34424.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>
Message-id: <48D7001D.7090400@linuxtv.org>
MIME-version: 1.0
References: <200809211905.34424.hftom@free.fr>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] hvr4000-s2api + QAM_AUTO
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

Christophe Thommeret wrote:
> Hi Steve,
> 
> I've managed to add S2 support to kaffeine, so it can scan and zap.
> However, i have a little problem with DVB-S:
> Before tuning to S2, S channels tune well with QAM_AUTO.
> But after having tuned to S2 channels, i can no more lock on S ones until i 
> set modulation to QPSK insteed of QAM_AUTO for these S channels.
> Is this known?
> 

Other users aren't seeing this, so it could be something odd with 
Kaffeine. Please collect dmesg output and email me, it should be obvious 
what's going on with this.

Thanks,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
