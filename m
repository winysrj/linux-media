Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JLmZ0-0004ZU-RW
	for linux-dvb@linuxtv.org; Sun, 03 Feb 2008 22:39:46 +0100
Received: from [11.11.11.138] (user-54458eb9.lns1-c13.telh.dsl.pol.co.uk
	[84.69.142.185])
	by mail.youplala.net (Postfix) with ESMTP id 0F3B1D88110
	for <linux-dvb@linuxtv.org>; Sun,  3 Feb 2008 22:38:59 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <200802031137.32087.shaun@saintsi.co.uk>
References: <BC723861-F3E2-4B1C-BA54-D74B8960579A@firshman.co.uk>
	<200802021020.20298.shaun@saintsi.co.uk>
	<1202031541.17762.23.camel@anden.nu>
	<200802031137.32087.shaun@saintsi.co.uk>
Date: Sun, 03 Feb 2008 21:38:55 +0000
Message-Id: <1202074735.16574.19.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


On Sun, 2008-02-03 at 11:37 +0000, Shaun wrote:
> Hi  People,
> 
> Jonas I like your never give up attitude.
> 
> I am running on a 3Ghz P4. At the moment I am running with a very
> slightly 
> modified driver. I have my remote plugged in and I sometimes get
> hundreds of 
> messages like the one below:
> 
> Jan 23 22:01:00 media-desktop kernel: [ 1062.522880] dib0700: Unknown
> remote
> controller key :  0 20
> 
> I have included a line in
> linux/drivers/media/dvb/dvb-usb/dib0700_devices.c 
> that eats the unknown controller key and prevents the message
> repeating, as 
> was suggested by Jonas.

There is a patch on the wiki for this, and I'm using it.

Related?

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
