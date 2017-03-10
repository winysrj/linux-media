Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37062 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934440AbdCJLIh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:08:37 -0500
Date: Fri, 10 Mar 2017 13:08:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 10/15] ov2640: convert from soc-camera to a standard
 subdev sensor driver.
Message-ID: <20170310110832.GC3220@valkosipuli.retiisi.org.uk>
References: <20170310102614.20922-1-hverkuil@xs4all.nl>
 <20170310102614.20922-11-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170310102614.20922-11-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Mar 10, 2017 at 11:26:09AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Convert ov2640 to a standard subdev driver. The soc-camera driver no longer
> uses this driver, so it can safely be converted.
> 
> Note: the s_power op has been dropped: this never worked. When the last open()
> is closed, then the power is turned off, and when it is opened again the power
> is turned on again, but the old state isn't restored.
> 
> Someone else can figure out in the future how to get this working correctly,
> but I don't want to spend more time on this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
