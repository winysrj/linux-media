Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51148 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3FIUW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jun 2013 16:22:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com, s.nawrocki@samsung.com
Subject: Re: [RFC PATCH v2 0/2] Media entity links handling
Date: Sun, 09 Jun 2013 22:23:02 +0200
Message-ID: <152314640.pO20KFaLY3@avalon>
In-Reply-To: <1370806899-17709-1-git-send-email-s.nawrocki@samsung.com>
References: <1370806899-17709-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sunday 09 June 2013 21:41:37 Sylwester Nawrocki wrote:
> Hi All,
> 
> This small patch set adds a function for removing all links at a media
> entity. I found out such a function is needed when media entites that
> belong to a single media device have drivers in different kernel modules.
> This means virtually all camera drivers, since sensors are separate
> modules from the host interface drivers.
> 
> More details can be found at each patch's description.

The patches look good to me.

> The links removal from a media entity is rather strightforward, but when
> and where links should be created/removed is not immediately clear to me.
> 
> I assumed that links should normally be created/removed when an entity
> is registered to its media device, with the graph mutex held.
> 
> I'm open to opinions whether it's good or not and possibly suggestions
> on how those issues could be handled differently.

It's a very good question. So far links were created at initialization time 
and assumed to stay until the device gets torn down. Existing drivers thus 
access the links without holding the graph mutex.

An easy solution to fix race conditions at link creation time would be to take 
the graph mutex in media_entity_create_link(). We will still have to fix 
drivers to take the mutex when accessing links, I don't think there's a way 
around that. We also need to precisely define what the graph mutex protects 
and how drivers can access links and entities. This will become especially 
important when the media controller framework will be used in DRM/KMS.

-- 
Regards,

Laurent Pinchart

