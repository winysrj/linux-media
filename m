Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47905 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752359AbZEWPRp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 11:17:45 -0400
Date: Sat, 23 May 2009 17:17:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC 09/10 v2] v4l2-subdev: re-add s_standby to v4l2_subdev_core_ops
In-Reply-To: <87hbzc6nuz.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0905231707030.4057@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
 <Pine.LNX.4.64.0905151907460.4658@axis700.grange> <200905211533.34827.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0905221611160.4418@axis700.grange> <873aaxxf3d.fsf@free.fr>
 <Pine.LNX.4.64.0905221933180.4418@axis700.grange> <87hbzc6nuz.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 23 May 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > I think we can put the camera to a low-power state in streamoff. But - not 
> > power it off! This has to be done from system's PM functions.
> That means, from a sensor POV, through icd->stop_capture().
> For my single mt9m111, it's fine by me, as the mt9m111 does have a powersave
> mode. Yet I'm wondering if there are sensors without that capability, with only
> one control (ie. one GPIO line) to switch them on and off ...

Doesn't this actually belong to PM? I begin to think that our whole 
->power() handling might be a bit suboptimally placed and should migrate 
to pm, one might give it some thinking...

> > What was there on linux-pm about managing power of single devices?...
> Reference ?

I meant this thread

http://thread.gmane.org/gmane.linux.power-management.general/4655/focus=4670

as you see, it is not very fresh, and I have no idea what came out of it, 
have a look if you're interested.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
