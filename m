Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38863 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2GSMSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 08:18:14 -0400
Received: by vcbfk26 with SMTP id fk26so1890686vcb.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 05:18:14 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Jul 2012 17:48:13 +0530
Message-ID: <CAGzWAsg3hsGV5CPsCzxcKO4djG4iRZauEQvju=G=Zp4Rpqpz2g@mail.gmail.com>
Subject: Supporting 3D formats in V4L2
From: Soby Mathew <soby.linuxtv@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,
    Currently there is limitation in v4l2 for specifying the 3D
formats . In HDMI 1.4 standard, the following 3D formats are
specified:

      1. FRAME_PACK,
      2. FIELD_ALTERNATIVE,
      3. LINE_ALTERNATIVE,
      4. SIDE BY SIDE FULL,
      5. SIDE BY SIDE HALF,
      6. LEFT + DEPTH,
      7. LEFT + DEPTH + GRAPHICS + GRAPHICS-DEPTH,
      8. TOP AND BOTTOM


In addition for some of the formats like Side-by-side-half there are
some additional metadata (like type of horizontal sub-sampling) and
parallax information which may be required for programming the display
processing pipeline properly.

I am not very sure on how to expose this to the userspace. This is an
inherent property of video signal  , hence it would be appropriate to
have an additional field in v4l_format to specify 3D format. Currently
this is a requirement for HDMI 1.4 Rx / Tx but in the future it would
be applicable to broadcast sources also.

In our implementation we have temporarily defined a Private Control to
expose this .

Please let me know of your suggestions .

Best Regards
Soby Mathew
