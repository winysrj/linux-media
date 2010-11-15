Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59240 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab0KOW6L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 17:58:11 -0500
Received: by bwz15 with SMTP id 15so41771bwz.19
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 14:58:10 -0800 (PST)
Date: Mon, 15 Nov 2010 23:57:46 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	stefano.pompa@gmail.com
Subject: Re: Hauppauge WinTV MiniStick IR in 2.6.36 - [PATCH]
Message-ID: <20101115225746.GA26766@linux-m68k.org>
References: <20101115112746.GB6607@linux-m68k.org> <1289824506.2057.9.camel@morgan.silverblock.net> <20101115150903.GB10718@linux-m68k.org> <1289858364.5515.3.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289858364.5515.3.camel@morgan.silverblock.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Nov 15, 2010 at 04:59:24PM -0500, Andy Walls wrote:
> On Mon, 2010-11-15 at 16:09 +0100, Richard Zidlicky wrote:
> > On Mon, Nov 15, 2010 at 07:35:06AM -0500, Andy Walls wrote:
> > > On Mon, 2010-11-15 at 12:27 +0100, Richard Zidlicky wrote:
> > 
> > > http://git.linuxtv.org/v4l-utils.git?a=tree;f=utils/keytable;h=e599a8b5288517fc7fe58d96f44f28030b04afbc;hb=HEAD
> > 
> > thanks, that should do the trick. 
> > 
> > In addition I am wondering if the maps of the two remotes that apparently get 
> > bundled with the MiniStick should not be merged into one map in the kernel sources 
> > so the most common cases are covered?
> 
> I have a certain case where I would like the maps of two bundled remotes
> both to be loaded - one an RC-5 and one an RC-6 - for a receiver on the
> HVR-1850 and friends.

looks a bit more twisted. In the case of the siano reciever it should be 
simpler. Apparently it has been bundled with 2 different rc5 type remotes
and normal users will have either one of them. So technically it is very 
easy to provide a table that serves both cases.

Richard

