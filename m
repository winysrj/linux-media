Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4258 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab1GAH5w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 03:57:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [GIT PULL FOR 3.1] Bitmask controls, flash API and adp1653 driver
Date: Fri, 1 Jul 2011 09:57:39 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <20110610092703.GH7830@valkosipuli.localdomain> <4E0D226E.5010809@redhat.com>
In-Reply-To: <4E0D226E.5010809@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107010957.39930.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, July 01, 2011 03:27:10 Mauro Carvalho Chehab wrote:
> Em 10-06-2011 06:27, Sakari Ailus escreveu:
> > Hi Mauro,
> > 
> > This pull request adds the bitmask controls, flash API and the adp1653
> > driver. What has changed since the patches is:
> > 
> > - Adp1653 flash faults control is volatile. Fix this.
> > - Flash interface marked as experimental.
> > - Moved the DocBook documentation to a new location.
> > - The target version is 3.1, not 2.6.41.
> > 
> > The following changes since commit 75125b9d44456e0cf2d1fbb72ae33c13415299d1:
> > 
> >   [media] DocBook: Don't be noisy at make cleanmediadocs (2011-06-09 16:40:58 -0300)
> > 
> > are available in the git repository at:
> >   ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.1
> > 
> > Hans Verkuil (3):
> >       v4l2-ctrls: add new bitmask control type.
> >       vivi: add bitmask test control.
> >       DocBook: document V4L2_CTRL_TYPE_BITMASK.
> 
> I'm sure I've already mentioned, but I think it was at the Hans pull request:
> the specs don't mention what endiannes is needed for the bitmask controls: 
> machine endianess, little endian or big endian.  IMO, we should stick with either
> LE or BE.

Sorry Sakari, I should have fixed that. But since the patch was going through
your repository I forgot about it. Anyway, it should be machine endianess. You
have to be able to do (value & bit_define). The bit_defines for each bitmask
control should be part of the control's definition in videodev2.h.

It makes no sense to require LE or BE. We don't do that for other control types,
so why should bitmask be any different?

Can you add this clarification to DocBook?

Regards,

	Hans

> 
> > 
> > Sakari Ailus (3):
> >       v4l: Add a class and a set of controls for flash devices.
> >       v4l: Add flash control documentation
> >       adp1653: Add driver for LED flash controller
> > 
> >  Documentation/DocBook/media/v4l/compat.xml         |   11 +
> >  Documentation/DocBook/media/v4l/controls.xml       |  283 ++++++++++++
> >  Documentation/DocBook/media/v4l/v4l2.xml           |    9 +-
> >  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +
> >  .../DocBook/media/v4l/vidioc-queryctrl.xml         |   12 +-
> >  drivers/media/video/Kconfig                        |    9 +
> >  drivers/media/video/Makefile                       |    1 +
> >  drivers/media/video/adp1653.c                      |  485 ++++++++++++++++++++
> >  drivers/media/video/v4l2-common.c                  |    3 +
> >  drivers/media/video/v4l2-ctrls.c                   |   62 +++-
> >  drivers/media/video/vivi.c                         |   18 +-
> >  include/linux/videodev2.h                          |   37 ++
> >  include/media/adp1653.h                            |  126 +++++
> >  13 files changed, 1058 insertions(+), 5 deletions(-)
> >  create mode 100644 drivers/media/video/adp1653.c
> >  create mode 100644 include/media/adp1653.h
> > 
> 
> 
