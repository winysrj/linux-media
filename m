Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46060 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754285AbeEHJP4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 05:15:56 -0400
Date: Tue, 8 May 2018 12:15:54 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media: v4l: Add new 10-bit packed grayscale format
Message-ID: <20180508091554.7j45kylakhnuannv@valkosipuli.retiisi.org.uk>
References: <1525769177-6328-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525769177-6328-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 08, 2018 at 11:46:17AM +0300, Todor Tomov wrote:
> The new format will be called V4L2_PIX_FMT_Y10P.
> It is similar to the V4L2_PIX_FMT_SBGGR10P family formats
> but V4L2_PIX_FMT_Y10P is a grayscale format.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
