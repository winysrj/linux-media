Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60146 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0LWJ1P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 04:27:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Thu, 23 Dec 2010 10:27:25 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012231002.34251.laurent.pinchart@ideasonboard.com> <201012231020.17558.hverkuil@xs4all.nl>
In-Reply-To: <201012231020.17558.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231027.25701.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

On Thursday 23 December 2010 10:20:17 Hans Verkuil wrote:
> On Thursday, December 23, 2010 10:02:33 Laurent Pinchart wrote:
> > On Monday 20 December 2010 14:09:40 Hans Verkuil wrote:
> > > On Monday, December 20, 2010 13:48:51 Laurent Pinchart wrote:
> > > > What if the application wants to change the resolution during capture
> > > > ? It will have to stop capture, call REQBUFS(0), change the format,
> > > > request buffers and restart capture. If filehandle ownership is
> > > > dropped after REQBUFS(0) that will open the door to a race
> > > > condition.
> > > 
> > > That's why S_PRIORITY was invented.
> > 
> > Right, I should implement that. I think the documentation isn't clear
> > though. What is the background priority for exactly ?
> 
> As the documentation mentions, it can be used for background processes
> monitoring VBI (e.g. teletext) transmissions. I'm not aware of any such
> applications, though.
> 
> PRIORITY_DEFAULT and PRIORITY_RECORD are the only two relevant prios in
> practice.
> 
> > And the "unset" priority ?
> 
> Internal prio only. I think it's the value when no file handle is open.

Aren't priorities associated with file handles ?

> > Are other applications allowed to change controls when an application has
> > the record priority ?
> 
> No. Only read-only ioctls can be executed.

Then we got an issue here. I want an application to be able to acquire 
exclusive streaming rights on the device (so that there won't be race 
conditions when changing the resolution), but still allow other applications 
to change controls.

> > In general I find the priority ioctls underspecified, that's why I
> > haven't implemented them yet.
> 
> Use the prio support functions in v4l2-common. They are easy to use and do
> the job.

-- 
Regards,

Laurent Pinchart
