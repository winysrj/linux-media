Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:41278 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbZLCRbR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 12:31:17 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: lirc@bartelmus.de (Christoph Bartelmus)
Cc: jonsmirl@gmail.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <BE3edeNXqgB@lirc>
Date: Thu, 03 Dec 2009 18:31:20 +0100
In-Reply-To: <BE3edeNXqgB@lirc> (Christoph Bartelmus's message of "01 Dec 2009
	08:45:00 +0100")
Message-ID: <m3k4x42cd3.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc@bartelmus.de (Christoph Bartelmus) writes:

> Currently I would tend to an approach like this:
> - raw interface to userspace using LIRC
> - fixed set of in-kernel decoders that can handle bundled remotes

I'd modify it a bit:
- raw interface to userspace using LIRC
- fixed set of in-kernel decoders

Longer term:

Removing the key assignment tables from the kernel. Plug-and-play can be
then achieved with udev. The only thing needed from the kernel is
indicating the tuner/sensor type, udev can guess the bundled remote type.

Porting the in-kernel drivers (such as ir-common) to LIRC interface
(while not removing the input layer mode).
-- 
Krzysztof Halasa
