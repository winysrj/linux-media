Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54719 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2FMVnN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 17:43:13 -0400
Received: by weyu7 with SMTP id u7so792643wey.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 14:43:12 -0700 (PDT)
Message-ID: <4FD9096E.2070900@gmail.com>
Date: Wed, 13 Jun 2012 23:43:10 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, t.stanislaws@samsung.com
Subject: Re: [PATCH v2 2/6] v4l: Remove "_ACTUAL" from subdev selection API
 target definition names
References: <4FD9065B.2030703@iki.fi> <1339623025-6227-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1339623025-6227-2-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2012 11:30 PM, Sakari Ailus wrote:
> The string "_ACTUAL" does not say anything more about the target names. Drop
> it. V4L2 selection API was changed by "V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
> V4L2_SEL_TGT_[CROP/COMPOSE]" by Sylwester Nawrocki. This patch does the same

The new patch summary line is now:
"V4L: Remove "_ACTIVE" from the selection target name definitions"
Hence might be worth to update it also in here.

> for the V4L2 subdev API.
>
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>

Regards,
Sylwester
