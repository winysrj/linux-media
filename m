Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55318 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S967292AbdIZIUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 04:20:50 -0400
Date: Tue, 26 Sep 2017 11:20:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v14 15/28] v4l: async: Allow binding notifiers to
 sub-devices
Message-ID: <20170926082046.sfmhyf7xmkutzjbe@valkosipuli.retiisi.org.uk>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-16-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925222540.371-16-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 26, 2017 at 01:25:26AM +0300, Sakari Ailus wrote:
> Registering a notifier has required the knowledge of struct v4l2_device
> for the reason that sub-devices generally are registered to the
> v4l2_device (as well as the media device, also available through
> v4l2_device).
> 
> This information is not available for sub-device drivers at probe time.
> 
> What this patch does is that it allows registering notifiers without
> having v4l2_device around. Instead the sub-device pointer is stored in the
> notifier. Once the sub-device of the driver that registered the notifier
> is registered, the notifier will gain the knowledge of the v4l2_device,
> and the binding of async sub-devices from the sub-device driver's notifier
> may proceed.
> 
> The root notifier's complete callback is only called when all sub-device
> notifiers are completed.

This paragraph is actually no longer true. I changed it to:

	The complete callbacks will be called only when the v4l2_device is
	available and no notifier has pending sub-devices to bind.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
