Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43591 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754516AbdLOJOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 04:14:48 -0500
Date: Fri, 15 Dec 2017 11:14:44 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH] media: v4l2-device: Link subdevices to their parent
 devices if available
Message-ID: <20171215091444.nbvqtbomc7henfnf@paasikivi.fi.intel.com>
References: <20171215043221.242719-1-tfiga@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171215043221.242719-1-tfiga@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 15, 2017 at 01:32:21PM +0900, Tomasz Figa wrote:
> Currently v4l2_device_register_subdev_nodes() does not initialize the
> dev_parent field of the video_device structs it creates for subdevices
> being registered. This leads to __video_register_device() falling back
> to the parent device of associated v4l2_device struct, which often does
> not match the physical device the subdevice is registered for.
> 
> Due to the problem above, the links between real devices and v4l-subdev
> nodes cannot be obtained from sysfs, which might be confusing for the
> userspace trying to identify the hardware.
> 
> Fix this by initializing the dev_parent field of the video_device struct
> with the value of dev field of the v4l2_subdev struct. In case of
> subdevices without a parent struct device, the field will be NULL and the
> old behavior will be preserved by the semantics of
> __video_register_device().
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
