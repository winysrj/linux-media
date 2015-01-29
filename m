Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53891 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbA2U5w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 15:57:52 -0500
Date: Thu, 29 Jan 2015 21:57:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 5/8] media: rcar_vin: Add RGB888_1X24 input format support
In-Reply-To: <54CA99D9.4020901@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1501292146310.7281@axis700.grange>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
 <1422548388-28861-6-git-send-email-william.towle@codethink.co.uk>
 <54CA6869.9060100@cogentembedded.com> <Pine.LNX.4.64.1501291915100.30602@axis700.grange>
 <54CA7BBF.6070607@cogentembedded.com> <Pine.LNX.4.64.1501292118020.7281@axis700.grange>
 <54CA99D9.4020901@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2015, Sergei Shtylyov wrote:

> On 01/29/2015 11:19 PM, Guennadi Liakhovetski wrote:
> 
> > > > > > This adds V4L2_MBUS_FMT_RGB888_1X24 input format support
> > > > > > which is used by the ADV7612 chip.
> 
> > > > > > Signed-off-by: Valentine Barshak
> > > > > > <valentine.barshak@cogentembedded.com>
> 
> > > > >      I wonder why it hasn't been merged still? It's pending since
> > > > > 2013, and
> > > > > I'm
> > > > > seeing no objections to it...
> 
> > > > Indeed, strange. I'm saving it for me to look at it for the next
> > > > merge...
> > > > and I'll double-check that series. Maybe the series had some objections,
> 
> > >     Indeed, I'm now seeing the patch #1 was objected to. Patch #2 has been
> > > merged somewhat later.
> 
> > Right, and since this RGB888 format support was needed for the ADV761X
> > driver from patch #1, this patch wasn't merged either. Do you need it now
> > for something different?
> 
>    No, the same ADV7612 chip, just the different driver this time, it seems.

Right, I see now. [OT] The problem is - this is not the first time this is 
happening - I didn't get that thread in my INBOX, only in the mailing list 
folder. I subscribe the mailing list from a different email address, than 
the one I'm CC'ed at. So, I anyway should be getting 2 copies of all these 
mails. I received 2 copies of Sergei's mails, but the rest only once... 
Not in spam, not in logs - they just disappear. A day or two ago another 
similar thread also missed my INBOX... Investigating...

Thanks
Guennadi
