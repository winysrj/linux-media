Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <shaun@saintsi.co.uk>) id 1JM6wJ-0003XA-Va
	for linux-dvb@linuxtv.org; Mon, 04 Feb 2008 20:25:11 +0100
From: Shaun <shaun@saintsi.co.uk>
To: linux-dvb@linuxtv.org
Date: Mon, 4 Feb 2008 19:24:36 +0000
References: <BC723861-F3E2-4B1C-BA54-D74B8960579A@firshman.co.uk>
	<200802031137.32087.shaun@saintsi.co.uk>
	<1202074735.16574.19.camel@youkaida>
In-Reply-To: <1202074735.16574.19.camel@youkaida>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802041924.36042.shaun@saintsi.co.uk>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
Reply-To: shaun@saintsi.co.uk
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

Hi,

> > I have included a line in
> > linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> > that eats the unknown controller key and prevents the message
> > repeating, as
> > was suggested by Jonas.


Yes, the change I was writing about is on the wiki. 

Shaun


On Sunday 03 February 2008 21:38:55 Nicolas Will wrote:
> On Sun, 2008-02-03 at 11:37 +0000, Shaun wrote:
> > Hi  People,
> >
> > Jonas I like your never give up attitude.
> >
> > I am running on a 3Ghz P4. At the moment I am running with a very
> > slightly
> > modified driver. I have my remote plugged in and I sometimes get
> > hundreds of
> > messages like the one below:
> >
> > Jan 23 22:01:00 media-desktop kernel: [ 1062.522880] dib0700: Unknown
> > remote
> > controller key :  0 20
> >
> > I have included a line in
> > linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
> > that eats the unknown controller key and prevents the message
> > repeating, as
> > was suggested by Jonas.
>
> There is a patch on the wiki for this, and I'm using it.
>
> Related?
>
> Nico
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
