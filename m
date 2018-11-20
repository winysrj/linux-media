Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:10648 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbeKUCgk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 21:36:40 -0500
Date: Tue, 20 Nov 2018 18:06:24 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] media: video-i2c: don't use msleep for 1ms - 20ms
Message-ID: <20181120160623.ev6hayzlukdx3k57@mara.localdomain>
References: <1542727660-14117-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542727660-14117-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 21, 2018 at 12:27:40AM +0900, Akinobu Mita wrote:
> Documentation/timers/timers-howto.txt says:
> 
> "msleep(1~20) may not do what the caller intends, and will often sleep
> longer (~20 ms actual sleep for any value given in the 1~20ms range)."
> 
> So replace msleep(2) by usleep_range(2000, 3000).
> 
> Reported-by: Hans Verkuil <hansverk@cisco.com>
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
