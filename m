Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:51364 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbbIOU2J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 16:28:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [Y2038] [PATCH 7/7] [RFC] [media] introduce v4l2_timespec type for timestamps
Date: Tue, 15 Sep 2015 22:27:56 +0200
Message-ID: <1872149.XE0by8RQTx@wuerfel>
In-Reply-To: <55F84824.2000603@xs4all.nl>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de> <1442332148-488079-8-git-send-email-arnd@arndb.de> <55F84824.2000603@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 15 September 2015 18:32:36 Hans Verkuil wrote:
> >  
> > -     ktime_get_ts(&timestamp);
> > +     ktime_get_ts64(&timestamp);
> > +     vts.tv_sec = timestamp.tv_sec;
> > +     vts.tv_nsec = timestamp.tv_nsec;
> 
> I prefer to take this opportunity to create a v4l2_get_timespec helper
> function, just like v4l2_get_timeval.

Ok, good idea. I'll do that once we have agreed on the ABI.

> > @@ -2088,7 +2094,7 @@ struct v4l2_event {
> >       } u;
> >       __u32                           pending;
> >       __u32                           sequence;
> > -     struct timespec                 timestamp;
> > +     struct v4l2_timespec            timestamp;
> >       __u32                           id;
> >       __u32                           reserved[8];
> >  };
> > 
> 
> I think I am OK with this. This timestamp is used much more rarely and I do
> not expect this ABI change to cause any problems in userspace.

I'd still wait the outcome of the v4l2_timeval discussion though. It may
be useful for consistency to pick the same approach for both structures.

	Arnd
