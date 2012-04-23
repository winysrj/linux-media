Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37499 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751819Ab2DWWXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 18:23:08 -0400
Message-ID: <4F95D64A.10505@iki.fi>
Date: Tue, 24 Apr 2012 01:23:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] omap3isp: ccdc: Add crop support on output formatter
 source pad
References: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com> <1335180595-27931-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335180595-27931-4-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

The patch looks good as such on the first glance, but I have another 
question: why are you not using the selections API instead? It's in 
Mauro's tree already. Also, the old S_CROP IOCTL only has been defined 
for sink pads, not source.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
