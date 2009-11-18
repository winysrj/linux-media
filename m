Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2024 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbZKRJNd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:13:33 -0500
Message-ID: <4c8e56e69e0b1619dd4e5c32d45b8374.squirrel@webmail.xs4all.nl>
In-Reply-To: <829197380911180056i5102b87bw2926a7b38608570d@mail.gmail.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1258504731-8430-8-git-send-email-laurent.pinchart@ideasonboard.com>
    <200911180801.48950.hverkuil@xs4all.nl>
    <829197380911180056i5102b87bw2926a7b38608570d@mail.gmail.com>
Date: Wed, 18 Nov 2009 10:13:30 +0100
Subject: Re: v4l: Use the video_drvdata function in drivers
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Wed, Nov 18, 2009 at 2:01 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Very nice cleanup!
>
> The last time I saw one of these relatively innocent-looking changes
> being done across all drivers without testing, it introduced a rather
> nasty and hard to find OOPS into one of my drivers and I had to fix
> it:
>
> http://linuxtv.org/hg/v4l-dvb/rev/5a54038a66c9
>
> Is there some reason this is one massive patch instead of individual
> patches for each driver?  How confident are we that this *really*
> isn't going to break some bridge without anyone realizing it?  Is this
> going to be some situation where it just "goes in" and then the
> maintainers of individual bridges are going to have to clean up the
> mess when users start complaining?
>
> If there are going to be a series of cleanups such as this, perhaps it
> makes sense for Laurent to setup a tree with all the proposed fixes,
> and put out a call for testers so we can be more confident that it
> doesn't screw anything up.
>
> Don't get me wrong, I'm all for seeing these things cleaned up, and
> the more functionality in the core the better.  But I am admittedly a
> bit nervous to see huge patches touching all the drivers where I am
> pretty sure that the developer probably only tested it on a couple of
> drivers and is assuming it works across all.

I agree that it would help to split this patch up. Some cases are trivial,
so they can be put together in one patch. When things get more complex it
makes sense to put it in a separate patch for easier reviewing by the
relevant maintainers.

This is a very nice cleanup and improves the driver code significantly.
Especially since so many drivers keep copying the same useless code time
and again :-(

Reducing driver code complexity is a very important goal since that is the
weakest point of many of the existing drivers. But it should be done
carefully of course and in such a manner that people can review it easily.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

