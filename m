Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab3CYM4F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 08:56:05 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2PCu585021143
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 08:56:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] Do a few more fixes/cleanups for has_signal/get_afc
Date: Mon, 25 Mar 2013 09:55:56 -0300
Message-Id: <1364216159-12707-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <201303251232.31456.hverkuil@xs4all.nl>
References: <201303251232.31456.hverkuil@xs4all.nl>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While reviewing "tuner-core fix for au0828 g_tuner bug" patch, I noticed
a few other related issues with tuner. This series addresses it.

Hans, please add on your git tree when sending me the au0828 g_tuner bug
patch.

Mauro Carvalho Chehab (3):
  tuner-core: return afc instead of zero
  tuner-core: Remove the now uneeded checks at fe_has_signal/get_afc
  tuner-core: handle errors when getting signal strength/afc

 drivers/media/v4l2-core/tuner-core.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

-- 
1.8.1.4

