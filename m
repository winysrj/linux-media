Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54427 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753180AbdBNNmd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:42:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, geert+renesas@glider.be,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Add V4L2 SDR (DRIF & MAX2175) driver
Date: Tue, 14 Feb 2017 15:42:53 +0200
Message-ID: <3113698.4oBLQ9QWl0@avalon>
In-Reply-To: <fe15c9ed-be08-c954-5891-c42ec7584b46@xs4all.nl>
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <fe15c9ed-be08-c954-5891-c42ec7584b46@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 13 Feb 2017 13:46:08 Hans Verkuil wrote:
> On 02/07/2017 04:02 PM, Ramesh Shanmugasundaram wrote:
> > Hi Media, DT maintainers, All,
> > 
> > This patch set contains two drivers
> > 
> >  - Renesas R-Car Digital Radio Interface (DRIF) driver
> >  - Maxim's MAX2175 RF to Bits tuner driver
> > 
> > These patches were based on top of media-tree repo
> > commit: 47b037a0512d9f8675ec2693bed46c8ea6a884ab
> > 
> > These two drivers combined together expose a V4L2 SDR device that is
> > compliant with the V4L2 framework [1]. Agreed review comments are
> > incorporated in this series.
> > 
> > The rcar_drif device is modelled using "renesas,bonding" property. The
> > discussion on this property is available here [2].
> Other than the single comment I had it all looks good. Once I have Acks for
> the bindings and from Laurent for the rcar part I can merge it.

Just FYI, I won't have time to review this before March at the earliest.

-- 
Regards,

Laurent Pinchart
