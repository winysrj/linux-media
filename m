Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57160 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2AaJaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 04:30:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH][media] s5p-g2d: Add HFLIP and VFLIP support
Date: Tue, 31 Jan 2012 10:30:24 +0100
Cc: "'Sachin Kamat'" <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, patches@linaro.org
References: <1327917523-29836-1-git-send-email-sachin.kamat@linaro.org> <201201301311.48370.laurent.pinchart@ideasonboard.com> <008b01ccdf54$962229d0$c2667d70$%debski@samsung.com>
In-Reply-To: <008b01ccdf54$962229d0$c2667d70$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201311030.25154.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Monday 30 January 2012 14:39:22 Kamil Debski wrote:
> On 30 January 2012 13:12 Laurent Pinchart wrote:
> > On Monday 30 January 2012 10:58:43 Sachin Kamat wrote:
> > > This patch adds support for flipping the image horizontally and
> > > vertically.

[snip]

> > > +	v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
> > > +						V4L2_CID_HFLIP, 0, 1, 1, 0);
> > > +	if (ctx->ctrl_handler.error)
> > > +		goto error;
> > > +
> > > +	v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
> > > +						V4L2_CID_VFLIP, 0, 1, 1, 0);
> > 
> > As a single register controls hflip and vflip, you should group the two
> > controls in a cluster.
> 
> I think it doesn't matter in this use case. As register are not written
> in the g2d_s_ctrl. Because the driver uses multiple context it modifies
> the appropriate values in its context structure and registers are written
> when the transaction is run.
> 
> Also there is no logical connection between horizontal and vertical flip.
> I think this is the case when using clusters. Here one is independent from
> another.

As the value is only written to hardware registers later, not in the s_ctrl() 
handler, a cluster is (probably) not mandatory if the driver uses proper 
locking. Otherwise there will be no guarantee that setting both hflip and 
vflip in a single VIDIOC_S_EXT_CTRLS call will not result in one frame with 
only hflip or vflip applied.

-- 
Regards,

Laurent Pinchart
