Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n40.bullet.mail.ukl.yahoo.com ([87.248.110.173])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KQoru-0000xc-VB
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 21:40:24 +0200
Date: Wed, 06 Aug 2008 15:38:52 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Message-Id: <1218051532l.16151l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Anybody here would know how to fix the locking problem
 for TT-3200???
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
once more I am throwing this bottle to the electronic sea ;-)
I am using multiproto-plus with a TT-3200. I am able to lock and get 
good enough reception with 4 dvb-s transponders (srate is 30MS, FEC 
3/4, vertical polarisation, freq are: 11093, 11555, 11635, 11675) with 
a basic dish+universal LNB. Another dvb-s transponder is emitting on 
11495 with 30MS, FEC 5/6 and I can't lock on this one (used mythtv, 
simpletune, szap2).
I can try patches, I can gather data using a prog you would direct me 
to, well whatever is needed to debug this.
Hope someone can help,
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
