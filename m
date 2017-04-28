Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36897 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162172AbdD1IjL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 04:39:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms@verge.net.au>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, hans.verkuil@cisco.com,
        niklas.soderlund@ragnatech.se, geert@linux-m68k.org,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v2 0/3] r8a7793 Gose video input support
Date: Fri, 28 Apr 2017 11:40:20 +0300
Message-ID: <1636596.a9JMt0l4X4@avalon>
In-Reply-To: <20170428051624.GC18349@verge.net.au>
References: <1476802943-5189-1-git-send-email-ulrich.hecht+renesas@gmail.com> <1702484.RNuXBAXB1F@avalon> <20170428051624.GC18349@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Friday 28 Apr 2017 07:16:24 Simon Horman wrote:
> On Wed, Apr 26, 2017 at 06:56:06PM +0300, Laurent Pinchart wrote:
> > On Tuesday 21 Feb 2017 01:42:15 Laurent Pinchart wrote:
> >> On Thursday 20 Oct 2016 10:49:11 Simon Horman wrote:
> >>> On Tue, Oct 18, 2016 at 05:02:20PM +0200, Ulrich Hecht wrote:
> >>>> Hi!
> >>>> 
> >>>> This is a by-the-datasheet implementation of analog and digital video
> >>>> input on the Gose board.
> >>>> 
> >>>> I have tried to address all concerns raised by reviewers, with the
> >>>> exception of the composite input patch, which has been left as is for
> >>>> now.
> >>>> 
> >>>> CU
> >>>> Uli
> >>>> 
> >>>> 
> >>>> Changes since v1:
> >>>> - r8a7793.dtsi: added VIN2
> >>>> - modeled HDMI decoder input/output and connector
> >>>> - added "renesas,rcar-gen2-vin" compat strings
> >>>> - removed unnecessary "remote" node and aliases
> >>>> - set ADV7612 interrupt to GP4_2
> >>>> 
> >>>> Ulrich Hecht (3):
> >>>>   ARM: dts: r8a7793: Enable VIN0-VIN2
> >>> 
> >>> I have queued up the above patch with Laurent and Geert's tags.
> >>> 
> >>>>   ARM: dts: gose: add HDMI input
> >>>>   ARM: dts: gose: add composite video input
> >>> 
> >>> Please address the review of the above two patches and repost.
> >> 
> >> Could you please do so ? Feedback on 2/3 should be easy to handle. For
> >> 3/3, you might need to ping the DT maintainers.
> > 
> > Ping. These are the only two patches that block
> > 
> > VIN,v4.12,public,ulrich,Gen2 VIN integration
> 
> Sorry, I'm unsure how these slipped through the cracks.
> I now have them queued up locally for v4.13 and I plan to push this morning.

Please don't, the ping was for Ulrich, he needs to address review comments on 
patches 2/3 and 3/3.

-- 
Regards,

Laurent Pinchart
