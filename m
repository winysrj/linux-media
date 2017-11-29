Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34057 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751254AbdK2UFX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 15:05:23 -0500
Date: Wed, 29 Nov 2017 20:05:21 +0000
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [BUG] ir-ctl: error sending file with multiple scancodes
Message-ID: <20171129200521.z4phw7kzcmf56qgi@gofer.mess.org>
References: <20171129144400.ojhd32gz33wabp33@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129144400.ojhd32gz33wabp33@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,

On Wed, Nov 29, 2017 at 03:44:00PM +0100, Matthias Reichl wrote:
> Hi Sean!
> 
> According to the ir-ctl manpage it should be possible to send a file
> containing multiple scancodes, but when trying to do this I get
> a warning and an error message.
> 
> I initially noticed that on version 1.12.3 but 1.12.5 and master
> (rev 85f8e5a99) give the same error.
> 
> Sending a file with a single scancode or using the -S option
> to specify the scancode on the command line both work fine.
> 
> I've tested with the following file:
> 
> scancode sony12:0x100015
> space 25000
> scancode sony12:0x100015
> 
> Trying to send it gives this:
> $ ./utils/ir-ctl/ir-ctl -s ../sony-test.irctl
> warning: ../sony-test.irctl:2: trailing space ignored
> /dev/lirc0: failed to send: Invalid argument
> 
> Checking with the -v option gives some interesting output - it
> looks like the the second half of the buffer hadn't been filled in:
> 
> $ ./utils/ir-ctl/ir-ctl -v -s ../sony-test.irctl
> warning: ../sony-test.irctl:2: trailing space ignored
> Sending:
> pulse 2400
> space 600
> pulse 1200
> space 600
> pulse 600
> space 600
> pulse 1200
> space 600
> pulse 600
> space 600
> pulse 1200
> space 600
> pulse 600
> space 600
> pulse 600
> space 600
> pulse 600
> space 600
> pulse 600
> space 600
> pulse 600
> space 600
> pulse 600
> space 600
> pulse 1200
> space 600
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> space 0
> pulse 0
> /dev/lirc0: failed to send: Invalid argument

Oh dear, that looks very broken! Looks like I did not test multiple
scancodes in one file.

> The goal I'm trying to achieve is to send a repeated signal with ir-ctl
> (a user reported his sony receiver needs this to actually power up).

That's interesting.

> Using the -S option multiple times comes rather close, but the 125ms
> delay between signals is a bit long for the sony protocol - would be
> nice if that would be adjustable :)

Yes, that would be a useful feature.

I've got some patches for this, I'll send them as a reply to this. Please
let me know what you think.

Thanks,

Sean
