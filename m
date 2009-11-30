Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:62591 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZK3J55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 04:57:57 -0500
Message-ID: <4B139728.5070803@gmail.com>
Date: Mon, 30 Nov 2009 10:58:00 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ray Lee <ray-lk@madrabbit.org>, Andy Walls <awalls@radix.net>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jon Smirl <jonsmirl@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc> 	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> 	<m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com> 	<1259469121.3125.28.camel@palomino.walls.org> <20091129124011.4d8a6080@lxorguk.ukuu.org.uk> 	<1259515703.3284.11.camel@maxim-laptop> <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com> 	<1259537732.5231.11.camel@palomino.walls.org> <2c0942db0911291815r7cf93287k78acb8ddb13a7920@mail.gmail.com>
In-Reply-To: <2c0942db0911291815r7cf93287k78acb8ddb13a7920@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ray Lee wrote:
> On Sun, Nov 29, 2009 at 3:35 PM, Andy Walls <awalls@radix.net> wrote:
>>> If decoding can *only* be sanely handled in user-space, that's one
>>> thing. If it can be handled in kernel, then that would be better.
>> Why does the address space in which decoding is performed make the
>> decoding process better or worse?  The in kernel infrastructre and
>> restrictions add constraints to a decoding implementation.  Userspace is
>> much more flexible.
> 
> In which case I look forward to seeing your patches to move
> drivers/hid/ to userspace. Please cc: me so I can enjoy the ensuing
> festival.

Umm, this thread is really about several independent issues

- Event delivery
  There's an existing input system that works, there's no need to
  reinvent the wheel; all remote events (usually key presses, but
  there are also wheels/touchpads/joysticks/etc, which don't necessarily
  map to buttons) should eventually arrive through it. Whether there's a
  userspace component somewhere on the receiver->/dev/input path doesn't
  change anything.

- Acquisition
  If it isn't interrupt-driven it should to be in userspace. ADC falls
  into this category, but also various bitbanging approaches and probably
  also many serial port (ab)uses where the decoding isn't trivial.
  (Receivers that require accurate timestamps could be one exception)

- Decoding
  There is "decoding" and there is "translation". With hw receivers
  (such as usb ir/rf dongles and HID devices mentioned above) you often
  only need to translate or map events sent by the hw to the correct input
  event and that's it. This can easily be done in-kernel (modulo complex
  remote/key mappings, maybe).
  Decoding analog input (even if it's only timing) is a different story.
  Would you want to worry about somebody with an IR transmitter (think
  phone/pda/laptop, but it could also be a modded remote) crashing your
  machine, just because the in-kernel decoder didn't handle some weird
  data? Or somebody leaving a small device around, which over time lead to
  OOM, cause the kernel decoder kept leaking memory?
  The bandwidth requirements for a remote are minimal, say <=20 events/s,
  and the max latency in the 100ms range would still be ok, so two, or six,
  context switches per key pressed shouldn't be a problem.

- Configuration
  This isn't actually as simple as it looks at first. If you want to support
  multiple remotes (and you do), complex mappings (eg one->many or sequence->one),
  multiple modes etc then going through a userspace mapper is probably better.
  I looked briefly at Jon's configfs i/f and it seems it could handle the
  multiple-physical-remotes-with-one-receiver-and-multiple-independent-devices
  case, but being able to grab the receiver, process the data in userspace and
  reinject it back would still be needed for some setups.

artur
  
