Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab3AKPDK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 10:03:10 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0BF3ABb032340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 11 Jan 2013 10:03:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] extract_xc3028.pl: fix permissions
Date: Fri, 11 Jan 2013 13:02:32 -0200
Message-Id: <1357916552-31886-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an executable file. Change permissions to reflect it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 0 files changed
 mode change 100644 => 100755 Documentation/video4linux/extract_xc3028.pl

diff --git a/Documentation/video4linux/extract_xc3028.pl b/Documentation/video4linux/extract_xc3028.pl
old mode 100644
new mode 100755
-- 
1.7.11.7

