Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41852 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaDQX6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 19:58:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: will@williammanley.net
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvcvideo: Work around buggy Logitech C920 firmware
Date: Fri, 18 Apr 2014 01:58:13 +0200
Message-ID: <1531415.W4qquBIbnZ@avalon>
In-Reply-To: <1397471220.18984.106207305.0AC6C440@webmail.messagingengine.com>
References: <1394647711-25291-1-git-send-email-will@williammanley.net> <1551199.fyCn5EYGon@avalon> <1397471220.18984.106207305.0AC6C440@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Will,

On Monday 14 April 2014 11:27:00 Will Manley wrote:
> On Mon, 14 Apr 2014, at 1:34, Laurent Pinchart wrote:

[snip]

> > Thank you for investigating this, and sorry for the late reply.
> > 
> > I still haven't heard back from Logitech on this issue. I've pinged them,
> > they might be busy at the moment.
> 
> Thanks for looking at my patch :).

You're welcome.

> > Given that the device notifies us that the control value changes, one
> > possibly more clever fix would be to handle that even and set the old
> > control value back when the auto control is disabled. However, that's
> > probably an overengineered solution.
> > 
> > I've still been wondering whether the quirk shouldn't restore only the
> > control(s) that are known to be erroneously changed by the camera instead
> > of restoring them all. Feel free to disagree, what's your opinion about
> > that ?
> 
> So that was my initial intention, but when I got into it it seemed like
> it was going to add a whole bunch of additional complexity (and lines of
> code) for questionable benefit.  While uploading all the values is a bit
> of a sledgehammer it has the advantage that it's simple and dumb and
> exercises code that's already in use for suspend/resume.  OTOH you could
> argue that a patch which explicitly contains code like:
> 
>     if (strcmp(param.name, "Exposure (Absolute)") == 0) {
>         blah, blah, blah
>     }
> 
> or similar documents the quirk a little more explicitly.  I still didn't
> think it was worth the extra complexity.  I'm quite willing to be
> convinced otherwise though :).
> 
> Another more marginal advantage is that the quirk may be more applicable
> to other hardware.  Of course this is entirely theoretical at this point
> so probably can be discounted.

One of the things that bother me with restoring all controls right after 
starting the stream is that it might actually result in different unexpected 
behaviors. For instance, this would write the value of all manual controls 
even when the corresponding auto control is turned on. Some cameras might not 
be happy, and this could have an adverse effect from temporary glitches in the 
video to complete crashes. Of course the quirk should not be enabled for 
cameras that would then crash, so we could consider that it's good as-is for 
the C920.

I'd like to hear from Logitech on this issue before taking a decision. I've 
pinged them, let's wait one more week if that's fine with you.

In the meantime, there's another question that crossed my mind, have you 
checked whether the camera has a similar buggy behaviour for other auto 
controls (auto white balance for instance), or if it's limited to auto-
exposure ?

-- 
Regards,

Laurent Pinchart

