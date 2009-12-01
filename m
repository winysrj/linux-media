Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:64185 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZLAPIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 10:08:54 -0500
MIME-Version: 1.0
Date: Tue, 1 Dec 2009 10:08:59 -0500
Message-ID: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com>
Subject: [RFC v2] Another approach to IR
From: Jon Smirl <jonsmirl@gmail.com>
To: awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	mchehab@redhat.com, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While reading all of these IR threads another way of handling IR
occurred to me that pretty much eliminates the need for LIRC and
configuration files in default cases. The best way to make everything
"just work" is to eliminate it.

The first observation is that the IR profile of various devices are
well known. Most devices profiles are in the published One-for-All
database. These device profiles consist of vendor/device/command
triplets. There is one triplet for each command like play, pause, 1,
2, 3, power, etc.

The second observation is that universal remotes know how to generate
commands for all of the common devices.

Let's define evdev messages for IR than contain vendor/device/command
triplets. I already posted code for doing that in my original patch
set. These messages are generated from in-kernel code.

Now add a small amount of code to MythTV, etc to act on these evdev
messages. Default MythTV, etc to respond to the IR commands for a
common DVR device. Program your universal remote to send the commands
for this device. You're done. Everything will "just work" - no LIRC,
no irrecord, no config files, no command mapping, etc.

Of course there are details involved in making this work. MythTV will
have to have a config option to allow it to emulate several different
DVR devices so that you can pick one that you don't own. It should
also have choices for emulating the common devices defined for the
remotes included with various Linux video board like the Hauppauge
remote.

For apps that haven't been modified you will have to run a daemon
which will capture vendor/device/command evdev events and convert them
into keystroke commands than work the menus. You'll need a config file
for this and have to write scripts. Instead I'd just go modify the app
the respond to the IR events, it is easy to do.

Long run, we define a MythTV IR profile, mplayer profile, etc and get
these into the IR database for universal remotes. Now MythTV can stop
emulating another vendor's device.

For the default MythTV case no external support will need to be
installed if the protocol decode engines are in the kernel. The raw
data will come in, run through the engines, and pop out as evdev
messages with a vendor/device/command triplet. Devices that decode in
hardware will just send vendor/device/command triplets.

-- 
Jon Smirl
jonsmirl@gmail.com
