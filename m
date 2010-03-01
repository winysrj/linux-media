Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:18161 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0CAIRg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 03:17:36 -0500
Message-ID: <4B8B780B.8040202@nokia.com>
Date: Mon, 01 Mar 2010 10:17:15 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	david.cohen@nokia.com
Subject: Re: [PATCH v8 4/6] V4L: Events: Add backend
References: <4B85AC1E.8060302@maxwell.research.nokia.com> <1267051568-5757-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1267051568-5757-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus wrote:
> Add event handling backend to V4L2. The backend handles event subscription
> and delivery to file handles. Event subscriptions are based on file handle.
> Events may be delivered to all subscribed file handles on a device
> independent of where they originate from.

Hi,

Some style problems accidentally slipped into this one. I'm not
resending the whole set, just the broken patch, now v8.1.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
