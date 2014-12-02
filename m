Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:45491 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaLBL67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 06:58:59 -0500
Message-ID: <547DA733.8060804@cisco.com>
Date: Tue, 02 Dec 2014 12:49:07 +0100
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: sakari.ailus@iki.fi
Subject: v4l2_mbus_config flags for CSI-2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I am writing a driver for Toshiba TC358743 HDMI to CSI-2 bridge. The 
chip has four CSI lanes. Toshiba recommends to configure the CSI output 
speed for the highest resolution the CSI interface can handle and reduce 
the number of CSI lanes in use if the received video has lower 
resolution. The number of CSI lanes in use is also reduced when the 
bridge transmits YCbCr 4:2:2 encoded video instead of RGB888.

The plan was to use g_mbus_config for this, but it is not clear to me 
what the different defines in include/media/v4l2-mediabus.h should be 
used for:

/* How many lanes the client can use */
#define V4L2_MBUS_CSI2_1_LANE                   (1 << 0)
#define V4L2_MBUS_CSI2_2_LANE                   (1 << 1)
#define V4L2_MBUS_CSI2_3_LANE                   (1 << 2)
#define V4L2_MBUS_CSI2_4_LANE                   (1 << 3)
/* On which channels it can send video data */
#define V4L2_MBUS_CSI2_CHANNEL_0                (1 << 4)
#define V4L2_MBUS_CSI2_CHANNEL_1                (1 << 5)
#define V4L2_MBUS_CSI2_CHANNEL_2                (1 << 6)
#define V4L2_MBUS_CSI2_CHANNEL_3                (1 << 7)

Should I set V4L2_MBUS_CSI2_4_LANE since the device supports four lanes, 
and set V4L2_MBUS_CSI2_CHANNEL_X according to the number of lanes in use?

Thanks,

Mats Randgaard

