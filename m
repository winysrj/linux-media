Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:43884 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdJLCZf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 22:25:35 -0400
Received: by mail-qt0-f172.google.com with SMTP id a43so11115135qta.0
        for <linux-media@vger.kernel.org>; Wed, 11 Oct 2017 19:25:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1507769407.2736.10.camel@gmail.com>
References: <cover.1507618840.git.sean@mess.org> <176506027db4255239dc8ce192dc6652af75bd52.1507618840.git.sean@mess.org>
 <1507750996.2479.11.camel@gmail.com> <20171011210237.bpbfuhpf7om26ldi@gofer.mess.org>
 <0D74D058-EE11-4BFF-974C-16DB6910D2CF@gmail.com> <CAGoCfixQ6uLwbs7pQv5SzNkhP_Au18WrdNnM=Odi4JpbAn174w@mail.gmail.com>
 <1507769407.2736.10.camel@gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Wed, 11 Oct 2017 22:25:34 -0400
Message-ID: <CAGoCfiyfEHqrNqQP6eiJ58rpMBasezwbS23N5bqcrSVv8P760Q@mail.gmail.com>
Subject: Re: [PATCH v3 04/26] media: lirc_zilog: remove receiver
To: Andy Walls <awalls.cx18@gmail.com>
Cc: Sean Young <sean@mess.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

> 5. Rx and IR Learn both use the same external hardware.  Not
> coordinating Rx with Learn mode in the same driver, will prevent Learn
> operation from working.  That is, if Learn mode is ever implemented.
> (Once upon a time, I was planning on doing that.  But I have no time
> for that anymore.)

There's not really any infrastructure in Linux that maps to the
Zilog's "learning mode" functionality.  Usually I would just tell
users to do the learning under Windows and send me the resulting .ini
file (which we could then add to the database).

I had planned on getting rid of the database entirely and just
converting an MCE compatible pulse train to the blasting format
required by the Zilog firmware (using the awesome work you sent me
privately), but the fact of the matter is that nobody cares and MCEUSB
devices are $20 online.

> I'm glad someone remembers all this stuff.  I'm assuming you had more
> pain with this than I ever did.

This would be a safe assumption.  I probably put about a month's worth
of engineering into driver work for the Zilog, which seems
extraordinary given how simple something like an IR blaster/receiver
is supposed to be.  I guess that's the fun of proving out a new
hardware design as opposed to just making something work under Linux
that is already known to work under Windows.

> I never owned an HD-PVR.

I'm sure I have a spare or two if you really want one (not that you
have the time to muck with such things nowadays).  :-)

The HD-PVR was a bit of a weird case compared to devices like ivtv and
cx18 because it was technically multi-master (I2C commands came both
from the host and from the onboard SOC).  Hence you could have weird
cases where one would block the other at unexpected times.  I2C
commands to the Zilog would hold the bus which would delay the onboard
firmware from issuing commands to the video decoder (fun timing
issues).  There was also some weird edge case I don't recall the
details of that prompted them to add an I2C gate in later board
revisions.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
