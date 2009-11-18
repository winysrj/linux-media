Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52394 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbZKRJiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:38:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: v4l: Use the video_drvdata function in drivers
Date: Wed, 18 Nov 2009 10:38:31 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@infradead.org, sakari.ailus@maxwell.research.nokia.com
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com> <200911180801.48950.hverkuil@xs4all.nl> <829197380911180056i5102b87bw2926a7b38608570d@mail.gmail.com>
In-Reply-To: <829197380911180056i5102b87bw2926a7b38608570d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181038.31139.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Wednesday 18 November 2009 09:56:12 Devin Heitmueller wrote:
> On Wed, Nov 18, 2009 at 2:01 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Very nice cleanup!
> 
> The last time I saw one of these relatively innocent-looking changes
> being done across all drivers without testing, it introduced a rather
> nasty and hard to find OOPS into one of my drivers and I had to fix
> it:
> 
> http://linuxtv.org/hg/v4l-dvb/rev/5a54038a66c9
> 
> Is there some reason this is one massive patch instead of individual
> patches for each driver?

It was just easier to do so in a single patch, there's no other particular 
reason. The patch can be split.

> How confident are we that this *really* isn't going to break some bridge
> without anyone realizing it?  Is this going to be some situation where it
> just "goes in" and then the maintainers of individual bridges are going to
> have to clean up the mess when users start complaining?

Hopefully not. I haven't changed the drivers blindly but I've tried to 
understand the logic behind every piece of code I changed. Obviously a bug can 
still slip in, regardless of how careful we are.

So to answer your question, no, the patch will not blindly introduce a mess 
that will need to be cleaned by driver maintainers, but a bug could still get 
in.

> If there are going to be a series of cleanups such as this, perhaps it
> makes sense for Laurent to setup a tree with all the proposed fixes,
> and put out a call for testers so we can be more confident that it
> doesn't screw anything up.

Good idea, I'll do that. I'll incorporate the review comments and I'll send a 
link to the tree to the mailing list.

> Don't get me wrong, I'm all for seeing these things cleaned up, and
> the more functionality in the core the better.  But I am admittedly a
> bit nervous to see huge patches touching all the drivers where I am
> pretty sure that the developer probably only tested it on a couple of
> drivers and is assuming it works across all.

I share your concern. Unfortunately I can't test all the changes myself 
(unless people start sending me lots of hardware samples, but in that case 
I'll probably have to move to a bigger house :-)).

By the way, how would splitting the patches help solve (or at least mitigate) 
the problem ?

-- 
Regards,

Laurent Pinchart
