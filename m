Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:22728 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab1BYKgP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 05:36:15 -0500
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH600M095GE75E0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 19:36:14 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH600C935GEIV@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 19:36:14 +0900 (KST)
Date: Fri, 25 Feb 2011 19:36:10 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: Hello, how to control FrameBuffer device as v4l2 sub-device?
In-reply-to: <015301cbd34b$22aa38a0$67fea9e0$%kang@samsung.com>
To: sungchun.kang@samsung.com, linux-media@vger.kernel.org
Message-id: <002a01cbd4d7$d3a03460$7ae09d20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
References: <015301cbd34b$22aa38a0$67fea9e0$%kang@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi,

There are two solutions. But it never looks nice.
Does anyone have no idea ?


1. Save the struct s3c_fb in the v4l2_subdev.priv like:
In the s3cfb_probe:
	v4l2_set_subdevdata(&sfb->sd, sfb);
	platform_set_drvdata(pdev, &sfb->sd);

In the s3cfb_remove:
	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
	struct s3c_fb *sfb = sd->priv;

In the s5p-fimc driver:
	sd = dev_get_drvdata(dev);
-> This bothers s3cfb due to s5p-fimc driver.

2. let sd locate top of the struct s3c_fb like:
	struct s3c_fb {
		struct v4l2_subdev      sd;
		struct device           *dev;
-> and then don't save the sfb->sd in the platform driver data.
It makes s3cfb driver use the platform driver data for its own purpose.
But you can get the v4l2_subdev pointer in s5p-fimc driver using dev_get_drvdata.
The reason how to get the pointer is that the address of v4l2_subdev is same with s3cfb's platform driver data.

BRs,


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sungchun Kang
> Sent: Wednesday, February 23, 2011 8:17 PM
> To: linux-media@vger.kernel.org
> Subject: Hello, how to control FrameBuffer device as v4l2 sub-device?
> 
> FIMC is hardware function like csc, post, rotatin and so on.
> It is necessary to send some data to FB from FIMC.
> 
> So, I have registered FB driver as v4l2 sub-device of FIMC.
> ----------------
> |  v4l2_device   |
>  ----------------
> |   fimc-0       |----------------
> |                |                |
>  ----------------              |
>         |                         |
> ----------------         ----------------
> |  v4l2_subdev   |       |  v4l2_subdeve   |
>  ----------------         ----------------
> |     FB1        |       |     mipi-csi,   |
> |     FB2        |       |      senor     |
>  ----------------         ----------------
> And, it is controlled using platform_get_drvdata and platform_set_drvdata
> between FIMC and FB drvier.
> But, FB driver uses drvdata for its own purpose. If I set v4l2_subdev ptr like this :
> platform_set_drvdata(pdev, &sfb->sd); // v4l2_subdev sd;
> 
> platform_device ptr is changed.
> 
> Because FB driver aleady set like this :
> platform_set_drvdata(pdev, sfb);
> 
> So, I wonder how to control data between 2 hardware.
> 
> If you have some idea, pls reply.
> 
> BRs,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

