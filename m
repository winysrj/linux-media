Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54377 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaE0KgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 06:36:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 0/2] Propert alpha channel support in pixel formats
Date: Tue, 27 May 2014 12:36:30 +0200
Message-ID: <11776568.dvWb72dmNF@avalon>
In-Reply-To: <53843C3F.8070204@xs4all.nl>
References: <1401142629-12856-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <53843C3F.8070204@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 27 May 2014 09:18:23 Hans Verkuil wrote:
> On 05/27/2014 12:17 AM, Laurent Pinchart wrote:
> > Hello,
> > 
> > This RFC patch series attempts to clean up the current ARGB format mess.
> > 
> > The core issue is that the existing ARGB formats are ill-defined. The V4L2
> > specification doesn't clearly document how the alpha bits should behave.
> > Drivers have thus used the same formats in different, incompatible ways,
> > and applications now rely on the driver-specific behaviours. In a word,
> > that's a mess.
> > 
> > I've discussed the issue in the #v4l channel a couple of days ago and we
> > came up to the conclusion that the best (or least painful) way to fix the
> > problem is to define new clean XRGB and ARGB formats, and consider the
> > existing formats as deprecated (meaning that no new driver should use
> > them, they won't disappear in a couple of months, as that would break
> > userspace).
> > 
> > The first patch adds the new XRGB and ARGB formats and documents them.
> 
> Question: should we add all XRGB and ARGB formats even if drivers do not use
> them? Or just those that are actually used?

The VSP1 driver is going to use them all, so we need them all.

> > It purposely includes no core code to handle backward compatibility for
> > existing drivers that may wish to move to the new formats. The reason is
> > that I would first like to get feedback on the proposal before working on
> > compat code, and I believe we should first implement the compat code in a
> > couple of drivers and then see how the approach could be generalized, if
> > possible at all.
> > 
> > The second patch allows using the ALPHA_COMPONENT control on output
> > devices to support an ARGB use case documented in the first patch. One
> > possible shortcoming of reusing the existing control is that a mem-to-mem
> > driver that exposes an output and a capture queue on a single video node
> > through the same file handle wouldn't be able to set different alpha
> > component values on the two queues. I'm not sure whether that use case is
> > real though, it seems weird to me to set a fixed alpha value on one side
> > to request a different fixed alpha value on the other side.
> 
> I prefer a CAP_ALPHA_COMPONENT control. It's easy to add a capture-specific
> control now, it's much harder to change it in the future.

What bothers me with this approach is the duplication of otherwise identical 
controls. As we'll likely need per-pad controls at some point in the future, 
wouldn't it better to implement a similar way to distinguish between capture 
and output controls ?

-- 
Regards,

Laurent Pinchart

