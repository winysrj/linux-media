Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:63275 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZK0P5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 10:57:54 -0500
MIME-Version: 1.0
Date: Fri, 27 Nov 2009 10:57:59 -0500
Message-ID: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
Subject: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Christoph Bartelmus <christoph@bartelmus.de>
Cc: jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 27, 2009 at 2:45 AM, Christoph Bartelmus
<christoph@bartelmus.de> wrote:
> Hi Mauro,
>
> on 26 Nov 09 at 14:25, Mauro Carvalho Chehab wrote:
>> Christoph Bartelmus wrote:
> [...]
>>> But I'm still a bit hesitant about the in-kernel decoding. Maybe it's just
>>> because I'm not familiar at all with input layer toolset.
> [...]
>> I hope it helps for you to better understand how this works.
>
> So the plan is to have two ways of using IR in the future which are
> incompatible to each other, the feature-set of one being a subset of the
> other?

Take advantage of the fact that we don't have a twenty year old legacy
API already in the kernel. Design an IR API that uses current kernel
systems. Christoph, ignore the code I wrote and make a design proposal
that addresses these goals...

1) Unified input in Linux using evdev. IR is on equal footing with
mouse and keyboard.
2) plug and play for basic systems - you only need an external app for scripting
3) No special tools - use mkdir, echo, cat, shell scripts to build maps
4) Use of modern Linux features like sysfs, configfs and udev.
5) Direct multi-app support - no daemon
6) Hide timing data from user as much as possible.

What are other goals for this subsystem?

Maybe we decide to take the existing LIRC system as is and not
integrate it into the input subsystem. But I think there is a window
here to update the LIRC design to use the latest kernel features. We
don't want to build another /dev/mouse and have to rip it out in five
years.

>
> When designing the key mapping in the kernel you should be aware that
> there are remotes out there that send a sequence of scan codes for some
> buttons, e.g.
> http://lirc.sourceforge.net/remotes/pioneer/CU-VSX159

This is good input.


-- 
Jon Smirl
jonsmirl@gmail.com
