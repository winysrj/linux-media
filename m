Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:37948 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZK0VuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 16:50:11 -0500
Message-ID: <4B104971.4020800@s5r6.in-berlin.de>
Date: Fri, 27 Nov 2009 22:49:37 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Christoph Bartelmus <christoph@bartelmus.de>, jarod@wilsonet.com,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
In-Reply-To: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> 3) No special tools - use mkdir, echo, cat, shell scripts to build maps

>From the POV of a distributor, there is always a special tool required.
Whether it is implemented in bash, Python, or C doesn't make a
difference to him.

For an enduser whose distributor doesn't package that tool, it also
doesn't matter whether it is bash or Python.  (C is awkward because it
needs to be run through gcc first.)  A Pyton tool can operate the
existing EVIOCSKEYCODE interface just as well as a C tool.

Your mkdir/ echo/ cat programs would still just this:  Programs.  Sure,
these programs would be interpreted by an interpreter which is installed
everywhere, and the data they operate on is in a clear text format.  The
downside is that these programs do not exist yet.

> 5) Direct multi-app support - no daemon

Think of lircd (when it feeds into uinput) as of a userspace driver
rather than a daemon.  The huge benefit of a userspace driver is that it
can load configuration files.

Multi-app support is provided by evdev of course.

> What are other goals for this subsystem?

  - Minimal development cost; reduced maintenance cost relative
    the to status quo.

  - No regressions would be best.
-- 
Stefan Richter
-=====-==--= =-== ==-==
http://arcgraph.de/sr/
