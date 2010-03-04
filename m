Return-path: <linux-media-owner@vger.kernel.org>
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:51431
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0CDQBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 11:01:12 -0500
From: Arnout Vandecappelle <arnout@mind.be>
To: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	mchehab@infradead.org
Subject: [PATCHv2] Support for zerocopy to DSP on OMAP3
Date: Thu,  4 Mar 2010 17:00:49 +0100
Message-Id: <1267718451-24961-1-git-send-email-arnout@mind.be>
In-Reply-To: <201003031512.45428.arnout@mind.be>
References: <201003031512.45428.arnout@mind.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Here is an updated patch, properly split up and with commit messages.

 I've tested it on my OMAP3 board an it works.  I don't have anything else
to test it with.

 Regards,
 Arnout

 [PATCH 1/2] V4L/DVB: buf-dma-sg.c: don't assume nr_pages == sglen
 [PATCH 2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memory
