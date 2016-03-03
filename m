Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34570 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337AbcCCVaL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 16:30:11 -0500
Date: Thu, 3 Mar 2016 18:30:06 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.6] Fixes, enhancement and move 3 soc-camera
 drivers to staging
Message-ID: <20160303183006.56e1ba55@recife.lan>
In-Reply-To: <56D81F0C.1010406@xs4all.nl>
References: <56D002AC.7020005@xs4all.nl>
	<20160303074017.750ff14c@recife.lan>
	<56D81F0C.1010406@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Mar 2016 12:25:00 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/03/16 11:40, Mauro Carvalho Chehab wrote:
> > Em Fri, 26 Feb 2016 08:45:48 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> The following changes since commit 3915d367932609f9c0bdc79c525b5dd5a806ab18:
> >>
> >>   [media] ttpci: cleanup a bogus smatch warning (2016-02-23 07:26:22 -0300)
> >>
> >> are available in the git repository at:
> >>
> >>   git://linuxtv.org/hverkuil/media_tree.git for-v4.6f
> >>
> >> for you to fetch changes up to 16295c7590a2272050fb1ae935ce65860f930351:
> >>
> >>   soc_camera/mx3_camera.c: move to staging in preparation, for removal (2016-02-26 08:21:05 +0100)
> >>
> >> ----------------------------------------------------------------
> >> Hans Verkuil (5):
> >>       tc358743: use - instead of non-ascii wide-dash character
> >>       vivid: support new multiplanar YUV formats
> >>       soc_camera/omap1: move to staging in preparation for removal
> >>       soc_camera/mx2_camera.c: move to staging in preparation, for removal
> >>       soc_camera/mx3_camera.c: move to staging in preparation, for removal
> >>
> >> Philipp Zabel (2):
> >>       coda: add support for native order firmware files with Freescale header
> >>       coda: add support for firmware files named as distributed by NXP
> >>
> >> Ulrich Hecht (1):
> >>       adv7604: fix SPA register location for ADV7612
> >>
> >>  drivers/media/i2c/adv7604.c                                          |  3 +-
> >>  drivers/media/i2c/tc358743.c                                         | 30 +++++-----
> >>  drivers/media/platform/coda/coda-common.c                            | 96 ++++++++++++++++++++++++++------
> >>  drivers/media/platform/coda/coda.h                                   |  3 +-
> >>  drivers/media/platform/soc_camera/Kconfig                            | 28 ----------
> >>  drivers/media/platform/soc_camera/Makefile                           |  3 -
> >>  drivers/media/platform/vivid/vivid-tpg.c                             | 32 +++++++++++
> >>  drivers/media/platform/vivid/vivid-vid-common.c                      | 39 ++++++++++++-
> >>  drivers/staging/media/Kconfig                                        |  6 ++
> >>  drivers/staging/media/Makefile                                       |  3 +
> >>  drivers/staging/media/mx2/Kconfig                                    | 12 ++++
> >>  drivers/staging/media/mx2/Makefile                                   |  3 +
> >>  .../{media/platform/soc_camera => staging/media/mx2}/mx2_camera.c    |  0
> >>  drivers/staging/media/mx3/Kconfig                                    | 15 +++++
> >>  drivers/staging/media/mx3/Makefile                                   |  3 +
> >>  .../{media/platform/soc_camera => staging/media/mx3}/mx3_camera.c    |  0
> >>  drivers/staging/media/omap1/Kconfig                                  | 13 +++++
> >>  drivers/staging/media/omap1/Makefile                                 |  3 +
> >>  .../platform/soc_camera => staging/media/omap1}/omap1_camera.c       |  0
> >>  19 files changed, 224 insertions(+), 68 deletions(-)
> >>  create mode 100644 drivers/staging/media/mx2/Kconfig
> >>  create mode 100644 drivers/staging/media/mx2/Makefile
> >>  rename drivers/{media/platform/soc_camera => staging/media/mx2}/mx2_camera.c (100%)
> >>  create mode 100644 drivers/staging/media/mx3/Kconfig
> >>  create mode 100644 drivers/staging/media/mx3/Makefile
> >>  rename drivers/{media/platform/soc_camera => staging/media/mx3}/mx3_camera.c (100%)
> >>  create mode 100644 drivers/staging/media/omap1/Kconfig
> >>  create mode 100644 drivers/staging/media/omap1/Makefile
> >>  rename drivers/{media/platform/soc_camera => staging/media/omap1}/omap1_camera.c (100%)  
> > 
> > Please send a followup patch adding README instructions for those
> > drivers that got moved to staging. We don't want to receive
> > trivial fixup patches for this stuff, but, instead, if one
> > wants them to go promoted again, it should be converted to work
> > without soc_camera.  
> 
> Done.

Applied.

Thanks!
Mauro
