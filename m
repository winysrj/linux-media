Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2947 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2FROck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 10:32:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Dillow <dave@thedillows.org>
Subject: Re: [RFC] [media] cx231xx: restore tuner settings on first open
Date: Mon, 18 Jun 2012 16:31:59 +0200
Cc: linux-media@vger.kernel.org
References: <1339994998.32360.61.camel@obelisk.thedillows.org> <201206180929.48107.hverkuil@xs4all.nl> <1340028940.32360.70.camel@obelisk.thedillows.org>
In-Reply-To: <1340028940.32360.70.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206181631.59966.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 16:15:40 David Dillow wrote:
> On Mon, 2012-06-18 at 09:29 +0200, Hans Verkuil wrote:
> > On Mon June 18 2012 06:49:58 David Dillow wrote:
> > > What does the V4L2 API spec say about tuning frequency being persistent
> > > when there are no users of a video capture device? Is MythTV wrong to
> > > have that assumption, or is cx231xx wrong to not restore the frequency
> > > when a user first opens the device?
> > 
> > Tuner standards and frequencies must be persistent. So cx231xx is wrong.
> > Actually, all V4L2 settings must in general be persistent (there are
> > some per-filehandle settings when dealing with low-level subdev setups or
> > mem2mem devices).
> 
> Is there a document somewhere I can reference; I need to go through the
> cx231xx driver and make sure it is doing the right things and it would
> be handy to have a checklist.

By far the easiest method is to run v4l2-compliance from the v4l-utils
repository on the driver. It's not 100%, but it is achieving pretty good
coverage. It's purpose is to verify all the fields are properly filled in,
all the latest frameworks are used, and everything is according to spec.

Make sure you compile the v4l-utils repository yourself to be sure you
use the latest version of this utility.

In principle the V4L2 spec should contain all that information, but it is
sometimes buries in the text and there are some things that are only
available in the collective memory of the developers :-)

> > > Either way, I think MythTV should keep the device open until it is done
> > > with it, as that would avoid added latency from putting the tuner to
> > > sleep and waking it back up. But, I think we should address the issue in
> > > the driver if it is not living up to the guarantees of the API.
> > 
> > From what I can tell it is a bug in the tda tuner (not restoring the frequency)
> > and cx231xx (not setting the initial standard and possibly frequency).
> 
> Ok, I'll break this up and have a go at a proper fix. Thanks for the
> pointers on the persistence of parameters.

As Devin mentioned, putting the fix in tuner-core is a better approach
since that fixes it for all such tuners.

And a quite separate problem is when to put a tuner to sleep. That's a very
dark corner in V4L2.

For that someone would have to write an RFC, outlining the various options
and starting a proper discussion on how to solve this.

Regards,

	Hans

> 
> Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
