Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19791 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727405AbeKPSar (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 13:30:47 -0500
Date: Fri, 16 Nov 2018 10:19:26 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Ben Kao <ben.kao@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org, andy.yeh@intel.com
Subject: Re: media: ov8856: Add support for OV8856 sensor
Message-ID: <20181116081926.7y5h2pu6tmk2adbx@paasikivi.fi.intel.com>
References: <1541648506-13744-1-git-send-email-ben.kao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541648506-13744-1-git-send-email-ben.kao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

On Thu, Nov 08, 2018 at 11:41:46AM +0800, Ben Kao wrote:
> This patch adds driver for Omnivision's ov8856 sensor,
> the driver supports following features:
> 
> - manual exposure/gain(analog and digital) control support
> - two link frequencies
> - VBLANK/HBLANK support
> - test pattern support
> - media controller support
> - runtime pm support
> - supported resolutions
>   + 3280x2464 at 30FPS
>   + 1640x1232 at 30FPS
> 
> Signed-off-by: Ben Kao <ben.kao@intel.com>

I just realised the driver is missing the MAINTAINERS entry. Could you
provide one? Just the diff is fine, I'll then squash it to the patch.

Thanks.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
