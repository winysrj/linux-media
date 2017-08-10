Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55196 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751361AbdHJH4v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 03:56:51 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 4F771600C7
        for <linux-media@vger.kernel.org>; Thu, 10 Aug 2017 10:56:49 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dfiKm-0005mJ-PE
        for linux-media@vger.kernel.org; Thu, 10 Aug 2017 10:56:48 +0300
Date: Thu, 10 Aug 2017 10:56:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES for 4.13] Revert full OF path comparison in OF matching
Message-ID: <20170810075648.dwukyzztir5lj7ag@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This reverts the change from pointer comparison to full OF node path
comparison. As per commit message:

    The commit was flawed in that if the device_node pointers are different,
    then in fact a different device is present and the device node could be
    different in ways other than full_name.
    
    As Frank Rowand explained:
    
    "When an overlay (1) is removed, all uses and references to the nodes and
    properties in that overlay are no longer valid.  Any driver that uses any
    information from the overlay _must_ stop using any data from the overlay.
    Any driver that is bound to a new node in the overlay _must_ unbind.  Any
    driver that became bound to a pre-existing node that was modified by the
    overlay (became bound after the overlay was applied) _must_ adjust itself
    to account for any changes to that node when the overlay is removed.  One
    way to do this is to unbind when notified that the overlay is about to
    be removed, then to re-bind after the overlay is completely removed.
    
    If an overlay (2) is subsequently applied, a node with the same
    full_name as from overlay (1) may exist.  There is no guarantee
    that overlay (1) and overlay (2) are the same overlay, even if
    that node has the same full_name in both cases."
    
    Also, there's not sufficient overlay support in mainline to actually
    remove and re-apply an overlay to hit this condition as overlays can
    only be applied from in kernel APIs.
    
    Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
    Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
    Cc: Javi Merino <javi.merino@kernel.org>
    Cc: Javier Martinez Canillas <javier@osg.samsung.com>
    Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Cc: Frank Rowand <frowand.list@gmail.com>
    Signed-off-by: Rob Herring <robh@kernel.org>
    Acked-by: Javi Merino <javi.merino@kernel.org>
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Please pull.


The following changes since commit 0659445f47586b128613e011eae9f24b07ebe838:

  media: staging: atomisp: sh_css_calloc shall return a pointer to the allocated space (2017-08-09 10:49:36 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git fwnode-fix

for you to fetch changes up to 219ebbde1b134f9ae357b6e45c215f71de6f48d3:

  Revert "[media] v4l: async: make v4l2 coexist with devicetree nodes in a dt overlay" (2017-08-10 10:40:51 +0300)

----------------------------------------------------------------
Rob Herring (1):
      Revert "[media] v4l: async: make v4l2 coexist with devicetree nodes in a dt overlay"

 drivers/media/v4l2-core/v4l2-async.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
