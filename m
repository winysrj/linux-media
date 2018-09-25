Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbeIYSOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 14:14:32 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 0/3] Add a glossary and fix some issues at open.rst docs
Date: Tue, 25 Sep 2018 09:06:50 -0300
Message-Id: <cover.1537876293.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those three patches were part of an attempt to add definitions for
some terms used at the media subsystem:

	https://lwn.net/Articles/732022/

On that time, the first patch generated heated discussions, on terms
related to mc-centric/vdev-centric. The cern of the discussions were
how to call the subdev API and the non-subdev API part of the 
video4linux API.

I ended by being side-tracked by other things, and didn't have a chance
to submit an updated version.

Well, now I'm doing things differently: at the glossary.rst, I removed
everything related to hardware control. So, it should contain only the
terms that there aren't any divergences. So, I hope we can manage to
merge it this time.

After having this series merged, I'll address again the MC/vdev centric
hardware control on a separate patchset, perhaps using a different
approach together with the new glossary definitions related
to it.

Mauro Carvalho Chehab (3):
  media: add glossary.rst with common terms used at V4L2 spec
  media: open.rst: better document device node naming
  media: open.rst: remove the minor number range

 Documentation/media/uapi/v4l/glossary.rst | 108 ++++++++++++++++++++++
 Documentation/media/uapi/v4l/open.rst     |  53 +++++++++--
 Documentation/media/uapi/v4l/v4l2.rst     |   1 +
 3 files changed, 154 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/glossary.rst

-- 
2.17.1
