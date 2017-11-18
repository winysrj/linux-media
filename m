Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51212 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764654AbdKRK3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Nov 2017 05:29:52 -0500
Date: Sat, 18 Nov 2017 11:29:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: usbvision: remove unneeded DRIVER_LICENSE #define
Message-ID: <20171118102955.GH8368@kroah.com>
References: <CAOFm3uG-b5RYC4Wxms2dPw659cAUPvdVHeZOG8fjfkQji7wyMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFm3uG-b5RYC4Wxms2dPw659cAUPvdVHeZOG8fjfkQji7wyMg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 17, 2017 at 06:26:30PM +0100, Philippe Ombredanne wrote:
> On Fri, Nov 17, 2017 at 6:01 PM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
> > Em Fri, 17 Nov 2017 16:01:41 +0100
> > Philippe Ombredanne <pombredanne@nexb.com> escreveu:
> >
> >> On Fri, Nov 17, 2017 at 3:58 PM, Mauro Carvalho Chehab
> >> <mchehab@s-opensource.com> wrote:
> >> > Em Fri, 17 Nov 2017 15:18:26 +0100
> >> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:
> >> >
> >> > Its license is actually GPL 2.0+
> >> >
> >> > So, I would actually change it to:
> >> >
> >> > MODULE_LICENSE("GPL v2");
> >>
> >> Mauro:
> >>
> >> actually even if it sounds weird the module.h doc [1] is clear on this topic:
> >>
> >>  * "GPL" [GNU Public License v2 or later]
> >>  * "GPL v2" [GNU Public License v2]
> >>
> >> So it should be "GPL" IMHO.
> >>
> >>
> >> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/module.h?id=refs/tags/v4.10#n175
> >>
> >
> > Oh! Yeah, you're right. I would add that on the Kernel documentation
> > somewhere, perhaps with the new document that Thomas is writing
> > about SPFX.
> > The Documentation/kernel-hacking/hacking.rst doc mentions
> > MODULE_LICENSE, but doesn't define the expected values for it.
> 
> 
> Good point!
> 
> Thomas:
> Is this something that should be taken care of?
> If yes, I may be able take a crack at it sometimes next week.
> 
> unless...
> 
> Mauro:
> if you have a docwriter soul and want to make a good deed for the
> holidays, may you feel like starting a doc patch? :P
> 
> e.g. something along the lines:
> 
> "Here are the valid values for MODULE_LICENSE as found in module.h ...
> And here are the rules to set a MODULE_LICENSE and how this relates to
> the top level SPDX-License-Identifier..."
> 
> BTW, I wished we could align the MODULE_LICENSE values with the SPDX
> ids for clarity and as this would inject normalized SPDX license tags
> in the Elf binaries.
> 
> But that 's likely impossible as it would break a truck load of
> out-of-tree module macros and out-of-tree module loading command line
> tools everywhere (such as busybox and many other) so the (computing)
> world would crawl to a halt. *sigh*

That's a much longer-term project, let's get the obvious things done
first before worrying about this type of thing :)

thanks,

greg k-h
