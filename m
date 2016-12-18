Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48506 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753752AbcLRWLa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Dec 2016 17:11:30 -0500
Date: Mon, 19 Dec 2016 00:10:56 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>
Subject: Re: [PATCH 00/15] atmel-isi/ov7670/ov2640: convert to standalone
 drivers
Message-ID: <20161218221055.GW16630@valkosipuli.retiisi.org.uk>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 12, 2016 at 04:55:05PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series converts the soc-camera atmel-isi to a standalone V4L2
> driver.
> 
> The same is done for the ov7670 and ov2640 sensor drivers: the ov7670 was
> used to test the atmel-isi driver. The ov2640 is needed because the em28xx
> driver has a soc_camera include dependency. Both ov7670 and ov2640 sensors
> have been tested with the atmel-isi driver.
> 
> The first 6 patches improve the ov7670 sensor driver, mostly adding modern
> features such as MC and DT support.
> 
> The next three convert the atmel-isi and move it out of soc_camera.

You're adding Media controller support but without device nodes. Does that
make sense? You'll have an entity but the user won't be able to do anything
with it.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
