Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34601 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753950AbdLDNeN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 08:34:13 -0500
Received: by mail-lf0-f67.google.com with SMTP id x20so19173444lff.1
        for <linux-media@vger.kernel.org>; Mon, 04 Dec 2017 05:34:12 -0800 (PST)
Date: Mon, 4 Dec 2017 14:34:10 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: rcar-vin: Implement V4L2 video node release handler
Message-ID: <20171204133410.GA31989@bigcity.dyn.berto.se>
References: <20171115224907.392-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171115233433.GL12677@bigcity.dyn.berto.se>
 <2234965.HDk880jUUl@avalon>
 <1fa05d50-b45e-126c-4401-7bfb00b99170@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1fa05d50-b45e-126c-4401-7bfb00b99170@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2017-12-04 10:05:35 +0100, Hans Verkuil wrote:
> Hi Niklas,
> 
> On 11/16/2017 01:27 AM, Laurent Pinchart wrote:
> > Hi Niklas,
> > 
> > On Thursday, 16 November 2017 01:34:33 EET Niklas Söderlund wrote:
> >> On 2017-11-16 00:49:07 +0200, Laurent Pinchart wrote:
> >>> The rvin_dev data structure contains driver private data for an instance
> >>> of the VIN. It is allocated dynamically at probe time, and must be freed
> >>> once all users are gone.
> >>>
> >>> The structure is currently allocated with devm_kzalloc(), which results
> >>> in memory being freed when the device is unbound. If a userspace
> >>> application is currently performing an ioctl call, or just keeps the
> >>> device node open and closes it later, this will lead to accessing freed
> >>> memory.
> >>>
> >>> Fix the problem by implementing a V4L2 release handler for the video
> >>> node associated with the VIN instance (called when the last user of the
> >>> video node releases it), and freeing memory explicitly from the release
> >>> handler.
> >>>
> >>> Signed-off-by: Laurent Pinchart
> >>> <laurent.pinchart+renesas@ideasonboard.com>
> >>
> >> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >>
> >> This patch is based on-top of the VIN Gen3 enablement series not yet
> >> upstream. This is OK for me, just wanted to check that this was the
> >> intention as to minimize conflicts between the two.
> > 
> > Yes, that's my intention. The patch should be included, or possibly squashed 
> > in, your development branch.
> > 
> 
> Has this patch been added in your v8 series? If not, can you add it when you
> post a v9?

This patch needs more work, with the video device now registered at 
complete() time and unregistered at unbind() time. Applying this would 
free the rcar-vin private data structure at unbind() which probably not 
what we want.

I think this issue should be addressed but maybe together with a 
patch-set targeting the generic problem with video device lifetimes in 
v4l2 framework? For now I would be happy to focus on getting Gen3 
support picked-up and observe what Laurent's work on lifetime issues 
brings and adept the rcar-vin driver to take advantage of that once it's 
ready.

> 
> Thanks,
> 
> 	Hans

-- 
Regards,
Niklas Söderlund
