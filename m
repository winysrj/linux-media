Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47281 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1L3ANI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 19:13:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: Re: [RFC PATCH 3/4] v4l: Add V4L2_CID_WDR button control
Date: Fri, 30 Dec 2011 01:13:15 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <201112281456.51024.laurent.pinchart@ideasonboard.com> <001401ccc5ee$1c60dc60$55229520$%kim@samsung.com>
In-Reply-To: <001401ccc5ee$1c60dc60$55229520$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112300113.16090.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 29 December 2011 06:52:55 HeungJun, Kim wrote:
> On Wednesday, December 28, 2011 10:57 PM Laurent Pinchart wrote:
> > On Wednesday 28 December 2011 07:23:47 HeungJun, Kim wrote:
> > > It adds the new CID for setting White Balance Preset. This CID is
> > > provided
> > 
> > I suppose you mean wide dynamic range here.
> 
> Right, it's my miss.
> 
> > > as button type. This can commands only if the camera turn on/off this
> > > function.
> > 
> > Shouldn't it be a boolean ? A button can only be activated, for one-shot
> > auto- focus for instance.
> 
> Any type can be possible, and fine to me. But, it depends on the whole
> hardware architecture. The WDR is proceeded and used only in the ISP or
> another engine processing image. And, the cases I've seen ever, are just
> one - The ISP exists in the sensor.
> 
> In M-5MOLS use-case, the ISP is in the M-5MOLS sensor. To the position of
> developer,
> it's just ok to turn on/off for using this. But, in the other architecture
> it might be need more.

You can't turn a button control on or off. A button control can only be 
activated, it has no state. On/off controls are boolean controls.

> But, I anticipate if the other architecture use this function, probably
> any other setting seems be not needed any more. The photographer just says,
> "turn on the WDR!", not says "adjust parm 1, 2, 3, and turn on WDR!". :)
> 
> So, IMHO, I think the any other setting is not needed more for now.

-- 
Regards,

Laurent Pinchart
