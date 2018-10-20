Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58778 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725198AbeJUEfh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Oct 2018 00:35:37 -0400
Date: Sat, 20 Oct 2018 23:23:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v4 1/6] media: video-i2c: avoid accessing released memory
 area when removing driver
Message-ID: <20181020202357.awictxh334v5zhgh@valkosipuli.retiisi.org.uk>
References: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com>
 <1540045588-9091-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540045588-9091-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 20, 2018 at 11:26:23PM +0900, Akinobu Mita wrote:
> The video device release() callback for video-i2c driver frees the whole
> struct video_i2c_data.  If there is no user left for the video device
> when video_unregister_device() is called, the release callback is executed.
> 
> However, in video_i2c_remove() some fields (v4l2_dev, lock, and queue_lock)
> in struct video_i2c_data are still accessed after video_unregister_device()
> is called.
> 
> This fixes the use after free by moving the code from video_i2c_remove()
> to the release() callback.
> 
> Fixes: 5cebaac60974 ("media: video-i2c: add video-i2c driver")
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Reviewed-by: Matt Ranostay <matt.ranostay@konsulko.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
