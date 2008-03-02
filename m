Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JVnA3-0006hE-Lo
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 13:19:23 +0100
Received: by gv-out-0910.google.com with SMTP id o2so2427688gve.16
	for <linux-dvb@linuxtv.org>; Sun, 02 Mar 2008 04:19:19 -0800 (PST)
Message-ID: <8ad9209c0803020419s49e9f9f0i883f48cf857fb20c@mail.gmail.com>
Date: Sun, 2 Mar 2008 13:19:17 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47CA609F.3010209@philpem.me.uk>
MIME-Version: 1.0
Content-Disposition: inline
References: <47A98F3D.9070306@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>
	<47C7076B.6060903@philpem.me.uk> <47C879BA.7080002@philpem.me.uk>
	<1204356192.6583.0.camel@youkaida> <47CA609F.3010209@philpem.me.uk>
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

On Sun, Mar 2, 2008 at 9:09 AM, Philip Pemberton <lists@philpem.me.uk> wrote:
> Nicolas Will wrote:
>  > You should really stick to the 1.10 firmware. 03-pre1 was an earlier
>  > test and has more issues.
>
>  Well, I've figured out what was going on.
>  Seems if you run 'make' against the source tree with one kernel, it will
>  always build modules for said kernel until you run 'make distclean'. I started
>  by building for 2.6.24-8-generic, then upgraded to -10-generic, then to
>  -11-generic, and only did a 'make clean; make; sudo make install' when I
>  rebuilt v4l-dvb, as this worked for Madwifi.
>
>  So to summarise, if you're going to reuse the same source tree for multiple
>  kernels, make distclean before making the drivers, or it'll build for the last
>  kernel you built for... Not sure if it installs to the running kernel, but it
>  certainly doesn't use the headers for the running kernel...
>
>  But at least the card seems to be behaving now. Up 10 hours with:
>
>  options dvb-usb-dib0700 debug=15 force_lna_activation=1
>
> options dvb_usb disable_rc_polling=1
>  options usbcore autosuspend=-1
>
>  I've also blacklisted dvb-usb-dib0700 and modprobe'd it in an rc-script, so my
>  HVR-3000 ends up as device 0 and the two T-500 tuners end up as devices 1 and
>  2; said shell script also sets up symlinks for the 1st and 2nd front-ends on
>  the HVR to devices 10 and 11, because MythTV doesn't like the idea of a card
>  having multiple front-ends...
>
>  The clock is once again running...
>
>
>  --
>  Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
>  lists@philpem.me.uk           | (='.'=) into your signature to help him gain
>  http://www.philpem.me.uk/     | (")_(") world domination.
>
>  _______________________________________________
>
>
> linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

When i started using options usbcore autosuspend=-1 i deactivated debug=15
Will reactivate it again and reset my clock also.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
