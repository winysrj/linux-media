Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:59003 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1FORXG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 13:23:06 -0400
Message-ID: <4DF8EA77.4000404@iki.fi>
Date: Wed, 15 Jun 2011 20:23:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	hdegoede@redhat.com
Subject: Re: [PATCH] v4l: Don't access media entity after is has been destroyed
References: <201106131809.28074.laurent.pinchart@ideasonboard.com> <1308126986-7679-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1308126986-7679-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Entities associated with video device nodes are unregistered in
> video_unregister_device(). This destroys the entity even though it can
> still be accessed through open video device nodes.
>
> Move the media_device_unregister_entity() call from
> video_unregister_device() to v4l2_device_release() to ensure that the
> entity isn't unregistered until the last reference to the video device
> is released.
>
> Also remove the media_entity_get()/put() calls from v4l2-dev.c. Those
> functions were designed for subdevs, to avoid a parent module from being
> removed while still accessible through board code. They're not currently
> needed for video device nodes, and will oops when a hotpluggable device
> is disconnected during streaming, as media_entity_put() called in
> v4l2_device_release() tries to access entity->parent->dev->driver which
> is set to NULL when the device is disconnected.

Thanks for the patch, Laurent!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
