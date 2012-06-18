Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:38328 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2FROPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 10:15:42 -0400
Message-ID: <1340028940.32360.70.camel@obelisk.thedillows.org>
Subject: Re: [RFC] [media] cx231xx: restore tuner settings on first open
From: David Dillow <dave@thedillows.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Date: Mon, 18 Jun 2012 10:15:40 -0400
In-Reply-To: <201206180929.48107.hverkuil@xs4all.nl>
References: <1339994998.32360.61.camel@obelisk.thedillows.org>
	 <201206180929.48107.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-06-18 at 09:29 +0200, Hans Verkuil wrote:
> On Mon June 18 2012 06:49:58 David Dillow wrote:
> > What does the V4L2 API spec say about tuning frequency being persistent
> > when there are no users of a video capture device? Is MythTV wrong to
> > have that assumption, or is cx231xx wrong to not restore the frequency
> > when a user first opens the device?
> 
> Tuner standards and frequencies must be persistent. So cx231xx is wrong.
> Actually, all V4L2 settings must in general be persistent (there are
> some per-filehandle settings when dealing with low-level subdev setups or
> mem2mem devices).

Is there a document somewhere I can reference; I need to go through the
cx231xx driver and make sure it is doing the right things and it would
be handy to have a checklist.

> > Either way, I think MythTV should keep the device open until it is done
> > with it, as that would avoid added latency from putting the tuner to
> > sleep and waking it back up. But, I think we should address the issue in
> > the driver if it is not living up to the guarantees of the API.
> 
> From what I can tell it is a bug in the tda tuner (not restoring the frequency)
> and cx231xx (not setting the initial standard and possibly frequency).

Ok, I'll break this up and have a go at a proper fix. Thanks for the
pointers on the persistence of parameters.

Dave

