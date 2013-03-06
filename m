Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:62426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab3CFPCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 10:02:10 -0500
Date: Wed, 6 Mar 2013 16:02:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: RE: [REVIEW PATCH V4 12/12] [media] marvell-ccic: add 3 frame buffers
 support in DMA_CONTIG mode
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D8DAA8F@SC-VEXCH1.marvell.com>
Message-ID: <Pine.LNX.4.64.1303061600420.7010@axis700.grange>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-13-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051515590.25837@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D9D8DAA8F@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 6 Mar 2013, Albert Wang wrote:

[snip]

> >> +		if (cam->frame_state.usebufs == 0)
> >> +			cam->frame_state.usebufs++;
> >> +		else {
> >> +			set_bit(CF_SINGLE_BUFFER, &cam->flags);
> >> +			cam->frame_state.singles++;
> >> +			if (cam->frame_state.usebufs < 2)
> >> +				cam->frame_state.usebufs++;
> >
> >What is this .usebufs actually supposed to do? AFAICS, it is only used to
> >decide, whether it should be changed, I don't see it having any effect on
> >anything else?
> >
> Actually, we use .usebufs to decide if will enter single buffer mode.
> Only usebufs == 2 can enter single buffer mode.
> But when init it:
> 	If CCIC use Two Buffers mode, init usebufs == 1
> 	If CCIC use Three Buffers mode, init usebufs == 0
> That means when CCIC use Two Buffers mode, once buffer used out, CCIC will enter single buffer mode soon
> But when CCIC use Two Buffers mode, we can have 1 frame time to wait for 
> new buffer and needn't enter single buffer mode.
> If we still can't get new buffer after 1 frame, then CCIC has to enter single buffer mode.
> But if we are lucky enough and get new buffer when next frame come, then 
> we can still run in normal mode.

Thanks for the explanation. Could you please tell me where in the code 
this .usebufs field is used as you describe?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
