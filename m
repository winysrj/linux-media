Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42979 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZA2JbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 04:31:25 -0500
Date: Thu, 29 Jan 2009 07:30:56 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Michael Schimek <mschimek@gmx.at>
Subject: Re: Merging the v4l2 spec?
Message-ID: <20090129073056.675dd4b4@caramujo.chehab.org>
In-Reply-To: <200901290951.04874.hverkuil@xs4all.nl>
References: <200901290951.04874.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009 09:51:04 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Mauro,
> 
> Is it possible to merge the v4l2 spec from my tree soon? With all the 
> various new API additions that are being discussed it would help a lot if 
> they can also make patches against the documentation at the same time.

I'd like to give a few more days to Michael Schimek to ack on this. Since we
are in a period of the year where lots of people gets vacation, it is better to
give Michael some more time on this.

> BTW, I'm working on improving the qv4l2 tool to make it much more useful for 
> testing. I'm integrating it with the v4lconvert lib and added capture 
> support as well. It should become a proper testbench for drivers. All the 
> other tools around are really crappy, so I decided to extend qv4l2 instead.

Good news! IMO, you should also add the new tool to get sysfs patch integrated
on it. I was planning to do it later, but, since you're already working with
qv4l2, maybe you can add this feature on it as well. The drawback is that it
requires libsysfs-devel in order to compile. Maybe this can be an optional feature.

> I've also bought a bunch of old hardware from ebay. I should be able to test 
> various old v4l1 drivers and convert them to v4l2. I basically want to be 
> able to test pretty much the whole v4l2 API, preferably with qv4l2. 
> Yesterday two webcams came in, so I can now test w9968cf and se401.

Great! IMO, the better would be to make those cams as sub-drivers of gspca. 

> Check out my qv4l2 tree for progress on this tool!

I'll take a look soon.

> Now all I need is lots more time :-(

I know what you're meaning... I'm also needing more time here... I just wrote
some tools to help me with patchwork stuff. Hopefully, this week, I'll have all
pending patches (there that aren't being reviewed by somebody else) updated.

Cheers,
Mauro
