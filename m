Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JdlgY-0008VN-0n
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 13:21:57 +0100
Received: by ug-out-1314.google.com with SMTP id o29so3044869ugd.20
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 05:21:50 -0700 (PDT)
Message-ID: <8ad9209c0803240521s5426c957te42339397aac06ab@mail.gmail.com>
Date: Mon, 24 Mar 2008 13:21:49 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Adding timestamp to femon
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

Hello
I couldn't find a mailinglist for dvb-apps so i hope this is ok.

I would like to add timestamp to the output of femon -H in some way.
This so I can monitor ber value over a long timeperiod and see the
timedifference between some very high ber-values.

I found a patch from 2005 but was unable to manually use the code in
dvb-apps/utils/femon/femon.c
I have zero skill in c/c++ but for someone with some skill i would
belive it would be very easy ?

Ps. If there is a better place for this kind of question please tell me. Ds.

/ Patrik

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
