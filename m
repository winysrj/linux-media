Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JfHki-0002ia-EQ
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 17:48:34 +0100
From: Nicolas Will <nico@youplala.net>
To: Patrik Hansson <patrik@wintergatan.com>
In-Reply-To: <8ad9209c0803280936k2cba9115laa49f828ffda55bf@mail.gmail.com>
References: <1206139910.12138.34.camel@youkaida>
	<1206563002.8947.2.camel@youkaida>
	<8ad9209c0803261352s664d40fdud2fcbf877b10484b@mail.gmail.com>
	<1206566255.8947.5.camel@youkaida> <1206605144.8947.18.camel@youkaida>
	<af2e95fa0803271044lda4ac30yb242d7c9920c2051@mail.gmail.com>
	<47EC13BE.6020600@simmons.titandsl.co.uk>
	<1206655986.17233.8.camel@youkaida>
	<8ad9209c0803280846q53e75546g2007d4e8be98fb8e@mail.gmail.com>
	<1206719797.14161.8.camel@acropora>
	<8ad9209c0803280936k2cba9115laa49f828ffda55bf@mail.gmail.com>
Date: Fri, 28 Mar 2008 16:47:17 +0000
Message-Id: <1206722837.12480.3.camel@acropora>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects -	They
	are back!
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

On Fri, 2008-03-28 at 17:36 +0100, Patrik Hansson wrote:
> 
> hmm, ok this is odd.
> I searched my entire syslog and messages and the only disconnect i
> have is from now during the reboot to get the tuner back.
> 
> So i have the following:
> This morning everything is fine.
> In the afternoon i loose a tuner, restarting mythtv-backend and so on
> does not bring it back.
> I reboot and tuner comes back.
> I check the logs and have 0 disconnects.

You have another problem.

You lose a tuner.

I get a card that disconnects completely, I lose both tuners and the
remote, and get a flood of mt2060 i2c errors, but after the disconnect.


Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
