Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from difo.com ([217.147.177.146] helo=thin.difo.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ivor@ivor.org>) id 1JacHf-0005Ur-Rb
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 20:43:14 +0100
Message-ID: <47DC26C0.2050609@ivor.org>
Date: Sat, 15 Mar 2008 19:42:56 +0000
From: Ivor Hewitt <ivor@ivor.org>
MIME-Version: 1.0
To: Patrik Hansson <patrik@wintergatan.com>
References: <20080314164100.GA3470@mythbackend.home.ivor.org>
	<8ad9209c0803151138v45edf1e1p27f12aa4faa32d23@mail.gmail.com>
In-Reply-To: <8ad9209c0803151138v45edf1e1p27f12aa4faa32d23@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Patrik Hansson wrote:
> I tried changing to 2.6.22-19 on my ubuntu 7.10 with autosuspend=-1
> but i still lost one tuner.
>
> Have reverted back to 2.6.22-14-generic now and have disabled the
> remote-pulling...and i just lost a tuner, restarting my cardclient and
> mythbackend got it back.
>
> Did you have remote-pulling disabled in -19 ?
>
>   
Still ticking along nicely here.

I have options:
options dvb-usb-dib0700 force_lna_activation=1
options dvb-usb disable_rc_polling=1
(since I have no remote)

Is the ubuntu kernel completely generic?

I still see an mt2060 write failed error every now and then (four in the 
past 24 hours), but that doesn't appear to break anything. Do you have 
complete tuner loss as soon as you get a write error?

Ivor.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
