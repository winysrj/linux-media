Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37439 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752061AbaLCLOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 06:14:52 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: aviv.d.greenberg@intel.com
Subject: [REVIEW PATCH 0/2] data_offset for single plane buffers, packed raw10
Date: Wed,  3 Dec 2014 13:14:07 +0200
Message-Id: <1417605249-5322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

These two patches add data_offset support for single-plane buffers and
definitions and documentation for 10-bit packed raw bayer formats.

-- 
Kind regards,
Sakari
