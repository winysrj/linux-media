Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41984 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752410AbdHIIDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 04:03:42 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 2651D600C7
        for <linux-media@vger.kernel.org>; Wed,  9 Aug 2017 11:03:41 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dfLxs-0005X4-Rb
        for linux-media@vger.kernel.org; Wed, 09 Aug 2017 11:03:40 +0300
Date: Wed, 9 Aug 2017 11:03:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] Stream control documentation
Message-ID: <20170809080340.4c5b4jjypqiqyllp@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Add stream control documentation.

We have recently added support for hardware that makes it possible to have
pipelines that are controlled by more than two drivers. This necessitates
documenting V4L2 stream control behaviour for such pipelines.

Please pull.


The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  https://linuxtv.org/git/sailus/media_tree.git v4l2-stream-doc

for you to fetch changes up to ef8e5d20b45b05290c56450d2130a0dc3c021c5a:

  docs-rst: media: Document s_stream() video op usage (2017-08-08 17:31:25 +0300)

----------------------------------------------------------------
Sakari Ailus (1):
      docs-rst: media: Document s_stream() video op usage

 Documentation/media/kapi/v4l2-subdev.rst | 36 ++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)


-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
