Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35514 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbbD1IQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 04:16:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergman <arnd@arndb.de>,
	Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>
Subject: [GIT PULL FOR v4.1] OMAP4 ISS fix
Date: Tue, 28 Apr 2015 11:16:48 +0300
Message-ID: <2435047.PJ6oufUfoi@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Could you please pull the following OMAP4 ISS regression fox for v4.1 ? If 
fixes a compilation breakage due to a change in the OMAP4 API.

The following changes since commit cb0c9e1f6777287e81d9b48c264d980bf5014b48:

  [media] smiapp: Use v4l2_of_alloc_parse_endpoint() (2015-04-27 16:05:55 
-0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/fixes

for you to fetch changes up to 2039b0a6114b4ebc26ac261467225cc4622753ca:

  v4l: omap4iss: Replace outdated OMAP4 control pad API with syscon 
(2015-04-28 11:06:14 +0300)

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: omap4iss: Replace outdated OMAP4 control pad API with syscon

 drivers/staging/media/omap4iss/Kconfig      |  1 +
 drivers/staging/media/omap4iss/iss.c        | 11 +++++++++++
 drivers/staging/media/omap4iss/iss.h        |  4 ++++
 drivers/staging/media/omap4iss/iss_csiphy.c | 12 +++++++-----
 4 files changed, 23 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart

