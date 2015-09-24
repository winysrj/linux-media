Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:58335 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752221AbbIXJCn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2015 05:02:43 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Robin Murphy <robin.murphy@arm.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>
Subject: [PATCH v2] media: vb2: Fix vb2_dc_prepare do not correct sync data to device 
Date: Thu, 24 Sep 2015 17:02:35 +0800
Message-ID: <1443085356-1010-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change in v2:
Apply same fix to videobuf2-dma-sg

