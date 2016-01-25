Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49118 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026AbcAYMnJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 07:43:09 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 0/2] automake fixes
Date: Mon, 25 Jan 2016 14:41:22 +0200
Message-Id: <1453725684-4561-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set fixes deprecated use of $(MKDIR_P) in Makefile.am and a configure
script error if libqt isn't available.

-- 
Kind regards,
Sakari 

