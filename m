Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52828 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab0CALq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Mar 2010 06:46:58 -0500
Subject: Re: How do private controls actually work?
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl>
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>
	 <201003010957.49198.laurent.pinchart@ideasonboard.com>
	 <829197381003010107m79ff65bajde4da911eafc6740@mail.gmail.com>
	 <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Mon, 01 Mar 2010 06:47:01 -0500
Message-Id: <1267444021.3110.32.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-03-01 at 10:58 +0100, Hans Verkuil wrote:
> > Hello Laurent,
> >
> > On Mon, Mar 1, 2010 at 3:57 AM, Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com> wrote:
> >> I don't think it should matter which API (the base one or the extended
> >> one)
> >> you use for controls, be they private, standard or whatever. I don't see
> >> a
> >> reason for disallowing some controls to be used through one or the other
> >> API.
> >
> > I would generally agree.  My original belief was that the extended
> > control API was designed to be a superset of the older API and that it
> > could be used for both types of controls.  Imagine my surprise to find
> > that private controls were specifically excluded from the extended
> > control interface.
> 
> New private controls should not use V4L2_CID_PRIVATE_BASE at all. That
> mechanism was a really bad idea. Instead a new control should be added to
> the appropriate control class and with a offset >= 0x1000. See for example
> the CX2341X private controls in videodev2.h.

I recall doing something like this a while ago:

#define CX18_AV_CID_USER_PRIV_BASE	(V4L2_CTRL_CLASS_USER | 0x1000)
#define CX18_AV_CID_EXTRA_12DB_GAIN	(CX18_AV_CID_USER_PRIV_BASE+0)
.....

http://linuxtv.org/hg/~awalls/v4l-dvb-ctls/file/e4b2c5d550b5/linux/drivers/media/video/cx18/cx18-av-core.h#l77

(I'm not sure if it's a good example though.)

I'm still just waiting for an approved method for implementing such
video decoder controls.  I don't care how, just that there is a way.

I don't have much in the way of plans to offer, because I really don't
grok all the existing issues with controls.

Regards,
Andy

> The EXT_G/S_CTRLS ioctls do not accept PRIVATE_BASE because I want to
> force driver developers to stop using PRIVATE_BASE. So only G/S_CTRL will
> support controls in that range for backwards compatibility.
> 
> Regards,
> 
>         Hans


