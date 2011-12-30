Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:36804 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1L3FlV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 00:41:21 -0500
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LX0001F754UTMJ0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Dec 2011 14:41:20 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LX000KEM54VTS10@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Fri, 30 Dec 2011 14:41:19 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <201112281456.51024.laurent.pinchart@ideasonboard.com>
 <001401ccc5ee$1c60dc60$55229520$%kim@samsung.com>
 <201112300113.16090.laurent.pinchart@ideasonboard.com>
In-reply-to: <201112300113.16090.laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC PATCH 3/4] v4l: Add V4L2_CID_WDR button control
Date: Fri, 30 Dec 2011 14:41:19 +0900
Message-id: <000501ccc6b5$a7bddd40$f73997c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, December 30, 2011 9:13 AM
> To: HeungJun, Kim
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; hverkuil@xs4all.nl;
> sakari.ailus@iki.fi; s.nawrocki@samsung.com; kyungmin.park@samsung.com
> Subject: Re: [RFC PATCH 3/4] v4l: Add V4L2_CID_WDR button control
> 
> Hi,
> 
> On Thursday 29 December 2011 06:52:55 HeungJun, Kim wrote:
> > On Wednesday, December 28, 2011 10:57 PM Laurent Pinchart wrote:
> > > On Wednesday 28 December 2011 07:23:47 HeungJun, Kim wrote:
> > > > It adds the new CID for setting White Balance Preset. This CID is
> > > > provided
> > >
> > > I suppose you mean wide dynamic range here.
> >
> > Right, it's my miss.
> >
> > > > as button type. This can commands only if the camera turn on/off this
> > > > function.
> > >
> > > Shouldn't it be a boolean ? A button can only be activated, for one-shot
> > > auto- focus for instance.
> >
> > Any type can be possible, and fine to me. But, it depends on the whole
> > hardware architecture. The WDR is proceeded and used only in the ISP or
> > another engine processing image. And, the cases I've seen ever, are just
> > one - The ISP exists in the sensor.
> >
> > In M-5MOLS use-case, the ISP is in the M-5MOLS sensor. To the position of
> > developer,
> > it's just ok to turn on/off for using this. But, in the other architecture
> > it might be need more.
> 
> You can't turn a button control on or off. A button control can only be
> activated, it has no state. On/off controls are boolean controls.
Ah, ok. I'll modify this to Boolean for next version. You're right.

> 
> > But, I anticipate if the other architecture use this function, probably
> > any other setting seems be not needed any more. The photographer just says,
> > "turn on the WDR!", not says "adjust parm 1, 2, 3, and turn on WDR!". :)
> >
> > So, IMHO, I think the any other setting is not needed more for now.
> 
> --
> Regards,
> 
> Laurent Pinchart

