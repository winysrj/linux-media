Return-path: <mchehab@gaivota>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1434 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab0LWNI0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 08:08:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Thu, 23 Dec 2010 14:08:06 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012231002.34251.laurent.pinchart@ideasonboard.com> <1293109478.2092.29.camel@morgan.silverblock.net>
In-Reply-To: <1293109478.2092.29.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231408.06817.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thursday, December 23, 2010 14:04:38 Andy Walls wrote:
> On Thu, 2010-12-23 at 10:02 +0100, Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Monday 20 December 2010 14:09:40 Hans Verkuil wrote:
> > > On Monday, December 20, 2010 13:48:51 Laurent Pinchart wrote:
> > > >
> > > > What if the application wants to change the resolution during capture ?
> > > > It will have to stop capture, call REQBUFS(0), change the format,
> > > > request buffers and restart capture. If filehandle ownership is dropped
> > > > after REQBUFS(0) that will open the door to a race condition.
> > > 
> > > That's why S_PRIORITY was invented.
> > 
> > Right, I should implement that. I think the documentation isn't clear though. 
> > What is the background priority for exactly ? 
> 
> http://linuxtv.org/downloads/v4l-dvb-apis/app-pri.html
> 
> "Another objective is to permit low priority applications working in
> background, which can be preempted by user controlled applications and
> automatically regain control of the device at a later time."
> 
> <contrived examples>
> A use case would be for a daemon that does background channel scanning
> or VBI data collection when the user isn't doing something else with the
> video device.
> 
> For a camera, maybe it would be an application that does device health
> monitoring, some sort of continuous calibration, or motion detection
> when the device isn't in use by the user for viewing.
> </contrived examples>
> 
> > And the "unset" priority ?
> 
> When checking for the maximum priority in use, it indicates that no
> nodes have any priorities. See v4l2_prio_max().  For a driver that
> supports priorities, it means no device nodes are opened, since any
> device node being open would get a priority of
> V4L2_PRIORITY_INTERACTIVE/_DEFAULT by default in v4l2_prio_open().
> 
> V4L2_PRIORITY_UNSET is also used to indicate to the v4l2_prio_*()
> functions that a struct v4l2_prio_state hasn't been initialized (i.e.
> has just been kzalloc()'ed).
> 
> > Are 
> > other applications allowed to change controls when an application has the 
> > record priority ?
> 
> According to the spec, no:
> 
> "V4L2_PRIORITY_RECORD 3 Highest priority. Only one file descriptor can
> have this priority, it blocks any other fd from changing device
> properties."
> 
> Once an automated, scheduled-recording process is recording, one really
> wouldn't want another process changing them.  I personally would not
> like unpredictable volume level variations on my TV show recordings.
> 
> 
> In cx18-controls.c one can find an implementation example for the old
> control framework:
> 
>         int cx18_s_ext_ctrls(struct file *file, void *fh, struct v4l2_ext_controls *c)
>         {       
>                 struct cx18_open_id *id = fh;   
>                 struct cx18 *cx = id->cx;       
>                 int ret;
>                 struct v4l2_control ctrl;       
>         
>                 ret = v4l2_prio_check(&cx->prio, id->prio);
>                 if (ret)
>                         return ret;
>     [...]
> 
> However, the new control framework in v4l2-ctrl.c seems to be missing
> any v4l2_prio_check() calls. The ioctl() handling in v4l2-ioctl.c
> doesn't have any either.

Oops, I'd forgotten about that. The priority support really should be
moved into the v4l2 core framework where it belongs. I'll see if I can spend
some time on that after Christmas.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
