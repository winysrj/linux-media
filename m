Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:34305 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbeI2ERi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 00:17:38 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Bad MAINTAINERS pattern in section 'CS3308 MEDIA DRIVER'
Date: Fri, 28 Sep 2018 14:51:54 -0700
Message-Id: <20180928215154.28947-1-joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please fix this defect appropriately.

linux-next MAINTAINERS section:

	3826	CS3308 MEDIA DRIVER
	3827	M:	Hans Verkuil <hverkuil@xs4all.nl>
	3828	L:	linux-media@vger.kernel.org
	3829	T:	git git://linuxtv.org/media_tree.git
	3830	W:	http://linuxtv.org
	3831	S:	Odd Fixes
	3832	F:	drivers/media/i2c/cs3308.c
-->	3833	F:	drivers/media/i2c/cs3308.h

Commit that introduced this:

commit fc279cc2887f0830b9232e970dd6a5dcd8612f3c
 Author: Hans Verkuil <hans.verkuil@cisco.com>
 Date:   Mon Nov 30 18:05:54 2015 -0200
 
     [media] cs3308: add new 8-channel volume control driver
     
     Add simple support for this 8 channel volume control driver.
     Currently all it does is to unmute all 8 channels.
     
     Based upon Devin's initial patch made for an older kernel which I
     cleaned up and rebased. Thanks to Kernel Labs for that work.
     
     Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
     Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
     Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 
  MAINTAINERS                |   9 +++
  drivers/media/i2c/Kconfig  |  10 ++++
  drivers/media/i2c/Makefile |   1 +
  drivers/media/i2c/cs3308.c | 138 +++++++++++++++++++++++++++++++++++++++++++++
  4 files changed, 158 insertions(+)

No commit with drivers/media/i2c/cs3308.h found
