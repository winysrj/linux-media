Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbbGFNKQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2015 09:10:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] Rename ISDB-T table for Gama city
Date: Mon,  6 Jul 2015 10:09:14 -0300
Message-Id: <1436188155-18875-3-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1436188155-18875-1-git-send-email-mchehab@osg.samsung.com>
References: <1436188155-18875-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gama is actually part of Brasilia, but is a separate County.
It is not called "Brasilia Gama". So, better name the file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 isdb-t/{br-df-BrasiliaGama => br-df-Gama} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename isdb-t/{br-df-BrasiliaGama => br-df-Gama} (100%)

diff --git a/isdb-t/br-df-BrasiliaGama b/isdb-t/br-df-Gama
similarity index 100%
rename from isdb-t/br-df-BrasiliaGama
rename to isdb-t/br-df-Gama
-- 
2.4.3

