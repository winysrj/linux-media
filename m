Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:1849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZK2V71 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 16:59:27 -0500
Message-ID: <4B12EEC2.3030207@gmail.com>
Date: Sun, 29 Nov 2009 22:59:30 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: mike@mtgambier.net
CC: Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com> <200911291317.03612.mike@mtgambier.net>
In-Reply-To: <200911291317.03612.mike@mtgambier.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mike Lampard wrote:
> an example I have a VDR instance running in the background on my desktop 
> machine outputting to a TV in another room via a pci mpeg decoder - I 
> certainly don't want the VDR remote control interacting with my X11 desktop in 
> any way unless I go out of my way to set it up to do so, nor do I want it 
> interacting with other applications (such as MPD piping music around the 
> house) that are controlled via other remotes in other rooms unless specified.
> 
> Setting this up with Lircd was easy, how would a kernel-based proposal handle 
> this?

eg

EV="/dev/input/"$( cd "/sys/class/input" &&
   ( grep -l 'X10' event*/device/name || grep -l 'X10' event*/device/manufacturer ) |
   sed -e 's,/.*,,' )

./vdr [...] -P "remote -i $EV"

This is how it has worked for years, so there's no reason it wouldn't work w/ any
future scheme. The remote buttons normally arrive as normal kbd keys; once an app
grabs the input device corresponding to a remote, it receives the events exclusively.

artur
