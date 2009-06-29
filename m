Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:23267 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754766AbZF2XCM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 19:02:12 -0400
From: David Brownell <david-b@pacbell.net>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 3/3 - v0] davinci: platform changes to support vpfe camera capture
Date: Mon, 29 Jun 2009 15:55:35 -0700
Cc: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1246053948-8371-1-git-send-email-m-karicheri2@ti.com> <200906291043.43140.david-b@pacbell.net> <A69FA2915331DC488A831521EAE36FE401448CE221@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401448CE221@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291555.35568.david-b@pacbell.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 29 June 2009, Karicheri, Muralidharan wrote:
> I think you didn't get my point. We have patches that are in
> the pipeline waiting for merge that is neither available in
> the upstream nor in the DaVinci tree.

The linux-media pipeline.  Sure.  I'm quite familiar with
what it means to have pathes depending on others, which are
headed upstream by different merge queues.


> That gets merged to 
> upstream at some point in future and also will get rebased
> to DaVinci later. But If I need to make patches based on them
> (like this one) it can be done only by applying the patches
> to the DaVinci tree and then creating new patches based on
> that. That is why my note clearly says " Depends on v3 version
> of vpfe capture driver patch"        

Maybe you're not getting my point:  that submitting a patch
series against mainline (or almost-mainline) means you don't
trip across goofs like the one I first noted.  That one was
pretty obvious.  The more subtle problems are harder to see...

In this case, your patch ignored a driver that's been in GIT
since December.  Which means that you're developing against
a code base that's ... pretty old, not nearly current enough.

I fully understand that all this video stuff is a large and
complex chunk of driver code.  That's *ALL THE MORE REASON* to
be sure you're tracking mainline (or in some cases the DaVinci
platform code) very closely when you send patches upstream.
Because all kinds of stuff will have changed between six months
ago and today.  Standard policy is to develop such merge patches
with more or less bleeding edge code, so integration issues
show up (and get resolved) ASAP.

I can't believe the current linux-media or V4L2 trees are
six months out of date.

- Dave

