Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60967 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751299Ab2ETUAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 16:00:47 -0400
Message-ID: <4FB94D6B.2060104@iki.fi>
Date: Sun, 20 May 2012 23:00:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L: Remove "_ACTIVE" from the selection target name
 definitions
References: <20120519181000.GQ3373@valkosipuli.retiisi.org.uk> <1337523432-25148-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1337523432-25148-1-git-send-email-sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> This patch drops the _ACTIVE part from the selection target names
> as a prerequisite to unify the selection target names across the subdev
> and regular video node API.
>
> The meaning of V4L2_SEL_TGT_*_ACTIVE and V4L2_SUBDEV_SEL_TGT_*_ACTUAL
> selection targets is logically the same. Different names add to confusion
> where both APIs are used in a single driver or an application. For some
> system configurations different names may lead to interoperability issues.
>
> For backwards compatibility V4L2_SEL_TGT_CROP_ACTIVE and
> V4L2_SEL_TGT_COMPOSE_ACTIVE are defined as aliases to V4L2_SEL_TGT_CROP
> and V4L2_SEL_TGT_COMPOSE. These aliases will be removed after deprecation
> period, according to Documentation/feature-removal-schedule.txt.
>
> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> Acked-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
> ---
> This a replacement for this patch:  http://patchwork.linuxtv.org/patch/11226
> Changes include an adition of backward compatibility alias definitions and
> the required bits for FIMC-LITE driver.
>
> Sakari, do you think you could update you pull request with this patch ?
>
> I assumed the Acks still apply, if not, please let me know.

I'll send a new pull req with the new patch tomorrow, during early 
morning unless something unexpected happens.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
