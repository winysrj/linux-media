Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51798 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZLAPrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 10:47:09 -0500
Subject: Re: [RFC v2] Another approach to IR
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	mchehab@redhat.com, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com>
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 17:47:08 +0200
Message-ID: <1259682428.18599.10.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-12-01 at 10:08 -0500, Jon Smirl wrote: 
> While reading all of these IR threads another way of handling IR
> occurred to me that pretty much eliminates the need for LIRC and
> configuration files in default cases. The best way to make everything
> "just work" is to eliminate it.
> 
> The first observation is that the IR profile of various devices are
> well known. Most devices profiles are in the published One-for-All
> database. These device profiles consist of vendor/device/command
> triplets. There is one triplet for each command like play, pause, 1,
> 2, 3, power, etc.
> 
> The second observation is that universal remotes know how to generate
> commands for all of the common devices.
> 
> Let's define evdev messages for IR than contain vendor/device/command
> triplets. I already posted code for doing that in my original patch
> set. These messages are generated from in-kernel code.
> 
> Now add a small amount of code to MythTV, etc to act on these evdev
> messages. Default MythTV, etc to respond to the IR commands for a
> common DVR device. Program your universal remote to send the commands
> for this device. You're done. Everything will "just work" - no LIRC,
> no irrecord, no config files, no command mapping, etc.
You are making one  big wrong assumption that everyone that has a remote
uses mythtv, and only it.

Many users including me, use the remote just like a keyboard, or even
like a mouse.


> 
> Of course there are details involved in making this work. MythTV will
> have to have a config option to allow it to emulate several different
> DVR devices so that you can pick one that you don't own. It should
> also have choices for emulating the common devices defined for the
> remotes included with various Linux video board like the Hauppauge
> remote.
> 
> For apps that haven't been modified you will have to run a daemon
> which will capture vendor/device/command evdev events and convert them
> into keystroke commands than work the menus. You'll need a config file
> for this and have to write scripts. Instead I'd just go modify the app
> the respond to the IR events, it is easy to do.
> 
> Long run, we define a MythTV IR profile, mplayer profile, etc and get
> these into the IR database for universal remotes. Now MythTV can stop
> emulating another vendor's device.
> 
> For the default MythTV case no external support will need to be
> installed if the protocol decode engines are in the kernel. The raw
> data will come in, run through the engines, and pop out as evdev
> messages with a vendor/device/command triplet. Devices that decode in
> hardware will just send vendor/device/command triplets.
> 


