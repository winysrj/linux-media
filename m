Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38428 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756364AbdCULXm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 07:23:42 -0400
Date: Tue, 21 Mar 2017 13:23:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv5 00/16] atmel-isi/ov7670/ov2640: convert to standalone
 drivers
Message-ID: <20170321112304.GM10701@valkosipuli.retiisi.org.uk>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170311112328.11802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Mar 11, 2017 at 12:23:12PM +0100, Hans Verkuil wrote:
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
> The first 5 patches improve the ov7670 sensor driver, mostly adding modern
> features such as DT support.
> 
> The next three convert the atmel-isi and move it out of soc_camera.
> 
> The following 6 patches convert ov2640 and drop the soc_camera dependency
> in em28xx. I have tested that this works with my 'SpeedLink Vicious And
> Divine Laplace webcam'.
> 
> The last two patches add isi support to the DT: the first for the ov7670
> sensor, the second modifies it for the ov2640 sensor.
> 
> These two final patches are for demonstration purposes only, I do not plan
> on merging them.
> 
> Tested with my sama5d3-Xplained board, the ov2640 sensor and two ov7670
> sensors: one with and one without reset/pwdn pins. Also tested with my
> em28xx-based webcam.
> 
> I'd like to get this in for 4.12. Fingers crossed.

A question on the last two patches --- what's in the commit description
still holds, right? In that case, how about dropping them from the set?
There have been no changes to those patches during review AFAIR.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
