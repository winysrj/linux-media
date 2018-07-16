Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59066 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727101AbeGPN4B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 09:56:01 -0400
Date: Mon, 16 Jul 2018 16:28:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH v4] media: video-i2c: add hwmon support for amg88xx
Message-ID: <20180716132832.shvkl5jcsmxwfgsa@valkosipuli.retiisi.org.uk>
References: <20180628181104.16177-1-matt.ranostay@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628181104.16177-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 28, 2018 at 11:11:04AM -0700, Matt Ranostay wrote:
> AMG88xx has an on-board thermistor which is used for more accurate
> processing of its temperature readings from the 8x8 thermopile array
> 
> Cc: linux-hwmon@vger.kernel.org
> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
