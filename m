Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47179 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbeJVVgC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 17:36:02 -0400
Date: Mon, 22 Oct 2018 14:17:27 +0100
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] media: rc: cec devices do not have a lirc chardev
Message-ID: <20181022131727.yf5e6gorccs3m6w7@gofer.mess.org>
References: <b067e063-641c-0498-4989-3edda5296f9a@mbox200.swipnet.se>
 <e2bb2b91-861b-8cdc-4ad4-939e50019214@xs4all.nl>
 <20181022085910.2gndxc75zcqkto5z@gofer.mess.org>
 <1a63a5b5-644f-cef4-d0ad-9ae3bf491f9a@mbox200.swipnet.se>
 <20181022101405.v7setqacuftrafrb@gofer.mess.org>
 <45261f15-b022-8871-b087-937988b3bf1f@xs4all.nl>
 <20181022122842.mvrvpfyaflvmtbf6@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181022122842.mvrvpfyaflvmtbf6@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 22, 2018 at 01:28:42PM +0100, Sean Young wrote:
> On Mon, Oct 22, 2018 at 12:30:29PM +0100, Hans Verkuil wrote:
> > On 10/22/2018 11:14 AM, Sean Young wrote:
> > > Would you be able to test the following patch please?
> > 
> > Sean,
> > 
> > I think you should be able to test this with the vivid driver. Load the vivid driver,
> > run:
> > 
> > cec-ctl --tv; cec-ctl -d1 --playback
> > 
> > Then:
> > 
> > cec-ctl -d1 -t0 --user-control-pressed ui-cmd=F5
> 
> Ah, thanks. That will help with testing/reproducing.
>  
> > That said, I tried this, but it doesn't crash for me, but perhaps I need to run
> > some RC command first...
> 
> Hmm I think those commands should be enough. It probably needs
> CONFIG_DEBUG_SPINLOCK to detect the uninitialized spinlock. I'm trying it now.

Yes, that turned out to work. With CONFIG_DEBUG_SPINLOCK on, it goes bang
every time. With the patch, the problem goes away.

Without CONFIG_DEBUG_SPINLOCK we're going into undefined behaviour, so 
Torbjorn you're only seeing the oops occassionally (and which is why it has
not been observed or reported before).

Thanks,

Sean
