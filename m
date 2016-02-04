Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54926 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbcBDQBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2016 11:01:05 -0500
Subject: Re: [PATCH 2/7] [media] siano: remove get_frontend stub
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
 <a210c751a95453321d7e9204633785c32158d9cc.1454600641.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56B375B6.8010700@osg.samsung.com>
Date: Thu, 4 Feb 2016 13:00:54 -0300
MIME-Version: 1.0
In-Reply-To: <a210c751a95453321d7e9204633785c32158d9cc.1454600641.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 02/04/2016 12:57 PM, Mauro Carvalho Chehab wrote:
> There's nothing at siano's get_frontend() callback. So,
> remove it, as the core will handle it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---

The patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
