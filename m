Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51986 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754306AbeDXJmx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 05:42:53 -0400
Date: Tue, 24 Apr 2018 10:42:44 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 0/7] TDA998x CEC support
Message-ID: <20180424094244.GK16141@n2100.armlinux.org.uk>
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
 <a3c8c61a-83fa-5363-0065-fe22c6bf77fe@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3c8c61a-83fa-5363-0065-fe22c6bf77fe@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 11:29:42AM +0200, Hans Verkuil wrote:
> On 04/09/18 14:15, Russell King - ARM Linux wrote:
> > Hi,
> > 
> > This patch series adds CEC support to the DRM TDA998x driver.  The
> > TDA998x family of devices integrate a TDA9950 CEC at a separate I2C
> > address from the HDMI encoder.
> > 
> > Implementation of the CEC part is separate to allow independent CEC
> > implementations, or independent HDMI implementations (since the
> > TDA9950 may be a separate device.)
> 
> Reviewed, looks good.

Thanks!  If we need to rework the calibration GPIO stuff for BB, we can
do that in a later patch.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
