Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50524 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751364AbaJBIql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:41 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2] smiapp and smiapp-pll: more robust parameter handling, cleanups
Date: Thu,  2 Oct 2014 11:45:50 +0300
Message-Id: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is an update of my previous set of smiapp PLL improvements.

The previous set can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg80864.html>

Changes since v1:

- "smiapp: Clean up smiapp_set_format()" has been added to the set.

- "smiapp: Decrease link frequency if media bus pixel format BPP
  requires" is no longer needed since the control framework handles
  validation of the menu items (based on the mask supplied by the driver).

- A bug in the loop condition in "smiapp: Gather information on valid link
  rate and BPP combinations" has been fixed. In the same patch, fixed use of
  a non-existent label.

- Print available link frequencies using dev_dbg() rather than dev_info().

-- 
Kind regards,
Sakari
