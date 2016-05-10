Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42442 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbcEJVmi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 17:42:38 -0400
Subject: Re: [PATCH] [media] v4l2-async: Pass the v4l2_async_subdev to the
 unbind callback
To: Alban Bedel <alban.bedel@avionic-design.de>,
	linux-media@vger.kernel.org
References: <1462886354-2115-1-git-send-email-alban.bedel@avionic-design.de>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-kernel@vger.kernel.org
Message-ID: <9782608b-65da-8379-9ec8-bb7f08429af6@osg.samsung.com>
Date: Tue, 10 May 2016 17:42:30 -0400
MIME-Version: 1.0
In-Reply-To: <1462886354-2115-1-git-send-email-alban.bedel@avionic-design.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Alban,

On 05/10/2016 09:19 AM, Alban Bedel wrote:
> v4l2_async_cleanup() is always called before before calling the
> unbind() callback. However v4l2_async_cleanup() clear the asd member,
> so when calling the unbind() callback the v4l2_async_subdev is always
> NULL. To fix this save the asd before calling v4l2_async_cleanup().
> 
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---

Patch looks good to me. So after fixing the issues pointed out by Sakari:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
