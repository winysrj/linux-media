Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:63239 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaLBNu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 08:50:57 -0500
Message-ID: <547DC3BE.2040104@cisco.com>
Date: Tue, 02 Dec 2014 14:50:54 +0100
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: v4l2_mbus_config flags for CSI-2
References: <547DA733.8060804@cisco.com> <20141202124535.GA14746@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141202124535.GA14746@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for responding so quickly, Sakari!

On 12/02/2014 01:45 PM, Sakari Ailus wrote:
> Hi Mats,
>
> On Tue, Dec 02, 2014 at 12:49:07PM +0100, Mats Randgaard (matrandg) wrote:
>> Hi,
>> I am writing a driver for Toshiba TC358743 HDMI to CSI-2 bridge. The
>> chip has four CSI lanes. Toshiba recommends to configure the CSI
>> output speed for the highest resolution the CSI interface can handle
>> and reduce the number of CSI lanes in use if the received video has
>> lower resolution. The number of CSI lanes in use is also reduced
>> when the bridge transmits YCbCr 4:2:2 encoded video instead of
>> RGB888.
>>
>> The plan was to use g_mbus_config for this, but it is not clear to
>> me what the different defines in include/media/v4l2-mediabus.h
>> should be used for:
>>
>> /* How many lanes the client can use */
>> #define V4L2_MBUS_CSI2_1_LANE                   (1 << 0)
>> #define V4L2_MBUS_CSI2_2_LANE                   (1 << 1)
>> #define V4L2_MBUS_CSI2_3_LANE                   (1 << 2)
>> #define V4L2_MBUS_CSI2_4_LANE                   (1 << 3)
>> /* On which channels it can send video data */
>> #define V4L2_MBUS_CSI2_CHANNEL_0                (1 << 4)
>> #define V4L2_MBUS_CSI2_CHANNEL_1                (1 << 5)
>> #define V4L2_MBUS_CSI2_CHANNEL_2                (1 << 6)
>> #define V4L2_MBUS_CSI2_CHANNEL_3                (1 << 7)
>>
>> Should I set V4L2_MBUS_CSI2_4_LANE since the device supports four
>> lanes, and set V4L2_MBUS_CSI2_CHANNEL_X according to the number of
>> lanes in use?
> Channels in this case refer to CSI-2 channels, not how many lanes there are.
>
> Can you decide how many lanes you use or is that determined by other
> configuration?
>
> This is only used in SoC camera right now. Elsewhere the number of lanes is
> fixed in either platform data or device tree.

When the application set video timings or change color encoding the 
driver calculates the number of CSI lanes needed and disables the rest:

------------------------------------------------------------------------------------------
static void tc358743_set_csi(struct v4l2_subdev *sd)
{
         unsigned lanes = tc358743_num_csi_lanes_needed(sd);

         if (lanes < 1)
                 i2c_wr32(sd, CLW_CNTRL, MASK_CLW_LANEDISABLE);
         if (lanes < 1)
                 i2c_wr32(sd, D0W_CNTRL, MASK_D0W_LANEDISABLE);
         if (lanes < 2)
                 i2c_wr32(sd, D1W_CNTRL, MASK_D1W_LANEDISABLE);
         if (lanes < 3)
                 i2c_wr32(sd, D2W_CNTRL, MASK_D2W_LANEDISABLE);
         if (lanes < 4)
                 i2c_wr32(sd, D3W_CNTRL, MASK_D3W_LANEDISABLE);

------------------------------------------------------------------------------------------

Regards,
Mats Randgaard
