Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab2DHP5p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:57:45 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/10] uvcvideo: Add support for control events (v2)
Date: Sun,  8 Apr 2012 17:59:44 +0200
Message-Id: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is v2 of my uvcvideo ctrl events patchset. It hopefully addresses
all remarks you had wrt the previous version.

As discussed before this also contains some none uvcvideo changes, which
are necessary for the uvcvideo ctrl event support. Since these patches
have already been reviewed and they are a dependency of the further patches
in this set it is probably best for these patches to go upstream through
your tree too.

Regards,

Hans
