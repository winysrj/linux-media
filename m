Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32797 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaIDM6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 08:58:36 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBD00AMMO1NXQ00@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Sep 2014 08:58:35 -0400 (EDT)
Date: Thu, 04 Sep 2014 09:58:31 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 16/46] [media] smiapp-core: use true/false for boolean vars
Message-id: <20140904095831.020363c7.m.chehab@samsung.com>
In-reply-to: <20140904070340.GJ30024@valkosipuli.retiisi.org.uk>
References: <cover.1409775488.git.m.chehab@samsung.com>
 <64a4483b3c2e3864dfdc0029497c9e4188a88887.1409775488.git.m.chehab@samsung.com>
 <20140904070340.GJ30024@valkosipuli.retiisi.org.uk>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 04 Sep 2014 10:03:40 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> On Wed, Sep 03, 2014 at 05:32:48PM -0300, Mauro Carvalho Chehab wrote:
> > Instead of using 0 or 1 for boolean, use the true/false
> > defines.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> Thanks!
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Would you like me to pick this patch to my tree, or would you like to apply
> it directly? I'm fine with either.

I'll pick it myself.

Regards,
Mauro
