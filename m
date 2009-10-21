Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:1606 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbZJUTdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 15:33:07 -0400
Received: by qw-out-2122.google.com with SMTP id 9so985423qwb.37
        for <linux-media@vger.kernel.org>; Wed, 21 Oct 2009 12:33:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ADED23C.2080002@uq.edu.au>
References: <4ADED23C.2080002@uq.edu.au>
Date: Wed, 21 Oct 2009 15:33:10 -0400
Message-ID: <303a8ee30910211233r111d3378vedc1672f68728717@mail.gmail.com>
Subject: Re: Leadtek DTV-1000S
From: Michael Krufky <mkrufky@kernellabs.com>
To: Ryan Day <ryan.day@uq.edu.au>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 21, 2009 at 5:19 AM, Ryan Day <ryan.day@uq.edu.au> wrote:
> Michael-
> I wanted to see if you might be able to assist in getting a DTV-1000S to
> work.  I followed the instructions on the Whirlpool forum (DL the firmware,
> cp it to /lib/firmware, dl the dtv-1000s files from kernellabs.com, untar,
> make, make install, reboot), and everything looks good when I install, but
> when I reboot, the boot up hangs and eventually freezes.
>
> I thought reinstalling might give me a better chance for success with a
> clean slate to work with, but the problem continues.  Unfortunately, I don't
> have any of the error logs or anything, as I reinstalled.
>
> I can't remember the message at the first hang, but the freeze is caused by
> a failure to load the LIRC module.
>
> Also of note is that I'm installing this card as a second tuner.  I have a
> DTV-2000H already installed.  I don't know if that changes anything.
>
> Sorry I can't provide better info, but any advice you can give would be
> great.

Ryan,

This is really a question for the linux-media mailing list, so I've
added it in cc -- please use REPLY-TO-ALL in your correspondence, so
that anybody else that may have seen this issue can chime in with
their advice, or perhaps they may benefit themselves simply by reading
your problem description.  Also, please remember that your response on
the mailing list should appear below the quoted thread.

Meanwhile, why would failure to load the LIRC module cause a problem
on your board, causing a system hang... Sounds fishy to me -- are you
sure about this?

Have you tried deleting / blacklisting the module that you believe to
be freezing your system?

Have you tried moving your PCI card to another slot?

Have you google'd for other users of your motherboard who might be
suffering from similar issues?

I updated the dtv1000s tree yesterday, with the intention of getting
it merged into the master branch.  Perhaps there is a bug in the new
repository that is not present in the old repository?

The current repository that you probably have already tested is located here:

http://kernellabs.com/hg/~mkrufky/dtv1000s

The only difference in the new tree when compared to the older tree,
is that I've pulled in the latest v4l-dvb core changes from the master
branch on linuxtv.org, and updated the DTV1000S patch to account for
the latest board additions in the saa7134 driver.  The dtv1000s
support itself hasn't changed at all.  To eliminate this as a possible
cause, you can try testing the older tree, instead.  The older tree
that has already been tested by other users of both flavors of this
dtv1000s board is located here:

http://kernellabs.com/hg/~mkrufky/dtv1000s.old

If the older repository works but the new one doesn't, that would
indicate that there is a problem in the master v4l-dvb repository.

If all else fails, try removing the other board that you have
installed, and see if that is a factor in this problem

Please test and report your findings back to the mailing list as a
reply-to-all response in this thread.

I hope this helps.

Regards,

Mike Krufky
