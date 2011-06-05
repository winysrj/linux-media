Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41975 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab1FENKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jun 2011 09:10:34 -0400
Date: Sun, 5 Jun 2011 16:10:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 07/11] v4l2-ctrls: add control events.
Message-ID: <20110605131031.GG6073@valkosipuli.localdomain>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
 <2c6e1531f7f9ab33b60e8c7f972f58a0dd6fbbd1.1306329390.git.hans.verkuil@cisco.com>
 <20110528103421.GA4991@valkosipuli.localdomain>
 <201105281658.20086.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105281658.20086.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Sat, May 28, 2011 at 04:58:20PM +0200, Hans Verkuil wrote:
> On Saturday, May 28, 2011 12:34:21 Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Wed, May 25, 2011 at 03:33:51PM +0200, Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > Whenever a control changes value or state an event is sent to anyone
> > > that subscribed to it.
> > > 
> > > This functionality is useful for control panels but also for applications
> > > that need to wait for (usually status) controls to change value.
> > 
> > Thanks for the patch!
> > 
> > I agree that it's good to pass more information of the control (min, max
> > etc.) to the user space with the event. However, to support events arriving
> > from interrupt context which we've discussed in the past, such information
> > must be also accessible in those situations.
> > 
> > What do you think about more fine-grained locking of controls, say, spinlock
> > for each control (cluster) as an idea?
> 
> It's on my TODO list, but I need to think carefully on how to do it.
> One thing at a time :-)

I agree. I just wanted to hear your thoughts about this. :)

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
