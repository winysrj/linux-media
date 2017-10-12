Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35713 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751458AbdJLMZ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 08:25:59 -0400
Date: Thu, 12 Oct 2017 13:25:57 +0100
From: Sean Young <sean@mess.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls.cx18@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 04/26] media: lirc_zilog: remove receiver
Message-ID: <20171012122557.4hvg6qfje2u7ef5o@gofer.mess.org>
References: <cover.1507618840.git.sean@mess.org>
 <176506027db4255239dc8ce192dc6652af75bd52.1507618840.git.sean@mess.org>
 <1507750996.2479.11.camel@gmail.com>
 <20171011210237.bpbfuhpf7om26ldi@gofer.mess.org>
 <0D74D058-EE11-4BFF-974C-16DB6910D2CF@gmail.com>
 <CAGoCfixQ6uLwbs7pQv5SzNkhP_Au18WrdNnM=Odi4JpbAn174w@mail.gmail.com>
 <1507769407.2736.10.camel@gmail.com>
 <CAGoCfiyfEHqrNqQP6eiJ58rpMBasezwbS23N5bqcrSVv8P760Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGoCfiyfEHqrNqQP6eiJ58rpMBasezwbS23N5bqcrSVv8P760Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin, Andy,

On Wed, Oct 11, 2017 at 10:25:34PM -0400, Devin Heitmueller wrote:
> Hi Andy,
> 
> > 5. Rx and IR Learn both use the same external hardware.  Not
> > coordinating Rx with Learn mode in the same driver, will prevent Learn
> > operation from working.  That is, if Learn mode is ever implemented.
> > (Once upon a time, I was planning on doing that.  But I have no time
> > for that anymore.)
> 
> There's not really any infrastructure in Linux that maps to the
> Zilog's "learning mode" functionality.  Usually I would just tell
> users to do the learning under Windows and send me the resulting .ini
> file (which we could then add to the database).
> 
> I had planned on getting rid of the database entirely and just
> converting an MCE compatible pulse train to the blasting format
> required by the Zilog firmware (using the awesome work you sent me
> privately), but the fact of the matter is that nobody cares and MCEUSB
> devices are $20 online.

I wouldn't mind working on that, if I had the blasting format. :)

Note that you can have IR Rx and Tx on a gpio port, so it can get even
cheaper than $20. The hauppauge solution with a z8 microcontroller
with it's non-obvious firmware and i2c format seem a bit ludricous.

> > I'm glad someone remembers all this stuff.  I'm assuming you had more
> > pain with this than I ever did.
> 
> This would be a safe assumption.  I probably put about a month's worth
> of engineering into driver work for the Zilog, which seems
> extraordinary given how simple something like an IR blaster/receiver
> is supposed to be.  I guess that's the fun of proving out a new
> hardware design as opposed to just making something work under Linux
> that is already known to work under Windows.
> 
> > I never owned an HD-PVR.
> 
> I'm sure I have a spare or two if you really want one (not that you
> have the time to muck with such things nowadays).  :-)
> 
> The HD-PVR was a bit of a weird case compared to devices like ivtv and
> cx18 because it was technically multi-master (I2C commands came both
> from the host and from the onboard SOC).  Hence you could have weird
> cases where one would block the other at unexpected times.  I2C
> commands to the Zilog would hold the bus which would delay the onboard
> firmware from issuing commands to the video decoder (fun timing
> issues).  There was also some weird edge case I don't recall the
> details of that prompted them to add an I2C gate in later board
> revisions.

Interesting.

Thanks

Sean
