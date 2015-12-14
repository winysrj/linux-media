Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36314 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbLNTvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 14:51:04 -0500
Date: Mon, 14 Dec 2015 22:50:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] media-entity: protect object creation/removal using spin
 lock
Message-ID: <20151214195053.GA15098@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

The patch f8fd4c61b5ae: "[media] media-entity: protect object
creation/removal using spin lock" from Dec 9, 2015, leads to the
following static checker warning:

	drivers/media/media-entity.c:781 media_remove_intf_link()
	error: dereferencing freed memory 'link'

drivers/media/media-entity.c
   777  void media_remove_intf_link(struct media_link *link)
   778  {
   779          spin_lock(&link->graph_obj.mdev->lock);
   780          __media_remove_intf_link(link);
   781          spin_unlock(&link->graph_obj.mdev->lock);

Do we need this unlock any more?  Haven't we freed the lock on the
previous line?

   782  }

regards,
dan carpenter
