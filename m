Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62268 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079AbZLOUpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 15:45:15 -0500
MIME-Version: 1.0
In-Reply-To: <20091215203300.GL24406@elf.ucw.cz>
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <20091207184153.GD998@core.coreip.homeip.net>
	 <4B24DABA.9040007@redhat.com> <20091215115011.GB1385@ucw.cz>
	 <4B279017.3080303@redhat.com> <20091215195859.GI24406@elf.ucw.cz>
	 <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
	 <20091215201933.GK24406@elf.ucw.cz>
	 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
	 <20091215203300.GL24406@elf.ucw.cz>
Date: Tue, 15 Dec 2009 15:45:14 -0500
Message-ID: <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 15, 2009 at 3:33 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2009-12-15 15:29:51, Jon Smirl wrote:
>> On Tue, Dec 15, 2009 at 3:19 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > On Tue 2009-12-15 15:14:02, Jon Smirl wrote:
>> >> On Tue, Dec 15, 2009 at 2:58 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> >> > Hi!
>> >> >
>> >> >>       (11) if none is against renaming IR as RC, I'll do it on a next patch;
>> >> >
>> >> > Call it irc -- infrared remote control. Bluetooth remote controls will
>> >> > have very different characteristics.
>> >>
>> >> How are they different after the scancode is extracted from the
>> >> network packet? The scancode still needs to be passed to the input
>> >> system, go through a keymap, and end up on an evdev device.
>> >>
>> >> I would expect the code for extracting the scancode to live in the
>> >> networking stack, but after it is recovered the networking code would
>> >> use the same API as IR to submit it to input.
>> >
>> > For one thing,  bluetooth (etc) has concept of devices (and reliable
>> > transfer). If you have two same bluetooth remotes, you can tell them
>> > apart, unlike IR.
>>
>> IR has the same concept of devices. That's what those codes you enter
>> into a universal remote do - they set the device.
>
> They set the device _model_.
>
>> There are three classes of remotes..
>> Fixed function - the device is hardwired
>> Universal - you can change the device
>> Multi-function - a universal that can be multiple devices - TV, cable,
>> audio, etc
>>
>> If you set two Bluetooth remotes both to the same device you can't
>> tell them apart either.
>
> Untrue. Like ethernets and wifis, bluetooth devices have unique
> addresses. Communication is bidirectional.

I agree with that, but the 802.15.4 remote control software I've
worked with ignores the MAC address. You set your remote to send codes
for a specific device.  The mac address of the remote is ignored so
that any remote can control the device.  You don't need to pair
802.15.4 remotes like Bluetooth devices need to be paired.

I haven't played around with a Bluetooth remote. Nothing I own can
send the signals.  How can a Bluetooth remote control multiple devices
in the same room if it needs to be paired?

If it doesn't use this API, how does a Bluetooth remote turn a button
press into a Linux keycode on an evdev device?


>
> Imagine wifi connected bluetooth. It is very different from infrared.
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Jon Smirl
jonsmirl@gmail.com
