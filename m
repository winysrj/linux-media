Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47298 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab1L3AQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 19:16:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH 0/4] Add some new camera controls
Date: Fri, 30 Dec 2011 01:16:28 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <201112281501.25091.laurent.pinchart@ideasonboard.com> <001601ccc5f1$4db353d0$e919fb70$%kim@samsung.com>
In-Reply-To: <001601ccc5f1$4db353d0$e919fb70$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112300116.28572.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 29 December 2011 07:15:46 HeungJun, Kim wrote:
> On Wednesday, December 28, 2011 11:01 PM Laurent Pinchart wrote:
> > On Wednesday 28 December 2011 07:23:44 HeungJun, Kim wrote:
> > > Hi everyone,
> > > 
> > > This RFC patch series include new 4 controls ID for digital camera.
> > > I about to suggest these controls by the necessity enabling the M-5MOLS
> > > sensor's function, and I hope to discuss this in here.
> > 
> > Thanks for the patches.
> > 
> > The new controls introduced by these patches are very high level. Should
> > they be put in their own class ? I also think we should specify how
> > those high- level controls interact with low-level controls, otherwise
> > applications will likely get very confused.
> 
> I did not consider yet, but I think it's first to define about what
> low-/high- is. I think this is not high- level controls. And, honestly, I
> don't understand it's really important to categorize low-/high-, or not.
> 
> IMHO, The importance is the just complexity of interacting with each
> modules. If this means the level of low-/high-, I can understand this.
> But I'm wrong, please explain this. :)

Low level controls are usually handled in hardware and pretty much self-
contained. High level controls are usually software algorithms (possibly 
running on the sensor itself) that modify low level controls behind the scene.

If a sensor exposes both an exposure time control and a scene mode control 
that modifies exposure time handling, documentation of the scene mode control 
must explain how the two interacts and what applications can and can't do.

> There is some different story, I just got the N900 some days ago :).
> The purpose is just understanding Nokia and TI OMAP camera architecture
> well. Probably, it helps for me to talk more easily, and I'll be able to
> speak more well
> with omap workers - you and Sakari.

-- 
Regards,

Laurent Pinchart
