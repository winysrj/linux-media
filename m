Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35412 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754510AbdFWK3i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 06:29:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/6] v4l: vsp1: Remove WPF vertical flip support on VSP2-B[CD] and VSP2-D
Date: Fri, 23 Jun 2017 13:30:17 +0300
Message-ID: <2834844.GxJxlkDrrf@avalon>
In-Reply-To: <e499dfd0-50fd-a45b-6807-a87224d0ddf5@xs4all.nl>
References: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com> <3fc0137d-02ce-c9e4-0c82-5fff803b440d@xs4all.nl> <e499dfd0-50fd-a45b-6807-a87224d0ddf5@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 23 Jun 2017 11:10:45 Hans Verkuil wrote:
> On 06/19/17 13:18, Hans Verkuil wrote:
> > On 06/19/2017 01:16 PM, Laurent Pinchart wrote:
> >> On Thursday 15 Jun 2017 10:53:33 Hans Verkuil wrote:
> >>> On 06/15/17 10:24, Laurent Pinchart wrote:
> >>>> The WPF vertical flip is only supported on Gen3 SoCs on the VSP2-I.
> >>>> Don't enable it on other VSP2 instances.
> >>>> 
> >>>> Signed-off-by: Laurent Pinchart
> >>>> <laurent.pinchart+renesas@ideasonboard.com>
> >>> 
> >>> Should this go to older kernels as well? Or is that not needed?
> >> 
> >> Now that I have access to the hardware again, after further testing, it
> >> looks like vertical flip is implemented in the VSP2-B[CD] and VSP2-D
> >> even though the datasheet states otherwise. Let's ignore this patch for
> >> now, I'll try to double-check with Renesas.
> > 
> > Patches 2-6 are OK, though? If they are, then I'll pick them up.
> 
> Ping! Please let me know if patches 2-6 are OK for me to pick up. I'll make
> a final pull request today, after that they'll be postponed until 4.14.

I've received confirmation that the feature is actually implemented. The bug 
was in the datasheet, not in the driver. I've thus marked the patch as 
rejected in patchwork.

-- 
Regards,

Laurent Pinchart
