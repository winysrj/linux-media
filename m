Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50725 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaEZWQy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 18:16:54 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC 0/2] Propert alpha channel support in pixel formats
Date: Tue, 27 May 2014 00:17:07 +0200
Message-Id: <1401142629-12856-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This RFC patch series attempts to clean up the current ARGB format mess.

The core issue is that the existing ARGB formats are ill-defined. The V4L2
specification doesn't clearly document how the alpha bits should behave.
Drivers have thus used the same formats in different, incompatible ways, and
applications now rely on the driver-specific behaviours. In a word, that's a
mess.

I've discussed the issue in the #v4l channel a couple of days ago and we came
up to the conclusion that the best (or least painful) way to fix the problem
is to define new clean XRGB and ARGB formats, and consider the existing
formats as deprecated (meaning that no new driver should use them, they won't
disappear in a couple of months, as that would break userspace).

The first patch adds the new XRGB and ARGB formats and documents them. It
purposely includes no core code to handle backward compatibility for existing
drivers that may wish to move to the new formats. The reason is that I would
first like to get feedback on the proposal before working on compat code, and
I believe we should first implement the compat code in a couple of drivers and
then see how the approach could be generalized, if possible at all.

The second patch allows using the ALPHA_COMPONENT control on output devices to
support an ARGB use case documented in the first patch. One possible
shortcoming of reusing the existing control is that a mem-to-mem driver that
exposes an output and a capture queue on a single video node through the same
file handle wouldn't be able to set different alpha component values on the
two queues. I'm not sure whether that use case is real though, it seems weird
to me to set a fixed alpha value on one side to request a different fixed
alpha value on the other side.

Laurent Pinchart (2):
  v4l: Add ARGB and XRGB pixel formats
  DocBook: media: Document ALPHA_COMPONENT control usage on output
    devices

 Documentation/DocBook/media/v4l/controls.xml       |  17 +-
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 415 ++++++++++++++++++++-
 include/uapi/linux/videodev2.h                     |   8 +
 3 files changed, 413 insertions(+), 27 deletions(-)

-- 
Regards,

Laurent Pinchart

