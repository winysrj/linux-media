Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f177.mail.ru ([194.67.57.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <subbotin222@mail.ru>) id 1KkeEY-0001rg-U5
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 14:21:43 +0200
Received: from mail by f177.mail.ru with local id 1KkeE0-0007gP-00
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 16:21:08 +0400
From: =?windows-1251?Q?=C0=EB=E5=EA=F1=E5=E9_=D1=F3=E1=E1=EE=F2=E8=ED?=
	<subbotin222@mail.ru>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0
Date: Tue, 30 Sep 2008 16:21:08 +0400
In-Reply-To: <mailman.1.1222768801.15304.linux-dvb@linuxtv.org>
References: <mailman.1.1222768801.15304.linux-dvb@linuxtv.org>
Message-Id: <E1KkeE0-0007gP-00.subbotin222-mail-ru@f177.mail.ru>
Subject: [linux-dvb] =?windows-1251?q?Re_=3A_TT_S2-3200_driver?=
Reply-To: =?windows-1251?Q?=C0=EB=E5=EA=F1=E5=E9_=D1=F3=E1=E1=EE=F2=E8=ED?=
	<subbotin222@mail.ru>
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

I've got the same card.  
Cannot reliably lock any channels with the symbol rate other than 22000. 
Tried both the latest multiproto drivers and those by Igor.
Sometimes a 27500 channel would suddenly lock (signal/snr being pretty good),
and keeps locking for several minutes.  Then it goes off, and no luck on any 27500 channel 
until I rmmod all dvb stack down to core and reload everything again.

> I'm unable to scan the channels on the Astra 23,5 satellite
> Frequency 11856000
> Symbol rate 27500000
> Vertical polarisation
> FEC 5/6


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
