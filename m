Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59952 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1CTXq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Mar 2011 19:46:56 -0400
Received: by wya21 with SMTP id 21so5317869wya.19
        for <linux-media@vger.kernel.org>; Sun, 20 Mar 2011 16:46:54 -0700 (PDT)
MIME-Version: 1.0
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 20 Mar 2011 16:46:33 -0700
Message-ID: <AANLkTikyYNdm9StQoM6cb-vVpnk0O1CM8MR4QP006pr4@mail.gmail.com>
Subject: [GIT PULL for 2.6.39] videobuf2 fixes, docbook fix and update e-mail address
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,
Please pull the below patches, which include minor vb2 fixes, a
docbook change as mplanes were added in .39 not .38 and my e-mail
address update. Thanks!


The following changes since commit 41f3becb7bef489f9e8c35284dd88a1ff59b190c:

  [media] V4L DocBook: update V4L2 version (2011-03-11 18:09:02 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/posciak/media_tree.git staging/for_v2.6.39

Pawel Osciak (4):
      [media] Make 2.6.39 not 2.6.38 the version when Multi-planar API was added
      Update Pawel Osciak's e-mail address.
      [media] vb2: vb2_poll() fix return values for file I/O mode
      [media] vb2: Handle return value from start_streaming callback

 Documentation/DocBook/v4l/compat.xml       |   13 ++++---------
 Documentation/DocBook/v4l/v4l2.xml         |   13 ++-----------
 drivers/media/video/mem2mem_testdev.c      |    4 ++--
 drivers/media/video/v4l2-mem2mem.c         |    4 ++--
 drivers/media/video/videobuf2-core.c       |   21 +++++++++++++--------
 drivers/media/video/videobuf2-dma-contig.c |    4 ++--
 drivers/media/video/videobuf2-memops.c     |    4 ++--
 drivers/media/video/videobuf2-vmalloc.c    |    4 ++--
 include/media/v4l2-mem2mem.h               |    2 +-
 include/media/videobuf2-core.h             |    2 +-
 include/media/videobuf2-dma-contig.h       |    2 +-
 include/media/videobuf2-memops.h           |    2 +-
 include/media/videobuf2-vmalloc.h          |    2 +-
 13 files changed, 34 insertions(+), 43 deletions(-)


-- 
Best regards,
Pawel Osciak
