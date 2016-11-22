Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36611 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753523AbcKVJUw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 04:20:52 -0500
Date: Tue, 22 Nov 2016 09:20:44 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161122092043.GA8630@gofer.mess.org>
References: <20161116105256.GA9998@shambles.local>
 <20161117134526.GA8485@gofer.mess.org>
 <20161118121422.GA1986@shambles.local>
 <20161118174034.GA6167@gofer.mess.org>
 <20161118220107.GA3510@shambles.local>
 <20161120132948.GA23247@gofer.mess.org>
 <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 22, 2016 at 06:25:59PM +1100, Vincent McIntyre wrote:
> On 11/21/16, Sean Young <sean@mess.org> wrote:
> >>
> >> Ah. Here we have a problem. The device (/dev/input/event15)
> >> doesn't have a corresponding rcX node, see ir-keytable output below.
> >> I had it explained to me like this:
> >
> > As I said you would need to use a raw IR receiver which has rc-core support
> > to determine the protocol, so never mind. Please can you try this patch:
> >
> > I don't have the hardware to test this so your input would be appreciated.
> >
> 
> Thanks for this. I have got it to build within the media_build setup
> but will need to find some windows in the schedule for testing. More
> in a couple of days. Are there specific things you would like me to
> test?

You should have an rc device for the IR receiver in the dvb device; does
it continue to work and can you clear/load a new keymap with ir-keytable,
and does it work after that.

A "Tested-by" would be great if it all works of course.

Thanks
Sean
