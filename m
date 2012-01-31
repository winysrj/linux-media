Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39314 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2AaKKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 05:10:15 -0500
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LYN002Q4QW574X0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jan 2012 19:09:41 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LYN00CDSQW0EE10@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Tue, 31 Jan 2012 19:09:41 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, patches@linaro.org
References: <1327917523-29836-1-git-send-email-sachin.kamat@linaro.org>
 <201201301311.48370.laurent.pinchart@ideasonboard.com>
 <008b01ccdf54$962229d0$c2667d70$%debski@samsung.com>
 <201201311030.25154.laurent.pinchart@ideasonboard.com>
In-reply-to: <201201311030.25154.laurent.pinchart@ideasonboard.com>
Subject: RE: [PATCH][media] s5p-g2d: Add HFLIP and VFLIP support
Date: Tue, 31 Jan 2012 11:09:35 +0100
Message-id: <00a601cce000$72522670$56f67350$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Sachin,

> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: 31 January 2012 10:30
> 
> Hi Kamil,
> 
> On Monday 30 January 2012 14:39:22 Kamil Debski wrote:
> > On 30 January 2012 13:12 Laurent Pinchart wrote:
> > > On Monday 30 January 2012 10:58:43 Sachin Kamat wrote:
> > > > This patch adds support for flipping the image horizontally and
> > > > vertically.
> 
> [snip]
> 
> > > > +	v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
> > > > +						V4L2_CID_HFLIP, 0, 1, 1,
0);
> > > > +	if (ctx->ctrl_handler.error)
> > > > +		goto error;
> > > > +
> > > > +	v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
> > > > +						V4L2_CID_VFLIP, 0, 1, 1,
0);
> > >
> > > As a single register controls hflip and vflip, you should group the two
> > > controls in a cluster.
> >
> > I think it doesn't matter in this use case. As register are not written
> > in the g2d_s_ctrl. Because the driver uses multiple context it modifies
> > the appropriate values in its context structure and registers are written
> > when the transaction is run.
> >
> > Also there is no logical connection between horizontal and vertical flip.
> > I think this is the case when using clusters. Here one is independent from
> > another.
> 
> As the value is only written to hardware registers later, not in the s_ctrl()
> handler, a cluster is (probably) not mandatory if the driver uses proper
> locking. Otherwise there will be no guarantee that setting both hflip and
> vflip in a single VIDIOC_S_EXT_CTRLS call will not result in one frame with
> only hflip or vflip applied.

I see your point - this could happen. So Sachin - I think you need to add the
cluster.
You can find documentation about this in
Documentation/video4linux/v4l2-controls.txt

Also I have talked with Sylwester about locking. It turns out that a spinlock in
device_run and s_ctrl is necessary. I'll add it after you send your patch,
Sachin.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

