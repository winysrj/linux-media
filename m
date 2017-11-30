Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60051 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750768AbdK3W1v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 17:27:51 -0500
Date: Thu, 30 Nov 2017 22:27:49 +0000
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [BUG] ir-ctl: error sending file with multiple scancodes
Message-ID: <20171130222749.zuh6iqv63354wflf@gofer.mess.org>
References: <20171129144400.ojhd32gz33wabp33@camel2.lan>
 <20171129200521.z4phw7kzcmf56qgi@gofer.mess.org>
 <20171130153433.yiunybv2sgfwwt3t@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130153433.yiunybv2sgfwwt3t@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,

On Thu, Nov 30, 2017 at 04:34:33PM +0100, Matthias Reichl wrote:
> Hi Sean,
> 
> On Wed, Nov 29, 2017 at 08:05:21PM +0000, Sean Young wrote:
> > On Wed, Nov 29, 2017 at 03:44:00PM +0100, Matthias Reichl wrote:
> > > The goal I'm trying to achieve is to send a repeated signal with ir-ctl
> > > (a user reported his sony receiver needs this to actually power up).
> > 
> > That's interesting.
> 
> I'm not sure how common that is. I've got a Panasonic TV here
> that needs a 0.5-1sec button press to power up from standby,
> but it could well be that this is a rather nieche issue.
> 
> I had a look at what it would take to add proper repeat handling
> to ir-ctl (similar to the --count <NUMBER> option in lirc's irsend)
> but that looks like a larger endeavour: implement automatic
> variable length gaps to get fixed repeat times, handle toggle
> bits in some protocols, send special repeat codes eg in NEC etc.

Yes, I've thought about that too. I'm not sure what the user inferface
should look like (and how useful it is).

> As I'm not sure if all of this is even needed I think it's best
> to leave it for maybe some time later. For now the current
> functionality in ir-ctl looks sufficient.

If you have any suggestions. :-)

> > > Using the -S option multiple times comes rather close, but the 125ms
> > > delay between signals is a bit long for the sony protocol - would be
> > > nice if that would be adjustable :)
> > 
> > Yes, that would be a useful feature.
> > 
> > I've got some patches for this, I'll send them as a reply to this. Please
> > let me know what you think.
> 
> [PATCH 1/2] ir-ctl: fix multiple scancodes in one file 01-multiple-scancodes.patch
> [PATCH 2/2] ir-ctl: specify the gap between scancodes or files
> 
> Tested-by: Matthias Reichl <hias@horus.com>
> 
> Thanks, the patches look and tested fine!
> 
> I've tested multiple scancodes in a file with and without explicit
> space in between and the gap option with multiple -S scancodes on
> the command line. I also tested rc5 protocol in addition to sony12.
> 
> So I'd like to say a big thank you for fixing the issue so quickly!

Thanks for making ir-ctl a better tool :)


Sean
