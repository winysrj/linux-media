Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41854 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752406AbdHIHyQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 03:54:16 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id B4CEC600C7
        for <linux-media@vger.kernel.org>; Wed,  9 Aug 2017 10:54:14 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dfLok-0005WX-8c
        for linux-media@vger.kernel.org; Wed, 09 Aug 2017 10:54:14 +0300
Date: Wed, 9 Aug 2017 10:54:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.13] atomisp bugfix
Message-ID: <20170809075413.7s6wkihggruwzage@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The atomisp was broken by da22013f7df4 ("atomisp: remove indirection from
sh_css_malloc") which caused that sh_css_calloc() wrapper function always
returned NULL.

Please pull.


The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  https://linuxtv.org/git/sailus/media_tree.git atomisp-fix

for you to fetch changes up to c1d6d0506602b707696d024e989ce90d8970b1e8:

  media: staging: atomisp: sh_css_calloc shall return a pointer to the allocated space (2017-08-08 15:54:06 +0300)

----------------------------------------------------------------
Sergei A. Trusov (1):
      media: staging: atomisp: sh_css_calloc shall return a pointer to the allocated space

 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c | 1 +
 1 file changed, 1 insertion(+)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
