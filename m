Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n39.bullet.mail.ukl.yahoo.com ([87.248.110.172])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JWfwI-0000ks-I6
	for linux-dvb@linuxtv.org; Tue, 04 Mar 2008 23:48:51 +0100
Date: Tue, 04 Mar 2008 15:25:42 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Message-Id: <1204658742l.6376l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] TT 3200: corrupted stream/no lock depending on the
	transponder
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

	Hi all,
I can receive from 4 transponders (DVB-S): 11093, 11555, 11635, 11675 
MHz.
any channel on 11093: fast lock, perfect picture.
any channel on 11555: lock a bit slower and corrupted stream (lots of 
blocky artifacts, myhttv complains about corrupted stream)
any channel on 11635,11675: no lock.

I found that doing szap a few times (5-6 times) in a row would lock 
solid for the 11635 and 11675 transponders.
Is this something known?
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
