Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37390 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751400AbeEGLAq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 07:00:46 -0400
Date: Mon, 7 May 2018 14:00:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: v4l: Add new 2X8 10-bit grayscale media bus
 code
Message-ID: <20180507110044.lsfifcixg2ol3sxg@valkosipuli.retiisi.org.uk>
References: <1524829239-4664-1-git-send-email-todor.tomov@linaro.org>
 <1524829239-4664-2-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524829239-4664-2-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 27, 2018 at 02:40:38PM +0300, Todor Tomov wrote:
> The code will be called MEDIA_BUS_FMT_Y10_2X8_PADHI_LE.
> It is similar to MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE
> but MEDIA_BUS_FMT_Y10_2X8_PADHI_LE describes grayscale
> data.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
