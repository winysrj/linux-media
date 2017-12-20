Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:41987 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755397AbdLTQ1B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 11:27:01 -0500
Received: by mail-lf0-f54.google.com with SMTP id e30so7820801lfb.9
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 08:27:01 -0800 (PST)
Date: Wed, 20 Dec 2017 17:26:58 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 11/28] rcar-vin: do not allow changing scaling and
 composing while streaming
Message-ID: <20171220162658.GD32148@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <14690079.PLADEzS7Fe@avalon>
 <20171208141423.GQ31989@bigcity.dyn.berto.se>
 <1750592.qc2TZyzifv@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1750592.qc2TZyzifv@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 2017-12-08 21:20:48 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> On Friday, 8 December 2017 16:14:23 EET Niklas Söderlund wrote:
> > On 2017-12-08 11:04:26 +0200, Laurent Pinchart wrote:
> > > On Friday, 8 December 2017 03:08:25 EET Niklas Söderlund wrote:
> > >> It is possible on Gen2 to change the registers controlling composing and
> > >> scaling while the stream is running. It is however not a good idea to do
> > >> so and could result in trouble. There are also no good reasons to allow
> > >> this, remove immediate reflection in hardware registers from
> > >> vidioc_s_selection and only configure scaling and composing when the
> > >> stream starts.
> > > 
> > > There is a good reason: digital zoom.
> > 
> > OK, so you would recommend me to drop this patch to keep the current
> > behavior?
> 
> Yes, unless you don't care about breaking use cases for Gen2, but in that case 
> I'd recommend dropping Gen2 support altogether :-)

Well I don't want to do that so I will drop this patch for the next 
version. Thanks for clarifying the use-case for this.

> 
> > >> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > >> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > >> ---
> > >> 
> > >>  drivers/media/platform/rcar-vin/rcar-dma.c  | 2 +-
> > >>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ---
> > >>  drivers/media/platform/rcar-vin/rcar-vin.h  | 3 ---
> > >>  3 files changed, 1 insertion(+), 7 deletions(-)
> 
> [snip]
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
