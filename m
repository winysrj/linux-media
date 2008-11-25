Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep20-int.chello.at ([62.179.121.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <basq@bitklub.hu>) id 1L50wK-0006dJ-Lj
	for linux-dvb@linuxtv.org; Tue, 25 Nov 2008 17:39:05 +0100
Received: from edge05.upc.biz ([192.168.13.212]) by viefep20-int.chello.at
	(InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
	id <20081125163829.WTTM9471.viefep20-int.chello.at@edge05.upc.biz>
	for <linux-dvb@linuxtv.org>; Tue, 25 Nov 2008 17:38:29 +0100
Date: Tue, 25 Nov 2008 17:37:59 +0100
From: Kovacs Balazs <basq@bitklub.hu>
Message-ID: <1642788920.20081125173759@bitklub.hu>
To: linux-dvb@linuxtv.org
In-Reply-To: <a3ef07920811250832g35f4670ft4e14c942c3eef990@mail.gmail.com>
References: <8622.130.36.62.139.1227602799.squirrel@webmail.xs4all.nl>
	<492BBFD9.50909@cadsoft.de>
	<a3ef07920811250832g35f4670ft4e14c942c3eef990@mail.gmail.com>
MIME-Version: 1.0
Subject: [linux-dvb] TT3200 revisions - 0702 works, 0708 not in S2
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

Today I had an interesting experience:

  I wrote about i was not able to lock on Amos4.0W 10723V, 10759V and 10842V S2 transponders with my TT3200 card. 

Fortunately on the first weeks of November Igor patched the s2-liplianin tree, and everything worked.

Now i got a new revision of TT3200 card, it has another text below the input box (where you attach the antenna cable). THe previous cards was 0702 text and the newer ones with 0708 title.

My problem is the newer cards won't work anymore. I pulled the latest s2liplianin but doesn't help. V4L-DVB drivers doesn't work with this newer cards, unable to lock on these transponders. :(

The older cards with 0702 locks properly...

help me,

thanks

Balazs Kovacs


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
