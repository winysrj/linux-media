Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.240])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JapLg-0004Hn-4K
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 10:40:12 +0100
Received: by an-out-0708.google.com with SMTP id d18so1730756and.125
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 02:40:08 -0700 (PDT)
Message-ID: <8ad9209c0803160240r75705620q27b76f3f31bad8f5@mail.gmail.com>
Date: Sun, 16 Mar 2008 10:40:07 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0803151442p742c10eas3aa0b82c84123194@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080314164100.GA3470@mythbackend.home.ivor.org>
	<8ad9209c0803151138v45edf1e1p27f12aa4faa32d23@mail.gmail.com>
	<47DC26C0.2050609@ivor.org>
	<8ad9209c0803151442p742c10eas3aa0b82c84123194@mail.gmail.com>
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

On Sat, Mar 15, 2008 at 10:42 PM, Patrik Hansson <patrik@wintergatan.com> wrote:
>
> On Sat, Mar 15, 2008 at 8:42 PM, Ivor Hewitt <ivor@ivor.org> wrote:
>  > Patrik Hansson wrote:
>  >  > I tried changing to 2.6.22-19 on my ubuntu 7.10 with autosuspend=-1
>  >  > but i still lost one tuner.
>  >  >
>  >  > Have reverted back to 2.6.22-14-generic now and have disabled the
>  >  > remote-pulling...and i just lost a tuner, restarting my cardclient and
>  >  > mythbackend got it back.
>  >  >
>  >  > Did you have remote-pulling disabled in -19 ?
>  >  >
>  >  >
>  >  Still ticking along nicely here.
>  >
>  >  I have options:
>  >  options dvb-usb-dib0700 force_lna_activation=1
>  >  options dvb-usb disable_rc_polling=1
>  >  (since I have no remote)
>  >
>  >  Is the ubuntu kernel completely generic?
>  >
>  >  I still see an mt2060 write failed error every now and then (four in the
>  >  past 24 hours), but that doesn't appear to break anything. Do you have
>  >  complete tuner loss as soon as you get a write error?
>  >
>  >  Ivor.
>  >
>
>  The only error in my log the lat time i lost a tuner was:
>  mt2060 I2C read failed
>
>  So not even a write failed.
>

During the night i had another read failed, but this time both tuners
stayed alive.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
