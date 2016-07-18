Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45805 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/36] [media] extract_xc3028.pl: move it to scripts/dir
Date: Sun, 17 Jul 2016 22:55:44 -0300
Message-Id: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This doesn't belong at documentation. Move it to scripts.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 {Documentation/video4linux => scripts}/extract_xc3028.pl | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename {Documentation/video4linux => scripts}/extract_xc3028.pl (100%)

diff --git a/Documentation/video4linux/extract_xc3028.pl b/scripts/extract_xc3028.pl
similarity index 100%
rename from Documentation/video4linux/extract_xc3028.pl
rename to scripts/extract_xc3028.pl
-- 
2.7.4

