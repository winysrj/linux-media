Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3162 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1EXG2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 02:28:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.40] Fixes
Date: Tue, 24 May 2011 08:28:32 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	"Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
References: <201105231306.56050.hverkuil@xs4all.nl> <4DDB0D08.2000503@redhat.com>
In-Reply-To: <4DDB0D08.2000503@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105240828.32866.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, May 24, 2011 03:42:32 Mauro Carvalho Chehab wrote:
> Em 23-05-2011 08:06, Hans Verkuil escreveu:
> > Hi Mauro,
> > 
> > Here are a few fixes: the first fixes a bug in the wl12xx drivers (I hope Matti's
> > email is still correct). The second fixes a few DocBook validation errors, and
> > the last fixes READ_ONLY and GRABBED handling in the control framework.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit 87cf028f3aa1ed51fe29c36df548aa714dc7438f:
> > 
> >   [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked (2011-05-21 11:10:28 -0300)
> > 
> > are available in the git repository at:
> >   ssh://linuxtv.org/git/hverkuil/media_tree.git fixes
> > 
> > Hans Verkuil (3):
> >       wl12xx: g_volatile_ctrl fix: wrong field set.
> >       Media DocBook: fix validation errors.
> 
> The two above are fixes...
> 
> >       v4l2-ctrls: drivers should be able to ignore READ_ONLY and GRABBED flags
> 
> But this one is a change at the behaviour. I need to analyse it better. The idea
> of a "read only" control that it is not read only seems too weird on my tired eyes.

It's read-only for *applications*. But if you have a read-only control that
reflects a driver state, then it should be possible for a *driver* to change
it. It's something that is needed for the upcoming Flash and HDMI APIs.

The userspace behavior does not change.

BTW, if you prefer to move this last patch to 2.6.41, then that's OK by me.
It's not really necessary for 2.6.40.

Regards,

	Hans

> 
> I'll take a more careful look on it tomorrow.
> 
> Thanks,
> Mauro.
> 
> > 
> >  Documentation/DocBook/dvb/dvbproperty.xml    |    5 ++-
> >  Documentation/DocBook/v4l/subdev-formats.xml |   10 ++--
> >  drivers/media/radio/radio-wl1273.c           |    2 +-
> >  drivers/media/radio/wl128x/fmdrv_v4l2.c      |    2 +-
> >  drivers/media/video/v4l2-ctrls.c             |   59 +++++++++++++++++---------
> >  5 files changed, 50 insertions(+), 28 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
