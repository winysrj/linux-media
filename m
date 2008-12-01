Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L7DuZ-0006c6-Ct
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 19:54:26 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1561730nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 01 Dec 2008 10:54:20 -0800 (PST)
Message-ID: <412bdbff0812011054j21fe1831hcf6b6bc2c0f77bff@mail.gmail.com>
Date: Mon, 1 Dec 2008 13:54:19 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linuxtv@hotair.fastmail.co.uk
In-Reply-To: <1228152690.22348.1287628393@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
	<412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
	<1227228030.18353.1285952745@webmail.messagingengine.com>
	<412bdbff0811302059p23155b1dka4c67fcb8f17eb0e@mail.gmail.com>
	<1228152690.22348.1287628393@webmail.messagingengine.com>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] dib0700 remote control support fixed
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

On Mon, Dec 1, 2008 at 12:31 PM, petercarm
<linuxtv@hotair.fastmail.co.uk> wrote:
> On Sun, 30 Nov 2008 23:59:51 -0500, "Devin Heitmueller"
> <devin.heitmueller@gmail.com> said:
>> On Thu, Nov 20, 2008 at 7:40 PM, petercarm
>> <linuxtv@hotair.fastmail.co.uk> wrote:
>> > OK it is working on the Nova-T 500 but it is throwing up "Unknown remote
>> > controller key" messages in dmesg in amongst correctly processing the
>> > correct key presses.  I'll try using irrecord to work on a new
>> > lircd.conf and see if it goes away.
>>
>> Hello Peter,
>>
>> I am following up on your issue with your Nova-T 500.  I noticed the
>> following update to the linuxtv.org wiki:
>>
>> http://www.linuxtv.org/wiki/index.php?title=Template:Firmware:dvb-usb-dib0700&curid=3008&diff=18052&oldid=17297
>>
>> If there is a problem with the dib0700 1.20 firmware, I would like to
>> get to the bottom of it (and get Patrick Boettcher involved as
>> necessary).  I am especially concerned since this code is going into
>> 2.6.27 and the behavior you are describing could definitely be
>> considered a regression.
>>
>> As far as I have heard, most people have reported considerable
>> improvement with the 1.20 firmware, including users of the Nova-T 500.
>>  So I would like to better understand what is different about your
>> environment.
>
> First off I'd like to point out that I had considerable success with fw
> 1.20 and the drivers that I tested on mid-November.  At the time, the
> driver had the issues with the repeating remote control messages.  Since
> the update (I think November 16th) I have not been able to get a stable
> build, suffering from the i2c problem.
>
> My test environment consists of 2 different VIA Epia boards (SP8000 and
> CN10000).  I have both a PCI Nova-T 500 2040:9950 and a USB stick
> Nova-TD 2040:5200 which are dibcom devices.  I also have a Hauppauge
> Nova-T PCI (cx88xx) and a Kworld 399U dual tuner USB stick 1b80:e399
> (af9015).
>
> The build is a scripted build of gentoo, built as a livecd (which means
> it is very repeatable).  The snapshot of gentoo portage dates from
> 20081028 which gives me a 2.6.25 kernel.  I'm using gentoo-sources so I
> get 2.6.25-gentoo-r7.
>
> In one of my previous posts I mentioned that I am testing remote control
> functionality using lirc.  This is using devinput and allows me to
> abstract the key bindings for different applications.
>
> What else can I tell you?

Hello Peter,

Of the devices that you have, which are the ones that are failing?
Both of the dibcom devices?

I am not familiar with how lirc interacts with the dib0700 driver,
since the driver polls the bulk endpoint every 50ms and injects the
keys directly.  I will have to look at the driver and see how this
hooks into lirc.

I suspect that most people are not using lirc at all, since the device
works without it.  This would explain why you are the only person I
know of still reporting these problems.

Could you please send my your lirc configuration so I can attempt to
reproduce the issue locally?  If I can get an environment that
reproduces the issue, I can almost certainly fix it.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
