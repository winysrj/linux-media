Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60423 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbbL1OQA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 09:16:00 -0500
Subject: Re: [PATCH RFC] [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <d029047c76d6d3e5e6a531080ede83f6e063f7db.1451311244.git.mchehab@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56814412.4000903@osg.samsung.com>
Date: Mon, 28 Dec 2015 11:15:46 -0300
MIME-Version: 1.0
In-Reply-To: <d029047c76d6d3e5e6a531080ede83f6e063f7db.1451311244.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/28/2015 11:03 AM, Mauro Carvalho Chehab wrote:
> There are a few discussions left with regards to this ioctl:
> 
> 1) the name of the new structs will contain _v2_ on it?
> 2) what's the best alternative to avoid compat32 issues?
> 
> Due to that, let's postpone the addition of this new ioctl to
> the next Kernel version, to give people more time to discuss it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>

I agree that leaving the IOCTL out for now is the most sensible thing to
do since as you said, we didn't have time due holidays season to finish
the discussion about the struct media_v2_topology layout.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
