Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:54521 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867AbZIMFlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 01:41:47 -0400
Subject: Re: Initial media controller implementation
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Markus Rechberger <mrechberger@gmail.com>,
	linux-media@vger.kernel.org
In-Reply-To: <200909121313.50084.hverkuil@xs4all.nl>
References: <200909121257.28522.hverkuil@xs4all.nl>
	 <d9def9db0909120405n277ad8e0r85ea82d877bc53f8@mail.gmail.com>
	 <200909121313.50084.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 13 Sep 2009 07:38:43 +0200
Message-Id: <1252820323.3257.18.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Samstag, den 12.09.2009, 13:13 +0200 schrieb Hans Verkuil:
> On Saturday 12 September 2009 13:05:14 Markus Rechberger wrote:
> > Hi,
> > 
> > On Sat, Sep 12, 2009 at 12:57 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > Rather than writing long mails on what a media controller is and what it can
> > > do, I thought that I could just as well implement it.
> > >
> > > So in 4 hours I implemented pretty much all of the media controller
> > > functionality. The main missing features are the ability to register non-v4l
> > > device nodes so that they can be enumerated and setting controls private to
> > > a sub-device. For that I should first finish the control handling framework.
> > >
> > > The datastructures and naming conventions needs to be cleaned up, and it
> > > needs some tweaking, but I'd say this is pretty much the way I want it.
> > >
> > > The code is available here:
> > >
> > > http://linuxtv.org/hg/~hverkuil/v4l-dvb-mc/
> > >
> > > It includes a v4l2-mc utility in v4l2-apps/util that has the
> > > --show-topology option that enumerates all nodes and subdev. Currently any
> > > registered subdevs and v4l device nodes are already automatically added.
> > > Obviously, there are no links setup between them, that would require work
> > > in the drivers.
> > >
> > > Total diffstat:
> > >
> > >  b/linux/include/media/v4l2-mc.h         |   54 +++++
> > >  b/v4l2-apps/util/v4l2-mc.cpp            |  325 ++++++++++++++++++++++++++++++++
> > >  linux/drivers/media/video/v4l2-dev.c    |   15 +
> > >  linux/drivers/media/video/v4l2-device.c |  265 +++++++++++++++++++++++++-
> > >  linux/include/linux/videodev2.h         |   74 +++++++
> > >  linux/include/media/v4l2-dev.h          |    6
> > >  linux/include/media/v4l2-device.h       |   23 +-
> > >  linux/include/media/v4l2-subdev.h       |   11 -
> > >  v4l2-apps/util/Makefile                 |    2
> > >  9 files changed, 762 insertions(+), 13 deletions(-)
> > >
> > > Ignoring the new utility that's just 435 lines of core code.
> > >
> > > Now try this with sysfs. Brrr.
> > >
> > 
> > please even more important when doing this push out a proper
> > documentation for it,
> > The s2api is a mess seen from the documentation people need to hack
> > existing code in order
> > to figure out how to use it it seems. v4l2/(incomplete)linuxdvb v3 API
> > are still the best references
> > to start with right now.
> 
> It will obviously be documented extensively when/if this becomes official.
> Right now it is an initial implementation people can play with.
> 
> Regards,
> 
>          Hans

Hi,

going through mail backlash I arrived at least here for now.

What to say?

One of our previous best hackers, who decided meanwhile to distribute
exclusive hardware also on GNU/Linux, providing the driver only as
closed source, if the possessor/buyer/idiot is clearly identified by his
hardware and then gets it exclusively ...

Makes suggestions for better documentation ???

My "Nero" OEM version is now also to be claimed not to be functional
anymore after one year. Three years were guarantied once. Who cares? I
do. 

I'll bail out of that zoo very soon, if such is going further on.

Cheers,
Hermann






