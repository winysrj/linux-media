Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:60435 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726441AbeI2EbF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 00:31:05 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Bad MAINTAINERS pattern in section 'VIDEOBUF2 FRAMEWORK'
Date: Fri, 28 Sep 2018 15:05:15 -0700
Message-Id: <20180928220516.31962-1-joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please fix this defect appropriately.

linux-next MAINTAINERS section:

	15636	VIDEOBUF2 FRAMEWORK
	15637	M:	Pawel Osciak <pawel@osciak.com>
	15638	M:	Marek Szyprowski <m.szyprowski@samsung.com>
	15639	M:	Kyungmin Park <kyungmin.park@samsung.com>
	15640	L:	linux-media@vger.kernel.org
	15641	S:	Maintained
-->	15642	F:	drivers/media/v4l2-core/videobuf2-*
	15643	F:	include/media/videobuf2-*

Commit that introduced this:

commit 90d72ac6e1c3c65233a13816770fb85c8831bff2
 Author: Mauro Carvalho Chehab <mchehab@redhat.com>
 Date:   Sat Sep 15 17:59:42 2012 -0300
 
     MAINTAINERS: fix the path for the media drivers that got renamed
     
     Due to the media tree path renaming, several drivers change their
     location. Update MAINTAINERS accordingly.
     
     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
 
  MAINTAINERS | 43 +++++++++++++++++++++----------------------
  1 file changed, 21 insertions(+), 22 deletions(-)

Last commit with drivers/media/v4l2-core/videobuf2-*

commit 03fbdb2fc2b8bb27b0ee0534fd3e9c57cdc3854a
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Thu Dec 21 08:29:39 2017 -0500

    media: move videobuf2 to drivers/media/common
    
    Now that VB2 is used by both V4L2 and DVB core, move it to
    the common part of the subsystem.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

 drivers/media/common/Kconfig                       |  1 +
 drivers/media/common/Makefile                      |  2 +-
 drivers/media/common/videobuf/Kconfig              | 31 +++++++++++++++++++++
 drivers/media/common/videobuf/Makefile             |  7 +++++
 .../videobuf}/videobuf2-core.c                     |  0
 .../videobuf}/videobuf2-dma-contig.c               |  0
 .../videobuf}/videobuf2-dma-sg.c                   |  0
 .../{v4l2-core => common/videobuf}/videobuf2-dvb.c |  0
 .../videobuf}/videobuf2-memops.c                   |  0
 .../videobuf}/videobuf2-v4l2.c                     |  0
 .../videobuf}/videobuf2-vmalloc.c                  |  0
 drivers/media/v4l2-core/Kconfig                    | 32 ----------------------
 drivers/media/v4l2-core/Makefile                   |  7 -----
 13 files changed, 40 insertions(+), 40 deletions(-)
