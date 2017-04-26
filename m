Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41692 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934683AbdDZPzG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 11:55:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: Simon Horman <horms@verge.net.au>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        geert@linux-m68k.org, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v2 0/3] r8a7793 Gose video input support
Date: Wed, 26 Apr 2017 18:56:06 +0300
Message-ID: <1702484.RNuXBAXB1F@avalon>
In-Reply-To: <3952799.qV1GSftN8A@avalon>
References: <1476802943-5189-1-git-send-email-ulrich.hecht+renesas@gmail.com> <20161020084911.GH4612@verge.net.au> <3952799.qV1GSftN8A@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

On Tuesday 21 Feb 2017 01:42:15 Laurent Pinchart wrote:
> On Thursday 20 Oct 2016 10:49:11 Simon Horman wrote:
> > On Tue, Oct 18, 2016 at 05:02:20PM +0200, Ulrich Hecht wrote:
> >> Hi!
> >> 
> >> This is a by-the-datasheet implementation of analog and digital video
> >> input on the Gose board.
> >> 
> >> I have tried to address all concerns raised by reviewers, with the
> >> exception of the composite input patch, which has been left as is for
> >> now.
> >> 
> >> CU
> >> Uli
> >> 
> >> 
> >> Changes since v1:
> >> - r8a7793.dtsi: added VIN2
> >> - modeled HDMI decoder input/output and connector
> >> - added "renesas,rcar-gen2-vin" compat strings
> >> - removed unnecessary "remote" node and aliases
> >> - set ADV7612 interrupt to GP4_2
> >> 
> >> Ulrich Hecht (3):
> >>   ARM: dts: r8a7793: Enable VIN0-VIN2
> > 
> > I have queued up the above patch with Laurent and Geert's tags.
> > 
> >>   ARM: dts: gose: add HDMI input
> >>   ARM: dts: gose: add composite video input
> > 
> > Please address the review of the above two patches and repost.
> 
> Could you please do so ? Feedback on 2/3 should be easy to handle. For 3/3,
> you might need to ping the DT maintainers.

Ping. These are the only two patches that block

VIN,v4.12,public,ulrich,Gen2 VIN integration

> >>  arch/arm/boot/dts/r8a7793-gose.dts | 100 +++++++++++++++++++++++++++++
> >>  arch/arm/boot/dts/r8a7793.dtsi     |  27 ++++++++++
> >>  2 files changed, 127 insertions(+)

-- 
Regards,

Laurent Pinchart
