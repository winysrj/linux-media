Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:46512 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab1JLVnC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 17:43:02 -0400
Message-ID: <4E9609E3.3000902@mlbassoc.com>
Date: Wed, 12 Oct 2011 15:42:59 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: OMAP3 ISP ghosting
References: <4E9442A9.1060202@mlbassoc.com>
In-Reply-To: <4E9442A9.1060202@mlbassoc.com>
Content-Type: multipart/mixed;
 boundary="------------020106000400020802080407"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020106000400020802080407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2011-10-11 07:20, Gary Thomas wrote:
> As a number of us have seen, when using the OMAP3 ISP with a BT-656
> sensor, e.g. TVP5150, the results are not 100% correct. Some number
> of frames (typically 2) will be correct, followed by another set (3)
> which are incorrect and show only partially correct data. Note: I
> think the numbers (2 correct, 3 wrong) are not cast in stone and may
> be related to some other factors like number of buffers in use, etc.
>
> Anyway, I've observed that in the incorrect frames, 1/2 the data is
> correct (even lines?) and the other 1/2 is wrong. One of my customers
> pointed out that it looks like the incorrect data is just what was
> left in memory during some previous frame. I'd like to prove this
> by "zeroing" the entire frame data memory before the frame is captured.
> That way, there won't be stale data from a previous frame, but null
> data which should show up strongly when examined. Does anyone in this
> group have a suggestion the best way/place to do this?
>
> Final question: given a properly connected TVP5150->CCDC, including
> all SYNC signals, could this setup be made to work in RAW, non BT-656
> mode? My board at least has all of these signals routed, so it should
> just be a matter of configuring the software...

Any ideas on this?  My naive attempt (diffs attached) just hangs up.
These changes disable BT-656 mode in the CCDC and tell the TVP5150
to output raw YUV 4:2:2 data including all SYNC signals.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------

--------------020106000400020802080407
Content-Type: text/plain;
 name="ccdc.raw"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ccdc.raw"

diff --git a/arch/arm/mach-omap2/board-cobra3530p60.c b/arch/arm/mach-omap2/board-cobra3530p60.c
index a8e8f21..5e97838 100644
--- a/arch/arm/mach-omap2/board-cobra3530p60.c
+++ b/arch/arm/mach-omap2/board-cobra3530p60.c
@@ -480,6 +480,6 @@ static struct isp_v4l2_subdevs_group cobra3530p60_camera_subdevs[] = {
 					.data_lane_shift = 0,
 					.clk_pol = 1,
-                                        .bt656 = 1,
+                                        .bt656 = 0,
                                         .fldmode = 1,
 				}
 		},
 
diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index f4a66c7..26360ae 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -499,7 +499,7 @@ static const struct i2c_reg_value tvp5150_init_enable[] = {
 	},{	/* Activates video std autodetection for all standards */
 		TVP5150_AUTOSW_MSK, 0x0
 	},{	/* Default format: 0x47. For 4:2:2: 0x40 */
-		TVP5150_DATA_RATE_SEL, 0x47
+		TVP5150_DATA_RATE_SEL, 0x40 /*0x47*/
 	},{
 		TVP5150_CHROMA_PROC_CTL_1, 0x0c
 	},{
@@ -993,7 +993,7 @@ static int tvp515x_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
 	if (enable)
-		tvp5150_write(subdev, TVP5150_MISC_CTL, 0x09);
+		tvp5150_write(subdev, TVP5150_MISC_CTL, 0x09+0x04);
 	else
 		tvp5150_write(subdev, TVP5150_MISC_CTL, 0x00);
 

--------------020106000400020802080407--
