Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58162 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2K1HLi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 02:11:38 -0500
Date: Wed, 28 Nov 2012 08:11:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Libin Yang <lbyang@marvell.com>
cc: Albert Wang <twang13@marvell.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH 03/15] [media] marvell-ccic: add clock tree support for
 marvell-ccic driver
In-Reply-To: <A63A0DC671D719488CD1A6CD8BDC16CF230A8D7846@SC-VEXCH4.marvell.com>
Message-ID: <Pine.LNX.4.64.1211280807100.32652@axis700.grange>
References: <1353677595-24034-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271145320.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C8D5@SC-VEXCH1.marvell.com>
 <A63A0DC671D719488CD1A6CD8BDC16CF230A8D7846@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Libin

On Tue, 27 Nov 2012, Libin Yang wrote:

> Hello Guennadi,
> 
> Thanks for your suggestion, please see my comments below.
> 
> Best Regards,
> Libin 
> 
> >>-----Original Message-----
> >>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> >>Sent: Tuesday, 27 November, 2012 18:50
> >>To: Albert Wang
> >>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
> >>Subject: Re: [PATCH 03/15] [media] marvell-ccic: add clock tree support for marvell-ccic
> >>driver
> >>
> >>> +		mcam->clk_num = pdata->clk_num;
> >>> +	} else {
> >>> +		for (i = 0; i < pdata->clk_num; i++) {
> >>> +			if (mcam->clk[i]) {
> >>> +				clk_put(mcam->clk[i]);
> >>> +				mcam->clk[i] = NULL;
> >>> +			}
> >>> +		}
> >>> +		mcam->clk_num = 0;
> >>> +	}
> >>> +}
> >>
> >>Don't think I like this. IIUC, your driver should only try to use clocks, that it knows about,
> >>not some random clocks, passed from the platform data. So, you should be using explicit
> >>clock names. In your platform data you can set whether a specific clock should be used or
> >>not, but not pass clock names down. Also you might want to consider using devm_clk_get()
> >>and be more careful with error handling.
> >>
> >OK, we will try to enhance it.
> 
> [Libin] Because there are some boards using mmp chip, and the clock 
> names on different board may be totally different. And also this is why 
> the clock number is not definite. To support more boards, the dynamic 
> names are used instead of the static names.

No, I don't think it's right. The clock connection ID is the ID of the 
clock _consumer_, not the clock provider. So, your camera IP block has 
several clock inputs, and your platforms should provide clock lookup 
entries with names of those clock _inputs_, not of their clock sources. 
BTW, I really doubt it your camera block has 4 clock inputs? If some of 
them are parents of the clocks, that really supply the block (which would 
also explain why you call it a tree), then you don't have to clk_get() 
them explicitly. The clock framework will refcount and enable those parent 
clocks for you. So, I think, you really should fix your platforms.

This has been discussed multiple times on the mailing lists, feel free to 
do some research, here one link:

http://thread.gmane.org/gmane.linux.ports.arm.kernel/131302/focus=37730

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
