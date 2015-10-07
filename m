Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60132 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947AbbJGLZ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2015 07:25:28 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: tiffany.lin@mediatek.com
Subject: [PATCH v3 0/2] vb2: Fix dma sg and dma contig cache sync
Date: Wed,  7 Oct 2015 14:23:31 +0300
Message-Id: <1444217013-21156-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany and others,

I split the patches into two as they need to be applied since different
stable kernel versions, and added cc stable. I intend to send a pull
request later today.

-- 
Kind regards,
Sakari

