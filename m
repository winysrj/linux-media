Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4387 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZA2JiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 04:38:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Merging the v4l2 spec?
Date: Thu, 29 Jan 2009 10:37:54 +0100
Cc: linux-media@vger.kernel.org, Michael Schimek <mschimek@gmx.at>
References: <200901290951.04874.hverkuil@xs4all.nl> <20090129073056.675dd4b4@caramujo.chehab.org>
In-Reply-To: <20090129073056.675dd4b4@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291037.55037.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 January 2009 10:30:56 Mauro Carvalho Chehab wrote:
> On Thu, 29 Jan 2009 09:51:04 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Mauro,
> >
> > Is it possible to merge the v4l2 spec from my tree soon? With all the
> > various new API additions that are being discussed it would help a lot
> > if they can also make patches against the documentation at the same
> > time.
>
> I'd like to give a few more days to Michael Schimek to ack on this. Since
> we are in a period of the year where lots of people gets vacation, it is
> better to give Michael some more time on this.

I haven't heard from him since my first mail on this subject on December 
7th. That's almost two months ago! Even in Europe people don't have that 
much vacation time :-)

> > BTW, I'm working on improving the qv4l2 tool to make it much more
> > useful for testing. I'm integrating it with the v4lconvert lib and
> > added capture support as well. It should become a proper testbench for
> > drivers. All the other tools around are really crappy, so I decided to
> > extend qv4l2 instead.
>
> Good news! IMO, you should also add the new tool to get sysfs patch
> integrated on it. I was planning to do it later, but, since you're
> already working with qv4l2, maybe you can add this feature on it as well.
> The drawback is that it requires libsysfs-devel in order to compile.
> Maybe this can be an optional feature.

Can you give me a pointer? I've no idea what you are referring to.

> > I've also bought a bunch of old hardware from ebay. I should be able to
> > test various old v4l1 drivers and convert them to v4l2. I basically
> > want to be able to test pretty much the whole v4l2 API, preferably with
> > qv4l2. Yesterday two webcams came in, so I can now test w9968cf and
> > se401.
>
> Great! IMO, the better would be to make those cams as sub-drivers of
> gspca.

That was my idea as well.

> > Check out my qv4l2 tree for progress on this tool!
>
> I'll take a look soon.
>
> > Now all I need is lots more time :-(
>
> I know what you're meaning... I'm also needing more time here... I just
> wrote some tools to help me with patchwork stuff. Hopefully, this week,
> I'll have all pending patches (there that aren't being reviewed by
> somebody else) updated.

Cool.

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
