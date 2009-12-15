Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56808 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbZLOViP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 16:38:15 -0500
MIME-Version: 1.0
In-Reply-To: <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <4B24DABA.9040007@redhat.com> <20091215115011.GB1385@ucw.cz>
	 <4B279017.3080303@redhat.com> <20091215195859.GI24406@elf.ucw.cz>
	 <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
	 <20091215201933.GK24406@elf.ucw.cz>
	 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
	 <20091215203300.GL24406@elf.ucw.cz>
	 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
Date: Tue, 15 Dec 2009 16:38:14 -0500
Message-ID: <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
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
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 15, 2009 at 3:45 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Tue, Dec 15, 2009 at 3:33 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> Untrue. Like ethernets and wifis, bluetooth devices have unique
>> addresses. Communication is bidirectional.

I read a little about how Bluetooth remotes work. Correct me if I get
things wrong....

They create pairings between the remote and the device. Each of these
pairings is assigned a device type. Multiple devices in the same room
are handled by the remote remembering the pairings and sending
directed packets instead of broadcast. That lets you have two TVs in
the same room.

Bluetooth devices need to advertise what profiles they support. So on
the Linux box you'd run a command to load the Bluetooth profile for
TV. This command would create an evdev subdevice, load the Bluetooth
keymap for TV, and tell the networking stack to advertise TV support.
Next you initiate the pairing from the Bluetooth remote and pick the
Linux box. This causes a pairing established exchange which tells the
Linux box to make the pairing persistent.

I believe the Bluetooth remote profile is handled in user space by the
BlueZ stack. BlueZ should be aware of the remote pairings. When it
decodes a button press it would need to inject the scancode into the
correct evdev subdevice. Evdev would translate it in the keymap and
create the keyevent. This is the same mechanism LIRC is using.


At a more general level we're missing a way for something like Myth to
declare that it is a DVR device. Myth should load, say I'm a DVR, and
then the remote control subsystem should automatically create a
Bluetooth DVR profile, load an IR profile for Motorola DVR on a
universal remote if the box has Bluetooth, IR or 802.15.4.

The whole concept of a remote control subsystem seems like it needs
more design work done. We keep coming up with big areas that no one
has thought about.

-- 
Jon Smirl
jonsmirl@gmail.com
