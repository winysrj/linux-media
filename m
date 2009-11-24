Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39590 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934355AbZKXXlJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 18:41:09 -0500
Subject: Re: cx18: Reprise of YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <829197380911240957t5bc93f3esb85bea7a5a12bf04@mail.gmail.com>
References: <1257913905.28958.32.camel@palomino.walls.org>
	 <829197380911221904uedc18e5qbc9a37cfcee23b5d@mail.gmail.com>
	 <1258978370.3058.25.camel@palomino.walls.org>
	 <829197380911230909u27f6df33icbbc52c5268a1658@mail.gmail.com>
	 <1259027346.3871.76.camel@palomino.walls.org>
	 <829197380911240957t5bc93f3esb85bea7a5a12bf04@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 24 Nov 2009 18:39:33 -0500
Message-Id: <1259105973.3069.14.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-11-24 at 12:57 -0500, Devin Heitmueller wrote:
> On Mon, Nov 23, 2009 at 8:49 PM, Andy Walls <awalls@radix.net> wrote:
> > Of course that's all speculation about the problem.  If you could
> > reproduce the condition and then
> >
> > # echo 271 > /sys/modules/cx18/parameters/debug
> 
> Hi Andy,
> 
> Thanks for the additional info.  I had to tear down my HVR-1600 test
> rig to finish the em28xx PAL support

So I read -- Looks good!

>  (using a PVR-350 and the CD of
> PAL VBI samples you were very kind in sending me), but I should be
> able to get back to this early next week.

Take your time.  I've got plenty of other problems. ;)


BTW, I did a quick skim of your cx18-alsa stuff.  I noticed two things:

1.  A memory leak in an error path:

http://www.kernellabs.com/hg/~dheitmueller/hvr-1600-alsa-2/rev/cb267593943f#l85


2.  Technically open_id should probably be changed to an atomic type and
atomic_inc() used:

http://www.kernellabs.com/hg/~dheitmueller/hvr-1600-alsa-2/rev/cb267593943f#l80

Under normal use it will likely never matter though, but perhaps someone
could use it as a possible exploit.



I'll try and give the code a good review and test sometime this weekend.
I just wanted to let you know about those minor bugs before I forgot.

Regards,
Andy

> Devin


