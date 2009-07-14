Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.Stanford.EDU ([171.67.219.83]:58073 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZGNRcw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 13:32:52 -0400
Message-ID: <4A5CBF3D.80002@stanford.edu>
Date: Tue, 14 Jul 2009 10:24:13 -0700
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: Zach LeRoy <zleroy@rii.ricoh.com>
CC: "Aguirre Rodriguez, Sergio" <saaguirre@ti.com>,
	linux-media <linux-media@vger.kernel.org>,
	linux-omap <linux-omap@vger.kernel.org>
Subject: Re: Problems configuring OMAP35x ISP driver
References: <15157053.23861247590158808.JavaMail.root@mailx.crc.ricoh.com>
In-Reply-To: <15157053.23861247590158808.JavaMail.root@mailx.crc.ricoh.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zach,

We've gotten a Aptina MT9P031 driver working with the latest ISP 
patchset, both with YUV and RAW data.
I don't know what the problem might be with YUYV data - we get useful 
YUYV data without any changes to the ISP defaults.
However, to request RAW data, that simply uses the CCDC and bypasses all 
the processing in the ISP, request the pixelformat of 
V4L2_PIX_FMT_SGRBG10.  This will give you two bytes per pixel, at least 
in our case (although we have a 12-bit sensor cut down to 10 bits), so 
be prepared to throw out every other byte.

Hope this helps,

Eino-Ville (Eddy) Talvala
Computer Graphics Lab
Stanford University

On 7/14/2009 9:49 AM, Zach LeRoy wrote:
> Hello Sergio,
>
> I spoke with you earlier about using the ISP and omap34xxcam drivers with a micron mt9d111 SOC sensor.  I have since been able to take pictures, but the sensor data is not making it through the ISP data-path correctly.  I know the problem is in the ISP data-path because I am configuring the sensor the exact same way as I have been on my working PXA system.  I am expecting 4:2:2 packed YUV data, but all of the U and V data is no more than 2 bits where it should be 8.  I know the ISP has a lot of capabilities, but all I want to use it for is grabbing 8-bit data from my sensor and putting it in a buffer untouched using the CCDC interface (and of course clocking and timing).  What are the key steps to take to get this type of configuration?
>
> Other Questions:
>
> Is there any processing done on YUV data in the ISP driver by default that I am missing?
> Has any one else experienced similar problems while adding new sensor support?
>
> Any help here would be greatly appreciated.
>
> Thank you,
>
> Zach LeRoy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

