Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from m106.maoz.com ([205.167.76.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhall@m106.maoz.com>) id 1KDUUb-0005ns-2K
	for linux-dvb@linuxtv.org; Tue, 01 Jul 2008 03:17:14 +0200
Received: from m106.maoz.com (localhost [127.0.0.1])
	by m106.maoz.com (8.14.3/8.14.3/Debian-4) with ESMTP id m611H8D8003053
	for <linux-dvb@linuxtv.org>; Mon, 30 Jun 2008 18:17:08 -0700
Received: (from jhall@localhost)
	by m106.maoz.com (8.14.3/8.14.3/Submit) id m611H8t1003052
	for linux-dvb@linuxtv.org; Mon, 30 Jun 2008 18:17:08 -0700
Date: Mon, 30 Jun 2008 18:17:08 -0700
From: jhall@maoz.com
To: linux-dvb@linuxtv.org
Message-ID: <20080701011708.GA2994@maoz.com>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] problems tuning with multiproto
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

Hello,

today I was watching a transponder with symbol rate 4340 and had rain
fade.  I was using vdr-1.7.0 and the multiproto driver.  When the
thunderstorm passed, the multiproto drivers didn't recover.  I killed
vdr, unloaded and reloaded the modules and restarted vdr.  Still it
refused to lock to the channel.  I stopped vdr and started an old vdr,
using the older api.  Instantly the old vdr locked the transponder and
started transferring good data.  I stopped the old vdr and restarted
new vdr-1.7.0 using multiproto api.  Again it could not lock the
signal.  I repeated this several times to no avail.

oh and are there plans to integrate the multiproto api into the main
linux-dvb repository?

Thanks.

_J

P.S. the card is an stv0299-based budget card.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
