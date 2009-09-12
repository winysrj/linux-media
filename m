Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbZILNbj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 09:31:39 -0400
Date: Sat, 12 Sep 2009 10:31:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: Media controller: sysfs vs ioctl
Message-ID: <20090912103111.7afffb2d@caramujo.chehab.org>
In-Reply-To: <200909120021.48353.hverkuil@xs4all.nl>
References: <200909120021.48353.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 12 Sep 2009 00:21:48 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi all,
> 
> I've started this as a new thread to prevent polluting the discussions of the
> media controller as a concept.
> 
> First of all, I have no doubt that everything that you can do with an ioctl,
> you can also do with sysfs and vice versa. That's not the problem here.
> 
> The problem is deciding which approach is the best.

True. Choosing the better approach is very important since, once merged, we'll
need to stick it for a very long time.

I saw your proposal of a ioctl-only implementation for the media control. It is
important to have a sysfs implementation also to compare. I can do it.

However, we are currently in the middle of a merge window, and this one will
require even more time than usual, since we have 2 series of patches for
soc_camera and for DaVinci/OMAP that depends on arm and omap architecture merge.

Also, there are some pending merges that requires some time to analyze, like
the ISDB-T/ISDB-S patches and API changes that were proposed for 2.6.32, that
requiring the analysis of both Japanese and Brazilian specs and do some
tests, and the tuner changes for better handling the i2c gates, and the V4L and
DVB specs that we can now merge upstream, as both got converted to DocBook XML
4.1.2 (the same version used upstream).

So, during the next two weeks, we'll have enough fun to handle, in order to get
our patches merged for 2.6.32. So, unfortunately, I'm afraid that we'll need to
give a break on those discussions until the end of the merge window, focusing
on merging the patches we have for 2.6.32.


Cheers,
Mauro
