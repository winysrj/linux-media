Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:18906 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0BVQA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:00:59 -0500
Message-ID: <4B82AA2D.3050804@nokia.com>
Date: Mon, 22 Feb 2010 18:00:45 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	hverkuil@xs4all.nl, david.cohen@nokia.com
Subject: Re: [PATCH 1/6] V4L: File handles
References: <4B82A7FB.50505@maxwell.research.nokia.com> <1266853897-25749-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1266853897-25749-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus wrote:
> This patch adds a list of v4l2_fh structures to every video_device.
> It allows using file handle related information in V4L2. The event interface
> is one example of such use.
> 
> Video device drivers should use the v4l2_fh pointer as their
> file->private_data.

FYI: misspelled Laurent's address. Please change that when replying. Sorry.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
