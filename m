Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56344 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaKJLrB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 06:47:01 -0500
Date: Mon, 10 Nov 2014 12:46:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bin Chen <bin.chen@linaro.org>
cc: linux-media@vger.kernel.org
Subject: Re: Add controls to query camera read only paramters
In-Reply-To: <CANC6fRFjG6002rDiJjfDHteQSAnRkwfpyWV8wB39oHu5P8Q2mA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1411101243230.23739@axis700.grange>
References: <CANC6fRFjG6002rDiJjfDHteQSAnRkwfpyWV8wB39oHu5P8Q2mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bin,

On Sat, 8 Nov 2014, Bin Chen wrote:

> Hi Everyone,
> 
> I need suggestions with regard to adding controls to query camera read
> only parameters (e.g maxZoom/maxExposureCompensation) as needed by
> Android Camera API[1].

I'm not sure all Android HAL metadata tags should be 1-to-1 implemented in 
V4L2. Some of them can be derived from existing information, some are even 
more relevant to the HAL, then to the camera (kernel driver). E.g. 
wouldn't it be possible and make sense to calculate 
android.scaler.availableMaxDigitalZoom camera cropping capabilities?

Thanks
Guennadi

> What is in my mind is to add a customized camera control ID for each
> parameter I want to query and return EACCES when being used wit
> VIDIOC_S_EXT_CTRLS.
> 
> Or, I can port the compound controls [2] patch and then I only need to
> add one customized control ID.
> 
> Comments? What is the better way to do this?
> 
> [1] http://developer.android.com/reference/android/hardware/Camera.Parameters.html
> [2]http://comments.gmane.org/gmane.comp.video.linuxtv.scm/19545
> 
> -- 
> Regards,
> Bin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
