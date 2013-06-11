Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17702 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3FKLoe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 07:44:34 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO8004BE8GXFKC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Jun 2013 12:44:33 +0100 (BST)
Message-id: <51B70D9F.9010005@samsung.com>
Date: Tue, 11 Jun 2013 13:44:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, a.hajda@samsung.com
Subject: Re: [RFC PATCH v3 1/2] media: Add a function removing all links of a
 media entity
References: <1370876070-23699-1-git-send-email-s.nawrocki@samsung.com>
 <1370876070-23699-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370876070-23699-3-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2013 04:54 PM, Sylwester Nawrocki wrote:
> +void media_entity_remove_links(struct media_entity *entity)
> +{
> +	/* Do nothing if the entity is not registered. */
> +	if (entity->parent == NULL)
> +		return;
> +
> +	mutex_lock(&entity->parent->graph_mutex);
> +	__media_entity_remove_links(entity);
> +	mutex_lock(&entity->parent->graph_mutex);

And this bug snicked in again during rebase, I've noticed this yesterday,
after posting and more testing. I'll keep it corrected locally, unless
there is v4 needed.

Regards,
Sylwester
