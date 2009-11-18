Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59576 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZKRI4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 03:56:08 -0500
Received: by bwz27 with SMTP id 27so838070bwz.21
        for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 00:56:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911180801.48950.hverkuil@xs4all.nl>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1258504731-8430-8-git-send-email-laurent.pinchart@ideasonboard.com>
	 <200911180801.48950.hverkuil@xs4all.nl>
Date: Wed, 18 Nov 2009 03:56:12 -0500
Message-ID: <829197380911180056i5102b87bw2926a7b38608570d@mail.gmail.com>
Subject: Re: v4l: Use the video_drvdata function in drivers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 18, 2009 at 2:01 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Very nice cleanup!

The last time I saw one of these relatively innocent-looking changes
being done across all drivers without testing, it introduced a rather
nasty and hard to find OOPS into one of my drivers and I had to fix
it:

http://linuxtv.org/hg/v4l-dvb/rev/5a54038a66c9

Is there some reason this is one massive patch instead of individual
patches for each driver?  How confident are we that this *really*
isn't going to break some bridge without anyone realizing it?  Is this
going to be some situation where it just "goes in" and then the
maintainers of individual bridges are going to have to clean up the
mess when users start complaining?

If there are going to be a series of cleanups such as this, perhaps it
makes sense for Laurent to setup a tree with all the proposed fixes,
and put out a call for testers so we can be more confident that it
doesn't screw anything up.

Don't get me wrong, I'm all for seeing these things cleaned up, and
the more functionality in the core the better.  But I am admittedly a
bit nervous to see huge patches touching all the drivers where I am
pretty sure that the developer probably only tested it on a couple of
drivers and is assuming it works across all.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
