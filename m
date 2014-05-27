Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3315 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaE0HTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 03:19:04 -0400
Message-ID: <53843C3F.8070204@xs4all.nl>
Date: Tue, 27 May 2014 09:18:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 0/2] Propert alpha channel support in pixel formats
References: <1401142629-12856-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1401142629-12856-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2014 12:17 AM, Laurent Pinchart wrote:
> Hello,
> 
> This RFC patch series attempts to clean up the current ARGB format mess.
> 
> The core issue is that the existing ARGB formats are ill-defined. The V4L2
> specification doesn't clearly document how the alpha bits should behave.
> Drivers have thus used the same formats in different, incompatible ways, and
> applications now rely on the driver-specific behaviours. In a word, that's a
> mess.
> 
> I've discussed the issue in the #v4l channel a couple of days ago and we came
> up to the conclusion that the best (or least painful) way to fix the problem
> is to define new clean XRGB and ARGB formats, and consider the existing
> formats as deprecated (meaning that no new driver should use them, they won't
> disappear in a couple of months, as that would break userspace).
> 
> The first patch adds the new XRGB and ARGB formats and documents them.

Question: should we add all XRGB and ARGB formats even if drivers do not use
them? Or just those that are actually used?

> It
> purposely includes no core code to handle backward compatibility for existing
> drivers that may wish to move to the new formats. The reason is that I would
> first like to get feedback on the proposal before working on compat code, and
> I believe we should first implement the compat code in a couple of drivers and
> then see how the approach could be generalized, if possible at all.
> 
> The second patch allows using the ALPHA_COMPONENT control on output devices to
> support an ARGB use case documented in the first patch. One possible
> shortcoming of reusing the existing control is that a mem-to-mem driver that
> exposes an output and a capture queue on a single video node through the same
> file handle wouldn't be able to set different alpha component values on the
> two queues. I'm not sure whether that use case is real though, it seems weird
> to me to set a fixed alpha value on one side to request a different fixed
> alpha value on the other side.

I prefer a CAP_ALPHA_COMPONENT control. It's easy to add a capture-specific
control now, it's much harder to change it in the future.

Regards,

	Hans

> 
> Laurent Pinchart (2):
>   v4l: Add ARGB and XRGB pixel formats
>   DocBook: media: Document ALPHA_COMPONENT control usage on output
>     devices
> 
>  Documentation/DocBook/media/v4l/controls.xml       |  17 +-
>  .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 415 ++++++++++++++++++++-
>  include/uapi/linux/videodev2.h                     |   8 +
>  3 files changed, 413 insertions(+), 27 deletions(-)
> 

