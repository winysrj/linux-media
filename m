Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58586 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758512Ab0KOV7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 16:59:30 -0500
Subject: Re: Hauppauge WinTV MiniStick IR in 2.6.36 - [PATCH]
From: Andy Walls <awalls@md.metrocast.net>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	stefano.pompa@gmail.com
In-Reply-To: <20101115150903.GB10718@linux-m68k.org>
References: <20101115112746.GB6607@linux-m68k.org>
	 <1289824506.2057.9.camel@morgan.silverblock.net>
	 <20101115150903.GB10718@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 16:59:24 -0500
Message-ID: <1289858364.5515.3.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2010-11-15 at 16:09 +0100, Richard Zidlicky wrote:
> On Mon, Nov 15, 2010 at 07:35:06AM -0500, Andy Walls wrote:
> > On Mon, 2010-11-15 at 12:27 +0100, Richard Zidlicky wrote:
> 
> > http://git.linuxtv.org/v4l-utils.git?a=tree;f=utils/keytable;h=e599a8b5288517fc7fe58d96f44f28030b04afbc;hb=HEAD
> 
> thanks, that should do the trick. 
> 
> In addition I am wondering if the maps of the two remotes that apparently get 
> bundled with the MiniStick should not be merged into one map in the kernel sources 
> so the most common cases are covered?

I have a certain case where I would like the maps of two bundled remotes
both to be loaded - one an RC-5 and one an RC-6 - for a receiver on the
HVR-1850 and friends.

I recall there's something in the works about allowing multiple input
devices per remote control receiver.  (I haven't been paying as much
attention as I should.) So maybe one day...

Regards,
Andy

> Richard


