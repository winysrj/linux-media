Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4130 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab1FSIOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 04:14:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: RFC: Add V4L2 decoder commands/controls to replace dvb/video.h
Date: Sun, 19 Jun 2011 10:14:03 +0200
Cc: Hans Verkuil <hansverk@cisco.com>
References: <201106091445.53598.hansverk@cisco.com> <201106182330.47020@orion.escape-edv.de>
In-Reply-To: <201106182330.47020@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191014.03615.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, June 18, 2011 23:30:46 Oliver Endriss wrote:
> On Thursday 09 June 2011 14:45:53 Hans Verkuil wrote:
> > RFC: Proposal for a V4L2 decoder API
> > ------------------------------------
> > 
> > This RFC is based on this discussion:
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg32703.html
> > 
> > The purpose is to remove the dependency of ivtv to the ioctls in dvb/audio.h
> > and dvb/video.h.
> > ...
> 
> Whatever you define: You are not allowed to remove the old interface!

Sure you can (see e.g. V4L1 API), it is just very, very painful and takes
a very, very long time.

> Linus always stated that breaking userspace is a no go.
> 
> So you may add a new interface, but you must not remove the old one.

I wasn't planning on removing anything.

Although I might deprecate the old API eventually in ivtv. But apps like VLC
and MythTV use it in their ivtv code, so I can't do that until they are all
converted. So we're talking 2-3 years from now at the earliest. I'm not even
sure if it is worth the effort.

Regards,

	Hans
