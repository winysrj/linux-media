Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:33778 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732079AbeKVVbe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 16:31:34 -0500
Date: Thu, 22 Nov 2018 12:52:40 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: linux-media@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [PATCH] media: ov2680: fix null dereference at power on
Message-ID: <20181122105239.s4vzfgc5mzfyuomy@paasikivi.fi.intel.com>
References: <20181121105955.9217-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121105955.9217-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rui,

On Wed, Nov 21, 2018 at 10:59:55AM +0000, Rui Miguel Silva wrote:
> Swapping the order between v4l2 subdevice registration and checking chip id in
> b7a417628abf ("media: ov2680: don't register the v4l2 subdevice before checking chip ID")
> makes the mode restore to use the sensor controls before they are set, so move
> the mode restore call to s_power after the handler setup for controls is done.
> 
> This remove also the need for the error code path in power on function.

Could you make sure you wrap the lines in the commit at 76 or so? Otherwise
they'll wrap in git log. I've re-wrapped it this time.

Thanks.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
