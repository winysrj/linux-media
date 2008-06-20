Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1K9hgB-0000Da-T4
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 16:33:32 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K9hg8-0007ey-E1
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 14:33:28 +0000
Received: from h240n2fls32o1121.telia.com ([217.211.84.240])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 20 Jun 2008 14:33:28 +0000
Received: from dvenion by h240n2fls32o1121.telia.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 20 Jun 2008 14:33:28 +0000
To: linux-dvb@linuxtv.org
From: Daniel <dvenion@hotmail.com>
Date: Fri, 20 Jun 2008 14:33:12 +0000 (UTC)
Message-ID: <loom.20080620T142728-129@post.gmane.org>
References: <200805122042.43456.ajurik@quick.cz>
	<200806162245.22999.ajurik@quick.cz>
	<loom.20080620T131302-220@post.gmane.org>
	<200806201547.28906.ajurik@quick.cz>
Mime-Version: 1.0
Subject: Re: [linux-dvb]
	=?utf-8?q?Re_=3A_Re_=3A_Re_=3A_No_lock_possible_at_so?=
	=?utf-8?q?me_DVB-S2=09channels_with_TT_S2-3200/linux?=
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

Ales Jurik <ajurik <at> quick.cz> writes:

> 
> I'm still trying to find the reason of that problem, but (as I think) this is 
> done not by FEC as well not by bitrate. All channels in 8PSK modulation are 
> not possible to receive, or the lock is after few minutes. So I'm thinking 
> that 8PSK is badly handled within the driver.
> 
> BR,
> 
> Ales
> 


Could it be something with the fact of detecting that it is 8PSK that it needs
to handle? I remember when I first was trying to get the 8PSK channels to work
in MythTV I had to manully set the modulation to 8PSK in the database to get a
lock, if I leaved it to auto it just thought it was a regular DVB-S stream when
you looked at the output in dmesg.

Daniel


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
