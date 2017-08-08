Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34144 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752030AbdHHOxy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 10:53:54 -0400
Date: Tue, 8 Aug 2017 17:53:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4 00/21] Qualcomm 8x16 Camera Subsystem driver
Message-ID: <20170808145349.piyovhkfrn75qgs7@valkosipuli.retiisi.org.uk>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 08, 2017 at 04:29:57PM +0300, Todor Tomov wrote:
> This patchset adds basic support for the Qualcomm Camera Subsystem found
> on Qualcomm MSM8916 and APQ8016 processors.
> 
> The driver implements V4L2, Media controller and V4L2 subdev interfaces.
> Camera sensor using V4L2 subdev interface in the kernel is supported.
> 
> The driver is implemented using as a reference the Qualcomm Camera
> Subsystem driver for Android as found in Code Aurora [1].
> 
> The driver is tested on Dragonboard 410C (APQ8016) with one and two
> OV5645 camera sensors. media-ctl [2] and yavta [3] applications were
> used for testing. Also Gstreamer 1.10.4 with v4l2src plugin is supported.
> 
> More information is present in the document added by the third patch.

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
