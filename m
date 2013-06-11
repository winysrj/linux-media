Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20500 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3FKLi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 07:38:57 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO8005ST8B7PHB0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Jun 2013 12:38:55 +0100 (BST)
Message-id: <51B70C4E.9000404@samsung.com>
Date: Tue, 11 Jun 2013 13:38:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: prabhakar.csengg@gmail.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com
Subject: Re: [RFC PATCH 1/2] smiapp: Clean up media entity after unregistering
 subdev
References: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
 <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi>
In-reply-to: <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/11/2013 12:50 PM, Sakari Ailus wrote:
> media_entity_cleanup() frees the links array which will be accessed by
> media_entity_remove_links() called by v4l2_device_unregister_subdev().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
