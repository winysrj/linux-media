Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:59679 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZLASS4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 13:18:56 -0500
MIME-Version: 1.0
In-Reply-To: <4B154C54.5090906@redhat.com>
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com>
	 <1259682428.18599.10.camel@maxim-laptop>
	 <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>
	 <4B154C54.5090906@redhat.com>
Date: Tue, 1 Dec 2009 13:19:02 -0500
Message-ID: <9e4733910912011019n798c7552i6f9b16f9e8e90c58@mail.gmail.com>
Subject: Re: [RFC v2] Another approach to IR
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 1, 2009 at 12:03 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Jon,
> So, what we can do is to have a "default" keycode table mapping several
> different IR's there to be used by drivers that are shipped with an IR
> that can be fully mapped by the default table. However, for devices
> with scancodes that overlaps with the default table, we'll need a separate
> table.

The goal is to try and design a set of zero config defaults that can
work for 90% of users.

LIRC merges two different things, basic IR driver support and
application scripting for non-IR aware apps. Application scripting for
unaware apps is always going to happen in user space and it will
always need to be manually configured.  But scripting should be
optional.

I'm looking at the driver half and I'd like to explore how zero config
support can be built for IR aware apps. Of course we don't have any IR
aware apps today because no kernel IR event types have been defined
yet. It is better to simply make the apps IR aware and have them
process IR events from evdev (in other words forget about the configs
code it was a poor man's scripting scheme).

For mouse/keyboard support something parallel to USB HID is needed. A
couple of common device profiles would be mapped to keyboard/mouse
events by default. That should support 90% of users. The other 10% can
use a set keys IOCTL to change the mappings.

A couple of use cases:
  insert MSMCE IR device
  kernel automatically loads all drivers
  IR events appear in evdev as vendor/device/command triplets

  apt-get mythtv
  set universal remote to xmit DVR commands
  everything just works

  set universal remote to xmit device A commands
  device A commands mapped to keyboard/mouse movements
  everything just works

For these default cases you just have to read enough docs to know what
device to set your universal remote to.

The scenario I'd like to achieve
   install TV app
   install audio app
   install home automation app
   use multi-function remote to control in parallel with zero config
other than setting three devices into the remote.

-- 
Jon Smirl
jonsmirl@gmail.com
