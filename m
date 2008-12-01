Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1L7CcS-0000lI-4l
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 18:31:37 +0100
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id 6E3891C96C4
	for <linux-dvb@linuxtv.org>; Mon,  1 Dec 2008 12:31:30 -0500 (EST)
Message-Id: <1228152690.22348.1287628393@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: "Linux-dvb" <linux-dvb@linuxtv.org>
Content-Disposition: inline
MIME-Version: 1.0
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
	<412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
	<1227228030.18353.1285952745@webmail.messagingengine.com>
	<412bdbff0811302059p23155b1dka4c67fcb8f17eb0e@mail.gmail.com>
In-Reply-To: <412bdbff0811302059p23155b1dka4c67fcb8f17eb0e@mail.gmail.com>
Date: Mon, 01 Dec 2008 17:31:30 +0000
Subject: Re: [linux-dvb] dib0700 remote control support fixed
Reply-To: linuxtv@hotair.fastmail.co.uk
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

On Sun, 30 Nov 2008 23:59:51 -0500, "Devin Heitmueller"
<devin.heitmueller@gmail.com> said:
> On Thu, Nov 20, 2008 at 7:40 PM, petercarm
> <linuxtv@hotair.fastmail.co.uk> wrote:
> > OK it is working on the Nova-T 500 but it is throwing up "Unknown remote
> > controller key" messages in dmesg in amongst correctly processing the
> > correct key presses.  I'll try using irrecord to work on a new
> > lircd.conf and see if it goes away.
> 
> Hello Peter,
> 
> I am following up on your issue with your Nova-T 500.  I noticed the
> following update to the linuxtv.org wiki:
> 
> http://www.linuxtv.org/wiki/index.php?title=Template:Firmware:dvb-usb-dib0700&curid=3008&diff=18052&oldid=17297
> 
> If there is a problem with the dib0700 1.20 firmware, I would like to
> get to the bottom of it (and get Patrick Boettcher involved as
> necessary).  I am especially concerned since this code is going into
> 2.6.27 and the behavior you are describing could definitely be
> considered a regression.
> 
> As far as I have heard, most people have reported considerable
> improvement with the 1.20 firmware, including users of the Nova-T 500.
>  So I would like to better understand what is different about your
> environment.

First off I'd like to point out that I had considerable success with fw
1.20 and the drivers that I tested on mid-November.  At the time, the
driver had the issues with the repeating remote control messages.  Since
the update (I think November 16th) I have not been able to get a stable
build, suffering from the i2c problem.

My test environment consists of 2 different VIA Epia boards (SP8000 and
CN10000).  I have both a PCI Nova-T 500 2040:9950 and a USB stick
Nova-TD 2040:5200 which are dibcom devices.  I also have a Hauppauge
Nova-T PCI (cx88xx) and a Kworld 399U dual tuner USB stick 1b80:e399
(af9015).

The build is a scripted build of gentoo, built as a livecd (which means
it is very repeatable).  The snapshot of gentoo portage dates from
20081028 which gives me a 2.6.25 kernel.  I'm using gentoo-sources so I
get 2.6.25-gentoo-r7.

In one of my previous posts I mentioned that I am testing remote control
functionality using lirc.  This is using devinput and allows me to
abstract the key bindings for different applications.

What else can I tell you?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
