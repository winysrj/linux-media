Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41445 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZCSHm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 03:42:59 -0400
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
To: ext Suresh Rao <sureshraomr@gmail.com>
Subject: Re: ISP Configuration for RAW Bayer sensor
Date: Thu, 19 Mar 2009 09:42:42 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <d9ec170c0903180917k691f9d01pe4cb4231efe282e4@mail.gmail.com>
In-Reply-To: <d9ec170c0903180917k691f9d01pe4cb4231efe282e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903190942.43219.tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 March 2009 18:17:56 ext Suresh Rao wrote:
> I am working with MT9V023 RAW sensor.  The data format from the sensor is
> 
> B G B G B G B G ...
> G R G R G R G R ...
> B G B G B G B G ...
> G R G R G R G R ........      [ Format 1]
[...]
> I want to use the ISP on the OMAP for doing interpolation and format
> conversion to UYVY.  I am able to capture the images from the sensor,
> however I notice that the color information is missing.  I dug the
> sources and found that in the RAW capture mode ISP is getting
> configured to input format
> 
> G R G R G R G R ...
> B G B G B G B G ...
> G R G R G R G R ...
> B G B G B G B G ...          [Format 2]
> 
> Has anyone tried sensors with BGGR ( Format 1) on OMAP?
> 
> Can anyone give me some pointers or information on how to configure
> ISP for BGGR (Format 1)

If you can live with losing a few pixels (maybe sensor has a few extra)
I recommend to configure ISP to crop away the topmost line.

Here's couple of old _example_ patches how to configure the cropping.
Just gives an idea where to start...

- Tuukka


diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index 2288bc9..87870f1 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -1189,13 +1189,13 @@ int ispccdc_config_size(u32 input_w, u32 input_h, u32 output_w, u32 output_h)
 						ISPCCDC_HORZ_INFO);
 		} else {
 			if (ispccdc_obj.ccdc_inpfmt == CCDC_RAW) {
-				omap_writel(1 << ISPCCDC_HORZ_INFO_SPH_SHIFT
-						| ((ispccdc_obj.ccdcout_w - 1)
+				omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT
+						| (ispccdc_obj.ccdcout_w
 						<< ISPCCDC_HORZ_INFO_NPH_SHIFT),
 						ISPCCDC_HORZ_INFO);
 			} else {
 				omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT
-						| ((ispccdc_obj.ccdcout_w - 1)
+						| (ispccdc_obj.ccdcout_w
 						<< ISPCCDC_HORZ_INFO_NPH_SHIFT),
 						ISPCCDC_HORZ_INFO);
 			}
@@ -1227,7 +1227,7 @@ int ispccdc_config_size(u32 input_w, u32 input_h, u32 output_w, u32 output_h)
 					ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
 					ISPCCDC_VP_OUT);
 		omap_writel(0 << ISPCCDC_HORZ_INFO_SPH_SHIFT |
-					((ispccdc_obj.ccdcout_w - 1) <<
+					(ispccdc_obj.ccdcout_w <<
 					ISPCCDC_HORZ_INFO_NPH_SHIFT),
 					ISPCCDC_HORZ_INFO);
 		omap_writel(0 << ISPCCDC_VERT_START_SLV0_SHIFT,
diff --git a/drivers/media/video/isp/ispccdc.c 
b/drivers/media/video/isp/ispccdc.c
index f5957b2..6afaabf 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -478,7 +478,7 @@ EXPORT_SYMBOL(ispccdc_enable_lsc);
   **/
  void ispccdc_config_crop(u32 left, u32 top, u32 height, u32 width)
  {
-       ispccdc_obj.ccdcin_woffset = left + ((left + 1) % 2);
+       ispccdc_obj.ccdcin_woffset = left + (left % 2);
         ispccdc_obj.ccdcin_hoffset = top + (top % 2);

         ispccdc_obj.crop_w = width - (width % 16);
@@ -1166,7 +1166,7 @@ int ispccdc_config_size(u32 input_w, u32 input_h, 
u32 output_w, u32 output_h)
                                         ISPCCDC_FMT_VERT);
                 omap_writel((ispccdc_obj.ccdcout_w <<
                                         ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
-                                       (ispccdc_obj.ccdcout_h <<
+                                       (ispccdc_obj.ccdcout_h - 1 <<
                                         ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
                                         ISPCCDC_VP_OUT);
                 omap_writel((((ispccdc_obj.ccdcout_h - 25) &


