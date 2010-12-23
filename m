Return-path: <mchehab@gaivota>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2251 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0LWJiC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 04:38:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Thu, 23 Dec 2010 10:37:42 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012231020.17558.hverkuil@xs4all.nl> <201012231027.25701.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012231027.25701.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231037.43151.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thursday, December 23, 2010 10:27:25 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 23 December 2010 10:20:17 Hans Verkuil wrote:
> > On Thursday, December 23, 2010 10:02:33 Laurent Pinchart wrote:
> > > On Monday 20 December 2010 14:09:40 Hans Verkuil wrote:
> > > > On Monday, December 20, 2010 13:48:51 Laurent Pinchart wrote:
> > > > > What if the application wants to change the resolution during capture
> > > > > ? It will have to stop capture, call REQBUFS(0), change the format,
> > > > > request buffers and restart capture. If filehandle ownership is
> > > > > dropped after REQBUFS(0) that will open the door to a race
> > > > > condition.
> > > > 
> > > > That's why S_PRIORITY was invented.
> > > 
> > > Right, I should implement that. I think the documentation isn't clear
> > > though. What is the background priority for exactly ?
> > 
> > As the documentation mentions, it can be used for background processes
> > monitoring VBI (e.g. teletext) transmissions. I'm not aware of any such
> > applications, though.
> > 
> > PRIORITY_DEFAULT and PRIORITY_RECORD are the only two relevant prios in
> > practice.
> > 
> > > And the "unset" priority ?
> > 
> > Internal prio only. I think it's the value when no file handle is open.
> 
> Aren't priorities associated with file handles ?

Yes, but there is also a global prio.

> > > Are other applications allowed to change controls when an application has
> > > the record priority ?
> > 
> > No. Only read-only ioctls can be executed.
> 
> Then we got an issue here. I want an application to be able to acquire 
> exclusive streaming rights on the device (so that there won't be race 
> conditions when changing the resolution), but still allow other applications 
> to change controls.

Why? The whole idea of prios is that once you are PRIO_RECORD no one else
can mess with settings. Allowing other apps access to controls will make it
possible to e.g. change the contrast to some crappy value. Not acceptable.

If the only thing you want to use PRIO_RECORD for in apps is to prevent this
'race condition' (I don't really see this as a real race, to be honest), then
the app can raise the prio to RECORD just before STREAMOFF, change the resolution,
start streaming again and lower it to the default prio.

Regards,

	Hans

> > > In general I find the priority ioctls underspecified, that's why I
> > > haven't implemented them yet.
> > 
> > Use the prio support functions in v4l2-common. They are easy to use and do
> > the job.
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
