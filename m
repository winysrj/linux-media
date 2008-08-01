Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from m106.maoz.com ([205.167.76.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhall@m106.maoz.com>) id 1KOtvi-0002na-I4
	for linux-dvb@linuxtv.org; Fri, 01 Aug 2008 14:40:23 +0200
Received: from m106.maoz.com (localhost [127.0.0.1])
	by m106.maoz.com (8.14.3/8.14.3/Debian-4) with ESMTP id m71Cdt7e025375
	for <linux-dvb@linuxtv.org>; Fri, 1 Aug 2008 05:39:55 -0700
Received: (from jhall@localhost)
	by m106.maoz.com (8.14.3/8.14.3/Submit) id m71Cdtr6025374
	for linux-dvb@linuxtv.org; Fri, 1 Aug 2008 05:39:55 -0700
Date: Fri, 1 Aug 2008 05:39:55 -0700
From: jhall@maoz.com
To: linux-dvb@linuxtv.org
Message-ID: <20080801123955.GA25308@maoz.com>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] problems locking a DVB/S signal with multiproto on
	stv0299
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

When I use vdr-1.7.0 with multiproto extensions (comes out of the box
that way) and try to lock this channel

channel:12185:HO0S0:23000:S79.0W:121:120:0:0:789:878:83:789

the channel will not lock, however if I tune that using the old api,
using multiproto but using a program such as an older version of vdr,
the signal will lock.  Anybody else able to reproduce this problem?

It's the skystar budget stv0299.

_J

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
