Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4894 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZBVKFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 05:05:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Adam Baker <linux@baker-net.org.uk>
Subject: Re: RFCv1: v4l-dvb development models & old kernel support
Date: Sun, 22 Feb 2009 11:05:26 +0100
Cc: linux-media@vger.kernel.org
References: <200902211200.45373.hverkuil@xs4all.nl> <200902212347.47109.linux@baker-net.org.uk>
In-Reply-To: <200902212347.47109.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902221105.26785.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 22 February 2009 00:47:46 Adam Baker wrote:
> On Saturday 21 February 2009, Hans Verkuil wrote:
> > The high rate of changes and new drivers means that keeping up the
> > backwards compatibility becomes an increasingly heavy burden.
> >
> > This leads to two questions:
> >
> > 1) Can we change our development model in such a way that this burden
> > is reduced?
>
> Possibly but even just spreading the burden better (and avoiding the
> compat code affecting the main tree in the case of i2c) would be a
> worthwhile change.
>
> > 2) How far back do we want to support older kernels anyway?
>
> To the point that the effort expended on the compat work is balanced by
> the benefit of more testers.
>
> > These questions are related, since changes in the development model has
> > implications for the answer to the second question.
> >
> >
> > 1: Alternatives to the development model
> > ----------------------------------------
> >
> > I see the following options:
> >
> > A) Keep our current model. This also keeps the way we do our backwards
> > compatibility unchanged.
> >
> > B) Switch to a git tree that tracks Linus' tree closely and we drop
> > backwards compatibility completely.
> >
> > C) Switch to the ALSA approach (http://git.alsa-project.org/).
>
> Another example of this approach can be seen with the linux-wireless git
> tree. There is a description of the process at
> http://linuxwireless.org/en/users/Download#Developers
>
> It might be a more relevant example as there are changes in 2.6.27 that
> make it difficult to support older kernels. They therefore made a
> decision at that point to restrict the automated backporting to 2.6.27
> onwards and say patches will be accepted to the compat tree that covers
> 2.6.21 to 2.6.26 if a driver change is compatible but they must be
> manually flagged as being suitable (I've no idea how many are).
>
> It does require one person (who isn't the main wireless maintainer) to be
> the maintainer of the compat tree.

This would basically mean making a snapshot of the v4l-dvb repository, 
calling it v4l-dvb-old and relying on people to update it with fixes. I did 
think about this myself but I thought it unlikely that the old tree would 
see much work, if at all. It's what they are admitting to on the wireless 
site as well. This could be an option if we are faced with an incompatible 
kernel change, but in this particular case it is my gut-feeling that 2.6.22 
is old enough that people can just upgrade to that release.

> > And luckily, since the oldest kernel currently in regular use is 2.6.22
> > that makes a very good argument for dropping the i2c compatibility
> > mess.
>
> Unfortunately this all omits one important point, are there any key
> developers for whom dropping support for old kernels will cause them a
> problem which could reduce their productivity.  Mauro has stated that it
> would cause him a problem but I can't tell how big a problem it would
> really be.

I'll start a poll. Let's see what the opinion is.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
