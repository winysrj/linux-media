Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1795 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0LWJUh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 04:20:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Thu, 23 Dec 2010 10:20:17 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012201409.40799.hverkuil@xs4all.nl> <201012231002.34251.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012231002.34251.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231020.17558.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thursday, December 23, 2010 10:02:33 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 20 December 2010 14:09:40 Hans Verkuil wrote:
> > On Monday, December 20, 2010 13:48:51 Laurent Pinchart wrote:
> > >
> > > What if the application wants to change the resolution during capture ?
> > > It will have to stop capture, call REQBUFS(0), change the format,
> > > request buffers and restart capture. If filehandle ownership is dropped
> > > after REQBUFS(0) that will open the door to a race condition.
> > 
> > That's why S_PRIORITY was invented.
> 
> Right, I should implement that. I think the documentation isn't clear though. 
> What is the background priority for exactly ?

As the documentation mentions, it can be used for background processes monitoring
VBI (e.g. teletext) transmissions. I'm not aware of any such applications, though.

PRIORITY_DEFAULT and PRIORITY_RECORD are the only two relevant prios in practice.

> And the "unset" priority ?

Internal prio only. I think it's the value when no file handle is open.

> Are 
> other applications allowed to change controls when an application has the 
> record priority ?

No. Only read-only ioctls can be executed.

> In general I find the priority ioctls underspecified, that's why I haven't 
> implemented them yet.

Use the prio support functions in v4l2-common. They are easy to use and do the
job.

Regards,

	Hans

> On a side note, I've just tested the latest uvcvideo driver, and I've 
> successfully captured video using a second application after calling 
> REQBUFS(0) in a first application.
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
