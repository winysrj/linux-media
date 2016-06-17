Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34148 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbcFQTBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 15:01:48 -0400
Received: by mail-pa0-f68.google.com with SMTP id us13so6278095pab.1
        for <linux-media@vger.kernel.org>; Fri, 17 Jun 2016 12:01:48 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [19/38] ARM: dts: imx6-sabrelite: add video capture ports and
 connections
To: Gary Bisson <gary.bisson@boundarydevices.com>,
	Steve Longerbeam <slongerbeam@gmail.com>
References: <1465944574-15745-20-git-send-email-steve_longerbeam@mentor.com>
 <20160616083231.GA6548@t450s.lan> <20160617151814.GA16378@t450s.lan>
Cc: linux-media@vger.kernel.org, Jack Mitchell <ml@embed.me.uk>
Message-ID: <57644915.3010006@gmail.com>
Date: Fri, 17 Jun 2016 12:01:41 -0700
MIME-Version: 1.0
In-Reply-To: <20160617151814.GA16378@t450s.lan>
Content-Type: multipart/mixed;
 boundary="------------050701020300060502050209"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050701020300060502050209
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit



On 06/17/2016 08:18 AM, Gary Bisson wrote:
> Steve, All,
>
> On Thu, Jun 16, 2016 at 10:32:31AM +0200, Gary Bisson wrote:
>> Steve, All,
>>
>> On Tue, Jun 14, 2016 at 03:49:15PM -0700, Steve Longerbeam wrote:
>>> Defines the host video capture device node and an OV5642 camera sensor
>>> node on i2c2. The host capture device connects to the OV5642 via the
>>> parallel-bus mux input on the ipu1_csi0_mux.
>>>
>>> Note there is a pin conflict with GPIO6. This pin functions as a power
>>> input pin to the OV5642, but ENET requires it to wake-up the ARM cores
>>> on normal RX and TX packet done events (see 6261c4c8). So by default,
>>> capture is disabled, enable by uncommenting __OV5642_CAPTURE__ macro.
>>> Ethernet will still work just not quite as well.
>> Actually the following patch fixes this issue and has already been
>> applied on Shawn's tree:
>> https://patchwork.kernel.org/patch/9153523/
>>
>> Also, this follow-up patch declared the HW workaround for SabreLite:
>> https://patchwork.kernel.org/patch/9153525/
>>
>> So ideally, once those two patches land on your base tree, you could get
>> rid of the #define and remove the HW workaround declaration.
>>
>> Finally, I'll test the series on Sabre-Lite this week.
> I've applied this series on top of Shawn tree (for-next branch) in order
> not to worry about the GPIO6 workaround.
>
> Although the camera seems to get enumerated properly, I can't seem to
> get anything from it. See log:
> http://pastebin.com/xnw1ujUq

Hi Gary, the driver does not implement vidioc_cropcap, it has
switched to the new selection APIs and v4l2src should be using
vidioc_g_selection instead of vidioc_cropcap.

>
> In your cover letter, you said that you have not run through
> v4l2-compliance. How have you tested the capture?

I use v4l2-ctl, and have used v4l2src in the past, but that was before
switching to the selection APIs. Try the attached hack that adds
vidioc_cropcap back in, and see how far you get on SabreLite with
v4l2src. I tried  the following on SabreAuto:

gst-launch-1.0 v4l2src io_mode=4 ! 
"video/x-raw,format=RGB16,width=640,height=480" ! fbdevsink

>
> Also, why isn't the OV5640 MIPI camera declared on the SabreLite device
> tree?

See Jack Mitchell's patch at http://ix.io/TTg. Thanks Jack! I will work on
incorporating it.


Steve




--------------050701020300060502050209
Content-Type: text/x-patch;
 name="vidioc_cropcap.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="vidioc_cropcap.diff"

diff --git a/drivers/staging/media/imx/capture/imx-camif.c b/drivers/staging/media/imx/capture/imx-camif.c
index 9c247e0..2c51bc7 100644
--- a/drivers/staging/media/imx/capture/imx-camif.c
+++ b/drivers/staging/media/imx/capture/imx-camif.c
@@ -1561,6 +1561,23 @@ static int vidioc_s_parm(struct file *file, void *fh,
 	return v4l2_subdev_call(dev->sensor->sd, video, s_parm, a);
 }
 
+static int vidioc_cropcap(struct file *file, void *priv,
+			  struct v4l2_cropcap *cropcap)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+
+	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    cropcap->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
+		return -EINVAL;
+
+	cropcap->bounds = dev->crop_bounds;
+	cropcap->defrect = dev->crop_defrect;
+	cropcap->pixelaspect.numerator = 1;
+	cropcap->pixelaspect.denominator = 1;
+	return 0;
+}
+
 static int vidioc_g_selection(struct file *file, void *priv,
 			      struct v4l2_selection *sel)
 {
@@ -1794,6 +1811,7 @@ static const struct v4l2_ioctl_ops imxcam_ioctl_ops = {
 	.vidioc_g_parm          = vidioc_g_parm,
 	.vidioc_s_parm          = vidioc_s_parm,
 
+	.vidioc_cropcap		= vidioc_cropcap,
 	.vidioc_g_selection     = vidioc_g_selection,
 	.vidioc_s_selection     = vidioc_s_selection,
 


--------------050701020300060502050209--
