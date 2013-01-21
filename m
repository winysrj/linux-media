Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33559 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab3AUKEf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 05:04:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: William Swanson <william.swanson@fuel7.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Ken Petit <ken@fuel7.com>, sakari.ailus@iki.fi
Subject: Re: [PATCH] omap3isp: Add support for interlaced input data
Date: Mon, 21 Jan 2013 11:06:16 +0100
Message-ID: <1966099.CiWxvjUmiL@avalon>
In-Reply-To: <50F484E9.9060103@fuel7.com>
References: <1355796739-2580-1-git-send-email-william.swanson@fuel7.com> <2574136.Nmpnc7I1z4@avalon> <50F484E9.9060103@fuel7.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

On Monday 14 January 2013 14:21:29 William Swanson wrote:
> On 01/09/2013 02:35 PM, Laurent Pinchart wrote:
> > On Tuesday 08 January 2013 14:49:41 William Swanson wrote:
> >> I believe the data is combined in a single buffer, with alternate fields
> >> interleaved.
> > 
> > Could you please double-check that ? I'd like to be sure, not just believe
> > :-)
>
> Sorry for the delay in getting back to you. I have checked it, and the
> fields are indeed interlaced into a single buffer. On the other hand,
> looking at this caused me to discover another problem with the patch.
> 
> According to the TI documentation, the CCDC_SDOFST register controls the
> deinterlacing process. My patch never configures this register, however,
> which is surprising. The reason things work on our boards is because we are
> carrying a separate patch which changes the register by accident. Oops! I
> have fixed this, and will be sending another patch with the CCDC_SDOFST
> changes.
> 
> > In that case the OMAP3 ISP driver should set the v4l2_pix_format::field to
> > V4L2_FIELD_INTERLACED in the format-related ioctl when an interlaced
> > format is used. I suppose this could be added later - Sakari, any opinion
> > ?
> 
> I don't have a lot of time to work on this stuff, so my main focus is just
> getting the data to flow. Changing the output format information involves
> other parts of the driver that I am not familiar with, so I don't know if I
> will be able to work on that bit.

OK. I will wait for the patch you mention above and I will then try to fix the 
field reporting issue. I might need your help to test the result.

> By the way, thanks for taking the time to review this, Laurent.

You're welcome.

-- 
Regards,

Laurent Pinchart

