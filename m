Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36583 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934986Ab1JEXlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 19:41:45 -0400
Date: Thu, 6 Oct 2011 02:41:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	linux-media@vger.kernel.org,
	laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
Message-ID: <20111005234140.GE8614@valkosipuli.localdomain>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <CAAwP0s1ozMVi5TgWUGmu5Pxd2cTEHd1rTD72HU9R+Fth3Rb9-A@mail.gmail.com>
 <4E891B22.1020204@infradead.org>
 <201110030830.25364.hverkuil@xs4all.nl>
 <4E8A04C2.5000508@infradead.org>
 <20111003190109.GN6180@valkosipuli.localdomain>
 <4E8A0ECC.3030006@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8A0ECC.3030006@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 03, 2011 at 04:36:44PM -0300, Mauro Carvalho Chehab wrote:
> Em 03-10-2011 16:01, Sakari Ailus escreveu:
> > On Mon, Oct 03, 2011 at 03:53:54PM -0300, Mauro Carvalho Chehab wrote:
> >> Yes, you're right. I should not try to answer emails when I'm lazy enough to not
> >> look in to the code ;)
> >>
> >> Anyway, the thing is that V4L2 API has enough support for auto-detection. There's
> >> no need to duplicate stuff with MC API.
> > 
> > It's not MC API but V4L2 subdev API. No-one has proposed to add video
> > standard awareness to the Media controller API. There's no reason to export
> > a video node in video decoder drivers... but I guess you didn't mean that.
> > 
> > Would implementing ENUM/G/S_STD make sense for the camera ISP driver, that
> > has nothing to do with any video standard?
> 
> This is an old discussion, and we never agreed on that. Some webcam drivers 
> implement those ioctls. Others don't. Both cases are compliant with the
> current specs. In the past, several userspace applications used to abort if those
> ioctl's weren't implemented, but I think that this were fixed already there.
> 
> As I said, we should define a per-device type profile in order to enforce that
> all devices of the same type will do the same. We'll need man power to fix the
> ones that aren't compliant, and solve the userspace issues. Volunteers needed.
> 
> There's one point to bold on it: devices that can have either an analog input
> or a digital input will likely need to implement ENUM/G/S_STD for both, as
> userspace applications may fail, if the ioctl's are disabled depending on the
> type of input. We had to implement them on several drivers, due to that.

My disguised question behind this was actually that would a driver need to
implement an ioctl that has no relevance to the driver itself at all but
only to support another driver, yet the first driver might not have enough
information to properly implement it?

It may be sometimes necessary but I would like to avoid that if possible
since it complicates even more drivers which already are very complex.

> > If you have two video decoders
> > connected to your system, then which one should the ioctls be redirected to?
> > What if there's a sensor and a video decoder? And how could the user know
> > about this?
> 
> When an input is selected (either via the V4L2 way - S_INPUT or via the MC/subdev
> way, there's just one video decoder or sensor associated to the corresponding
> V4L2 node).
> 
> > It's the same old issues again... let's discuss this in the Multimedia
> > summit.
> 
> We can discuss more at the summit, but we should start discussing it here, as
> otherwise we may not be able to go into a consensus there, due to the limited
> amount of time we would have for each topic.

Sounds good to me, but sometimes face-to-face discussion just is not
replaceable.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
