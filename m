Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2J0ep3L006774
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 20:40:51 -0400
Received: from mailout01.sul.t-online.de (mailout01.sul.t-online.de
	[194.25.134.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2J0eHi8024528
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 20:40:18 -0400
Message-ID: <47E060EB.5040207@t-online.de>
Date: Wed, 19 Mar 2008 01:40:11 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: LInux DVB <linux-dvb@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [RFC] TDA8290 / TDA827X with LNA: testers wanted
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi, Folks

Currently, the LNA support code for TDA8275a is broken, it may even cause a kernel oops.
The bugs were introduced during tuner refactoring.
In my personal repository at
  http://linuxtv.org/hg/~hhackmann/v4l-dvb/
these bugs hopefully are fixed. But i can test only 3 cases. So i am looking for owners
of the cards
Pinnacle 310i,
Happauge hvr1110
ASUSTeK P7131 with LNA
MSI TV@NYWHERE AD11
KWORLD DVBT 210
to check whether things are right again. This holds for both, analog as well as DVB-T.

Michael, may i ask you to check whether my changes contradict with things you are doing?
Mauro, what's your opinion on this? As far as i know, the broken code is in the upcoming
kernel release. The patch is big, is there a chance to commit it to the kernel?

Best regards
  Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
