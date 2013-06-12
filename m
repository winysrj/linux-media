Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55500 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3FLEo1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 00:44:27 -0400
Received: by mail-wi0-f170.google.com with SMTP id ey16so109834wid.1
        for <linux-media@vger.kernel.org>; Tue, 11 Jun 2013 21:44:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370947849-24314-2-git-send-email-sakari.ailus@iki.fi>
References: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
 <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi> <1370947849-24314-2-git-send-email-sakari.ailus@iki.fi>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 12 Jun 2013 10:14:04 +0530
Message-ID: <CA+V-a8t2MUwEHZMvbb0mN+dy6bH6yt_mwirH6cgoTfZfh83cew@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] davinci_vpfe: Clean up media entity after
 unregistering subdev
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: s.nawrocki@samsung.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tue, Jun 11, 2013 at 4:20 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> media_entity_cleanup() frees the links array which will be accessed by
> media_entity_remove_links() called by v4l2_device_unregister_subdev().
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
