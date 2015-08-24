Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59531 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbbHXUTC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 16:19:02 -0400
Subject: Re: [PATCH] media: don't try to empty links list in
 media_entity_cleanup()
To: linux-media@vger.kernel.org
References: <1440439073-4082-1-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <55DB7C30.90804@osg.samsung.com>
Date: Mon, 24 Aug 2015 22:18:56 +0200
MIME-Version: 1.0
In-Reply-To: <1440439073-4082-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 08/24/2015 07:57 PM, Javier Martinez Canillas wrote:
> The media_entity_cleanup() function only cleans up the entity links list
> but this operation is already made in media_device_unregister_entity().
> 
> In most cases this should be harmless (besides having duplicated code)
> since the links list would be empty so the iteration would not happen
> but the links list is initialized in media_device_register_entity() so
> if a driver fails to register an entity with a media device and clean up
> the entity in the error path, a NULL deference pointer error will happen.
> 
> So don't try to empty the links list in media_entity_cleanup() since
> is either done already or haven't been initialized yet.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 

I forgot to mention that this patch depends on Mauro's
"[PATCH v7 00/44] MC next generation patches" [0].

Sorry for missing that.

[0]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg91528.html

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
