Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3733 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbZBTG4n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 01:56:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: Comments on V4L controls
Date: Fri, 20 Feb 2009 07:56:49 +0100
Cc: gilles <gilles.gigan@gmail.com>, linux-media@vger.kernel.org
References: <4994A667.2000909@gmail.com> <200902181551.32623.laurent.pinchart@skynet.be>
In-Reply-To: <200902181551.32623.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902200756.49500.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 February 2009 15:51:32 Laurent Pinchart wrote:
> Hi Gilles,
>
> On Thursday 12 February 2009 23:44:55 gilles wrote:
> > Hi everyone,
> > Sorry for double posting, but I originally sent this to the old mailing
> > list. Here it is:
> >
> > I have a couple of comments / suggestions regarding the part on
> > controls of the V4L2 api:
> > Some controls, such as pan relative and tilt relative are write-only,
> > and reading their value makes little sense. Yet, there is no way of
> > knowing about this, but to try and read a value and be greeted with
> > EINVAL or similar. There is already a read-only flag
> > (V4L2_CTRL_FLAG_READ_ONLY) in struct v4l2_query. Does it make sense to
> > add another one for write-only controls ?
>
> Yes it does. Martin Rubli from Logitech sent a mail in April 2008 to the
> video4linux mailing list. Search the list archives for "[PATCH] Support
> for write-only controls". Feel free to submit a patch.
>
> > The extended controls Pan / Tilt  reset are defined in the API as
> > boolean controls. Shouldnt these be defined as buttons instead, as they
> > dont really hold a state (enabled/disabled) ?
>
> Agreed. As no driver seem to be using those controls yet, it should be
> safe to update the spec. Could you submit a patch ?

Hi Gilles, Laurent,

I will take care of this. I have to do some doc updates relating to controls 
anyway, so it's easy for me to add this as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
