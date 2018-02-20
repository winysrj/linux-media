Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39026 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbeBTXxv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 18:53:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Alexandre-Xavier =?ISO-8859-1?Q?Labont=E9=2DLamoureux?=
        <axdoomer@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Bug: Two device nodes created in /dev for a single UVC webcam
Date: Wed, 21 Feb 2018 01:54:32 +0200
Message-ID: <2753135.CmSHGSgxQU@avalon>
In-Reply-To: <CAGoCfiy296wh1u+LE-RoSVVzc8kNKngDvne-R2cDdOBM9LtVfg@mail.gmail.com>
References: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com> <3383770.t3Sncl0gtc@avalon> <CAGoCfiy296wh1u+LE-RoSVVzc8kNKngDvne-R2cDdOBM9LtVfg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Tuesday, 20 February 2018 20:18:16 EET Devin Heitmueller wrote:
> On Mon, Feb 19, 2018 at 11:19 AM, Laurent Pinchart wrote:
> > I've tested VLC (2.2.8) and haven't noticed any issue. If a program is
> > directed to the metadata video node and tries to capture video from it it
> > will obviously fail. That being said, software that work today should
> > continue working, otherwise it's a regression, and we'll have to handle
> > that.
> 
> Perhaps it shouldn't be a video node then (as we do with VBI devices).
> Would something like /dev/videometadataX would be more appropriate?

We've thought about it, and the initial implementation created a metadata 
device node instead of a video device node. This has been rejected, see 
https://www.mail-archive.com/linux-media@vger.kernel.org/msg97454.html and 
https://www.mail-archive.com/linux-media@vger.kernel.org/msg97446.html.

> People have for years operated under the expectation that /dev/videoX
> nodes are video nodes.  If we're going to be creating things with that
> name which aren't video nodes then that is going to cause considerable
> confusion as well as messing up all sorts of existing applications
> which operate under that expectation.
> 
> I know that some of the older PCI boards have always exposed a bunch
> of video nodes for various things (i.e. raw video vs. mpeg, etc), but
> because USB devices have traditionally been simpler they generally
> expose only one node of each type (i.e. one /dev/videoX, /dev/vbiX
> /dev/radioX).  I've already gotten an email from a customer who has a
> ton of scripts which depend on this behavior, so please seriously
> consider the implications of this design decision.

While I can't speak about other USB devices as I'm not too familiar with them, 
please note that the UVC driver already exposes multiple video nodes related 
to video capture (or video output) for some devices, and will posssibly do so 
increasingly in the future when we add support for UVC 1.5. We can reconsider 
the decision of exposing metadata through a video node, but adding new video 
nodes to expose additional compressed video streams for UVC 1.5 support is 
something that userspace has to live with the same way it already has to live 
with multiple video nodes for older PCI boards.

> It's easy to brush this off as "all the existing applications will
> eventually be updated", but you're talking about changing the basic
> behavior of how these device nodes have been presented for over a
> decade.

That's not what I meant, I might have not expressed myself correctly. Updating 
applications is something we should strive for when we want to get rid of an 
undesired userspace behaviour, but that's in no way an excuse for breaking 
anything. Regarding the issue reported by Alexandre-Xavier, it looks to me 
like he might be suffering from another problem, possibly part of the same 
patch series, but not caused by the extra video device node. That's why I 
asked for more information before taking any decision.

-- 
Regards,

Laurent Pinchart
