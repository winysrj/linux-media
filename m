Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38990 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965240AbdGTPZj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:25:39 -0400
Date: Thu, 20 Jul 2017 18:25:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 00/23] Qualcomm 8x16 Camera Subsystem driver
Message-ID: <20170720152535.crxlxhirtlv23rjr@valkosipuli.retiisi.org.uk>
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Jul 17, 2017 at 01:33:26PM +0300, Todor Tomov wrote:
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

After addressing the comments (please pay attention especially those
affecting the user space API behaviour) you can add:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Let me know if you have any further questions on the individual comments.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
