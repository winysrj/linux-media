Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37194 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbbL2MWt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 07:22:49 -0500
Subject: Re: [PATCH] [media] uvcvideo: Fix build if !MEDIA_CONTROLLER
To: Thierry Reding <thierry.reding@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1451385052-20158-1-git-send-email-thierry.reding@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56827B13.5060008@osg.samsung.com>
Date: Tue, 29 Dec 2015 09:22:43 -0300
MIME-Version: 1.0
In-Reply-To: <1451385052-20158-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Thierry,

On 12/29/2015 07:30 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Accesses to the UVC device's mdev field need to be protected by a
> preprocessor conditional to avoid build errors, since the field is only
> included if the MEDIA_CONTROLLER option is selected.
> 
> Fixes: 1590ad7b5271 ("[media] media-device: split media initialization and registration")
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---

Thanks for the patch but I've already posted the same fix a couple of
days ago [0]. Since the offending commit still has not landed in
mainline, Mauro squashed the fixes with the original commit and will
refresh his next branch soon.

[0]: https://lkml.org/lkml/2015/12/21/224

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
