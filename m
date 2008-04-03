Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JhQZP-0006MZ-7U
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 16:37:39 +0200
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Date: Thu, 3 Apr 2008 16:36:50 +0200
From: Nicolas Will <nico@youplala.net>
In-Reply-To: <874a271ecbbd66baae17d5acf725ef16@localhost>
References: <874a271ecbbd66baae17d5acf725ef16@localhost>
Message-ID: <9e0b4664d86aa1f391e9808292c3bde2@localhost>
Subject: Re: [linux-dvb]
	=?utf-8?q?Nova-T_500_disconnects_-_solved=3F_-_YES!?=
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




On Thu, 3 Apr 2008 10:47:25 +0200, Nicolas Will <nico@youplala.net> wrote:
> 
> Guys,
> 
> I have tried the ehci patch manually on the Ubuntu 2.6.24-13 source, and
> indeed it fixed the disconnects.
> 
> The fix is now in the 2.6.24-14 binaries, and works just as well.
> 
> My Ubuntu Hardy has now resumed normal activities and Gutsy stability
> levels, so far.
> 
> I can only recommend that users of other distros should check for kernel
> updates, bug their developers to include the fix, or do it themselves.

the fix is apparently also included in the 2.6.24.4-64.fc8 Fedora Core 8
kernel update.

This information comes from 

https://bugzilla.redhat.com/show_bug.cgi?id=440008

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
