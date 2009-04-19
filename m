Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.27])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1Lvdol-0006Kl-UU
	for linux-dvb@linuxtv.org; Sun, 19 Apr 2009 22:40:50 +0200
Received: by qw-out-2122.google.com with SMTP id 8so547457qwh.17
	for <linux-dvb@linuxtv.org>; Sun, 19 Apr 2009 13:40:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240170449.3589.334.camel@macbook.infradead.org>
References: <1214127575.4974.7.camel@jaswinder.satnam>
	<a3ef07920904191055j4205ad8du3173a8a2328a214e@mail.gmail.com>
	<1240167036.3589.310.camel@macbook.infradead.org>
	<a3ef07920904191214p7be3a0eem7f7abd91ffb374d2@mail.gmail.com>
	<1240170449.3589.334.camel@macbook.infradead.org>
Date: Sun, 19 Apr 2009 13:40:43 -0700
Message-ID: <a3ef07920904191340x6a4e9c5o5c51fe0169cbddab@mail.gmail.com>
From: VDR User <user.vdr@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
	linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] firmware: convert av7110 driver to
	request_firmware()
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, Apr 19, 2009 at 12:47 PM, David Woodhouse <dwmw2@infradead.org> wro=
te:
> When the kernel complains that it cannot find a certain item of firmware
> that is required for a driver to work, you need to place that firmware
> into the /lib/firmware directory, so that it can be found on demand.

So the files expected location is /lib/firmware/av7110/bootcode.bin
then.  Fair enough, however you might want to consider that many users
aren't familiar with what the kernel expects and have installed their
Linux dvb system according to howto's.  Unfortunately, I guess, those
likely aren't updated in sync with the most recent changes.  This is
usually not a problem, although clearly is in this case.

> A recent development is that we're starting to collect those firmware
> images into a central repository, so that you don't have to go hunting
> all over the place for them. That repository is at
> =A0git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git

I guess that's a good thing.  I've never had to use git so I'm not
familiar with it but hopefully users won't have to download the entire
repository and then delete everything they don't need.  I only need
firmware for use with my nexus-s dvb card, it would be nice to be able
to download only that -- only what I actually need.

> We've also started to fix up some of the older drivers which used to
> have firmware built directly into the kernel instead of using the
> request_firmware() API to fetch it only when it's needed. Firmware for
> _those_ drivers, which includes av7110, is actually included directly in
> the kernel source tree for now, but cleanly separated from the drivers.
> It can be included in the kernel if you build the driver in and set the
> CONFIG_FIRMWARE_IN_KERNEL option, or otherwise it'll be automatically
> installed for you when you run 'make modules_install', if you build the
> driver as a module.

I, like many others, don't build the dvb drivers in/from the kernel at
all.  I download the v4l tree from http://linuxtv.org/hg/v4l-dvb and
select my drivers using menuconfig.  Which by the way, didn't present
me with an option to compile this av7110 bootcode into the driver.
>From my perspective I used the same method I have been for a very long
time except now I get an error saying av7110/bootcode.bin wasn't found
both by 'apt-file search bootcode.bin' or 'find -H / |grep
bootcode.bin'..  However, there is
v4l-dvb/linux/firmware/av7110/bootcode.bin.ihex so is that the file
users are supposed to use?  If so, it's poor form that a user should
have to rename files.

> If you were using a normal kernel tree, this would all 'just work'. I
> believe the main problem, other than the fact that you don't _want_ to
> see the obvious answer, is that you're using a tree which has a lot of
> the normal kernel bits stripped out, so the automatic installation of
> the firmware doesn't work?

I'm using kernel 2.6.29.1, however as previously mentioned, I use
v4l-dvb, not kernel dvb drivers.

> As it is, you just need to copy one file. It's _really_ simple. Which is
> why I assumed (and still assume) that you're just trolling.

While I agree copying a single file is simple, it's not so smart to
assume everyone knows how to resolve the problem.  As I've pointed out
there are loads of users who are only as familiar with Linux as the
installation howto's they used taught them to be.  There's nothing
wrong with using howtos, and not knowing everything about Linux
behavior and the kernel.  Additionally, the only "av7110/bootcode.bin"
I found was actually
"v4l-dvb/linux/firmware/av7110/bootcode.bin.ihex".  The safe/smart
thing to do is to ask rather then assuming you should (right?) rename
& relocate that file.  If this is in fact the necessary action to
take, it should be mentioned somewhere people can search and find it
(this thread possibly).

As far as the "trolling" nonsense..  You can continue to think
whatever you want, no matter how ridiculous.  I, and others I know who
are reading this thread but haven't participated in it, are just glad
you actually replied with useful information this time.  Thank you for
that.

To be absolutely clear; users compiling dvb drivers outside of the
kernel should copy v4l-dvb/linux/firmware/av7110/bootcode.bin.ihex to
/lib/firmware/av7110/bootcode.bin correct?

Thanks for your help.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
