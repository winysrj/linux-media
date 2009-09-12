Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4353 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZILLNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 07:13:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Markus Rechberger <mrechberger@gmail.com>
Subject: Re: Initial media controller implementation
Date: Sat, 12 Sep 2009 13:13:50 +0200
Cc: linux-media@vger.kernel.org
References: <200909121257.28522.hverkuil@xs4all.nl> <d9def9db0909120405n277ad8e0r85ea82d877bc53f8@mail.gmail.com>
In-Reply-To: <d9def9db0909120405n277ad8e0r85ea82d877bc53f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909121313.50084.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 12 September 2009 13:05:14 Markus Rechberger wrote:
> Hi,
> 
> On Sat, Sep 12, 2009 at 12:57 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Rather than writing long mails on what a media controller is and what it can
> > do, I thought that I could just as well implement it.
> >
> > So in 4 hours I implemented pretty much all of the media controller
> > functionality. The main missing features are the ability to register non-v4l
> > device nodes so that they can be enumerated and setting controls private to
> > a sub-device. For that I should first finish the control handling framework.
> >
> > The datastructures and naming conventions needs to be cleaned up, and it
> > needs some tweaking, but I'd say this is pretty much the way I want it.
> >
> > The code is available here:
> >
> > http://linuxtv.org/hg/~hverkuil/v4l-dvb-mc/
> >
> > It includes a v4l2-mc utility in v4l2-apps/util that has the
> > --show-topology option that enumerates all nodes and subdev. Currently any
> > registered subdevs and v4l device nodes are already automatically added.
> > Obviously, there are no links setup between them, that would require work
> > in the drivers.
> >
> > Total diffstat:
> >
> >  b/linux/include/media/v4l2-mc.h         |   54 +++++
> >  b/v4l2-apps/util/v4l2-mc.cpp            |  325 ++++++++++++++++++++++++++++++++
> >  linux/drivers/media/video/v4l2-dev.c    |   15 +
> >  linux/drivers/media/video/v4l2-device.c |  265 +++++++++++++++++++++++++-
> >  linux/include/linux/videodev2.h         |   74 +++++++
> >  linux/include/media/v4l2-dev.h          |    6
> >  linux/include/media/v4l2-device.h       |   23 +-
> >  linux/include/media/v4l2-subdev.h       |   11 -
> >  v4l2-apps/util/Makefile                 |    2
> >  9 files changed, 762 insertions(+), 13 deletions(-)
> >
> > Ignoring the new utility that's just 435 lines of core code.
> >
> > Now try this with sysfs. Brrr.
> >
> 
> please even more important when doing this push out a proper
> documentation for it,
> The s2api is a mess seen from the documentation people need to hack
> existing code in order
> to figure out how to use it it seems. v4l2/(incomplete)linuxdvb v3 API
> are still the best references
> to start with right now.

It will obviously be documented extensively when/if this becomes official.
Right now it is an initial implementation people can play with.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
