Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32237 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3FKLiR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 07:38:17 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO800KE78BOENC0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Jun 2013 12:38:15 +0100 (BST)
Message-id: <51B70C26.9060402@samsung.com>
Date: Tue, 11 Jun 2013 13:38:14 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: prabhakar.csengg@gmail.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com
Subject: Re: [RFC PATCH 2/2] davinci_vpfe: Clean up media entity after
 unregistering subdev
References: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
 <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi>
 <1370947849-24314-2-git-send-email-sakari.ailus@iki.fi>
In-reply-to: <1370947849-24314-2-git-send-email-sakari.ailus@iki.fi>
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

