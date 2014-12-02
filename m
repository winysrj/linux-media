Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55878 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751211AbaLBMqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 07:46:13 -0500
Date: Tue, 2 Dec 2014 14:45:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
Cc: linux-media@vger.kernel.org
Subject: Re: v4l2_mbus_config flags for CSI-2
Message-ID: <20141202124535.GA14746@valkosipuli.retiisi.org.uk>
References: <547DA733.8060804@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547DA733.8060804@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mats,

On Tue, Dec 02, 2014 at 12:49:07PM +0100, Mats Randgaard (matrandg) wrote:
> Hi,
> I am writing a driver for Toshiba TC358743 HDMI to CSI-2 bridge. The
> chip has four CSI lanes. Toshiba recommends to configure the CSI
> output speed for the highest resolution the CSI interface can handle
> and reduce the number of CSI lanes in use if the received video has
> lower resolution. The number of CSI lanes in use is also reduced
> when the bridge transmits YCbCr 4:2:2 encoded video instead of
> RGB888.
> 
> The plan was to use g_mbus_config for this, but it is not clear to
> me what the different defines in include/media/v4l2-mediabus.h
> should be used for:
> 
> /* How many lanes the client can use */
> #define V4L2_MBUS_CSI2_1_LANE                   (1 << 0)
> #define V4L2_MBUS_CSI2_2_LANE                   (1 << 1)
> #define V4L2_MBUS_CSI2_3_LANE                   (1 << 2)
> #define V4L2_MBUS_CSI2_4_LANE                   (1 << 3)
> /* On which channels it can send video data */
> #define V4L2_MBUS_CSI2_CHANNEL_0                (1 << 4)
> #define V4L2_MBUS_CSI2_CHANNEL_1                (1 << 5)
> #define V4L2_MBUS_CSI2_CHANNEL_2                (1 << 6)
> #define V4L2_MBUS_CSI2_CHANNEL_3                (1 << 7)
> 
> Should I set V4L2_MBUS_CSI2_4_LANE since the device supports four
> lanes, and set V4L2_MBUS_CSI2_CHANNEL_X according to the number of
> lanes in use?

Channels in this case refer to CSI-2 channels, not how many lanes there are.

Can you decide how many lanes you use or is that determined by other
configuration?

This is only used in SoC camera right now. Elsewhere the number of lanes is
fixed in either platform data or device tree.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
