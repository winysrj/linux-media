Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:58919 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751763AbdHXIxx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 04:53:53 -0400
Date: Thu, 24 Aug 2017 09:53:52 +0100
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org,
        d.scheller@gmx.net
Subject: Re: [PATCH] [media_build] rc: Fix ktime erros in rc_ir_raw.c
Message-ID: <20170824085351.nf2ymtahbaupj7ss@gofer.mess.org>
References: <1503531988-15429-1-git-send-email-jasmin@anw.at>
 <9b070969-9422-b809-3611-648d8da0e121@anw.at>
 <93053a66-18f2-9c4f-1987-49687d8f3069@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93053a66-18f2-9c4f-1987-49687d8f3069@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 24, 2017 at 08:47:54AM +0200, Hans Verkuil wrote:
> On 08/24/2017 02:07 AM, Jasmin J. wrote:
> > Hi!
> > 
> > Just some notes on that patch.
> > 
> > I have *not* tested it due to the lack of an ir remote control. So someone
> > needs to test this on an <= 4.9 Kernel, if the ir core is still working as
> > expected.
> > 
> > Even if I fixed that in media_build, it may be better to apply this code change
> > in media_tree. This because the involved variables are all of type ktime_t and
> > there are accessor and converter functions available for that type, which
> > should have been used by the original author of 86fe1ac0d and 48b2de197 in my
> > opinion.
> 
> Sean,
> 
> I agree with Jasmin here. I noticed the same errors in the daily build and it
> is really caused by not using the correct functions. I just didn't have the
> time to follow up on it.
> 
> Can you take a look at Jasmin's patch and, if OK, make a pull request for
> it?

I hadn't taken media_build into account when I wrote this, so yes I'll
have a look and create a pull request.


Sean
