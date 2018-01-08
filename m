Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49410 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755386AbeAHPKQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 10:10:16 -0500
Date: Mon, 8 Jan 2018 17:10:13 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] media: media-device: use strlcpy() instead of strncpy()
Message-ID: <20180108151013.ess23wiff7slpr7h@valkosipuli.retiisi.org.uk>
References: <1515415259-195067-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515415259-195067-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 08, 2018 at 08:40:59PM +0800, Xiongfeng Wang wrote:
> From: Xiongfeng Wang <xiongfeng.wang@linaro.org>
> 
> gcc-8 reports
> 
> drivers/media/media-device.c: In function 'media_device_get_topology':
> ./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
> bound 64 equals destination size [-Wstringop-truncation]
> 
> We need to use strlcpy() to make sure the dest string is nul-terminated.
> 
> Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
