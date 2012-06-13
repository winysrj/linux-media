Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:33877 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab2FMVte (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 17:49:34 -0400
Message-ID: <4FD90ADF.7090000@iki.fi>
Date: Thu, 14 Jun 2012 00:49:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, t.stanislaws@samsung.com
Subject: Re: [PATCH v2 2/6] v4l: Remove "_ACTUAL" from subdev selection API
 target definition names
References: <4FD9065B.2030703@iki.fi> <1339623025-6227-2-git-send-email-sakari.ailus@iki.fi> <4FD9096E.2070900@gmail.com>
In-Reply-To: <4FD9096E.2070900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> On 06/13/2012 11:30 PM, Sakari Ailus wrote:
>> The string "_ACTUAL" does not say anything more about the target
>> names. Drop
>> it. V4L2 selection API was changed by "V4L: Rename
>> V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
>> V4L2_SEL_TGT_[CROP/COMPOSE]" by Sylwester Nawrocki. This patch does
>> the same
> 
> The new patch summary line is now:
> "V4L: Remove "_ACTIVE" from the selection target name definitions"
> Hence might be worth to update it also in here.

Thanks. Fixed this one, too.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi


