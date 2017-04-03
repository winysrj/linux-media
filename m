Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:36317 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752914AbdDCQfr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 12:35:47 -0400
Received: by mail-qt0-f172.google.com with SMTP id r45so116904748qte.3
        for <linux-media@vger.kernel.org>; Mon, 03 Apr 2017 09:35:47 -0700 (PDT)
Date: Mon, 3 Apr 2017 12:35:44 -0400
From: Sean Paul <seanpaul@chromium.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Archit Taneja <architt@codeaurora.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        laurent.pinchart+renesas@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PULL] Synopsys Media Formats
Message-ID: <20170403163544.kcw5kk52tgku5xua@art_vandelay>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the pull for Neil's new media formats. We're using a topic branch in
drm-misc, so it will not change. Once you have acked, we'll pull this in and
apply the rest of Neil's set.

Thanks,

Sean


The following changes since commit a71c9a1c779f2499fb2afc0553e543f18aff6edf:

  Linux 4.11-rc5 (2017-04-02 17:23:54 -0700)

are available in the git repository at:

  git://anongit.freedesktop.org/git/drm-misc tags/topic/synopsys-media-formats-2017-04-03

for you to fetch changes up to 3c2507d308afb233dd41387b41512e7aa97535f0:

  documentation: media: Add documentation for new RGB and YUV bus formats (2017-04-03 11:51:40 -0400)

----------------------------------------------------------------
Media formats for synopsys HDMI  TX Controller

----------------------------------------------------------------
Neil Armstrong (2):
      media: uapi: Add RGB and YUV bus formats for Synopsys HDMI TX Controller
      documentation: media: Add documentation for new RGB and YUV bus formats

 Documentation/media/uapi/v4l/subdev-formats.rst | 3000 +++++++++++++++--------
 include/uapi/linux/media-bus-format.h           |   13 +-
 2 files changed, 1990 insertions(+), 1023 deletions(-)

-- 
Sean Paul, Software Engineer, Google / Chromium OS
