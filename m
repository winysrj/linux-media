Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49113 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752093Ab0GIHXy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jul 2010 03:23:54 -0400
Date: Fri, 9 Jul 2010 09:23:04 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Norbert Wegener <nw@wegener-net.de>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: 1b80:d393 Afatech supported?
Message-ID: <20100709072304.GA8938@minime.bse>
References: <c1892bff73376fe4888d83d4da91eeed.squirrel@www.wegener-net.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1892bff73376fe4888d83d4da91eeed.squirrel@www.wegener-net.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please use linux-media@vger.kernel.org, video4linux-list@redhat.com is
dead.

On Thu, Jul 08, 2010 at 10:54:23PM +0200, Norbert Wegener wrote:
> I got a Conceptronics usb dvb-t stick. lsusb displays it as:
> ...
> Bus 001 Device 007: ID 1b80:d393 Afatech

Although it says Afatech, this one has a Realtek chip.
AFAIK there is currently only the out-of-tree driver written by Realtek.
I suggest following criticalmess' instructions in here:
	https://bugs.launchpad.net/ubuntu/+source/me-tv/+bug/478379


Should this driver maybe be put into staging?

  Daniel
