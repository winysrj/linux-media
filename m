Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4963 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbZCBVSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 16:18:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Results of the 'dropping support for kernels <2.6.22' poll
Date: Mon, 2 Mar 2009 22:18:24 +0100
Cc: Jean Delvare <khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903022218.24259.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Well, the polling station closed and the results are:

Yes: 32
No: 3

First of all thanks to all who responded! To be honest, I was quite 
surprised at the number of votes received as I hadn't expected to get so 
many. Thank you!

It was very interesting to read the reasons given for the yes or no vote. 
Basically, all the Yes votes boiled down to this reply given by David 
Ellingsworth:

"As others have already pointed out, it is a waste of time for developers 
who volunteer their time to work on supporting prior kernel revisions for 
use by enterprise distributions. The task of back-porting driver 
modifications to earlier kernels lessens the amount of time developers can 
focus on improving the quality and stability of new and existing drivers. 
Furthermore, it deters driver development since there an expectation that 
they will back-port their driver to earlier kernel versions. Finally, as a 
developer, I have little interest in what was new yesterday. I usually run 
the latest kernel whenever possible and for a number of different reasons. 
Some of those reasons include better hardware support, bug detection, and 
stability testing. All services greatly valued by other kernel developers."

Note that of the people that voted Yes about 10-15 are developers, and the 
others are users of v4l-dvb. It's a bit imprecise since some of the people 
who voted did contribute the occasional fix in the past, but are not active 
developers. It's a bit of a grey area.

The three No votes (all from developers) boiled down to this reply from 
Douglas Schilling Landgraf:

"I know it's not easy task keep this support working... but we still have 
*users* around the world using kernel < 2.6.22 (as some of them already 
reported this)."

It will come as no surprise when I say that I think that is not sufficient 
reason for supporting kernels < 2.6.22. There are no doubt users still on 
kernel 2.4 as well or even older. Yet we do not support those.

There are good reasons as a developer for keeping backwards compatibility 
with older kernels:

1) a larger testers base.
2) that warm feeling you get when users can get their new card to work with 
just v4l-dvb without having to upgrade their kernel.
3) as a developer you do not need to update to the latest kernel as well. 
Very useful if the latest kernel introduces a regression on your hardware 
as happened to me in the past.

There are also disadvantages:

1) it takes (unpaid!) time and effort to maintain the backward 
compatibility.
2) as time goes by the code becomes ever harder to maintain due to the 
accumulated kernel checks.
3) the additional complication of backwards compatibility code might deter 
new developers.

There has to be a balance here. Currently it is my opinion that I'm spending 
too much time on the backwards compat stuff. And that once all the i2c 
modules are converted to the new framework both the maintainability and the 
effort required to maintain the compat code will be improved considerably 
by dropping support for kernels <2.6.22.

Yes, the testers base will be reduced by this, but I believe that the vast 
majority of our users will not be affected by this. The poll did nothing to 
change my mind on this. The one argument I've seen that I thought had merit 
was with regards to netbooks, and the Asus eeePC in particular. Apparently 
that distro uses 2.6.21 and whether that will be upgraded to a newer kernel 
in the future is dubious.

But in the end it is really the same story: where do you put the line? If 
the eeePC will never receive an update, does that mean we have to keep 
maintaining support for 2.6.21 for many years to come? That's ridiculous 
IMHO.

I think that my proposal to do our best to support the actively maintained 
releases of the three top-distros makes sense. It will cater to the 
majority of users, and limits the amount of work we need to do. And we know 
that ugly workarounds can always be removed after a certain amount of time.

In the final analysis I'm the boss of my own time. And I've decided that 
once the conversion of all the i2c modules is finished I'll stop spending 
time on the compatibility code for kernels <2.6.22 as it is simply no 
longer an effective use of my time. If someone else wants to spend time on 
that, then that's great and I will of course answer questions or help in 
whatever way is needed.

I know that Mauro thinks he can keep the backwards compat code in by doing 
nifty code transformations. It would be nice if he succeeds (and I have no 
doubt that it is possible given enough time and effort), but personally I 
think it is time better spent elsewhere.

A final note regarding distros: we as v4l-dvb developers do not owe them 
anything. We are not paid by them to provide support to their products. 
It's *their* task to do so. If they want backwards compatibility for older 
kernels, then they can assign and pay a developer to work on that.

So any argument along the lines of 'we need to support users of distro X' is 
a false argument. It's the responsibility of distro X to support their 
users. It definitely is not our responsibility.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
